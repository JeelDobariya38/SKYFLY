package com.skyfly.dto;

import com.skyfly.entity.Gender;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public class PassengerDto {

    @NotBlank(message = "Passenger name is required")
    private String fullName;

    @NotNull(message = "Age is required")
    @Min(value = 0, message = "Age must be valid")
    @Max(value = 120, message = "Age must be valid")
    private Integer age;

    @NotNull(message = "Gender is required")
    private Gender gender = Gender.MALE;

    private String seatNumber;
    private String passportOrId;

    public PassengerDto() {
    }

    public PassengerDto(String fullName, Integer age, Gender gender, String seatNumber, String passportOrId) {
        this.fullName = fullName;
        this.age = age;
        this.gender = gender;
        this.seatNumber = seatNumber;
        this.passportOrId = passportOrId;
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
