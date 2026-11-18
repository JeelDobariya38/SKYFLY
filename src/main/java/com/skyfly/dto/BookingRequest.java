package com.skyfly.dto;

import com.skyfly.entity.PaymentMethod;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import java.util.ArrayList;
import java.util.List;

public class BookingRequest {

    @NotNull(message = "Flight selection is required")
    private Long flightId;

    @Min(value = 1, message = "At least one passenger is required")
    private Integer passengerCount = 1;

    @Valid
    private List<PassengerDto> passengers = new ArrayList<>();

    private PaymentMethod paymentMethod = PaymentMethod.SIMULATED;

    public BookingRequest() {
    }

    public Long getFlightId() {
        return flightId;
    }

    public void setFlightId(Long flightId) {
        this.flightId = flightId;
    }

    public Integer getPassengerCount() {
        return passengerCount;
    }

    public void setPassengerCount(Integer passengerCount) {
        this.passengerCount = passengerCount;
    }

    public List<PassengerDto> getPassengers() {
        return passengers;
    }

    public void setPassengers(List<PassengerDto> passengers) {
        this.passengers = passengers;
    }

    public PaymentMethod getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(PaymentMethod paymentMethod) {
        this.paymentMethod = paymentMethod;
    }
}
