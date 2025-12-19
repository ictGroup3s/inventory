# Copilot instructions (project module)

This folder is the runnable Spring Boot app. Canonical instructions also exist at the repo root: `.github/copilot-instructions.md`.

## Build/run (from this folder)
- PowerShell: `.\mvnw.cmd spring-boot:run`
- Bash: `./mvnw spring-boot:run`
- Tests: `.\mvnw.cmd test` (or `./mvnw test`)

## Architecture highlights
- Spring MVC with JSP views (`spring.mvc.view.*` in `src/main/resources/application.properties`).
- Oracle + MyBatis XML mappers (`mybatis.mapper-locations=classpath:mappers/**/*.xml`).
- Real-time chat via Spring WebSocket at `/ws/chat` (`com.example.config.WebSocketConfig`).

## MyBatis (follow existing style)
- Data access is mostly `SqlSessionTemplate` with string statement IDs.
- Two namespace styles are in use; match the module you’re editing:
  - Short namespace strings (e.g. `adminmapper.getItemList`, see `src/main/resources/mappers/adminMapper.xml`).
  - Fully-qualified namespaces (e.g. `com.example.model.ReviewRepository.selectReviewsByItemNo`, see `src/main/resources/mappers/ReviewMapper.xml`).
- Ensure Java calls match `<mapper namespace>.<statement id>` exactly.

## WebSocket chat protocol
- Handler: `src/main/java/com/example/webSocket/UnifiedChatHandler.java`.
- JSON fields: `customerId`, `adminId`, `sender`, `message`.
  - `message="__JOIN__"`: register session only
  - `message="__CLOSE__"`: broadcast close + reset cached file mapping
- Transcripts append under `src/main/resources/static/chat/` and are read via `GET /chat/files/{fileName}`.
