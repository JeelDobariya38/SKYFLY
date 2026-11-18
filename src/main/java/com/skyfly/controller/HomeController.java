package com.skyfly.controller;

import com.skyfly.dto.FlightSearchRequest;
import com.skyfly.entity.Airport;
import com.skyfly.entity.Flight;
import com.skyfly.service.AirportService;
import com.skyfly.service.FlightService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class HomeController {

    private final FlightService flightService;
    private final AirportService airportService;

    public HomeController(FlightService flightService, AirportService airportService) {
        this.flightService = flightService;
        this.airportService = airportService;
    }

    @GetMapping("/")
    public String home(@RequestParam(value = "error", required = false) String error,
                       Model model) {
        if ("access_denied".equals(error)) {
            model.addAttribute("errorMessage", "Access Denied: You do not have permission to view that page.");
        }

        List<Airport> airports = airportService.getAllAirports();
        List<Flight> featuredFlights = flightService.getFeaturedFlights();

        model.addAttribute("airports", airports);
        model.addAttribute("featuredFlights", featuredFlights);
        model.addAttribute("searchRequest", new FlightSearchRequest());
        return "customer/home";
    }
}
