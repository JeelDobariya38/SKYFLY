package com.skyfly.util;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;

/**
 * PasswordEncoder component that wraps Spring Security's BCryptPasswordEncoder.
 * Provides standard, secure BCrypt password hashing and verification.
 */
@Component
public class PasswordEncoder {

    private final BCryptPasswordEncoder delegate = new BCryptPasswordEncoder();

    public String encode(CharSequence rawPassword) {
        if (rawPassword == null) {
            throw new IllegalArgumentException("rawPassword cannot be null");
        }
        return delegate.encode(rawPassword);
    }

    public boolean matches(CharSequence rawPassword, String encodedPassword) {
        if (rawPassword == null || encodedPassword == null) {
            return false;
        }
        return delegate.matches(rawPassword, encodedPassword);
    }
}
