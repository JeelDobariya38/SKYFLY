package com.skyfly.interceptor;

import com.skyfly.entity.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Component
public class AuthenticationInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        // Admin-only protection
        if (path.startsWith("/admin")) {
            if (currentUser == null) {
                String returnUrl = URLEncoder.encode(uri, StandardCharsets.UTF_8);
                response.sendRedirect(contextPath + "/login?error=auth_required&returnUrl=" + returnUrl);
                return false;
            }
            if (!currentUser.isAdmin()) {
                response.sendRedirect(contextPath + "/?error=access_denied");
                return false;
            }
            return true;
        }

        // Customer authenticated pages protection
        if (path.startsWith("/booking") || path.startsWith("/my-bookings") || path.startsWith("/profile")) {
            if (currentUser == null) {
                String returnUrl = URLEncoder.encode(uri, StandardCharsets.UTF_8);
                response.sendRedirect(contextPath + "/login?error=auth_required&returnUrl=" + returnUrl);
                return false;
            }
            return true;
        }

        return true;
    }
}
