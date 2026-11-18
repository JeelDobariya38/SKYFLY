package com.skyfly.repository;

import com.skyfly.entity.Booking;
import com.skyfly.entity.BookingStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface BookingRepository extends JpaRepository<Booking, Long> {

    List<Booking> findByUserIdOrderByBookingDateDesc(Long userId);

    Optional<Booking> findByBookingReference(String bookingReference);

    List<Booking> findAllByOrderByBookingDateDesc();

    List<Booking> findByBookingStatusOrderByBookingDateDesc(BookingStatus status);

    long countByBookingStatus(BookingStatus status);

    List<Booking> findTop5ByOrderByBookingDateDesc();

    @Query("SELECT b FROM Booking b WHERE " +
           "LOWER(b.bookingReference) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(b.user.fullName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(b.user.email) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(b.flight.flightNumber) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
           "ORDER BY b.bookingDate DESC")
    List<Booking> searchBookings(@Param("keyword") String keyword);
}
