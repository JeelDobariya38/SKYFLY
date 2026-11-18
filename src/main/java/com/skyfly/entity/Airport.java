package com.skyfly.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "airports")
public class Airport {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "airport_name", nullable = false, length = 120)
    private String airportName;

    @Column(name = "airport_code", nullable = false, unique = true, length = 10)
    private String airportCode;

    @Column(name = "city", nullable = false, length = 80)
    private String city;

    @Column(name = "country", nullable = false, length = 80)
    private String country;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    public Airport() {
    }

    public Airport(String airportName, String airportCode, String city, String country) {
        this.airportName = airportName;
        this.airportCode = airportCode;
        this.city = city;
        this.country = country;
    }

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getAirportName() {
        return airportName;
    }

    public void setAirportName(String airportName) {
        this.airportName = airportName;
    }

    public String getAirportCode() {
        return airportCode;
    }

    public void setAirportCode(String airportCode) {
        this.airportCode = airportCode;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getDisplayName() {
        return city + " (" + airportCode + ") - " + airportName;
    }
}
