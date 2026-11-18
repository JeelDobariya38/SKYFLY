package com.skyfly.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public class AirportDto {

    private Long id;

    @NotBlank(message = "Airport name is required")
    @Size(min = 2, max = 120)
    private String airportName;

    @NotBlank(message = "Airport code is required")
    @Size(min = 3, max = 10, message = "Airport code must be 3-10 letters (e.g. DEL, BOM)")
    private String airportCode;

    @NotBlank(message = "City is required")
    @Size(min = 2, max = 80)
    private String city;

    @NotBlank(message = "Country is required")
    @Size(min = 2, max = 80)
    private String country;

    public AirportDto() {
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
}
