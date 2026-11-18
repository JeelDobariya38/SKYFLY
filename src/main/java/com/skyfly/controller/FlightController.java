package com.skyfly.controller;

import com.skyfly.dto.FlightSearchRequest;
import com.skyfly.entity.Airport;
import com.skyfly.entity.Flight;
import com.skyfly.service.AirportService;
import com.skyfly.service.FlightService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;

@Controller
public class FlightController {

    private final FlightService flightService;
    private final AirportService airportService;

    public FlightController(FlightService flightService, AirportService airportService) {
        this.flightService = flightService;
        this.airportService = airportService;
    }

    @GetMapping("/flights/search")
    public String searchFlights(@ModelAttribute("searchRequest") FlightSearchRequest searchRequest,
                                Model model) {
        List<Flight> matchingFlights = flightService.searchFlights(searchRequest);
        List<Airport> airports = airportService.getAllAirports();

        model.addAttribute("flights", matchingFlights);
        model.addAttribute("airports", airports);
        model.addAttribute("searchRequest", searchRequest);
        model.addAttribute("resultCount", matchingFlights.size());
        return "customer/search-results";
    }

    @GetMapping("/flights/{id}")
    public String flightDetails(@PathVariable("id") Long id, Model model) {
        Flight flight = flightService.getFlightById(id);
        model.addAttribute("flight", flight);
        return "customer/flight-details";
    }
}
