package com.skyfly.dto;

import com.skyfly.entity.UserStatus;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public class AirlineDto {

    private Long id;

    @NotBlank(message = "Airline name is required")
    @Size(min = 2, max = 100, message = "Airline name must be between 2 and 100 characters")
    private String airlineName;

    @NotBlank(message = "Airline code is required")
    @Size(min = 2, max = 10, message = "Airline code must be 2-10 characters (e.g. AI, 6E)")
    private String airlineCode;

    private String description;
    private UserStatus status = UserStatus.ACTIVE;

    public AirlineDto() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getAirlineName() {
        return airlineName;
    }

    public void setAirlineName(String airlineName) {
        this.airlineName = airlineName;
    }

    public String getAirlineCode() {
        return airlineCode;
    }

    public void setAirlineCode(String airlineCode) {
        this.airlineCode = airlineCode;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public UserStatus getStatus() {
        return status;
    }

    public void setStatus(UserStatus status) {
        this.status = status;
    }
}
