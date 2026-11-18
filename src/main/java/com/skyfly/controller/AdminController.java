package com.skyfly.controller;

import com.skyfly.dto.*;
import com.skyfly.entity.*;
import com.skyfly.service.*;
import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.format.DateTimeFormatter;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private final AdminService adminService;
    private final AirlineService airlineService;
    private final AirportService airportService;
    private final RouteService routeService;
    private final FlightService flightService;
    private final BookingService bookingService;
    private final AuthService authService;

    public AdminController(AdminService adminService,
                           AirlineService airlineService,
                           AirportService airportService,
                           RouteService routeService,
                           FlightService flightService,
                           BookingService bookingService,
                           AuthService authService) {
        this.adminService = adminService;
        this.airlineService = airlineService;
        this.airportService = airportService;
        this.routeService = routeService;
        this.flightService = flightService;
        this.bookingService = bookingService;
        this.authService = authService;
    }

    // ==========================================
    // 1. DASHBOARD
    // ==========================================
    @GetMapping({"", "/", "/dashboard"})
    public String dashboard(Model model) {
        DashboardStatsDto stats = adminService.getDashboardStatistics();
        model.addAttribute("stats", stats);
        return "admin/dashboard";
    }

    // ==========================================
    // 2. AIRLINE MANAGEMENT
    // ==========================================
    @GetMapping("/airlines")
    public String listAirlines(Model model) {
        model.addAttribute("airlines", airlineService.getAllAirlines());
        return "admin/airlines";
    }

    @GetMapping("/airlines/new")
    public String newAirlineForm(Model model) {
        model.addAttribute("airlineDto", new AirlineDto());
        model.addAttribute("isEdit", false);
        return "admin/airline-form";
    }

    @GetMapping("/airlines/edit/{id}")
    public String editAirlineForm(@PathVariable("id") Long id, Model model) {
        Airline airline = airlineService.getAirlineById(id);
        AirlineDto dto = new AirlineDto();
        dto.setId(airline.getId());
        dto.setAirlineName(airline.getAirlineName());
        dto.setAirlineCode(airline.getAirlineCode());
        dto.setDescription(airline.getDescription());
        dto.setStatus(airline.getStatus());

        model.addAttribute("airlineDto", dto);
        model.addAttribute("isEdit", true);
        return "admin/airline-form";
    }

    @PostMapping("/airlines/save")
    public String saveAirline(@Valid @ModelAttribute("airlineDto") AirlineDto airlineDto,
                              BindingResult bindingResult,
                              RedirectAttributes redirectAttributes,
                              Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("isEdit", airlineDto.getId() != null);
            return "admin/airline-form";
        }
        try {
            airlineService.saveAirline(airlineDto, airlineDto.getId());
            redirectAttributes.addFlashAttribute("successMessage", "Airline saved successfully!");
            return "redirect:/admin/airlines";
        } catch (Exception e) {
            model.addAttribute("isEdit", airlineDto.getId() != null);
            model.addAttribute("errorMessage", e.getMessage());
            return "admin/airline-form";
        }
    }

    @PostMapping("/airlines/delete/{id}")
    public String deleteAirline(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        try {
            airlineService.deleteAirline(id);
            redirectAttributes.addFlashAttribute("successMessage", "Airline deleted successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/admin/airlines";
    }

    // ==========================================
    // 3. AIRPORT MANAGEMENT
    // ==========================================
    @GetMapping("/airports")
    public String listAirports(Model model) {
        model.addAttribute("airports", airportService.getAllAirports());
        return "admin/airports";
    }

    @GetMapping("/airports/new")
    public String newAirportForm(Model model) {
        model.addAttribute("airportDto", new AirportDto());
        model.addAttribute("isEdit", false);
        return "admin/airport-form";
    }

    @GetMapping("/airports/edit/{id}")
    public String editAirportForm(@PathVariable("id") Long id, Model model) {
        Airport airport = airportService.getAirportById(id);
        AirportDto dto = new AirportDto();
        dto.setId(airport.getId());
        dto.setAirportName(airport.getAirportName());
        dto.setAirportCode(airport.getAirportCode());
        dto.setCity(airport.getCity());
        dto.setCountry(airport.getCountry());

        model.addAttribute("airportDto", dto);
        model.addAttribute("isEdit", true);
        return "admin/airport-form";
    }

    @PostMapping("/airports/save")
    public String saveAirport(@Valid @ModelAttribute("airportDto") AirportDto airportDto,
                              BindingResult bindingResult,
                              RedirectAttributes redirectAttributes,
                              Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("isEdit", airportDto.getId() != null);
            return "admin/airport-form";
        }
        try {
            airportService.saveAirport(airportDto, airportDto.getId());
            redirectAttributes.addFlashAttribute("successMessage", "Airport saved successfully!");
            return "redirect:/admin/airports";
        } catch (Exception e) {
            model.addAttribute("isEdit", airportDto.getId() != null);
            model.addAttribute("errorMessage", e.getMessage());
            return "admin/airport-form";
        }
    }

    @PostMapping("/airports/delete/{id}")
    public String deleteAirport(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        try {
            airportService.deleteAirport(id);
            redirectAttributes.addFlashAttribute("successMessage", "Airport deleted successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/admin/airports";
    }

    // ==========================================
    // 4. ROUTE MANAGEMENT
    // ==========================================
    @GetMapping("/routes")
    public String listRoutes(Model model) {
        model.addAttribute("routes", routeService.getAllRoutes());
        return "admin/routes";
    }

    @GetMapping("/routes/new")
    public String newRouteForm(Model model) {
        model.addAttribute("routeDto", new RouteDto());
        model.addAttribute("airports", airportService.getAllAirports());
        model.addAttribute("isEdit", false);
        return "admin/route-form";
    }

    @GetMapping("/routes/edit/{id}")
    public String editRouteForm(@PathVariable("id") Long id, Model model) {
        Route route = routeService.getRouteById(id);
        RouteDto dto = new RouteDto();
        dto.setId(route.getId());
        dto.setSourceAirportId(route.getSourceAirport().getId());
        dto.setDestinationAirportId(route.getDestinationAirport().getId());
        dto.setDistanceKm(route.getDistanceKm());
        dto.setStatus(route.getStatus());

        model.addAttribute("routeDto", dto);
        model.addAttribute("airports", airportService.getAllAirports());
        model.addAttribute("isEdit", true);
        return "admin/route-form";
    }

    @PostMapping("/routes/save")
    public String saveRoute(@Valid @ModelAttribute("routeDto") RouteDto routeDto,
                            BindingResult bindingResult,
                            RedirectAttributes redirectAttributes,
                            Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("airports", airportService.getAllAirports());
            model.addAttribute("isEdit", routeDto.getId() != null);
            return "admin/route-form";
        }
        try {
            routeService.saveRoute(routeDto, routeDto.getId());
            redirectAttributes.addFlashAttribute("successMessage", "Route saved successfully!");
            return "redirect:/admin/routes";
        } catch (Exception e) {
            model.addAttribute("airports", airportService.getAllAirports());
            model.addAttribute("isEdit", routeDto.getId() != null);
            model.addAttribute("errorMessage", e.getMessage());
            return "admin/route-form";
        }
    }

    @PostMapping("/routes/delete/{id}")
    public String deleteRoute(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        try {
            routeService.deleteRoute(id);
            redirectAttributes.addFlashAttribute("successMessage", "Route deleted successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/admin/routes";
    }

    // ==========================================
    // 5. FLIGHT MANAGEMENT
    // ==========================================
    @GetMapping("/flights")
    public String listFlights(Model model) {
        model.addAttribute("flights", flightService.getAllFlights());
        return "admin/flights";
    }

    @GetMapping("/flights/new")
    public String newFlightForm(Model model) {
        model.addAttribute("flightDto", new FlightDto());
        model.addAttribute("airlines", airlineService.getActiveAirlines());
        model.addAttribute("routes", routeService.getActiveRoutes());
        model.addAttribute("isEdit", false);
        return "admin/flight-form";
    }

    @GetMapping("/flights/edit/{id}")
    public String editFlightForm(@PathVariable("id") Long id, Model model) {
        Flight flight = flightService.getFlightById(id);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

        FlightDto dto = new FlightDto();
        dto.setId(flight.getId());
        dto.setFlightNumber(flight.getFlightNumber());
        dto.setAirlineId(flight.getAirline().getId());
        dto.setRouteId(flight.getRoute().getId());
        dto.setDepartureTime(flight.getDepartureTime().format(formatter));
        dto.setArrivalTime(flight.getArrivalTime().format(formatter));
        dto.setTotalSeats(flight.getTotalSeats());
        dto.setAvailableSeats(flight.getAvailableSeats());
        dto.setTicketPrice(flight.getTicketPrice());
        dto.setStatus(flight.getStatus());

        model.addAttribute("flightDto", dto);
        model.addAttribute("airlines", airlineService.getActiveAirlines());
        model.addAttribute("routes", routeService.getActiveRoutes());
        model.addAttribute("isEdit", true);
        return "admin/flight-form";
    }

    @PostMapping("/flights/save")
    public String saveFlight(@Valid @ModelAttribute("flightDto") FlightDto flightDto,
                             BindingResult bindingResult,
                             RedirectAttributes redirectAttributes,
                             Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("airlines", airlineService.getActiveAirlines());
            model.addAttribute("routes", routeService.getActiveRoutes());
            model.addAttribute("isEdit", flightDto.getId() != null);
            return "admin/flight-form";
        }
        try {
            flightService.saveFlight(flightDto, flightDto.getId());
            redirectAttributes.addFlashAttribute("successMessage", "Flight schedule saved successfully!");
            return "redirect:/admin/flights";
        } catch (Exception e) {
            model.addAttribute("airlines", airlineService.getActiveAirlines());
            model.addAttribute("routes", routeService.getActiveRoutes());
            model.addAttribute("isEdit", flightDto.getId() != null);
            model.addAttribute("errorMessage", e.getMessage());
            return "admin/flight-form";
        }
    }

    @PostMapping("/flights/delete/{id}")
    public String deleteFlight(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        try {
            flightService.deleteFlight(id);
            redirectAttributes.addFlashAttribute("successMessage", "Flight deleted successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/admin/flights";
    }

    // ==========================================
    // 6. BOOKING MANAGEMENT
    // ==========================================
    @GetMapping("/bookings")
    public String listBookings(@RequestParam(value = "keyword", required = false) String keyword,
                               @RequestParam(value = "status", required = false) BookingStatus status,
                               Model model) {
        List<Booking> bookings;
        if (keyword != null && !keyword.isBlank()) {
            bookings = bookingService.searchBookings(keyword);
        } else if (status != null) {
            bookings = bookingService.filterBookingsByStatus(status);
        } else {
            bookings = bookingService.getAllBookings();
        }
        model.addAttribute("bookings", bookings);
        model.addAttribute("keyword", keyword);
        model.addAttribute("selectedStatus", status);
        return "admin/bookings";
    }

    @GetMapping("/bookings/{id}")
    public String bookingDetailsAdmin(@PathVariable("id") Long id, Model model) {
        Booking booking = bookingService.getBookingById(id);
        model.addAttribute("booking", booking);
        return "admin/booking-details";
    }

    @PostMapping("/bookings/cancel/{id}")
    public String cancelBookingAdmin(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        try {
            bookingService.cancelBooking(id, null, true);
            redirectAttributes.addFlashAttribute("successMessage", "Booking cancelled and refunded successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/admin/bookings/" + id;
    }

    // ==========================================
    // 7. USER MANAGEMENT
    // ==========================================
    @GetMapping("/users")
    public String listUsers(@RequestParam(value = "keyword", required = false) String keyword, Model model) {
        List<User> customers = authService.searchCustomers(keyword);
        model.addAttribute("users", customers);
        model.addAttribute("keyword", keyword);
        return "admin/users";
    }

    @PostMapping("/users/toggle-status/{id}")
    public String toggleUserStatus(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        try {
            authService.toggleUserStatus(id);
            redirectAttributes.addFlashAttribute("successMessage", "User status updated successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/admin/users";
    }
}
