package com.skyfly.repository;

import com.skyfly.entity.Airline;
import com.skyfly.entity.UserStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface AirlineRepository extends JpaRepository<Airline, Long> {

    Optional<Airline> findByAirlineCode(String airlineCode);

    boolean existsByAirlineCode(String airlineCode);

    List<Airline> findByStatus(UserStatus status);

    List<Airline> findAllByOrderByAirlineNameAsc();
}
