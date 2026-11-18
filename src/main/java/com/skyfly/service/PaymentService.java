package com.skyfly.service;

import com.skyfly.entity.Booking;
import com.skyfly.entity.Payment;
import com.skyfly.entity.PaymentMethod;
import com.skyfly.entity.PaymentStatus;
import com.skyfly.repository.PaymentRepository;
import com.skyfly.util.BookingReferenceGenerator;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Service
public class PaymentService {

    private final PaymentRepository paymentRepository;

    public PaymentService(PaymentRepository paymentRepository) {
        this.paymentRepository = paymentRepository;
    }

    @Transactional
    public Payment processPayment(Booking booking, BigDecimal amount, PaymentMethod method) {
        String txnRef = BookingReferenceGenerator.generateTransactionReference();
        Payment payment = new Payment(booking, txnRef, amount, method, PaymentStatus.PAID);
        return paymentRepository.save(payment);
    }

    @Transactional
    public void refundPayment(Booking booking) {
        Payment payment = booking.getPayment();
        if (payment != null) {
            payment.setPaymentStatus(PaymentStatus.REFUNDED);
            paymentRepository.save(payment);
        }
    }
}
