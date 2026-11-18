package com.skyfly.controller;

import com.skyfly.dto.BookingRequest;
import com.skyfly.dto.PassengerDto;
import com.skyfly.entity.Booking;
import com.skyfly.entity.Flight;
import com.skyfly.entity.PaymentMethod;
import com.skyfly.entity.User;
import com.skyfly.service.BookingService;
import com.skyfly.service.FlightService;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Controller
public class BookingController {

    private final BookingService bookingService;
    private final FlightService flightService;

    public BookingController(BookingService bookingService, FlightService flightService) {
        this.bookingService = bookingService;
        this.flightService = flightService;
    }

    @GetMapping("/booking/new")
    public String newBookingForm(@RequestParam("flightId") Long flightId,
                                 @RequestParam(value = "passengers", defaultValue = "1") int passengerCount,
                                 HttpSession session,
                                 Model model) {
        Flight flight = flightService.getFlightById(flightId);

        if (passengerCount < 1) passengerCount = 1;
        if (passengerCount > flight.getAvailableSeats()) {
            passengerCount = flight.getAvailableSeats();
        }

        User currentUser = (User) session.getAttribute("currentUser");

        BookingRequest bookingRequest = new BookingRequest();
        bookingRequest.setFlightId(flightId);
        bookingRequest.setPassengerCount(passengerCount);
        bookingRequest.setPaymentMethod(PaymentMethod.SIMULATED);

        List<PassengerDto> passengerList = new ArrayList<>();
        for (int i = 0; i < passengerCount; i++) {
            PassengerDto p = new PassengerDto();
            if (i == 0 && currentUser != null) {
                p.setFullName(currentUser.getFullName());
            }
            passengerList.add(p);
        }
        bookingRequest.setPassengers(passengerList);

        BigDecimal totalFare = flight.getTicketPrice().multiply(BigDecimal.valueOf(passengerCount));

        model.addAttribute("flight", flight);
        model.addAttribute("bookingRequest", bookingRequest);
        model.addAttribute("totalFare", totalFare);
        model.addAttribute("passengerCount", passengerCount);
        return "customer/booking";
    }

    @PostMapping("/booking/confirm")
    public String confirmBooking(@Valid @ModelAttribute("bookingRequest") BookingRequest bookingRequest,
                                 BindingResult bindingResult,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes,
                                 Model model) {
        Flight flight = flightService.getFlightById(bookingRequest.getFlightId());

        if (bindingResult.hasErrors()) {
            int count = bookingRequest.getPassengers() != null ? bookingRequest.getPassengers().size() : 1;
            model.addAttribute("flight", flight);
            model.addAttribute("passengerCount", count);
            model.addAttribute("totalFare", flight.getTicketPrice().multiply(BigDecimal.valueOf(count)));
            return "customer/booking";
        }

        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login?error=auth_required";
        }

        try {
            Booking booking = bookingService.createBooking(currentUser, bookingRequest);
            redirectAttributes.addFlashAttribute("successMessage", "Flight booking confirmed successfully!");
            return "redirect:/booking/confirmation/" + booking.getBookingReference();
        } catch (Exception e) {
            model.addAttribute("flight", flight);
            model.addAttribute("errorMessage", e.getMessage());
            int count = bookingRequest.getPassengers() != null ? bookingRequest.getPassengers().size() : 1;
            model.addAttribute("passengerCount", count);
            model.addAttribute("totalFare", flight.getTicketPrice().multiply(BigDecimal.valueOf(count)));
            return "customer/booking";
        }
    }

    @GetMapping("/booking/confirmation/{reference}")
    public String bookingConfirmation(@PathVariable("reference") String reference, Model model) {
        Booking booking = bookingService.getBookingByReference(reference);
        model.addAttribute("booking", booking);
        return "customer/booking-confirmation";
    }

    @GetMapping({"/my-bookings", "/booking/history"})
    public String myBookings(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login?error=auth_required";
        }

        List<Booking> bookings = bookingService.getUserBookings(currentUser.getId());
        model.addAttribute("bookings", bookings);
        return "customer/booking-history";
    }

    @GetMapping("/booking/details/{reference}")
    public String bookingDetails(@PathVariable("reference") String reference,
                                 HttpSession session,
                                 Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        Booking booking = bookingService.getBookingByReference(reference);

        if (currentUser == null || (!currentUser.isAdmin() && !booking.getUser().getId().equals(currentUser.getId()))) {
            return "redirect:/?error=access_denied";
        }

        model.addAttribute("booking", booking);
        return "customer/booking-details";
    }

    @PostMapping("/booking/cancel/{id}")
    public String cancelBooking(@PathVariable("id") Long id,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login?error=auth_required";
        }

        try {
            bookingService.cancelBooking(id, currentUser.getId(), currentUser.isAdmin());
            redirectAttributes.addFlashAttribute("successMessage", "Booking cancelled successfully. Seat capacity has been restored and payment refunded.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }

        return currentUser.isAdmin() ? "redirect:/admin/bookings" : "redirect:/my-bookings";
    }
}
