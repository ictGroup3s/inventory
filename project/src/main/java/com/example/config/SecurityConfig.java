package com.example.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.password.NoOpPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;

// 파일 나중에 삭제 **** 개발 전용 로그인 활성화 **********************
// *************** 개발 전용**** 로그인 작업 완료시 파일 삭제    

@Configuration
public class SecurityConfig {

    @Bean
    public UserDetailsService users() {
        UserDetails user = User.withUsername("admin")
                .password("admin")
                .roles("USER")
                .build();
        return new InMemoryUserDetailsManager(user);
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        // Development only: plain text encoder. Replace with BCrypt in production.
        return NoOpPasswordEncoder.getInstance();
    }

// *************** 개발 전용**** 로그인 작업 완료시 파일 삭제    
// 나중에 삭제  -----------------------------------------------
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf().disable() // 개발 편의: CSRF 비활성화 (테스트 용도)
            .authorizeHttpRequests(auth -> auth
                // 보안: 기본적으로 모든 요청은 인증 필요.
                // 개발 중에만 전체 허용이 필요하면 `SecurityConfigDev` (dev 프로파일)를 사용하세요.
                .anyRequest().authenticated()
            );
        return http.build();
    }
}
