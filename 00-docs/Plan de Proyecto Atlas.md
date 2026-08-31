# Plan de proyecto: Atlas Knowledge Hub

> **Calendario a seguir:** [Plan 10 Dias.md](./Plan%2010%20Dias.md) (10×3 h, mínimo que cubre JD + HR + Atlas).
>
> **Speed run / triage:** [Speed Run Atlas.md](./Speed%20Run%20Atlas.md). Este documento sigue siendo la referencia completa.
>
> **Entrevista de HR:** [Plan Entrevista HR.md](./Plan%20Entrevista%20HR.md) — STAR, vocabulario para reclutadores y ensayo.

## Introducción

Este plan te lleva a construir **un solo proyecto**, simple pero completo, pensado para el rol de Full Stack Java Developer de Konrad Group (1–3 años).

En la entrevista no gana quien recita Spring. Gana quien puede contar **una feature de producción de punta a punta**: pantalla en React → API en Spring Boot → base de datos → caché → seguridad → tests → cómo se revisó y desplegó. Atlas existe para que tengas esa historia, con código tuyo, no de un tutorial.

**Qué vas a construir:** un centro de conocimiento (mini CMS) para una empresa ficticia. Hay un sitio público de artículos de ayuda y un panel para autores. Un usuario inicia sesión, escribe un artículo, lo publica, y cualquier visitante lo ve. Esa feature —**publicar un artículo**— es la que narrarás en la entrevista.

**Por qué este dominio y no un e-commerce genérico:** Konrad entrega aplicaciones consumer y enterprise; el nice-to-have del JD incluye CMS (WordPress, AEM, Sitefinity). Atlas te obliga a modelar contenido, roles, publicación, búsqueda y caché — el mismo tipo de problemas — sin la complejidad de un CMS real.

**Duración sugerida:** 6–8 semanas a ~10 horas/semana, o ~3–4 semanas a tiempo casi completo. No adelantes fases. Cada una cierra un hueco del scorecard.

**Regla de oro:** si no puedes explicarlo en voz alta, no lo subas al repo. Documenta decisiones en un `DECISIONS.md` (por qué PostgreSQL, por qué JWT, por qué Redis). Eso demuestra el “research and share” y el amor por mejorar workflows que pide el JD.

---

## El producto en una frase

Atlas es un knowledge base con:

- Catálogo público de artículos por categoría (listado, detalle, búsqueda).
- Autenticación y roles: `READER`, `AUTHOR`, `ADMIN`.
- Autores crean, editan y publican artículos (borrador vs publicado).
- Comentarios en artículos publicados.
- Panel admin mínimo (listar usuarios, cambiar rol).
- API REST en Java/Spring Boot, UI en React, datos en PostgreSQL, caché en Redis.

---

## Cómo este proyecto cubre el JD

| Punto del JD | Dónde lo practicas en Atlas |
|---|---|
| Java + Spring Boot | Backend entero: controllers, services, repos, config |
| React (o Angular) | SPA: routing, formularios, auth, consumo de API |
| APIs | REST versionada bajo `/api`, DTOs, errores HTTP correctos |
| Routing | React Router + slugs de artículos en el backend |
| Data storage | PostgreSQL + JPA/Hibernate, migraciones Flyway |
| Design patterns | Capas (controller → service → repository), DTO, mapper |
| Optimization + caching | Redis para listado y artículo por slug |
| Security | Spring Security, JWT, roles, CORS, validación |
| HTTP, DOM, SSL, web servers | Fundamentos + HTTPS en deploy + cómo el browser habla con la API |
| Bases relacionales | Esquema, FKs, índices, queries |
| Tests + code review | JUnit, MockMvc, tests de React, PRs contra ti mismo |
| Workflows | Git, Docker, CI simple, `DECISIONS.md` |
| CMS (nice-to-have) | Publicación de contenido, estados draft/published |
| Cloud (nice-to-have) | Deploy en un proveedor (Render, Railway o AWS) |
| GraphQL / ElasticSearch / Next.js | Fase 11, solo si el core ya está sólido |

---

## Stack (no lo cambies)

**Backend:** Java 17, Spring Boot 3.x, Spring Web, Spring Data JPA, Spring Security, Spring Cache, Validation, Flyway.

**Frontend:** React 18+ con Vite, React Router, un cliente HTTP (fetch o Axios). CSS simple (o un sistema mínimo); la UI no tiene que ser premiada, tiene que ser clara.

**Datos:** PostgreSQL 16. **Caché:** Redis.

**Calidad:** JUnit 5, Spring Boot Test / MockMvc, AssertJ; en frontend Vitest + React Testing Library.

**DevOps:** Git, Docker Compose (app + Postgres + Redis), un deploy con HTTPS.

**No uses** Next.js, GraphQL ni ElasticSearch hasta la fase 11. Primero el slice fullstack clásico. El JD dice Spring Boot *o* Spring Cloud: con Spring Boot basta; Spring Cloud es opcional después.

---

## Fase 0 — Fundamentos web (2–3 días)

**Por qué va primero:** el JD pide conocimiento fundamental de HTTP, DOM, SSL y web servers. Si saltas esto, en la entrevista dirás “el frontend llama al backend” y no podrás explicar *qué* viaja por la red.

### Objetivos

- Explicar un request HTTP (método, path, headers, body, status).
- Distinguir 200 / 201 / 400 / 401 / 403 / 404 / 409 / 500.
- Saber qué es el DOM y cómo React lo actualiza (sin recitar el virtual DOM de memoria: con un ejemplo).
- Entender TLS/SSL: por qué HTTPS, qué es un certificado, qué cambia vs HTTP.
- Saber qué hace un web server (Tomcat embebido en Spring Boot vs Nginx sirviendo el build de React).

### Tecnologías

Navegador (DevTools → Network), `curl` o Postman/Insomnia. Nada de Spring todavía, salvo leer qué es el servidor embebido.

### Funcionalidades

Ninguna de producto. Solo práctica:

1. Abre cualquier sitio, inspecciona 3 requests (documento, XHR, estático).
2. Con `curl` haz GET y POST a `https://httpbin.org`.
3. Dibuja en papel: browser → HTTPS → servidor → app.

### Buenas prácticas

- Habla con precisión: “el cliente envía `Authorization: Bearer …`”, no “el login se guarda”.
- Anota un glosario de 15 términos (header, cookie, CORS, origin, idempotencia, REST).

### Conceptos a estudiar

- HTTP/1.1: métodos, códigos, headers `Content-Type`, `Cache-Control`, `Authorization`.
- REST: recurso, representación JSON, idempotencia de GET/PUT/DELETE.
- Same-origin policy y CORS (lo vas a configurar en la fase 7).
- DOM: árbol, eventos, por qué no mezclar jQuery con React.
- SSL/TLS: handshake a alto nivel, certificados, por qué no ir a producción en HTTP.

### Pruebas y despliegue

No aplica. Criterio de salida: explicas en 3 minutos “qué pasa cuando abro un artículo” *antes* de tener código.

### Recursos

- [MDN: HTTP overview](https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview)
- [MDN: CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS)
- [MDN: Document Object Model](https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model)
- [OWASP: Transport Layer Protection](https://cheatsheetseries.owasp.org/cheatsheets/Transport_Layer_Protection_Cheat_Sheet.html)
- Libro: *HTTP: The Definitive Guide* (capítulos 1–5) o el más corto *The TCP/IP Guide* no hace falta; con MDN alcanza.

---

## Fase 1 — Repositorio, arquitectura y workflow (2–3 días)

**Por qué:** Konrad trabaja en equipo, code review y software mantenible. Un repo caótico delata tutorial. Un repo con convenciones delata profesional junior.

### Objetivos

- Repo Git con historial limpio (commits pequeños, mensajes en inglés o español, pero consistentes).
- Monorepo simple o dos carpetas: `/backend` y `/frontend`.
- README con cómo levantar el proyecto.
- `DECISIONS.md` vacío, listo para ir llenándolo.
- Diagrama de capas Spring: Controller → Service → Repository → DB.

### Tecnologías

Git, GitHub/GitLab, Maven o Gradle (elige **Maven** si no tienes preferencia: más común en entrevistas Java), Node 20+, JDK 17, IntelliJ IDEA o VS Code + Extension Pack for Java.

### Funcionalidades

- Skeleton Spring Boot (`spring-boot-starter-web`, actuator opcional).
- Skeleton Vite + React (`npm create vite@latest`).
- `.gitignore` correcto (sin `target/`, `node_modules/`, `.env`).
- Branch `main` protegida en tu cabeza: trabajas en `feature/...`.

### Buenas prácticas

- Conventional commits: `feat: add article entity`, `fix: return 404 when slug missing`.
- Un commit = una idea. No “WIP lots of stuff”.
- Nunca subas secretos. Variables en `.env.example`.
- Paquetes Java por feature o por capa; sé consistente. Recomendado por capa al inicio: `controller`, `service`, `repository`, `domain`, `dto`, `config`, `security`.

### Conceptos

- 12-factor: config por entorno.
- Qué es un JAR ejecutable de Spring Boot y el Tomcat embebido.
- Diferencia Maven vs Gradle (una frase basta).
- Git: branch, PR, rebase vs merge (elige merge PRs; es más simple de explicar).

### Pruebas y despliegue

- `./mvnw test` debe pasar (aunque no haya tests aún).
- `npm run build` debe pasar.

### Recursos

- [Spring Initializr](https://start.spring.io/) — Java 17, Spring Boot 3.x, Maven, Spring Web, Validation, Data JPA, Security, Cache, Actuator.
- [Baeldung: Spring Boot application structure](https://www.baeldung.com/spring-boot)
- [Pro Git, caps. 2–3](https://git-scm.com/book/en/v2)
- Ejercicio: crea el repo, abre un PR de “hello world” contra ti mismo y déjate un comentario de review. Esa costumbre importa en la entrevista.

---

## Fase 2 — Modelo de datos y PostgreSQL (3–4 días)

**Por qué:** el JD pide fluidez con bases relacionales. “Uso JPA” no es fluidez. Fluidez es explicar tablas, FKs, por qué un índice en `slug`, y qué query se ejecuta.

### Objetivos

- Esquema relacional de Atlas en papel *antes* de escribir entidades.
- PostgreSQL corriendo en Docker.
- Entidades JPA + Flyway (las migraciones son la fuente de verdad, no `ddl-auto=update` en serio).
- Seed mínimo: 1 admin, 1 autor, 2 categorías, 3 artículos.

### Tecnologías

PostgreSQL 16, Docker, Flyway, Spring Data JPA, Hibernate.

### Funcionalidades (modelo)

```
users          (id, email UNIQUE, password_hash, display_name, role, created_at)
categories     (id, name, slug UNIQUE)
articles       (id, title, slug UNIQUE, body, status, author_id FK, category_id FK,
                created_at, updated_at, published_at)
comments       (id, article_id FK, author_id FK, body, created_at)
```

`status`: `DRAFT` | `PUBLISHED`. Solo publicados son visibles en el API público.

### Buenas prácticas

- IDs: UUID o BIGSERIAL. Elige UUID y anótalo en `DECISIONS.md`.
- `slug` único, inmutable después de publicar (o redirige: para este proyecto, inmutable).
- Índices: `articles(slug)`, `articles(status, published_at DESC)`, `users(email)`.
- No expongas entidades JPA en el JSON. DTOs desde el día uno.
- `FetchType.LAZY` por defecto. Evita N+1: práctica un `@EntityGraph` o `JOIN FETCH` en “artículo + autor + categoría”.

### Conceptos

- 1:N (autor → artículos), N:1 (artículo → categoría).
- Integridad referencial, `ON DELETE` (restringe borrar categoría con artículos).
- Transacciones: `@Transactional` en el service, no en el controller.
- Diferencia SQL relacional vs NoSQL (una página en `DECISIONS.md`: por qué Postgres aquí; cuándo usarías Mongo).

### Pruebas y despliegue

- Docker Compose: servicio `postgres` con volumen.
- Test de repositorio con `@DataJpaTest` + Testcontainers (si Testcontainers se te traba, usa H2 *solo* en tests y anota la diferencia). Preferible Testcontainers: es lo que se parece a producción.

### Recursos

- [PostgreSQL tutorial (oficial, Getting Started)](https://www.postgresql.org/docs/current/tutorial.html)
- [Flyway docs](https://documentation.red-gate.com/fd/quickstart-184127223.html)
- [Baeldung: Spring Data JPA](https://www.baeldung.com/spring-data-jpa-tutorial)
- [Baeldung: N+1 problem](https://www.baeldung.com/hibernate-n-plus-one-problem-and-solutions)
- Libro: *Designing Data-Intensive Applications* (cap. 2, modelos de datos) — opcional, muy bueno para entrevista.

---

## Fase 3 — API REST en Spring Boot (5–7 días)

**Por qué:** “very strong Java programming skills utilizing Spring Boot”. Aquí se gana o se pierde el scorecard técnico. Construye el API *antes* del frontend para poder probarlo con curl/Postman.

### Objetivos

- CRUD de categorías (admin) y artículos (autor).
- Listado público paginado y detalle por slug.
- Comentarios en artículos publicados.
- Manejo global de errores (`@ControllerAdvice`).
- Validación con Bean Validation (`@NotBlank`, `@Size`, `@Email`).
- Capa de servicios con reglas: no publicar vacío, slug único, solo el autor edita su borrador.

### Tecnologías

Spring Web, Bean Validation, MapStruct o mapeo manual (manual está bien a esta escala), Spring Data `Pageable`.

### Funcionalidades clave

| Método | Ruta | Quién | Qué |
|---|---|---|---|
| POST | `/api/auth/register` | público | alta de usuario (rol READER) |
| POST | `/api/auth/login` | público | (stub hasta fase 4; o ya JWT) |
| GET | `/api/articles?category=&q=&page=` | público | solo PUBLISHED |
| GET | `/api/articles/{slug}` | público | 404 si draft o no existe |
| POST | `/api/articles` | AUTHOR+ | crea DRAFT |
| PUT | `/api/articles/{id}` | autor o ADMIN | edita |
| POST | `/api/articles/{id}/publish` | autor o ADMIN | pasa a PUBLISHED |
| DELETE | `/api/articles/{id}` | ADMIN | baja |
| GET | `/api/categories` | público | listado |
| POST | `/api/categories` | ADMIN | alta |
| GET | `/api/articles/{slug}/comments` | público | listado |
| POST | `/api/articles/{slug}/comments` | autenticado | crea |

Puedes dejar auth como “permitAll” temporal **solo si** en la fase 4 lo cierras. Mejor: esqueletos de seguridad ya.

### Buenas prácticas

- DTOs de entrada y salida distintos (`CreateArticleRequest` vs `ArticleResponse`).
- Nunca devolver `passwordHash`.
- Códigos HTTP honestos (201 + `Location` al crear).
- API consistente en JSON (`camelCase`). `server.servlet.context-path` no hace falta.
- Logs: INFO al publicar, WARN en 401/403, ERROR con stack solo en 500. Sin logs de passwords.
- Código Java idiomático: inmutables donde se pueda, `Optional` en repos, no `NullPointerException` como control de flujo.

### Conceptos

- Inyección de dependencias, `@Service`, `@Repository`, `@RestController`.
- Ciclo de un request Spring MVC.
- DTO vs Entity (por qué no son lo mismo).
- Paginación y por qué no devolver 10.000 filas.
- Idempotencia: PUT vs POST `/publish`.
- Principios SOLID a escala junior: un service no parsea HTTP; un controller no hace SQL.

### Pruebas y despliegue

- Tests `@WebMvcTest` del controller de artículos (mock del service).
- Un test `@SpringBootTest` + MockMvc del listado público.
- Collection de Postman/Insomnia en `/docs/api`.

### Recursos

- [Spring Guides: Building a RESTful Web Service](https://spring.io/guides/gs/rest-service/)
- [Baeldung: Error handling for REST](https://www.baeldung.com/exception-handling-for-rest-with-spring)
- [Baeldung: Bean Validation](https://www.baeldung.com/spring-boot-bean-validation)
- Libro: *Spring Boot in Action* (o el más actual *Spring Boot 3 Up and Running*).
- Ejercicio: implementa 404 vs 403 (artículo draft de otro usuario) y explícalo en voz alta.

---

## Fase 4 — Seguridad (3–4 días)

**Por qué:** el JD lista security como parte de “modern web application”. En entrevista, “tenemos login” es débil. “JWT en header, roles en el token, BCrypt, CORS restringido al origin del frontend” es el nivel junior/strong junior.

### Objetivos

- Registro y login reales.
- Passwords con BCrypt (nunca texto plano, nunca MD5).
- JWT de acceso (expiración corta, p. ej. 1h). Refresh token opcional; si te complica, no lo hagas y anótalo como deuda.
- Endpoints protegidos por rol.
- CORS: solo el origin de Vite (`http://localhost:5173`) en dev.

### Tecnologías

Spring Security 6, `jjwt` o `spring-security-oauth2-jose` para JWT, BCrypt.

### Funcionalidades

- Login devuelve `{ accessToken, tokenType, expiresIn, user }`.
- Frontend (fase 6) guardará el token; aquí documenta el contrato.
- Un AUTHOR no crea categorías. Un READER no crea artículos. Un no autenticado no comenta.

### Buenas prácticas

- Stateless: no sessions de servidor.
- No pongas datos sensibles en el JWT (solo `sub` + `role`).
- Rate limiting no es obligatorio; menciona que lo pondrías en el gateway/Nginx.
- Headers de seguridad en deploy (fase 10): `HSTS` cuando haya HTTPS.
- Validar inputs (SQL injection lo cubre JPA parametrizado; XSS se cubre en React no usando `dangerouslySetInnerHTML` en el body del artículo — o sanitiza si renderizas Markdown).

### Conceptos

- Authentication vs authorization.
- Password hashing vs encryption.
- CSRF: por qué en SPA + JWT Bearer suele deshabilitarse CSRF (y cuándo no).
- OWASP Top 10 a nivel conversación: injection, broken auth, XSS, security misconfiguration.

### Pruebas y despliegue

- Test: request sin token a POST `/api/articles` → 401.
- Test: READER a POST `/api/articles` → 403.
- Test: AUTHOR publica → 200 y el GET público lo ve.

### Recursos

- [Spring Security Reference](https://docs.spring.io/spring-security/reference/index.html)
- [Baeldung: JWT with Spring Security](https://www.baeldung.com/spring-security-oauth-jwt)
- [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/) — Auth, JWT, Password Storage.
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)

---

## Fase 5 — Caché, rendimiento y diseño (2–3 días)

**Por qué:** el JD pide optimization y caching de forma explícita. Es un diferenciador fácil: mucha gente llega con CRUD y se queda muda cuando preguntan “¿qué pasa si 10.000 usuarios abren el home?”.

### Objetivos

- Cachear `GET /api/articles` (primera página, publicados) y `GET /api/articles/{slug}`.
- Invalidar caché al publicar, editar o borrar.
- Medir *antes/después* (tiempo de respuesta con actuator o un log).
- Una mejora SQL: índice + evitar N+1 en el detalle.

### Tecnologías

Spring Cache, Redis (`spring-boot-starter-data-redis`), Docker Redis.

### Funcionalidades

- `@Cacheable` en el service de listado y detalle.
- `@CacheEvict` en publish/update/delete.
- TTL razonable (p. ej. 5 minutos) por si se olvida un evict.

### Buenas prácticas

- Cachea DTOs, no entidades Hibernate (las entidades detachadas/proxies son una trampa).
- Clave de caché incluye query params relevantes (`category`, `page`).
- No cachees respuestas autenticadas distintas por usuario en el mismo key.
- Documenta en `DECISIONS.md`: cache-aside, TTL, qué *no* cacheas (comentarios recientes, si quieres consistencia fuerte).

### Conceptos

- Cache-aside vs write-through (nombra cache-aside).
- Invalidación: el problema difícil de la caché.
- Complejidad: O(1) lookup vs query a Postgres.
- Pagination y por qué cachear solo las primeras páginas.

### Pruebas y despliegue

- Test de integración: segundo GET no pega a DB (puedes spy el repository) o verificar hit en Redis.
- Redis en Docker Compose.

### Recursos

- [Spring Cache Abstraction](https://docs.spring.io/spring-framework/reference/integration/cache.html)
- [Baeldung: Spring Cache with Redis](https://www.baeldung.com/spring-boot-redis-cache)
- [Redis docs: eviction](https://redis.io/docs/latest/develop/reference/eviction/)
- Ejercicio de entrevista: “¿Qué invalidas cuando un autor publica?” — ensaya la respuesta.

---

## Fase 6 — Frontend React (5–7 días)

**Por qué:** el rol es fullstack. React o Angular “or similar”. React es la apuesta más portable. Debes poder hablar de routing, estado, formularios y cómo el browser construye el DOM.

### Objetivos

- SPA usable, no un prototipo roto.
- Rutas: home, detalle, login, registro, editor, “mis artículos”, admin usuarios.
- Auth state (token en memoria + `localStorage`; documenta el riesgo XSS).
- Formularios con validación visible.
- Estados de UI: loading, vacío, error.

### Tecnologías

React 18, Vite, React Router 6, CSS modules o un único `styles.css` limpio. Sin Redux a menos que lo necesites: Context para auth alcanza.

### Funcionalidades clave

- **Home:** lista de publicados, filtro por categoría, búsqueda `q`, paginación.
- **Detalle:** título, autor, fecha, cuerpo, comentarios + form si hay sesión.
- **Login / register.**
- **Editor:** crear/editar draft, botón Publicar (la feature estrella).
- **Dashboard:** mis artículos con badge Draft/Published.
- **Admin:** tabla de usuarios y cambio de rol (simple).

### Buenas prácticas

- Componentes pequeños: `ArticleCard`, `ArticleForm`, `ProtectedRoute`.
- Un módulo `api.js` (o `api/`): base URL, `Authorization` header, parseo de errores.
- No dejes `console.log` de tokens.
- Accesibilidad básica: `label` en inputs, botones reales, contraste razonable.
- El body del artículo: texto o Markdown renderizado con librería que escape HTML.

### Conceptos

- SPA vs MPA (y por qué luego Next.js es nice-to-have).
- React Router: rutas anidadas, params (`:slug`).
- Controlled components.
- Lifting state vs Context.
- Cómo React actualiza el DOM (reconciliación a alto nivel).
- CORS visto desde el browser: el preflight OPTIONS.

### Pruebas y despliegue

- Vitest + Testing Library: test del form de login (submit llama a `api.login`).
- Test de `ProtectedRoute` (redirige si no hay token).
- `npm run build` genera estáticos que luego servirá Nginx o el propio Spring.

### Recursos

- [React docs (beta): Learn](https://react.dev/learn)
- [React Router tutorial](https://reactrouter.com/en/main/start/tutorial)
- [Testing Library: React](https://testing-library.com/docs/react-testing-library/intro/)
- [MDN: Using the Fetch API](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API/Using_Fetch)
- Si prefieres Angular: mismo diseño de pantallas; módulos + HttpClient + AuthGuard. El JD acepta ambos; no mezcles.

---

## Fase 7 — Integración fullstack: la feature que contarás (3–4 días)

**Por qué:** el screening bar dice: *Must show both sides of the stack in one feature* y *Can narrate a production feature from UI → API → database and back*. Esta fase no agrega pantallas nuevas: **cose el flujo de publicar** y lo deja demoable.

### Objetivos

- Flujo completo grabable en 2 minutos:
  1. Login como AUTHOR.
  2. Crear artículo (draft).
  3. Publicar.
  4. Logout / ventana anónima.
  5. Ver el artículo en el home y abrirlo.
- CORS funcionando.
- Errores de API mostrados en UI (409 slug duplicado, 401 sesión caducada).
- Invalidación de caché visible: el home se actualiza tras publicar (refetch o cache evict + reload).

### Tecnologías

Las ya elegidas. DevTools Network es tu herramienta principal.

### Funcionalidades

- Refresh del listado tras publicar.
- Redirect a `/articles/{slug}` después de publicar.
- Mensaje flash “Published”.

### Buenas prácticas

- Escribe un script de demo en `DEMO.md` (usuarios seed, pasos).
- Captura 1 diagrama (excalidraw o mermaid) del flujo. Lo usarás en la entrevista.
- Perfila un request en Network: status, headers, tiempo. Entiende cada uno.

### Conceptos

- Trazar un request: click → fetch → CORS → Security filter → Controller → Service → `@CacheEvict` → Repository → SQL → response JSON → setState → DOM.
- Contratos: frontend y backend acuerdan DTOs; un cambio de campo rompe el otro lado.
- Idempotencia al doble-click en Publicar (deshabilita el botón).

### Pruebas y despliegue

- Un test E2E mínimo (Playwright o Cypress) del happy path de publicar. Si el tiempo aprieta, un test de integración backend + un test de UI separados, y un checklist manual en `DEMO.md`.
- Criterio de salida: un compañero (o tú al día siguiente) sigue `DEMO.md` y lo logra sin preguntarte.

### Recursos

- [Playwright: intro](https://playwright.dev/docs/intro)
- Ejercicio: explica el flujo en inglés, 3 minutos, grabándote. El JD espera comunicación clara.

---

## Fase 8 — Testing serio (3–4 días)

**Por qué:** “Participate in code review and perform extensive testing”. Sin tests, el proyecto parece homework. Con tests en las reglas de negocio, parece producción junior.

### Objetivos

- Pirámide: muchos unitarios de service, algunos de API, pocos E2E.
- Cubrir: publicar, 404 de draft, 403 de rol, validación, caché evict (si es estable).
- Frontend: login, render de lista vacía, submit del editor.
- CI: GitHub Actions que corra `mvn test` y `npm test` en cada push.

### Tecnologías

JUnit 5, Mockito, MockMvc, Testcontainers, Vitest, Testing Library, GitHub Actions.

### Funcionalidades (calidad, no producto)

- `ArticleServiceTest`: no publica body vacío; slug duplicado lanza excepción de dominio.
- `ArticleControllerIT`: GET público no lista drafts.
- `SecurityIT`: matriz 401/403.
- CI verde.

### Buenas prácticas

- Nombres de test que lees como spec: `publish_shouldReturn404_whenArticleDoesNotExist`.
- No tests que solo verifican getters.
- Datos de test aislados (cada test crea lo suyo o usa `@Transactional` rollback).
- Cobertura como brújula, no como dogma. Apunta a reglas de negocio, no a el 100% de DTOs.

### Conceptos

- Unit vs integration vs E2E.
- Test doubles: mock vs stub vs fake.
- Qué no testear (el internals de Hibernate).
- Flaky tests: por qué duelen en un equipo.

### Pruebas y despliegue

Esta fase *es* pruebas. El “despliegue” es el pipeline CI: el merge a `main` exige verde.

### Recursos

- [Spring Boot Testing](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.testing)
- [Baeldung: Testcontainers](https://www.baeldung.com/spring-boot-testcontainers-integration-test)
- [JUnit 5 user guide](https://junit.org/junit5/docs/current/user-guide/)
- [Kent C. Dodds: Testing JavaScript](https://testingjavascript.com/) — o sus artículos gratis sobre Testing Library.
- Libro: *Unit Testing Principles, Practices, and Patterns* (Khorikov) — caps. 1–4.

---

## Fase 9 — Calidad, code review y procesos (2 días)

**Por qué:** el JD pide software mantenible, code review, comunicación, y “a love for improving software development workflows”. Un candidato que muestra PRs, linters y un README de contribución marca proactividad.

### Objetivos

- Checkstyle o Spotless en Java; ESLint + Prettier en React.
- Template de PR (qué cambió, cómo probarlo, screenshots).
- Al menos 5 PRs en el historial (aunque seas tú el reviewer).
- README de nivel profesional: stack, arquitectura, cómo correr, cómo testear, decisiones.
- Actuator `/health` (y no expongas `/env` en público).

### Tecnologías

Spotless o Checkstyle, ESLint, EditorConfig, GitHub PR template, Spring Boot Actuator.

### Funcionalidades

Ninguna nueva de negocio. Pulir:

- Manejo de errores de UI consistente.
- 404 de React Router.
- Logs estructurados simples.

### Buenas prácticas

- Relee tu código como si fuera de un extraño. Deja 3 comentarios de review en PRs viejos y corrígelos (eso *es* code review).
- ISSUE_TEMPLATE opcional: bug / feature.
- Changelog breve.

### Conceptos

- Definition of Done junior: código, test, README, PR.
- Deuda técnica consciente vs accidental.
- Observabilidad mínima: health, logs, un metric de timer en el listado (micrometer, opcional).

### Pruebas y despliegue

- El linter corre en CI.
- Code review “contra ti”: aprueba solo si el PR cumple el template.

### Recursos

- [Google Java Style](https://google.github.io/styleguide/javaguide.html) (o el de Spring).
- [Conventional Commits](https://www.conventionalcommits.org/)
- [12-factor app](https://12factor.net/)
- Artículo: cualquier guía de “how to write a good pull request”. Léela y aplícala.

---

## Fase 10 — Docker, despliegue y HTTPS (3–4 días)

**Por qué:** “fundamental knowledge of web servers” + nice-to-have cloud. No necesitas ser DevOps. Sí necesitas haber puesto Atlas en internet con HTTPS y poder decir “el JAR corre en un contenedor, Postgres gestionado, el frontend en un CDN o Nginx, TLS lo termina el proxy”.

### Objetivos

- `Dockerfile` del backend (multi-stage Maven → JRE).
- Frontend: build estático servido por Nginx **o** por Spring (`spring-boot-starter-web` + `classpath:/static`). Elige uno y documéntalo. Recomendado para simpleza: **Nginx sirve el SPA, Spring solo API**, o un único compose detrás de un reverse proxy.
- Docker Compose de producción-like: api, web, postgres, redis.
- Deploy en **un** cloud: Render, Railway, Fly.io, o AWS (App Runner / Elastic Beanstalk / ECS Fargate). Uno solo.
- HTTPS real (el PaaS suele dar certificado).
- Variables de entorno: `DATABASE_URL`, `JWT_SECRET`, `REDIS_URL`, `CORS_ORIGINS`.

### Tecnologías

Docker, Docker Compose, Nginx (si aplica), un PaaS. SSL lo emite el proveedor (Let’s Encrypt).

### Funcionalidades

- URL pública que abre Atlas.
- Healthcheck del API.
- Seed no destructivo o un usuario demo documentado.

### Buenas prácticas

- Imagen no corre como root.
- Secretos en el panel del PaaS, no en Git.
- `spring.jpa.hibernate.ddl-auto=validate` en prod (Flyway migra).
- CORS_ORIGINS = tu dominio HTTPS, no `*`.
- Backup: al menos “sé que Postgres del PaaS tiene backups”; anótalo.

### Conceptos

- Contenedor vs VM.
- Reverse proxy, TLS termination.
- Variables de entorno vs `application.properties`.
- Diferencia dev (Vite proxy) vs prod (mismo dominio `/api` o subdominio `api.`).
- Qué es un web server (Nginx) vs application server (Tomcat embebido).

### Pruebas y despliegue

- Checklist: HTTPS, login demo, publicar un artículo, aparece en home.
- Smoke test post-deploy (curl al `/actuator/health` y al `/api/articles`).
- Si el PaaS duerme (free tier), documenta el cold start.

### Recursos

- [Spring Guide: Docker](https://spring.io/guides/gs/spring-boot-docker/)
- [Docker: multi-stage builds](https://docs.docker.com/build/building/multi-stage/)
- [Nginx as reverse proxy](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/)
- Cloud — elige **una** doc y sigue el quickstart:
  - [Render: Deploy Spring Boot](https://render.com/docs)
  - [Railway](https://docs.railway.app/)
  - [AWS: Deploy Spring Boot on App Runner](https://docs.aws.amazon.com/apprunner/)
- Let’s Encrypt / HTTPS: si el PaaS no lo da, [Caddy](https://caddyserver.com/) es más simple que Nginx+certbot.

---

## Fase 11 — Nice-to-haves (opcional, 3–5 días)

Solo si las fases 0–10 están demoables. El JD los marca como bonus. **Uno** bien hecho vale más que tres a medias.

Elige **una** pista:

### A) Búsqueda con ElasticSearch (o OpenSearch)

Indexa título + body al publicar. Endpoint `GET /api/search?q=`. En la entrevista: “por qué no `LIKE %q%` a escala”.

### B) GraphQL

Un query `article(slug)` y `articles(category)` además del REST. No reemplaces REST; añade un `/graphql`. Habla de over-fetching.

### C) Next.js en el sitio público

El panel autor sigue en React/Vite; el help center público en Next.js (SSR/SSG de artículos). Encaja con CMS + performance. Más ambicioso.

### D) Cloud más “de verdad” en AWS

S3 para (si añades) imágenes, RDS Postgres, ElastiCache Redis, CloudWatch logs. Solo si ya desplegaste algo en fase 10.

No hace falta WordPress/AEM: Atlas *es* tu prueba de CMS. Si quieres mencionar AEM en entrevista, estudia a alto nivel qué problema resuelve (contenido, authors, preview, publish) y mapea esas ideas a draft/publish de Atlas.

### Recursos

- [ElasticSearch getting started](https://www.elastic.co/guide/en/elasticsearch/reference/current/getting-started.html)
- [Spring GraphQL](https://spring.io/projects/spring-graphql)
- [Next.js learn](https://nextjs.org/learn)
- AEM (solo overview): documentación Adobe de “author vs publish” — suficiente para una pregunta nice-to-have.

---

## Fase 12 — Preparación de entrevista (2–3 días)

**Por qué:** el proyecto no sirve si no puedes narrarlo. El flujo de entrevista del JD es predecible. Ensaya contra él.

### Objetivos

Tener respuestas de 2–4 minutos, con detalle personal (nombres de clases, un bug real, una decisión).

### Guion alineado al interview flow de Konrad

1. **Intro:** “Construí Atlas, un knowledge base. Java 17, Spring Boot, React, Postgres, Redis. Está desplegado en …”.
2. **Feature punta a punta:** publicar un artículo (fase 7). Di UI, DTO, service, Flyway, Redis evict, test que lo cubre.
3. **Spring Boot:** paquetes, por qué el controller no habla con el repositorio, `@ControllerAdvice`.
4. **Frontend:** React Router, dónde vive el token, cómo `api.js` pone el header, un estado de error.
5. **Base de datos:** tablas, por qué índice en `slug`, una query concreta, Flyway vs ddl-auto.
6. **Bug o seguridad/perf:** elige uno real (CORS, N+1, caché stale, 403 mal mapeado) y cómo lo depuraste.
7. **Tests y review:** pirámide, un test que salvó un bug, cómo usas PRs.
8. **Comunicación / workflow:** `DECISIONS.md`, CI, lo que mejorarías el próximo sprint.
9. **Nice-to-have:** solo si lo hiciste. Si no: “lo siguiente sería ElasticSearch porque LIKE no escala; el diseño ya cachea el listing”.

### Buenas prácticas de ensayo

- Grábate en inglés (el rol trabaja en inglés con el equipo).
- Distingue “lo hice yo” vs “lo copié y lo entiendo”.
- Prepara un gap honesto: “no usé Spring Cloud; Boot fue suficiente para un solo servicio”.

### Recursos

- Tu propio repo, `DEMO.md`, `DECISIONS.md`.
- [Spring interview-style: Baeldung quizzes](https://www.baeldung.com/spring-quiz) — complementario, no sustituye al proyecto.
- Practica code review: pide a Cursor o a un par que critiquen un PR tuyo y responde como en equipo.

---

## Orden cronológico resumido

| Fase | Qué | Tiempo | Scorecard que sube |
|---|---|---|---|
| 0 | HTTP, DOM, SSL, servers | 2–3 d | Core web |
| 1 | Repo, skeleton, Git | 2–3 d | Workflow |
| 2 | Postgres, Flyway, JPA | 3–4 d | Databases |
| 3 | API REST, capas, DTOs | 5–7 d | Java / Spring |
| 4 | JWT, roles, CORS | 3–4 d | Security |
| 5 | Redis, índices, N+1 | 2–3 d | Caching / optimization |
| 6 | React SPA | 5–7 d | Frontend |
| 7 | Slice publicar artículo | 3–4 d | Fullstack (el más importante) |
| 8 | Tests + CI | 3–4 d | Testing / quality |
| 9 | Lint, PRs, README | 2 d | Review / procesos |
| 10 | Docker, cloud, HTTPS | 3–4 d | Servers / cloud |
| 11 | Un bonus | 3–5 d | Nice-to-have |
| 12 | Ensayo de entrevista | 2–3 d | Comunicación |

---

## Criterio de “proyecto listo para aplicar”

Puedes aplicar cuando todo esto es verdad:

1. Un extraño sigue el README y ve Atlas en local.
2. Hay una URL o un video de 2 min del flujo publicar.
3. Puedes dibujar el flujo UI → API → DB → cache sin mirar código, y luego señalar las clases.
4. Hay tests que fallarían si rompes publicar o la seguridad.
5. Hay al menos una decisión documentada que defenderías (JWT vs session, Redis vs Caffeine, UUID vs long).
6. El historial Git no es un solo commit “final project”.

---

## Recursos globales (siempre a mano)

**Java / Spring**

- Documentación oficial [Spring Boot](https://docs.spring.io/spring-boot/docs/current/reference/html/) y [Spring Data JPA](https://docs.spring.io/spring-data/jpa/reference/)
- [Baeldung](https://www.baeldung.com/) — úsalo como referencia, no como copy-paste sin entender
- Libro: *Effective Java* (Bloch) — ítems de equals/hashCode, generics, excepciones; léelos cuando te duelan en el código
- Libro: *Spring Boot 3 Up and Running* (Greg L. Turnquist) o *Spring in Action* (Walls)

**Frontend**

- [react.dev/learn](https://react.dev/learn)
- [javascript.info](https://javascript.info/) — closures, promises, fetch (huecos típicos en entrevista)

**Datos y diseño**

- [Use The Index, Luke](https://use-the-index-luke.com/) — índices SQL, muy rentable
- *SQL Performance Explained* (Winand) — opcional

**Seguridad**

- OWASP Cheat Sheets (Password, JWT, REST Security)

**Práctica deliberada**

- Cada fase termina con un “explícalo en voz alta”.
- Cada fase termina con un commit/PR, no con “lo dejo en local”.

---

## Cómo usar este plan (didáctica)

1. Trabaja **una fase a la vez**. No diseñes el editor React mientras no existe `POST /api/articles`.
2. Al cerrar una fase, marca en `DECISIONS.md` qué aprendiste y qué duda te queda.
3. Si te atascas más de 90 minutos, reduce alcance (comentarios admin pueden esperar; publicar no).
4. El alcance sagrado es: **auth + artículo draft/publish + listado público + una base relacional + un test + un deploy**. Todo lo demás es mejora.
5. Cuando termines la fase 7, ya puedes ensayar la entrevista. Las fases 8–10 la hacen creíble. La 11 es extra.

Si más adelante quieres que este repo *sea* Atlas (código Spring + React), el siguiente paso es la fase 1: skeleton y README, no la UI.
