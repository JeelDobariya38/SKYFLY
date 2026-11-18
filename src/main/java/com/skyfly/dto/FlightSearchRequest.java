package com.skyfly.dto;

import org.springframework.format.annotation.DateTimeFormat;
import java.time.LocalDate;

public class FlightSearchRequest {

    private String sourceCity;
    private String destinationCity;

    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    private LocalDate departureDate;

    private Integer passengers = 1;

    public FlightSearchRequest() {
    }

    public FlightSearchRequest(String sourceCity, String destinationCity, LocalDate departureDate, Integer passengers) {
        this.sourceCity = sourceCity;
        this.destinationCity = destinationCity;
        this.departureDate = departureDate;
        this.passengers = (passengers == null || passengers < 1) ? 1 : passengers;
    }

    public String getSourceCity() {
        return sourceCity;
    }

    public void setSourceCity(String sourceCity) {
        this.sourceCity = sourceCity;
    }

    public String getDestinationCity() {
        return destinationCity;
    }

    public void setDestinationCity(String destinationCity) {
        this.destinationCity = destinationCity;
    }

    public LocalDate getDepartureDate() {
        return departureDate;
    }

    public void setDepartureDate(LocalDate departureDate) {
        this.departureDate = departureDate;
    }

    public Integer getPassengers() {
        return (passengers == null || passengers < 1) ? 1 : passengers;
    }

    public void setPassengers(Integer passengers) {
        this.passengers = passengers;
    }
}
