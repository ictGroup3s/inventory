# Copilot instructions (inventory)

## Project shape
- This repo’s runnable Spring Boot app lives under `project/` (Maven wrapper + `pom.xml`).
- Tech: Spring Boot 3.5.x, Java 17, JSP views, Oracle JDBC, MyBatis XML mappers, WebSocket chat.

## Build/run (from repo root)
- PowerShell: `cd project; .\mvnw.cmd spring-boot:run`
- Bash: `cd project && ./mvnw spring-boot:run`
- Tests: `cd project; .\mvnw.cmd test` (or `./mvnw test`)

## Key directories
- Controllers: `project/src/main/java/com/example/controller/`
- Services: `project/src/main/java/com/example/service/`
- Data access + MyBatis calls: `project/src/main/java/com/example/model/`
- Mapper XML: `project/src/main/resources/mappers/*.xml` (loaded via `mybatis.mapper-locations`)
- JSP views: `project/src/main/webapp/WEB-INF/views/` (resolver in `application.properties`)
- Static assets: `project/src/main/resources/static/`

## MyBatis conventions (important)
- This codebase uses **two** statement-ID styles—follow the one used by the feature you’re editing:
  - Short namespace strings in XML, called via `SqlSessionTemplate`, e.g. `adminmapper.getItemList` (see `adminMapper.xml` + `AdminRepositoryImpl`).
  - Fully-qualified interface namespace in XML, e.g. `com.example.model.ReviewRepository.selectReviewsByItemNo` (see `ReviewMapper.xml` + `ReviewRepositoryImpl`).
- When adding a query:
  - Ensure the Java call string exactly matches `<mapper namespace>.<statement id>`.
  - Put the XML under `project/src/main/resources/mappers/`.

## WebSocket chat
- WebSocket endpoint: `/ws/chat` registered in `project/src/main/java/com/example/config/WebSocketConfig.java`.
- Handler: `project/src/main/java/com/example/webSocket/UnifiedChatHandler.java`.
- Message format: JSON with `customerId`, `adminId`, `sender` (`admin` or customer), `message`.
  - `message="__JOIN__"`: registers session only (no broadcast/save)
  - `message="__CLOSE__"`: broadcasts close and resets cached file mapping (no DB/file save)
- Chat transcripts are appended to `project/src/main/resources/static/chat/chat_{customerId}_{adminId}_{timestamp}.txt`.
- REST helper to read transcripts: `GET /chat/files/{fileName}` in `UserChatController`.

## Session/auth assumptions used in controllers
- Several endpoints trust the session attribute `loginUser` (e.g. `ReviewController` forces `customer_id` from session and ignores client-supplied id).

## Local config notes
- `project/src/main/resources/application.properties` contains Oracle connection info and OAuth client settings; treat these as local/dev secrets and avoid introducing new hard-coded secrets in code.
