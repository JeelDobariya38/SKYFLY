package com.skyfly.dto;

import com.skyfly.entity.UserStatus;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

public class RouteDto {

    private Long id;

    @NotNull(message = "Source airport is required")
    private Long sourceAirportId;

    @NotNull(message = "Destination airport is required")
    private Long destinationAirportId;

    @Min(value = 1, message = "Distance must be positive")
    private Integer distanceKm;

    private UserStatus status = UserStatus.ACTIVE;

    public RouteDto() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getSourceAirportId() {
        return sourceAirportId;
    }

    public void setSourceAirportId(Long sourceAirportId) {
        this.sourceAirportId = sourceAirportId;
    }

    public Long getDestinationAirportId() {
        return destinationAirportId;
    }

    public void setDestinationAirportId(Long destinationAirportId) {
        this.destinationAirportId = destinationAirportId;
    }

    public Integer getDistanceKm() {
        return distanceKm;
    }

    public void setDistanceKm(Integer distanceKm) {
        this.distanceKm = distanceKm;
    }

    public UserStatus getStatus() {
        return status;
    }

    public void setStatus(UserStatus status) {
        this.status = status;
    }
}
