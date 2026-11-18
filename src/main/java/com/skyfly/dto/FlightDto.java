package com.skyfly.dto;

import com.skyfly.entity.FlightStatus;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;

public class FlightDto {

    private Long id;

    @NotBlank(message = "Flight number is required (e.g. SF-101)")
    private String flightNumber;

    @NotNull(message = "Airline is required")
    private Long airlineId;

    @NotNull(message = "Route is required")
    private Long routeId;

    @NotBlank(message = "Departure date & time is required (YYYY-MM-DDTHH:MM)")
    private String departureTime;

    @NotBlank(message = "Arrival date & time is required (YYYY-MM-DDTHH:MM)")
    private String arrivalTime;

    @NotNull(message = "Seat capacity is required")
    @Min(value = 1, message = "Total seats must be at least 1")
    private Integer totalSeats;

    private Integer availableSeats;

    @NotNull(message = "Ticket price is required")
    @DecimalMin(value = "0.01", message = "Ticket price must be positive")
    private BigDecimal ticketPrice;

    private FlightStatus status = FlightStatus.SCHEDULED;

    public FlightDto() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getFlightNumber() {
        return flightNumber;
    }

    public void setFlightNumber(String flightNumber) {
        this.flightNumber = flightNumber;
    }

    public Long getAirlineId() {
        return airlineId;
    }

    public void setAirlineId(Long airlineId) {
        this.airlineId = airlineId;
    }

    public Long getRouteId() {
        return routeId;
    }

    public void setRouteId(Long routeId) {
        this.routeId = routeId;
    }

    public String getDepartureTime() {
        return departureTime;
    }

    public void setDepartureTime(String departureTime) {
        this.departureTime = departureTime;
    }

    public String getArrivalTime() {
        return arrivalTime;
    }

    public void setArrivalTime(String arrivalTime) {
        this.arrivalTime = arrivalTime;
    }

    public Integer getTotalSeats() {
        return totalSeats;
    }

    public void setTotalSeats(Integer totalSeats) {
        this.totalSeats = totalSeats;
    }

    public Integer getAvailableSeats() {
        return availableSeats;
    }

    public void setAvailableSeats(Integer availableSeats) {
        this.availableSeats = availableSeats;
    }

    public BigDecimal getTicketPrice() {
        return ticketPrice;
    }

    public void setTicketPrice(BigDecimal ticketPrice) {
        this.ticketPrice = ticketPrice;
    }

    public FlightStatus getStatus() {
        return status;
    }

    public void setStatus(FlightStatus status) {
        this.status = status;
    }
}
