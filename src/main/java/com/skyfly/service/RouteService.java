package com.skyfly.service;

import com.skyfly.dto.RouteDto;
import com.skyfly.entity.Airport;
import com.skyfly.entity.Route;
import com.skyfly.entity.UserStatus;
import com.skyfly.exception.ResourceNotFoundException;
import com.skyfly.repository.FlightRepository;
import com.skyfly.repository.RouteRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class RouteService {

    private final RouteRepository routeRepository;
    private final AirportService airportService;
    private final FlightRepository flightRepository;

    public RouteService(RouteRepository routeRepository, AirportService airportService, FlightRepository flightRepository) {
        this.routeRepository = routeRepository;
        this.airportService = airportService;
        this.flightRepository = flightRepository;
    }

    public List<Route> getAllRoutes() {
        return routeRepository.findAll();
    }

    public List<Route> getActiveRoutes() {
        return routeRepository.findByStatus(UserStatus.ACTIVE);
    }

    public Route getRouteById(Long id) {
        return routeRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Route", "id", id));
    }

    @Transactional
    public Route saveRoute(RouteDto dto, Long id) {
        if (dto.getSourceAirportId().equals(dto.getDestinationAirportId())) {
            throw new IllegalArgumentException("Source and destination airports cannot be the same");
        }

        Airport source = airportService.getAirportById(dto.getSourceAirportId());
        Airport dest = airportService.getAirportById(dto.getDestinationAirportId());

        Route route;
        if (id != null) {
            route = getRouteById(id);
            if ((!route.getSourceAirport().getId().equals(dto.getSourceAirportId()) ||
                 !route.getDestinationAirport().getId().equals(dto.getDestinationAirportId())) &&
                 routeRepository.existsBySourceAirportIdAndDestinationAirportId(dto.getSourceAirportId(), dto.getDestinationAirportId())) {
                throw new IllegalArgumentException("A route between " + source.getCity() + " and " + dest.getCity() + " already exists");
            }
        } else {
            if (routeRepository.existsBySourceAirportIdAndDestinationAirportId(dto.getSourceAirportId(), dto.getDestinationAirportId())) {
                throw new IllegalArgumentException("A route between " + source.getCity() + " and " + dest.getCity() + " already exists");
            }
            route = new Route();
        }

        route.setSourceAirport(source);
        route.setDestinationAirport(dest);
        route.setDistanceKm(dto.getDistanceKm());
        if (dto.getStatus() != null) {
            route.setStatus(dto.getStatus());
        }
        return routeRepository.save(route);
    }

    @Transactional
    public void deleteRoute(Long id) {
        Route route = getRouteById(id);
        long flightCount = flightRepository.countByRouteId(id);
        if (flightCount > 0) {
            throw new IllegalStateException("Cannot delete route '" + route.getRouteName() +
                    "' because it has " + flightCount + " scheduled flight(s).");
        }
        routeRepository.delete(route);
    }
}
