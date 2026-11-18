package com.skyfly.config;

import com.skyfly.interceptor.AuthenticationInterceptor;
import com.skyfly.servlet.HealthCheckServlet;
import org.springframework.boot.web.servlet.ServletRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    private final AuthenticationInterceptor authenticationInterceptor;

    public WebConfig(AuthenticationInterceptor authenticationInterceptor) {
        this.authenticationInterceptor = authenticationInterceptor;
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(authenticationInterceptor)
                .addPathPatterns("/**")
                .excludePathPatterns(
                        "/",
                        "/login",
                        "/register",
                        "/logout",
                        "/flights/**",
                        "/servlet/**",
                        "/app-info",
                        "/static/**",
                        "/css/**",
                        "/js/**",
                        "/images/**",
                        "/error",
                        "/error/**",
                        "/favicon.ico"
                );
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/static/**")
                .addResourceLocations("classpath:/static/");
        registry.addResourceHandler("/css/**")
                .addResourceLocations("classpath:/static/css/");
        registry.addResourceHandler("/js/**")
                .addResourceLocations("classpath:/static/js/");
        registry.addResourceHandler("/images/**")
                .addResourceLocations("classpath:/static/images/");
    }

    /**
     * Explicit Servlet Registration Bean for HealthCheckServlet.
     * Demonstrates Servlet configuration in modern Spring Boot.
     */
    @Bean
    public ServletRegistrationBean<HealthCheckServlet> healthCheckServletRegistrationBean() {
        ServletRegistrationBean<HealthCheckServlet> bean = new ServletRegistrationBean<>(
                new HealthCheckServlet(), "/servlet/health", "/app-info"
        );
        bean.setName("HealthCheckServlet");
        bean.setLoadOnStartup(1);
        return bean;
    }
}
