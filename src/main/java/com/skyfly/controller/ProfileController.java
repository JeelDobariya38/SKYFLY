package com.skyfly.controller;

import com.skyfly.dto.ChangePasswordRequest;
import com.skyfly.dto.ProfileUpdateRequest;
import com.skyfly.entity.Booking;
import com.skyfly.entity.User;
import com.skyfly.service.AuthService;
import com.skyfly.service.BookingService;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
public class ProfileController {

    private final AuthService authService;
    private final BookingService bookingService;

    public ProfileController(AuthService authService, BookingService bookingService) {
        this.authService = authService;
        this.bookingService = bookingService;
    }

    @GetMapping("/profile")
    public String profilePage(HttpSession session, Model model) {
        User sessionUser = (User) session.getAttribute("currentUser");
        if (sessionUser == null) {
            return "redirect:/login?error=auth_required";
        }

        User user = authService.getUserById(sessionUser.getId());
        List<Booking> recentBookings = bookingService.getUserBookings(user.getId());

        model.addAttribute("user", user);
        model.addAttribute("recentBookings", recentBookings);
        model.addAttribute("profileRequest", new ProfileUpdateRequest(user.getFullName(), user.getPhoneNumber()));
        model.addAttribute("passwordRequest", new ChangePasswordRequest());
        return "customer/profile";
    }

    @PostMapping("/profile/update")
    public String updateProfile(@Valid @ModelAttribute("profileRequest") ProfileUpdateRequest profileRequest,
                                BindingResult bindingResult,
                                HttpSession session,
                                RedirectAttributes redirectAttributes,
                                Model model) {
        User sessionUser = (User) session.getAttribute("currentUser");
        if (sessionUser == null) {
            return "redirect:/login?error=auth_required";
        }

        if (bindingResult.hasErrors()) {
            User user = authService.getUserById(sessionUser.getId());
            model.addAttribute("user", user);
            model.addAttribute("passwordRequest", new ChangePasswordRequest());
            return "customer/profile";
        }

        authService.updateProfile(sessionUser.getId(), profileRequest.getFullName(), profileRequest.getPhoneNumber());
        User updatedUser = authService.getUserById(sessionUser.getId());
        session.setAttribute("currentUser", updatedUser);

        redirectAttributes.addFlashAttribute("successMessage", "Profile updated successfully!");
        return "redirect:/profile";
    }

    @PostMapping("/profile/change-password")
    public String changePassword(@Valid @ModelAttribute("passwordRequest") ChangePasswordRequest passwordRequest,
                                 BindingResult bindingResult,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes,
                                 Model model) {
        User sessionUser = (User) session.getAttribute("currentUser");
        if (sessionUser == null) {
            return "redirect:/login?error=auth_required";
        }

        if (bindingResult.hasErrors()) {
            User user = authService.getUserById(sessionUser.getId());
            model.addAttribute("user", user);
            model.addAttribute("profileRequest", new ProfileUpdateRequest(user.getFullName(), user.getPhoneNumber()));
            return "customer/profile";
        }

        if (!passwordRequest.isMatching()) {
            bindingResult.rejectValue("confirmPassword", "error.confirmPassword", "New passwords do not match");
            User user = authService.getUserById(sessionUser.getId());
            model.addAttribute("user", user);
            model.addAttribute("profileRequest", new ProfileUpdateRequest(user.getFullName(), user.getPhoneNumber()));
            return "customer/profile";
        }

        try {
            authService.changePassword(sessionUser.getId(), passwordRequest.getCurrentPassword(), passwordRequest.getNewPassword());
            redirectAttributes.addFlashAttribute("successMessage", "Password changed successfully!");
            return "redirect:/profile";
        } catch (IllegalArgumentException e) {
            model.addAttribute("errorMessage", e.getMessage());
            User user = authService.getUserById(sessionUser.getId());
            model.addAttribute("user", user);
            model.addAttribute("profileRequest", new ProfileUpdateRequest(user.getFullName(), user.getPhoneNumber()));
            return "customer/profile";
        }
    }
}
