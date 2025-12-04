# GitHub Copilot 지침 — Inventory 프로젝트

이 가이드는 Spring Boot + JSP 재고 관리 애플리케이션 작업을 수행하는 AI 에이전트에게 필수적인 컨텍스트를 제공합니다.

## 🏗 프로젝트 아키텍처 및 기술 스택
- **프레임워크**: Spring Boot 3.5.7 (Java 17).
- **프론트엔드**: JSP (`WEB-INF/views`), JSTL, 정적 자산은 `src/main/resources/static`에 위치.
- **데이터베이스**: 하이브리드 방식.
  - **핵심 비즈니스 (상품 등)**: **MyBatis**를 통한 Oracle Database.
  - **채팅 기능**: **Spring Data JPA** (H2/Oracle).
- **빌드**: Maven (`mvnw`).

## 🧩 주요 패턴 및 규칙

### 1. 데이터 액세스 (중요)
이 프로젝트는 두 가지 별도 패턴을 사용합니다. **절대 섞지 마세요.**

#### A. 핵심 비즈니스 로직 (MyBatis DAO 패턴)
`Item`, `Project` 및 레거시 기능에 사용됩니다.
- **VO**: `src/main/java/com/example/domain/`에 위치 (예: `ItemVO`). Lombok `@Data` 사용.
- **Repository**: `src/main/java/com/example/model/`에 위치.
  - **패턴**: 인터페이스 + 구현체 (`@Repository`).
  - **구현**: `SqlSessionTemplate`을 직접 사용.
  - **예시**:
    ```java
    // ItemDetailRepositoryImpl.java
    @Autowired private SqlSessionTemplate sess;
    public List<ItemVO> getItemDetail(ItemVO vo) {
        return sess.selectList("itemDetailMapper.getItemDetail", vo);
    }
    ```
- **Mapper**: `src/main/resources/mappers/`에 있는 XML 파일.
  - **네임스페이스**: 문자열 기반 (예: `<mapper namespace="itemDetailMapper">`), Java 인터페이스와 바인딩되지 *않음*.

#### B. 채팅 기능 (JPA)
실시간 채팅 기능에 사용됩니다.
- **위치**: `src/main/java/com/example/chat/`.
- **패턴**: 표준 Spring Data JPA.
  - **Entity**: `@Entity` 클래스 (예: `ChatMessageEntity`).
  - **Repository**: `JpaRepository` 상속 (예: `ChatMessageRepository`).

### 2. 웹 계층 (Controller & View)
- **Controller**: `src/main/java/com/example/controller/`.
  - **String** 뷰 이름을 반환 ( `WEB-INF/views/` 내의 `.jsp`로 해석됨).
  - 예시: `return "item";` -> `src/main/webapp/WEB-INF/views/item.jsp`.
- **파일 업로드**:
  - Controller에서 수동으로 처리.
  - 대상: `src/main/resources/static/img/uploads`.
  - **참고**: 디렉토리가 없으면 생성해야 함.

### 3. 실시간 / 채팅
- **스택**: Spring WebSocket (STOMP).
- **설정**: `src/main/java/com/example/config/WebSocketConfig.java`.
- **프론트엔드**: `SockJS` 및 `Stomp` 클라이언트 사용 (`chatPopup.jsp` 또는 정적 JS 확인).

## 📂 파일 구조 참조
- **Java 소스**: `src/main/java/com/example/`
  - `controller/`: 웹 컨트롤러.
  - `service/`: 비즈니스 로직.
  - `domain/`: MyBatis VO.
  - `model/`: MyBatis Repository (DAO Impl).
  - `chat/`: 채팅 JPA 엔티티 및 리포지토리.
- **리소스**: `src/main/resources/`
  - `mappers/`: MyBatis XML.
  - `static/`: CSS, JS, 이미지 (루트 `/`에서 제공됨).
  - `application.properties`: DB 및 앱 설정.
- **뷰**: `src/main/webapp/WEB-INF/views/`

## 🚀 빌드 및 실행
- **실행**: `.\mvnw.cmd spring-boot:run`
- **빌드**: `.\mvnw.cmd clean package`
- **테스트**: `.\mvnw.cmd test`
