# Copilot Instructions (Inventory Project)

## Project Overview
- **Framework**: Spring Boot 3.5.8 (Java 17)
- **Database**: Oracle JDBC (`ojdbc11`), MyBatis 3.0.5
- **Frontend**: JSP (`/WEB-INF/views/`), JSTL, Static resources (`/static/`)
- **Features**: WebSocket Chat, OAuth (Google, Kakao), Business Verification

## Build & Run
- **Run App**: `cd project; .\mvnw.cmd spring-boot:run` (Windows) or `./mvnw spring-boot:run` (Bash)
- **Run Tests**: `cd project; .\mvnw.cmd test`
- **Port**: Defaults to `8080`

## Architecture & Key Directories
- **Controllers**: `project/src/main/java/com/example/controller/`
- **Services**: `project/src/main/java/com/example/service/`
- **Models/VOs**: `project/src/main/java/com/example/model/vo/` (Aliased in `application.properties`)
- **Repositories**: `project/src/main/java/com/example/model/` (Impl classes use `SqlSessionTemplate`)
- **Mappers (XML)**: `project/src/main/resources/mappers/`
- **Views (JSP)**: `project/src/main/webapp/WEB-INF/views/`
- **Static Assets**: `project/src/main/resources/static/` (CSS, JS, Chat logs)

## MyBatis Conventions (CRITICAL)
This project uses **two distinct styles** for MyBatis statement IDs. Match the style of the file you are editing:
1.  **Short Namespace**: Used in `AdminRepositoryImpl` / `adminMapper.xml`.
    -   XML: `<mapper namespace="adminmapper">`
    -   Java: `sess.selectList("adminmapper.getItemList")`
2.  **Fully Qualified Namespace**: Used in `ReviewRepositoryImpl` / `ReviewMapper.xml`.
    -   XML: `<mapper namespace="com.example.model.ReviewRepository">`
    -   Java: `sess.selectList("com.example.model.ReviewRepository.selectReviewsByItemNo", ...)`

**Rule**: Always check the XML mapper's `namespace` attribute before writing the Java DAO call.

## WebSocket Chat Implementation
- **Handler**: `UnifiedChatHandler.java` (mapped to `/ws/chat`)
- **Room Logic**: `roomId = customerId + "_" + adminId`
- **Storage**: Chat logs are saved to `src/main/resources/static/chat/` as `.txt` files.
- **Message Protocol**:
    ```json
    {
      "customerId": "...",
      "adminId": "...",
      "sender": "admin" | "customer",
      "message": "..."
    }
    ```
- **Control Messages**: `__JOIN__` (init session), `__CLOSE__` (end session).

## Configuration & Secrets
- **Properties**: `project/src/main/resources/application.properties`
- **Secrets**:
    -   Oracle DB credentials (`c##scott`/`tiger`) are currently hardcoded for dev.
    -   OAuth keys (Google, Kakao) are present in properties.
    -   **Business Verify API**: Uses environment variables `BUSINESS_VERIFY_REMOTE_URL` and `BUSINESS_VERIFY_REMOTE_KEY`. Do not hardcode these.

## Coding Patterns
- **Logging**: Use Lombok `@Slf4j` for logging.
- **Session**: Controllers often rely on `session.getAttribute("loginUser")`. Ensure session state is handled in new endpoints.
- **JSP**: Views are resolved from `/WEB-INF/views/` with `.jsp` suffix.
