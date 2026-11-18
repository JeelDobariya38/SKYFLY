package com.skyfly.dto;

import com.skyfly.entity.Booking;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class DashboardStatsDto {

    private long totalCustomers;
    private long totalAirlines;
    private long totalFlights;
    private long totalBookings;
    private long confirmedBookings;
    private long cancelledBookings;
    private BigDecimal totalRevenue = BigDecimal.ZERO;
    private List<Map<String, Object>> popularRoutes = new ArrayList<>();
    private List<Booking> recentBookings = new ArrayList<>();

    public DashboardStatsDto() {
    }

    public long getTotalCustomers() {
        return totalCustomers;
    }

    public void setTotalCustomers(long totalCustomers) {
        this.totalCustomers = totalCustomers;
    }

    public long getTotalAirlines() {
        return totalAirlines;
    }

    public void setTotalAirlines(long totalAirlines) {
        this.totalAirlines = totalAirlines;
    }

    public long getTotalFlights() {
        return totalFlights;
    }

    public void setTotalFlights(long totalFlights) {
        this.totalFlights = totalFlights;
    }

    public long getTotalBookings() {
        return totalBookings;
    }

    public void setTotalBookings(long totalBookings) {
        this.totalBookings = totalBookings;
    }

    public long getConfirmedBookings() {
        return confirmedBookings;
    }

    public void setConfirmedBookings(long confirmedBookings) {
        this.confirmedBookings = confirmedBookings;
    }

    public long getCancelledBookings() {
        return cancelledBookings;
    }

    public void setCancelledBookings(long cancelledBookings) {
        this.cancelledBookings = cancelledBookings;
    }

    public BigDecimal getTotalRevenue() {
        return totalRevenue != null ? totalRevenue : BigDecimal.ZERO;
    }

    public void setTotalRevenue(BigDecimal totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public List<Map<String, Object>> getPopularRoutes() {
        return popularRoutes;
    }

    public void setPopularRoutes(List<Map<String, Object>> popularRoutes) {
        this.popularRoutes = popularRoutes;
    }

    public List<Booking> getRecentBookings() {
        return recentBookings;
    }

    public void setRecentBookings(List<Booking> recentBookings) {
        this.recentBookings = recentBookings;
    }
}
