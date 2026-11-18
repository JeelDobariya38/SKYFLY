package com.skyfly.service;

import com.skyfly.dto.AirportDto;
import com.skyfly.entity.Airport;
import com.skyfly.exception.ResourceNotFoundException;
import com.skyfly.repository.AirportRepository;
import com.skyfly.repository.RouteRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class AirportService {

    private final AirportRepository airportRepository;
    private final RouteRepository routeRepository;

    public AirportService(AirportRepository airportRepository, RouteRepository routeRepository) {
        this.airportRepository = airportRepository;
        this.routeRepository = routeRepository;
    }

    public List<Airport> getAllAirports() {
        return airportRepository.findAllByOrderByCityAsc();
    }

    public Airport getAirportById(Long id) {
        return airportRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Airport", "id", id));
    }

    @Transactional
    public Airport saveAirport(AirportDto dto, Long id) {
        Airport airport;
        if (id != null) {
            airport = getAirportById(id);
            if (!airport.getAirportCode().equalsIgnoreCase(dto.getAirportCode()) &&
                airportRepository.existsByAirportCode(dto.getAirportCode().toUpperCase())) {
                throw new IllegalArgumentException("Airport code already exists: " + dto.getAirportCode());
            }
        } else {
            if (airportRepository.existsByAirportCode(dto.getAirportCode().toUpperCase())) {
                throw new IllegalArgumentException("Airport code already exists: " + dto.getAirportCode());
            }
            airport = new Airport();
        }

        airport.setAirportName(dto.getAirportName().trim());
        airport.setAirportCode(dto.getAirportCode().trim().toUpperCase());
        airport.setCity(dto.getCity().trim());
        airport.setCountry(dto.getCountry().trim());
        return airportRepository.save(airport);
    }

    @Transactional
    public void deleteAirport(Long id) {
        Airport airport = getAirportById(id);
        long routeCount = routeRepository.countBySourceAirportIdOrDestinationAirportId(id, id);
        if (routeCount > 0) {
            throw new IllegalStateException("Cannot delete airport '" + airport.getAirportCode() +
                    "' because it is used by " + routeCount + " route(s).");
        }
        airportRepository.delete(airport);
    }
}
