package com.skyfly.exception;

import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;

@ControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler(ResourceNotFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public String handleResourceNotFound(ResourceNotFoundException ex, HttpServletRequest request, Model model) {
        log.warn("Resource not found at {}: {}", request.getRequestURI(), ex.getMessage());
        model.addAttribute("statusCode", 404);
        model.addAttribute("errorTitle", "Page or Resource Not Found");
        model.addAttribute("errorMessage", ex.getMessage());
        model.addAttribute("requestUrl", request.getRequestURI());
        return "error/404";
    }

    @ExceptionHandler({IllegalArgumentException.class, IllegalStateException.class})
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public String handleBadRequest(RuntimeException ex, HttpServletRequest request, Model model) {
        log.warn("Bad request at {}: {}", request.getRequestURI(), ex.getMessage());
        model.addAttribute("statusCode", 400);
        model.addAttribute("errorTitle", "Invalid Request");
        model.addAttribute("errorMessage", ex.getMessage());
        model.addAttribute("requestUrl", request.getRequestURI());
        return "error/error";
    }

    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public String handleGenericException(Exception ex, HttpServletRequest request, Model model) {
        log.error("Unhandled exception at " + request.getRequestURI(), ex);
        model.addAttribute("statusCode", 500);
        model.addAttribute("errorTitle", "Internal Server Error");
        model.addAttribute("errorMessage", "An unexpected error occurred while processing your request. Please try again later.");
        model.addAttribute("requestUrl", request.getRequestURI());
        return "error/500";
    }
}
