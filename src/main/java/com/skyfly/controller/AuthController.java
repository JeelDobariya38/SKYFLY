package com.skyfly.controller;

import com.skyfly.dto.LoginRequest;
import com.skyfly.dto.RegistrationRequest;
import com.skyfly.entity.User;
import com.skyfly.service.AuthService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Optional;

@Controller
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @GetMapping("/login")
    public String loginPage(@RequestParam(value = "error", required = false) String error,
                            @RequestParam(value = "logout", required = false) String logout,
                            @RequestParam(value = "returnUrl", required = false) String returnUrl,
                            HttpSession session,
                            Model model) {
        if (session != null && session.getAttribute("currentUser") != null) {
            User current = (User) session.getAttribute("currentUser");
            return current.isAdmin() ? "redirect:/admin/dashboard" : "redirect:/";
        }

        if ("auth_required".equals(error)) {
            model.addAttribute("errorMessage", "Please log in to continue.");
        } else if ("invalid_credentials".equals(error)) {
            model.addAttribute("errorMessage", "Invalid email or password. Please try again.");
        }

        if (logout != null) {
            model.addAttribute("successMessage", "You have been logged out successfully.");
        }

        model.addAttribute("loginRequest", new LoginRequest());
        model.addAttribute("returnUrl", returnUrl);
        return "auth/login";
    }

    @PostMapping("/login")
    public String processLogin(@Valid @ModelAttribute("loginRequest") LoginRequest loginRequest,
                               BindingResult bindingResult,
                               @RequestParam(value = "returnUrl", required = false) String returnUrl,
                               HttpServletRequest request,
                               Model model) {
        if (bindingResult.hasErrors()) {
            return "auth/login";
        }

        Optional<User> userOpt = authService.authenticate(loginRequest.getEmail(), loginRequest.getPassword());
        if (userOpt.isEmpty()) {
            model.addAttribute("errorMessage", "Invalid email or password. Please try again.");
            model.addAttribute("returnUrl", returnUrl);
            return "auth/login";
        }

        User user = userOpt.get();
        // Invalidate old session and create fresh session to prevent fixation
        HttpSession session = request.getSession(true);
        session.setAttribute("currentUser", user);
        session.setAttribute("userRole", user.getRole().name());

        if (returnUrl != null && !returnUrl.isBlank() && !returnUrl.contains("/login") && !returnUrl.contains("/register")) {
            return "redirect:" + returnUrl;
        }

        return user.isAdmin() ? "redirect:/admin/dashboard" : "redirect:/";
    }

    @GetMapping("/register")
    public String registerPage(HttpSession session, Model model) {
        if (session != null && session.getAttribute("currentUser") != null) {
            return "redirect:/";
        }
        model.addAttribute("registrationRequest", new RegistrationRequest());
        return "auth/register";
    }

    @PostMapping("/register")
    public String processRegister(@Valid @ModelAttribute("registrationRequest") RegistrationRequest registrationRequest,
                                  BindingResult bindingResult,
                                  RedirectAttributes redirectAttributes,
                                  Model model) {
        if (bindingResult.hasErrors()) {
            return "auth/register";
        }

        if (!registrationRequest.isPasswordMatching()) {
            bindingResult.rejectValue("confirmPassword", "error.confirmPassword", "Passwords do not match");
            return "auth/register";
        }

        try {
            authService.register(registrationRequest);
            redirectAttributes.addFlashAttribute("successMessage", "Registration successful! You can now log in.");
            return "redirect:/login";
        } catch (IllegalArgumentException e) {
            model.addAttribute("errorMessage", e.getMessage());
            return "auth/register";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        return "redirect:/login?logout=true";
    }
}
