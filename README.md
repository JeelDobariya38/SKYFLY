# SkyFly Airlines — Airline Reservation & Ticket Booking System

A full-stack enterprise web application built for the **Advanced Java Technologies (AJT)** academic curriculum. The system automates complete airline operations, providing separate interfaces for customers (flight search, booking, e-ticket issuance, booking history, cancellation) and administrators (flight scheduling, airline management, airport/route directory, passenger booking oversight, customer account management).

---

## 📋 Table of Contents
1. [Project Abstract](#project-abstract)
2. [Technology Stack](#technology-stack)
3. [AJT Technology Mapping](#ajt-technology-mapping)
4. [System Architecture](#system-architecture)
5. [Database Design & Schema](#database-design--schema)
6. [Project Directory Structure](#project-directory-structure)
7. [Prerequisites & Environment](#prerequisites--environment)
8. [Setup & Running Instructions](#setup--running-instructions)
9. [Demonstration Credentials](#demonstration-credentials)
10. [Key Application URLs](#key-application-urls)
11. [Troubleshooting](#troubleshooting)

---

## 🎯 Project Abstract
The **SkyFly Airlines** platform modernizes commercial airline reservations by replacing manual ticketing workflows with an automated, responsive web-based system. Developed using Spring Boot 3, Java Servlets, Jakarta Server Pages (JSP), JSTL, Hibernate ORM, and MySQL, the application enforces transactional integrity on seat allocations, guarantees secure password protection using BCrypt, and offers real-time analytical reporting powered by direct JDBC SQL queries via Spring's `JdbcTemplate`.

---

## 🛠 Technology Stack

### Backend
- **Java**: Version 21 (LTS) / 17
- **Framework**: Spring Boot 3.4.5
- **Web MVC**: Spring MVC with view resolution to JSP
- **Servlet Technology**: Jakarta Servlet 6.0 (`HttpServlet` implementation)
- **Persistence / ORM**: Hibernate ORM 6 via Spring Data JPA
- **Direct JDBC**: Spring `JdbcTemplate` for analytical aggregation queries
- **Security & Hashing**: Spring Security Crypto (`BCryptPasswordEncoder`)
- **Validation**: Jakarta Bean Validation (`hibernate-validator`)
- **Server**: Embedded Apache Tomcat with Jasper JSP engine

### Frontend
- **Templating**: Jakarta Server Pages (JSP 3.1)
- **Tag Libraries**: Jakarta JSTL 3.0 (`core`, `fmt`)
- **Expression Language**: Jakarta Expression Language (EL 5.0)
- **UI & Layout**: HTML5, Modern CSS3 with Custom Properties (Navy & Sky Blue theme)
- **Interactions**: Vanilla JavaScript (no heavy node/npm dependencies)

### Database
- **RDBMS**: MySQL 8+ / MariaDB 10.4+
- **Database Name**: `skyfly_db`
- **Port**: 3306

### Build & Package
- **Build Tool**: Apache Maven 3.9+ / Maven Wrapper (`./mvnw`)
- **Packaging**: WAR (`skyfly-1.0.0.war`) with embedded Tomcat launcher

---

## 🎓 AJT Technology Mapping
This project visibly demonstrates each required core technology under the Advanced Java Technologies curriculum:

| Technology | Implementation Location | Purpose |
| :--- | :--- | :--- |
| **Java Servlets (`HttpServlet`)** | `com.skyfly.servlet.HealthCheckServlet` | Extends `HttpServlet`, handles `doGet()`, returns live JSON diagnostic data via `HttpServletResponse` at `/servlet/health` and `/app-info`. Registered via `ServletRegistrationBean` in `WebConfig`. |
| **JavaServer Pages (JSP)** | `src/main/webapp/WEB-INF/views/**/*.jsp` | Dynamic server-side rendering for customer portal and admin dashboard. Organized into `common/`, `customer/`, `admin/`, `auth/`, and `error/`. |
| **JSTL (`jakarta.tags.core`, `fmt`)** | Throughout all JSP views | `<c:forEach>` for flight & passenger lists, `<c:if>` / `<c:choose>` for conditional status display, `<c:url>` for CSRF/context-safe URLs, `<fmt:formatNumber>` for currency formatting. |
| **Expression Language (EL)** | Throughout all JSP views | `${flight.flightNumber}`, `${sessionScope.currentUser.fullName}`, `${booking.totalAmount}`. |
| **Spring Dependency Injection** | Controllers, Services, Repositories | Constructor injection across all `@Controller`, `@Service`, and `@Repository` beans. |
| **Hibernate ORM / Spring Data JPA** | `com.skyfly.entity.*`, `com.skyfly.repository.*` | Entity mapping with `@Entity`, `@Table`, `@ManyToOne`, `@OneToMany`, `@OneToOne`, `@JoinColumn`, cascading operations, and transactional repository queries. |
| **Spring `JdbcTemplate` (Direct JDBC)** | `com.skyfly.service.AdminService` | Executes raw SQL queries and aggregations for dashboard metrics: customer counts, booking revenue sums, and popular route statistics. |
| **Session Management & Interceptors** | `AuthenticationInterceptor`, `AuthController` | Stores authenticated user in `HttpSession`, prevents unauthorized access to customer bookings and admin routes, protects against session fixation. |
| **BCrypt Password Hashing** | `com.skyfly.util.PasswordEncoder` | Secure Blowfish-based password hashing for all user credentials. |

---

## 🏛 System Architecture
The application adheres to a clean, layered enterprise architecture:

```
[ Web Browser / Client ]
       │  ▲
       ▼  │ (HTTP Requests / JSP & JSTL Dynamic HTML Views)
┌────────────────────────────────────────────────────────┐
│ Spring Boot 3 Web Layer                                │
│  ├─ WebConfig (Interceptor & Servlet Registration)     │
│  ├─ AuthenticationInterceptor (Role & Session Gate)    │
│  ├─ HealthCheckServlet (HttpServlet API)               │
│  └─ Controllers (Home, Auth, Flight, Booking, Admin)   │
└──────────────────────────┬─────────────────────────────┘
                           │
┌──────────────────────────▼─────────────────────────────┐
│ Business Service Layer                                 │
│  ├─ AuthService (Authentication, Profile & Passwords)  │
│  ├─ FlightService (Flight Availability & Schedules)    │
│  ├─ BookingService (@Transactional Booking & Refund)   │
│  ├─ PaymentService (Transaction Generation & Records)  │
│  ├─ AirlineService, AirportService, RouteService       │
│  └─ AdminService (JdbcTemplate Dashboard Analytics)    │
└──────────────────────────┬─────────────────────────────┘
                           │
       ┌───────────────────┴───────────────────┐
       ▼                                       ▼
┌───────────────────────────────┐ ┌──────────────────────────────┐
│ Spring Data JPA / Hibernate   │ │ Spring JdbcTemplate          │
│  (8 Entity Repositories)      │ │  (Raw SQL Analytical Queries)│
└──────────────┬────────────────┘ └──────────────┬───────────────┘
               │                                 │
               └───────────────┬─────────────────┘
                               ▼
               ┌───────────────────────────────┐
               │ MySQL Database (skyfly_db)    │
               └───────────────────────────────┘
```

---

## 🗄 Database Design & Schema

### Tables & Relationships
1. **`users`**: Customer and administrator profiles, hashed passwords, roles (`CUSTOMER`, `ADMIN`), and account statuses (`ACTIVE`, `INACTIVE`).
2. **`airlines`**: Operating air carriers (e.g., Air India, IndiGo, Emirates) with carrier codes and statuses.
3. **`airports`**: Worldwide airport registry (IATA codes, city, country, airport name).
4. **`routes`**: Origin airport to destination airport pairs with distance in kilometers.
5. **`flights`**: Scheduled departures linking airline, route, departure/arrival timestamps, seat capacity, available seats, and ticket price.
6. **`bookings`**: Customer ticket reservations containing booking reference (PNR), passenger count, total fare, and status (`CONFIRMED`, `CANCELLED`).
7. **`passengers`**: Individual traveler details attached to a booking (name, age, gender, assigned seat, ID/passport number).
8. **`payments`**: Transaction records linked to bookings with unique transaction references, payment methods, amounts, and statuses (`PAID`, `REFUNDED`).

---

## 📁 Project Directory Structure
```
d:\SKYFLY\
├── pom.xml                                 # Maven build configuration
├── mvnw / mvnw.cmd                         # Maven wrapper executables
├── .env.example                            # Configuration environment template
├── .gitignore                              # Git exclusion rules
├── AJT_IMPLEMENTATION.md                   # AJT Academic syllabus mapping
├── context.md                              # Implementation snapshot & context
├── Next.md                                 # Action plan for next agent/session
├── database/
│   └── skyfly_db.sql                       # Complete MySQL schema and seed data
└── src/
    ├── main/
    │   ├── java/com/skyfly/
    │   │   ├── SkyflyApplication.java      # Application entrypoint (WAR support)
    │   │   ├── config/                     # WebConfig, DatabaseConfig
    │   │   ├── controller/                 # HomeController, AuthController, FlightController, etc.
    │   │   ├── dto/                        # Request DTOs, Search DTOs, Stats DTOs
    │   │   ├── entity/                     # JPA Entities (User, Flight, Booking, etc.)
    │   │   ├── exception/                  # GlobalExceptionHandler, ResourceNotFoundException
    │   │   ├── interceptor/                # AuthenticationInterceptor
    │   │   ├── repository/                 # 8 Spring Data JPA Repository interfaces
    │   │   ├── service/                    # Business services, DataInitializerService
    │   │   ├── servlet/                    # HealthCheckServlet (HttpServlet implementation)
    │   │   └── util/                       # PasswordEncoder, BookingReferenceGenerator
    │   ├── resources/
    │   │   ├── application.properties      # Spring & MySQL datasource configuration
    │   │   └── static/
    │   │       ├── css/ (style.css, admin.css)
    │   │       └── js/  (main.js, admin.js)
    │   └── webapp/
    │       └── WEB-INF/
    │           └── views/
    │               ├── common/             # header, footer, navbar, admin-nav, messages
    │               ├── customer/           # home, search-results, booking, history, profile
    │               ├── admin/              # dashboard, airlines, airports, routes, flights, bookings, users
    │               ├── auth/               # login, register
    │               └── error/              # 404, 500, error
```

---

## ⚙ Prerequisites & Environment
- **Java Development Kit**: JDK 21 or JDK 17 installed.
- **MySQL / MariaDB**: Running on port `3306` (e.g., via XAMPP or MySQL Server).
- **Maven**: Bundled Maven wrapper (`mvnw.cmd`) or system Maven 3.9+.

---

## 🚀 Setup & Running Instructions

### 1. Database Setup
Ensure MySQL is running on port 3306. Import the database schema and sample data:
```bash
mysql -u root -p < database/skyfly_db.sql
```
*(If your root MySQL user has no password, omit `-p`)*

### 2. Configure Database Credentials (if needed)
Edit `src/main/resources/application.properties` or set environment variables:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/skyfly_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
spring.datasource.username=root
spring.datasource.password=
```

### 3. Build the Application
Compile the project and package the WAR file using the bundled Maven wrapper:
```bash
.\mvnw.cmd clean package -DskipTests
```

### 4. Run the Application
Run the executable Spring Boot application:
```bash
java -jar target/skyfly-1.0.0.war
```
*The application starts embedded Tomcat on port `8080`.*

---

## 🔑 Demonstration Credentials

| Role | Email | Password | Access Privileges |
| :--- | :--- | :--- | :--- |
| **System Administrator** | `admin@skyfly.com` | `Admin@123` | Full access to Admin Dashboard, Flight/Airline/Route CRUD, Bookings & User Management |
| **Demo Customer** | `customer@skyfly.com` | `Customer@123` | Search flights, make reservations, view booking history, cancel tickets, profile |

> **Note**: Quick-fill demo buttons are provided directly on the login page (`/login`) for instantaneous evaluation during demonstrations.

---

## 🌐 Key Application URLs

| URL | Component / Page | Description |
| :--- | :--- | :--- |
| `http://localhost:8080/` | **Home Page** | Flight search hero, featured flights, airline benefits |
| `http://localhost:8080/flights/search` | **Search Results** | Search flights with filters, seat counts, and pricing |
| `http://localhost:8080/login` | **Login Portal** | Customer & Admin login with quick demo credentials |
| `http://localhost:8080/register` | **Registration** | Customer account creation with validation |
| `http://localhost:8080/my-bookings` | **Booking History** | User's bookings, ticket cancellation & details |
| `http://localhost:8080/profile` | **Customer Profile** | Personal information and password change |
| `http://localhost:8080/admin/dashboard` | **Admin Dashboard** | Analytical metrics via JdbcTemplate, recent bookings |
| `http://localhost:8080/admin/flights` | **Flight Management**| Schedule, view, edit, and cancel flight departures |
| `http://localhost:8080/admin/airlines` | **Airline Carrier CRUD** | Manage partner airline operators |
| `http://localhost:8080/admin/airports` | **Airport Directory** | Manage domestic and international airports |
| `http://localhost:8080/admin/routes` | **Route Management** | Manage city-pair flight routes |
| `http://localhost:8080/admin/bookings` | **Booking Oversight** | Inspect passenger manifests, payments, cancel tickets |
| `http://localhost:8080/admin/users` | **User Accounts** | Activate or deactivate customer accounts |
| `http://localhost:8080/servlet/health` | **HttpServlet Health** | **Direct Java Servlet** JSON API demonstrating Servlet technology |
| `http://localhost:8080/app-info` | **App Info Servlet** | Alias servlet endpoint for application metadata |

---

## 🔧 Troubleshooting
- **Port 8080 already in use**:
  Change `server.port=8081` in `application.properties`.
- **Database Connection Refused**:
  Verify MySQL service is running via XAMPP or `net start mysql`.
- **JSP view not rendering**:
  Ensure you are running the packaged WAR or using `./mvnw.cmd spring-boot:run`. WAR packaging includes embedded Jasper JSP compilation.
