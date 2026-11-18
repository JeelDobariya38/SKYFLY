package com.skyfly.repository;

import com.skyfly.entity.Route;
import com.skyfly.entity.UserStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface RouteRepository extends JpaRepository<Route, Long> {

    Optional<Route> findBySourceAirportIdAndDestinationAirportId(Long sourceId, Long destId);

    boolean existsBySourceAirportIdAndDestinationAirportId(Long sourceId, Long destId);

    long countBySourceAirportIdOrDestinationAirportId(Long sourceId, Long destId);

    List<Route> findByStatus(UserStatus status);
}
