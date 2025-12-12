package com.example.config;

import com.example.webSocket.UnifiedChatHandler;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.*;

@Configuration
@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer {

    private final UnifiedChatHandler unifiedChatHandler;

    public WebSocketConfig(UnifiedChatHandler unifiedChatHandler) {
        this.unifiedChatHandler = unifiedChatHandler;
    }

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        // 통합 핸들러 사용 (관리자 + 고객 모두)
        registry.addHandler(unifiedChatHandler, "/ws/chat")
                .setAllowedOrigins("*");
    }
}