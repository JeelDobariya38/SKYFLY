package com.skyfly.service;

import com.skyfly.dto.BookingRequest;
import com.skyfly.dto.PassengerDto;
import com.skyfly.entity.*;
import com.skyfly.exception.ResourceNotFoundException;
import com.skyfly.repository.BookingRepository;
import com.skyfly.util.BookingReferenceGenerator;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class BookingService {

    private final BookingRepository bookingRepository;
    private final FlightService flightService;
    private final PaymentService paymentService;

    public BookingService(BookingRepository bookingRepository,
                          FlightService flightService,
                          PaymentService paymentService) {
        this.bookingRepository = bookingRepository;
        this.flightService = flightService;
        this.paymentService = paymentService;
    }

    @Transactional
    public Booking createBooking(User user, BookingRequest request) {
        Flight flight = flightService.getFlightById(request.getFlightId());

        int passengerCount = (request.getPassengers() != null && !request.getPassengers().isEmpty())
                ? request.getPassengers().size()
                : (request.getPassengerCount() != null ? request.getPassengerCount() : 1);

        if (passengerCount <= 0) {
            throw new IllegalArgumentException("Booking must have at least one passenger");
        }

        if (!flight.hasAvailableSeats(passengerCount)) {
            throw new IllegalStateException("Only " + flight.getAvailableSeats() + " seat(s) available. Cannot book " + passengerCount + " seat(s).");
        }

        BigDecimal totalAmount = flight.getTicketPrice().multiply(BigDecimal.valueOf(passengerCount));
        String reference = BookingReferenceGenerator.generateReference();

        Booking booking = new Booking(reference, user, flight, LocalDateTime.now(), totalAmount, passengerCount);

        if (request.getPassengers() != null) {
            int seatIdx = 1;
            for (PassengerDto pDto : request.getPassengers()) {
                String seat = pDto.getSeatNumber();
                if (seat == null || seat.isBlank()) {
                    seat = (flight.getTotalSeats() - flight.getAvailableSeats() + seatIdx) + "A";
                    seatIdx++;
                }
                Passenger passenger = new Passenger(
                        pDto.getFullName().trim(),
                        pDto.getAge(),
                        pDto.getGender() != null ? pDto.getGender() : Gender.MALE,
                        seat,
                        pDto.getPassportOrId() != null ? pDto.getPassportOrId().trim() : null
                );
                booking.addPassenger(passenger);
            }
        }

        // Deduct seats from flight
        flightService.deductSeats(flight, passengerCount);

        // Save booking with passengers
        Booking savedBooking = bookingRepository.save(booking);

        // Process payment record
        PaymentMethod method = request.getPaymentMethod() != null ? request.getPaymentMethod() : PaymentMethod.SIMULATED;
        Payment payment = paymentService.processPayment(savedBooking, totalAmount, method);
        savedBooking.setPayment(payment);

        return savedBooking;
    }

    @Transactional
    public Booking cancelBooking(Long bookingId, Long userId, boolean isAdmin) {
        Booking booking = getBookingById(bookingId);

        if (!isAdmin && !booking.getUser().getId().equals(userId)) {
            throw new IllegalStateException("You are not authorized to cancel this booking");
        }

        if (BookingStatus.CANCELLED.equals(booking.getBookingStatus())) {
            throw new IllegalStateException("This booking has already been cancelled");
        }

        // Update status
        booking.setBookingStatus(BookingStatus.CANCELLED);

        // Restore flight seat capacity
        flightService.restoreSeats(booking.getFlight(), booking.getPassengerCount());

        // Process refund in payment record
        paymentService.refundPayment(booking);

        return bookingRepository.save(booking);
    }

    public List<Booking> getUserBookings(Long userId) {
        return bookingRepository.findByUserIdOrderByBookingDateDesc(userId);
    }

    public Booking getBookingByReference(String reference) {
        return bookingRepository.findByBookingReference(reference)
                .orElseThrow(() -> new ResourceNotFoundException("Booking", "reference", reference));
    }

    public Booking getBookingById(Long id) {
        return bookingRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Booking", "id", id));
    }

    public List<Booking> getAllBookings() {
        return bookingRepository.findAllByOrderByBookingDateDesc();
    }

    public List<Booking> searchBookings(String keyword) {
        if (keyword == null || keyword.isBlank()) {
            return getAllBookings();
        }
        return bookingRepository.searchBookings(keyword.trim());
    }

    public List<Booking> filterBookingsByStatus(BookingStatus status) {
        if (status == null) {
            return getAllBookings();
        }
        return bookingRepository.findByBookingStatusOrderByBookingDateDesc(status);
    }
}
