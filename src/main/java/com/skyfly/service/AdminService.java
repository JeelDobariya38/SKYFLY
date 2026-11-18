package com.skyfly.service;

import com.skyfly.dto.DashboardStatsDto;
import com.skyfly.entity.Booking;
import com.skyfly.repository.BookingRepository;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Service
public class AdminService {

    private final JdbcTemplate jdbcTemplate;
    private final BookingRepository bookingRepository;

    public AdminService(JdbcTemplate jdbcTemplate, BookingRepository bookingRepository) {
        this.jdbcTemplate = jdbcTemplate;
        this.bookingRepository = bookingRepository;
    }

    /**
     * Demonstrates explicit Spring JdbcTemplate (direct JDBC SQL queries)
     * for analytical metrics and dashboard reports.
     */
    public DashboardStatsDto getDashboardStatistics() {
        DashboardStatsDto stats = new DashboardStatsDto();

        // 1. Total Registered Customers via direct JDBC query
        Long totalCustomers = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM users WHERE role = 'CUSTOMER'", Long.class);
        stats.setTotalCustomers(totalCustomers != null ? totalCustomers : 0);

        // 2. Total Airlines via direct JDBC query
        Long totalAirlines = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM airlines", Long.class);
        stats.setTotalAirlines(totalAirlines != null ? totalAirlines : 0);

        // 3. Total Flights via direct JDBC query
        Long totalFlights = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM flights", Long.class);
        stats.setTotalFlights(totalFlights != null ? totalFlights : 0);

        // 4. Total Bookings via direct JDBC query
        Long totalBookings = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM bookings", Long.class);
        stats.setTotalBookings(totalBookings != null ? totalBookings : 0);

        // 5. Confirmed Bookings via direct JDBC query
        Long confirmed = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM bookings WHERE booking_status = 'CONFIRMED'", Long.class);
        stats.setConfirmedBookings(confirmed != null ? confirmed : 0);

        // 6. Cancelled Bookings via direct JDBC query
        Long cancelled = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM bookings WHERE booking_status = 'CANCELLED'", Long.class);
        stats.setCancelledBookings(cancelled != null ? cancelled : 0);

        // 7. Total Recorded Revenue via direct JDBC aggregation
        BigDecimal totalRevenue = jdbcTemplate.queryForObject(
                "SELECT COALESCE(SUM(total_amount), 0) FROM bookings WHERE booking_status = 'CONFIRMED'",
                BigDecimal.class);
        stats.setTotalRevenue(totalRevenue != null ? totalRevenue : BigDecimal.ZERO);

        // 8. Popular Routes Report via direct SQL join
        String popularRoutesSql = """
                SELECT CONCAT(sa.city, ' → ', da.city) AS route_label,
                       COUNT(b.id) AS booking_count,
                       COALESCE(SUM(b.total_amount), 0) AS route_revenue
                FROM routes r
                JOIN airports sa ON r.source_airport_id = sa.id
                JOIN airports da ON r.destination_airport_id = da.id
                JOIN flights f ON f.route_id = r.id
                LEFT JOIN bookings b ON b.flight_id = f.id AND b.booking_status = 'CONFIRMED'
                GROUP BY r.id, sa.city, da.city
                ORDER BY booking_count DESC, route_revenue DESC
                LIMIT 5
                """;
        List<Map<String, Object>> popularRoutes = jdbcTemplate.queryForList(popularRoutesSql);
        stats.setPopularRoutes(popularRoutes);

        // 9. Recent Bookings for Dashboard Table
        List<Booking> recentBookings = bookingRepository.findTop5ByOrderByBookingDateDesc();
        stats.setRecentBookings(recentBookings);

        return stats;
    }
}
