package com.example.config;

import com.example.webSocket.AdminChatHandler;
import com.example.webSocket.CustomerChatHandler;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.*;

@Configuration
@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer {

    private final AdminChatHandler adminChatHandler;
    private final CustomerChatHandler customerChatHandler;

    public WebSocketConfig(AdminChatHandler adminChatHandler, CustomerChatHandler customerChatHandler) {
        this.adminChatHandler = adminChatHandler;
        this.customerChatHandler = customerChatHandler;
    }

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry.addHandler(adminChatHandler, "/ws/admin/chat").setAllowedOrigins("*");
        registry.addHandler(customerChatHandler, "/ws/customer/chat").setAllowedOrigins("*");
    }
}
