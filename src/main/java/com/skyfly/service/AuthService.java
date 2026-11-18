package com.skyfly.service;

import com.skyfly.dto.RegistrationRequest;
import com.skyfly.entity.Role;
import com.skyfly.entity.User;
import com.skyfly.entity.UserStatus;
import com.skyfly.exception.ResourceNotFoundException;
import com.skyfly.repository.UserRepository;
import com.skyfly.util.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public AuthService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional
    public User register(RegistrationRequest request) {
        if (!request.isPasswordMatching()) {
            throw new IllegalArgumentException("Passwords do not match");
        }
        if (userRepository.existsByEmail(request.getEmail().trim().toLowerCase())) {
            throw new IllegalArgumentException("An account with this email already exists");
        }

        String hashedPassword = passwordEncoder.encode(request.getPassword());
        User user = new User(
                request.getFullName().trim(),
                request.getEmail().trim().toLowerCase(),
                request.getPhoneNumber().trim(),
                hashedPassword,
                Role.CUSTOMER
        );
        return userRepository.save(user);
    }

    public Optional<User> authenticate(String email, String password) {
        if (email == null || password == null) {
            return Optional.empty();
        }
        Optional<User> userOpt = userRepository.findByEmail(email.trim().toLowerCase());
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            if (UserStatus.ACTIVE.equals(user.getStatus()) && passwordEncoder.matches(password, user.getPassword())) {
                return Optional.of(user);
            }
        }
        return Optional.empty();
    }

    public User getUserById(Long id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User", "id", id));
    }

    @Transactional
    public void updateProfile(Long userId, String fullName, String phoneNumber) {
        User user = getUserById(userId);
        user.setFullName(fullName.trim());
        user.setPhoneNumber(phoneNumber.trim());
        userRepository.save(user);
    }

    @Transactional
    public void changePassword(Long userId, String currentPassword, String newPassword) {
        User user = getUserById(userId);
        if (!passwordEncoder.matches(currentPassword, user.getPassword())) {
            throw new IllegalArgumentException("Current password does not match");
        }
        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
    }

    public List<User> getAllCustomers() {
        return userRepository.findByRole(Role.CUSTOMER);
    }

    public List<User> searchCustomers(String keyword) {
        if (keyword == null || keyword.isBlank()) {
            return getAllCustomers();
        }
        return userRepository.findByFullNameContainingIgnoreCaseOrEmailContainingIgnoreCase(keyword.trim(), keyword.trim());
    }

    @Transactional
    public void toggleUserStatus(Long userId) {
        User user = getUserById(userId);
        if (user.isAdmin()) {
            throw new IllegalStateException("Cannot deactivate administrator account");
        }
        user.setStatus(UserStatus.ACTIVE.equals(user.getStatus()) ? UserStatus.INACTIVE : UserStatus.ACTIVE);
        userRepository.save(user);
    }
}
