package com.skyfly.repository;

import com.skyfly.entity.Flight;
import com.skyfly.entity.FlightStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface FlightRepository extends JpaRepository<Flight, Long> {

    List<Flight> findByStatusOrderByDepartureTimeAsc(FlightStatus status);

    List<Flight> findAllByOrderByDepartureTimeDesc();

    long countByAirlineId(Long airlineId);

    long countByRouteId(Long routeId);

    @Query("SELECT f FROM Flight f WHERE " +
           "(LOWER(f.route.sourceAirport.city) = LOWER(:sourceCity) OR LOWER(f.route.sourceAirport.airportCode) = LOWER(:sourceCity)) AND " +
           "(LOWER(f.route.destinationAirport.city) = LOWER(:destCity) OR LOWER(f.route.destinationAirport.airportCode) = LOWER(:destCity)) AND " +
           "f.departureTime >= :startTime AND f.departureTime <= :endTime AND " +
           "f.availableSeats >= :seats AND " +
           "f.status = :status " +
           "ORDER BY f.ticketPrice ASC, f.departureTime ASC")
    List<Flight> searchFlightsWithDate(@Param("sourceCity") String sourceCity,
                                       @Param("destCity") String destCity,
                                       @Param("startTime") LocalDateTime startTime,
                                       @Param("endTime") LocalDateTime endTime,
                                       @Param("seats") int seats,
                                       @Param("status") FlightStatus status);

    @Query("SELECT f FROM Flight f WHERE " +
           "(LOWER(f.route.sourceAirport.city) = LOWER(:sourceCity) OR LOWER(f.route.sourceAirport.airportCode) = LOWER(:sourceCity)) AND " +
           "(LOWER(f.route.destinationAirport.city) = LOWER(:destCity) OR LOWER(f.route.destinationAirport.airportCode) = LOWER(:destCity)) AND " +
           "f.departureTime >= :startTime AND " +
           "f.availableSeats >= :seats AND " +
           "f.status = :status " +
           "ORDER BY f.departureTime ASC, f.ticketPrice ASC")
    List<Flight> searchFlightsWithoutDate(@Param("sourceCity") String sourceCity,
                                          @Param("destCity") String destCity,
                                          @Param("startTime") LocalDateTime startTime,
                                          @Param("seats") int seats,
                                          @Param("status") FlightStatus status);

    List<Flight> findTop6ByStatusAndDepartureTimeAfterOrderByDepartureTimeAsc(FlightStatus status, LocalDateTime now);
}
