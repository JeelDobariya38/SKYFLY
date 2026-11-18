package com.skyfly.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "passengers")
public class Passenger {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "booking_id", nullable = false)
    private Booking booking;

    @Column(name = "full_name", nullable = false, length = 100)
    private String fullName;

    @Column(name = "age", nullable = false)
    private Integer age;

    @Enumerated(EnumType.STRING)
    @Column(name = "gender", nullable = false, length = 10)
    private Gender gender;

    @Column(name = "seat_number", length = 10)
    private String seatNumber;

    @Column(name = "passport_or_id", length = 50)
    private String passportOrId;

    public Passenger() {
    }

    public Passenger(String fullName, Integer age, Gender gender, String seatNumber, String passportOrId) {
        this.fullName = fullName;
        this.age = age;
        this.gender = gender;
        this.seatNumber = seatNumber;
        this.passportOrId = passportOrId;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Booking getBooking() {
        return booking;
    }

    public void setBooking(Booking booking) {
        this.booking = booking;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    public Gender getGender() {
        return gender;
    }

    public void setGender(Gender gender) {
        this.gender = gender;
    }

    public String getSeatNumber() {
        return seatNumber;
    }

    public void setSeatNumber(String seatNumber) {
        this.seatNumber = seatNumber;
    }

    public String getPassportOrId() {
        return passportOrId;
    }

    public void setPassportOrId(String passportOrId) {
        this.passportOrId = passportOrId;
    }
}
