package com.example.config;

import java.nio.file.Path;
import java.nio.file.Paths;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        Path uploadsDir = Paths.get(System.getProperty("user.dir"), "uploads").toAbsolutePath();
        String uploadsPath = uploadsDir.toUri().toString(); // e.g. file:///D:/.../uploads/
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations(uploadsPath);
    }
}
