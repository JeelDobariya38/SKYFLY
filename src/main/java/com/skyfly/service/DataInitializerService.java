package com.skyfly.service;

import com.skyfly.dto.PassengerDto;
import com.skyfly.entity.*;
import com.skyfly.repository.*;
import com.skyfly.util.BookingReferenceGenerator;
import com.skyfly.util.PasswordEncoder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Component
public class DataInitializerService implements CommandLineRunner {

    private static final Logger log = LoggerFactory.getLogger(DataInitializerService.class);

    private final UserRepository userRepository;
    private final AirlineRepository airlineRepository;
    private final AirportRepository airportRepository;
    private final RouteRepository routeRepository;
    private final FlightRepository flightRepository;
    private final BookingRepository bookingRepository;
    private final PaymentRepository paymentRepository;
    private final PasswordEncoder passwordEncoder;

    public DataInitializerService(UserRepository userRepository,
                                  AirlineRepository airlineRepository,
                                  AirportRepository airportRepository,
                                  RouteRepository routeRepository,
                                  FlightRepository flightRepository,
                                  BookingRepository bookingRepository,
                                  PaymentRepository paymentRepository,
                                  PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.airlineRepository = airlineRepository;
        this.airportRepository = airportRepository;
        this.routeRepository = routeRepository;
        this.flightRepository = flightRepository;
        this.bookingRepository = bookingRepository;
        this.paymentRepository = paymentRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public void run(String... args) {
        log.info("Checking SkyFly database seed data...");

        // 1. Seed / Verify Demo Users
        User adminUser = userRepository.findByEmail("admin@skyfly.com").orElseGet(() -> {
            User admin = new User(
                    "System Administrator",
                    "admin@skyfly.com",
                    "+91 9876543210",
                    passwordEncoder.encode("Admin@123"),
                    Role.ADMIN
            );
            return userRepository.save(admin);
        });
        if (!passwordEncoder.matches("Admin@123", adminUser.getPassword())) {
            adminUser.setPassword(passwordEncoder.encode("Admin@123"));
            adminUser.setRole(Role.ADMIN);
            adminUser.setStatus(UserStatus.ACTIVE);
            userRepository.save(adminUser);
        }

        User demoCustomer = userRepository.findByEmail("customer@skyfly.com").orElseGet(() -> {
            User customer = new User(
                    "Demo Customer",
                    "customer@skyfly.com",
                    "+91 9876501234",
                    passwordEncoder.encode("Customer@123"),
                    Role.CUSTOMER
            );
            return userRepository.save(customer);
        });
        if (!passwordEncoder.matches("Customer@123", demoCustomer.getPassword())) {
            demoCustomer.setPassword(passwordEncoder.encode("Customer@123"));
            demoCustomer.setStatus(UserStatus.ACTIVE);
            userRepository.save(demoCustomer);
        }

        // 2. Seed Airlines
        if (airlineRepository.count() == 0) {
            log.info("Seeding Airlines...");
            airlineRepository.saveAll(List.of(
                    new Airline("Air India", "AI", "Flag carrier of India operating modern Boeing & Airbus fleet"),
                    new Airline("IndiGo", "6E", "India's largest low-cost airline known for punctuality"),
                    new Airline("Emirates", "EK", "Premier international airline based in Dubai with global network"),
                    new Airline("British Airways", "BA", "Flag carrier of the United Kingdom serving worldwide"),
                    new Airline("Singapore Airlines", "SQ", "Award-winning airline connecting Asia and beyond")
            ));
        }

        // 3. Seed Airports
        if (airportRepository.count() == 0) {
            log.info("Seeding Airports...");
            airportRepository.saveAll(List.of(
                    new Airport("Indira Gandhi International Airport", "DEL", "New Delhi", "India"),
                    new Airport("Chhatrapati Shivaji Maharaj International Airport", "BOM", "Mumbai", "India"),
                    new Airport("Kempegowda International Airport", "BLR", "Bengaluru", "India"),
                    new Airport("Dubai International Airport", "DXB", "Dubai", "United Arab Emirates"),
                    new Airport("Heathrow Airport", "LHR", "London", "United Kingdom"),
                    new Airport("John F. Kennedy International Airport", "JFK", "New York", "United States"),
                    new Airport("Singapore Changi Airport", "SIN", "Singapore", "Singapore"),
                    new Airport("Dabolim Airport", "GOI", "Goa", "India")
            ));
        }

        // 4. Seed Routes
        if (routeRepository.count() == 0) {
            log.info("Seeding Routes...");
            Airport del = airportRepository.findByAirportCode("DEL").orElseThrow();
            Airport bom = airportRepository.findByAirportCode("BOM").orElseThrow();
            Airport blr = airportRepository.findByAirportCode("BLR").orElseThrow();
            Airport dxb = airportRepository.findByAirportCode("DXB").orElseThrow();
            Airport lhr = airportRepository.findByAirportCode("LHR").orElseThrow();
            Airport jfk = airportRepository.findByAirportCode("JFK").orElseThrow();
            Airport sin = airportRepository.findByAirportCode("SIN").orElseThrow();
            Airport goi = airportRepository.findByAirportCode("GOI").orElseThrow();

            routeRepository.saveAll(List.of(
                    new Route(del, bom, 1148),
                    new Route(bom, del, 1148),
                    new Route(del, blr, 1740),
                    new Route(blr, del, 1740),
                    new Route(bom, dxb, 1928),
                    new Route(dxb, bom, 1928),
                    new Route(del, lhr, 6710),
                    new Route(lhr, del, 6710),
                    new Route(bom, goi, 435),
                    new Route(goi, bom, 435),
                    new Route(del, sin, 4150),
                    new Route(del, jfk, 11760)
            ));
        }

        // 5. Seed Flights
        if (flightRepository.count() == 0) {
            log.info("Seeding Flights...");
            Airline ai = airlineRepository.findByAirlineCode("AI").orElseThrow();
            Airline indigo = airlineRepository.findByAirlineCode("6E").orElseThrow();
            Airline ek = airlineRepository.findByAirlineCode("EK").orElseThrow();
            Airline ba = airlineRepository.findByAirlineCode("BA").orElseThrow();
            Airline sq = airlineRepository.findByAirlineCode("SQ").orElseThrow();

            List<Route> routes = routeRepository.findAll();
            LocalDateTime now = LocalDateTime.now().withMinute(0).withSecond(0).withNano(0);

            // Create flights over the next 14 days
            Route delBom = routes.stream().filter(r -> r.getSourceAirport().getAirportCode().equals("DEL") && r.getDestinationAirport().getAirportCode().equals("BOM")).findFirst().orElseThrow();
            Route bomDel = routes.stream().filter(r -> r.getSourceAirport().getAirportCode().equals("BOM") && r.getDestinationAirport().getAirportCode().equals("DEL")).findFirst().orElseThrow();
            Route delBlr = routes.stream().filter(r -> r.getSourceAirport().getAirportCode().equals("DEL") && r.getDestinationAirport().getAirportCode().equals("BLR")).findFirst().orElseThrow();
            Route bomDxb = routes.stream().filter(r -> r.getSourceAirport().getAirportCode().equals("BOM") && r.getDestinationAirport().getAirportCode().equals("DXB")).findFirst().orElseThrow();
            Route delLhr = routes.stream().filter(r -> r.getSourceAirport().getAirportCode().equals("DEL") && r.getDestinationAirport().getAirportCode().equals("LHR")).findFirst().orElseThrow();
            Route bomGoi = routes.stream().filter(r -> r.getSourceAirport().getAirportCode().equals("BOM") && r.getDestinationAirport().getAirportCode().equals("GOI")).findFirst().orElseThrow();
            Route delSin = routes.stream().filter(r -> r.getSourceAirport().getAirportCode().equals("DEL") && r.getDestinationAirport().getAirportCode().equals("SIN")).findFirst().orElseThrow();

            flightRepository.saveAll(List.of(
                    // Today & Tomorrow Domestic
                    new Flight("AI-101", ai, delBom, now.plusHours(4), now.plusHours(6).plusMinutes(15), 180, new BigDecimal("4500.00")),
                    new Flight("6E-205", indigo, delBom, now.plusHours(8), now.plusHours(10).plusMinutes(20), 180, new BigDecimal("3800.00")),
                    new Flight("AI-102", ai, bomDel, now.plusHours(6), now.plusHours(8).plusMinutes(15), 180, new BigDecimal("4600.00")),
                    new Flight("6E-310", indigo, delBlr, now.plusHours(10), now.plusHours(12).plusMinutes(45), 186, new BigDecimal("5200.00")),
                    new Flight("AI-404", ai, bomGoi, now.plusHours(5), now.plusHours(6).plusMinutes(10), 150, new BigDecimal("2900.00")),

                    // Upcoming Days Domestic
                    new Flight("AI-103", ai, delBom, now.plusDays(1).plusHours(7), now.plusDays(1).plusHours(9).plusMinutes(15), 180, new BigDecimal("4400.00")),
                    new Flight("6E-206", indigo, delBom, now.plusDays(1).plusHours(14), now.plusDays(1).plusHours(16).plusMinutes(20), 180, new BigDecimal("3950.00")),
                    new Flight("6E-312", indigo, delBlr, now.plusDays(2).plusHours(9), now.plusDays(2).plusHours(11).plusMinutes(45), 186, new BigDecimal("5100.00")),
                    new Flight("AI-406", ai, bomGoi, now.plusDays(2).plusHours(11), now.plusDays(2).plusHours(12).plusMinutes(15), 150, new BigDecimal("3100.00")),

                    // International Flights
                    new Flight("EK-501", ek, bomDxb, now.plusHours(12), now.plusHours(15).plusMinutes(30), 250, new BigDecimal("16500.00")),
                    new Flight("EK-502", ek, bomDxb, now.plusDays(1).plusHours(10), now.plusDays(1).plusHours(13).plusMinutes(30), 250, new BigDecimal("17000.00")),
                    new Flight("BA-142", ba, delLhr, now.plusDays(1).plusHours(3), now.plusDays(1).plusHours(12).plusMinutes(45), 280, new BigDecimal("48000.00")),
                    new Flight("SQ-401", sq, delSin, now.plusDays(2).plusHours(22), now.plusDays(3).plusHours(6).plusMinutes(30), 260, new BigDecimal("24000.00"))
            ));
        }

        // 6. Seed Sample Booking for demonstration
        if (bookingRepository.count() == 0) {
            log.info("Seeding Sample Booking...");
            Flight sampleFlight = flightRepository.findAll().get(0);
            String ref = "SF-DEMO01";
            BigDecimal fare = sampleFlight.getTicketPrice().multiply(BigDecimal.valueOf(2));

            Booking booking = new Booking(ref, demoCustomer, sampleFlight, LocalDateTime.now().minusDays(1), fare, 2);

            Passenger p1 = new Passenger("Demo Customer", 28, Gender.MALE, "12A", "ID-982341");
            Passenger p2 = new Passenger("Sarah Customer", 26, Gender.FEMALE, "12B", "ID-982342");
            booking.addPassenger(p1);
            booking.addPassenger(p2);

            sampleFlight.setAvailableSeats(sampleFlight.getAvailableSeats() - 2);
            flightRepository.save(sampleFlight);

            Booking savedBooking = bookingRepository.save(booking);

            Payment payment = new Payment(savedBooking, "TXN-DEMO001", fare, PaymentMethod.SIMULATED, PaymentStatus.PAID);
            paymentRepository.save(payment);
            savedBooking.setPayment(payment);
            bookingRepository.save(savedBooking);
        }

        log.info("SkyFly database initialization complete. Ready for demonstration!");
    }
}
