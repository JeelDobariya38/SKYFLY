package com.skyfly.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "routes", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"source_airport_id", "destination_airport_id"})
})
public class Route {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "source_airport_id", nullable = false)
    private Airport sourceAirport;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "destination_airport_id", nullable = false)
    private Airport destinationAirport;

    @Column(name = "distance_km")
    private Integer distanceKm;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private UserStatus status = UserStatus.ACTIVE;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    public Route() {
    }

    public Route(Airport sourceAirport, Airport destinationAirport, Integer distanceKm) {
        this.sourceAirport = sourceAirport;
        this.destinationAirport = destinationAirport;
        this.distanceKm = distanceKm;
        this.status = UserStatus.ACTIVE;
    }

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        if (this.status == null) this.status = UserStatus.ACTIVE;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Airport getSourceAirport() {
        return sourceAirport;
    }

    public void setSourceAirport(Airport sourceAirport) {
        this.sourceAirport = sourceAirport;
    }

    public Airport getDestinationAirport() {
        return destinationAirport;
    }

    public void setDestinationAirport(Airport destinationAirport) {
        this.destinationAirport = destinationAirport;
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

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getRouteName() {
        if (sourceAirport != null && destinationAirport != null) {
            return sourceAirport.getCity() + " (" + sourceAirport.getAirportCode() + ") → " +
                   destinationAirport.getCity() + " (" + destinationAirport.getAirportCode() + ")";
        }
        return "Unknown Route";
    }
}
