package com.skyfly.service;

import com.skyfly.dto.AirlineDto;
import com.skyfly.entity.Airline;
import com.skyfly.entity.UserStatus;
import com.skyfly.exception.ResourceNotFoundException;
import com.skyfly.repository.AirlineRepository;
import com.skyfly.repository.FlightRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class AirlineService {

    private final AirlineRepository airlineRepository;
    private final FlightRepository flightRepository;

    public AirlineService(AirlineRepository airlineRepository, FlightRepository flightRepository) {
        this.airlineRepository = airlineRepository;
        this.flightRepository = flightRepository;
    }

    public List<Airline> getAllAirlines() {
        return airlineRepository.findAllByOrderByAirlineNameAsc();
    }

    public List<Airline> getActiveAirlines() {
        return airlineRepository.findByStatus(UserStatus.ACTIVE);
    }

    public Airline getAirlineById(Long id) {
        return airlineRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Airline", "id", id));
    }

    @Transactional
    public Airline saveAirline(AirlineDto dto, Long id) {
        Airline airline;
        if (id != null) {
            airline = getAirlineById(id);
            if (!airline.getAirlineCode().equalsIgnoreCase(dto.getAirlineCode()) &&
                airlineRepository.existsByAirlineCode(dto.getAirlineCode().toUpperCase())) {
                throw new IllegalArgumentException("Airline code already exists: " + dto.getAirlineCode());
            }
        } else {
            if (airlineRepository.existsByAirlineCode(dto.getAirlineCode().toUpperCase())) {
                throw new IllegalArgumentException("Airline code already exists: " + dto.getAirlineCode());
            }
            airline = new Airline();
        }

        airline.setAirlineName(dto.getAirlineName().trim());
        airline.setAirlineCode(dto.getAirlineCode().trim().toUpperCase());
        airline.setDescription(dto.getDescription() != null ? dto.getDescription().trim() : null);
        if (dto.getStatus() != null) {
            airline.setStatus(dto.getStatus());
        }
        return airlineRepository.save(airline);
    }

    @Transactional
    public void deleteAirline(Long id) {
        Airline airline = getAirlineById(id);
        long flightCount = flightRepository.countByAirlineId(id);
        if (flightCount > 0) {
            throw new IllegalStateException("Cannot delete airline '" + airline.getAirlineName() +
                    "' because it has " + flightCount + " associated flight(s). Please deactivate it or reassign flights instead.");
        }
        airlineRepository.delete(airline);
    }
}
