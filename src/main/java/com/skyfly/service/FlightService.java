package com.skyfly.service;

import com.skyfly.dto.FlightDto;
import com.skyfly.dto.FlightSearchRequest;
import com.skyfly.entity.*;
import com.skyfly.exception.ResourceNotFoundException;
import com.skyfly.repository.FlightRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
public class FlightService {

    private final FlightRepository flightRepository;
    private final AirlineService airlineService;
    private final RouteService routeService;

    public FlightService(FlightRepository flightRepository, AirlineService airlineService, RouteService routeService) {
        this.flightRepository = flightRepository;
        this.airlineService = airlineService;
        this.routeService = routeService;
    }

    public List<Flight> getAllFlights() {
        return flightRepository.findAllByOrderByDepartureTimeDesc();
    }

    public List<Flight> getFeaturedFlights() {
        return flightRepository.findTop6ByStatusAndDepartureTimeAfterOrderByDepartureTimeAsc(
                FlightStatus.SCHEDULED, LocalDateTime.now());
    }

    public Flight getFlightById(Long id) {
        return flightRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Flight", "id", id));
    }

    public List<Flight> searchFlights(FlightSearchRequest request) {
        int seats = (request.getPassengers() != null && request.getPassengers() > 0) ? request.getPassengers() : 1;
        String source = (request.getSourceCity() != null) ? request.getSourceCity().trim() : "";
        String dest = (request.getDestinationCity() != null) ? request.getDestinationCity().trim() : "";

        if (source.isBlank() && dest.isBlank()) {
            return flightRepository.findByStatusOrderByDepartureTimeAsc(FlightStatus.SCHEDULED);
        }

        if (request.getDepartureDate() != null) {
            LocalDateTime start = request.getDepartureDate().atStartOfDay();
            LocalDateTime end = request.getDepartureDate().atTime(LocalTime.MAX);
            List<Flight> results = flightRepository.searchFlightsWithDate(source, dest, start, end, seats, FlightStatus.SCHEDULED);
            if (!results.isEmpty()) {
                return results;
            }
        }

        return flightRepository.searchFlightsWithoutDate(source, dest, LocalDateTime.now(), seats, FlightStatus.SCHEDULED);
    }

    @Transactional
    public Flight saveFlight(FlightDto dto, Long id) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
        LocalDateTime departure = LocalDateTime.parse(dto.getDepartureTime(), formatter);
        LocalDateTime arrival = LocalDateTime.parse(dto.getArrivalTime(), formatter);

        if (!arrival.isAfter(departure)) {
            throw new IllegalArgumentException("Arrival time must be after departure time");
        }

        Airline airline = airlineService.getAirlineById(dto.getAirlineId());
        Route route = routeService.getRouteById(dto.getRouteId());

        Flight flight;
        if (id != null) {
            flight = getFlightById(id);
            int bookedSeats = flight.getTotalSeats() - flight.getAvailableSeats();
            if (dto.getTotalSeats() < bookedSeats) {
                throw new IllegalArgumentException("Total seats cannot be less than already booked seats (" + bookedSeats + ")");
            }
            flight.setAvailableSeats(dto.getTotalSeats() - bookedSeats);
        } else {
            flight = new Flight();
            flight.setAvailableSeats(dto.getTotalSeats());
        }

        flight.setFlightNumber(dto.getFlightNumber().trim().toUpperCase());
        flight.setAirline(airline);
        flight.setRoute(route);
        flight.setDepartureTime(departure);
        flight.setArrivalTime(arrival);
        flight.setTotalSeats(dto.getTotalSeats());
        flight.setTicketPrice(dto.getTicketPrice());
        if (dto.getStatus() != null) {
            flight.setStatus(dto.getStatus());
        }
        return flightRepository.save(flight);
    }

    @Transactional
    public void deleteFlight(Long id) {
        Flight flight = getFlightById(id);
        flightRepository.delete(flight);
    }

    @Transactional
    public void deductSeats(Flight flight, int count) {
        if (flight.getAvailableSeats() < count) {
            throw new IllegalStateException("Not enough seats available on flight " + flight.getFlightNumber());
        }
        flight.setAvailableSeats(flight.getAvailableSeats() - count);
        flightRepository.save(flight);
    }

    @Transactional
    public void restoreSeats(Flight flight, int count) {
        int restored = Math.min(flight.getTotalSeats(), flight.getAvailableSeats() + count);
        flight.setAvailableSeats(restored);
        flightRepository.save(flight);
    }
}
