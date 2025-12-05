package com.example.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

import com.example.webSocket.ChatHandler;

@Configuration
@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer {

    private final ChatHandler chatHandler;

    public WebSocketConfig(ChatHandler chatHandler) {
        this.chatHandler = chatHandler;
    }

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry.addHandler(chatHandler, "/ws/chat").setAllowedOriginPatterns("*");
    }
}



/*public class WebSocketConfig implements WebSocketConfigurer {

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
*/