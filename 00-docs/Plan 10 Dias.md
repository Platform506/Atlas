# Plan 10 días × 3 horas — mínimo que cubre todo

**Total:** 30 horas. **Producto:** Atlas (publish de artículos). **HR:** ficha Astrix / Regeneron / Nova + 10 STAR. **Técnica:** un slice que puedes narrar.

Esto sustituye al calendario de 10 días del speed run. El plan largo y el banco STAR siguen como referencia:

- [Plan Entrevista HR.md](./Plan%20Entrevista%20HR.md) — textos STAR
- [Plan de Proyecto Atlas.md](./Plan%20de%20Proyecto%20Atlas.md) — detalle si te atascas
- [Speed Run Atlas.md](./Speed%20Run%20Atlas.md) — recortes y triage

---

## Lo que entra vs lo que no

| Entra (el “todo”) | No entra |
|---|---|
| Java + Spring Boot (capas, DTOs) | Spring Cloud, microservicios |
| React: lista, detalle, login, editor | Angular, Next.js, Redux |
| REST + routing (API y React Router) | GraphQL |
| PostgreSQL + Flyway | Mongo, ElasticSearch |
| JWT, roles, CORS, BCrypt | OAuth de Google, refresh token |
| Caché Caffeine + evict al publicar | Redis (dilo: “en Nova era Redis”) |
| HTTP status, CORS, HTTPS de concepto | SSL de cero, Nginx de producción |
| Tests: publish + 401/403 + draft oculto | E2E Playwright, Testcontainers |
| Git, README, DEMO, DECISIONS | CI, Kubernetes, AWS real |
| HR: elevator, why Konrad, 10 STAR, simulacro | 14 días de ensayo extra |

**Feature sagrada:** login AUTHOR → crear draft → Publish → anónimo lo ve en el home. Si el día 6 no hace eso, los días 7–10 son para arreglarlo, no para extras.

---

## Cada día, las mismas 3 horas

| Minuto | Qué |
|---|---|
| 0:00–0:10 | ¿Ayer arranca? Si no, eso es el día. |
| 0:10–0:30 | **HR** (abajo, 20 min). Timer. En voz alta. |
| 0:30–2:45 | **Una** meta de Atlas. Atascado 25 min → recorta, no rediseñes. |
| 2:45–2:55 | Explícalo en **inglés** (qué clase, qué HTTP status). |
| 2:55–3:00 | Commit `feat:` / `fix:` y push. |

No pases HR al final. La primera entrevista es HR.

---

## Mapa JD → día

| Scorecard Konrad | Día |
|---|---|
| Core web (HTTP, DOM, SSL a alto nivel) | 1 (30 min) + cada explicación de cierre |
| Java / Spring Boot | 2–4, 6 |
| APIs, routing, data, patrones | 2, 3, 5, 6 |
| Security | 4 |
| Caching / optimization | 6 |
| Databases | 2 |
| Frontend React | 5–6 |
| Testing + quality | 7 |
| Git / workflows / review | todos + 8 |
| Web servers / “deploy” | 9 (Docker Compose) |
| Comunicación / HR | 20 min diarios + día 10 |
| CMS nice-to-have | el producto *es* draft/publish |
| Cloud nice-to-have | una frase: Nova en AWS; Atlas en Docker |

---

## Día 1 — Arranca + quién eres

**HR (20 min):** ficha Astrix + cliente Regeneron (rol, Nova, stack, 18 meses). Elevator **EN + ES** 60 s. Grábate una vez.

**Atlas:** Spring Initializr Java 17, Spring Boot 3.x, Maven: Web, Validation, Data JPA, Security, Cache, Flyway. `GET /api/health`. Docker Compose **solo Postgres 16**. Vite + React, h1 “Atlas”, proxy `/api` → 8080. README de 10 líneas: cómo levantar los 3 procesos.

**HTTP (dentro de Atlas, no extra):** en el README, 5 líneas: GET vs POST, 200/401/404, por qué HTTPS en prod, Tomcat embebido vs Vite.

**Listo:** las tres cosas levantan. No hay entidades.

---

## Día 2 — Datos

**HR:** 8 frases de 30 s en inglés: fullstack, Spring Boot, React, REST, PostgreSQL vs NoSQL, Git/PR, Agile, JWT. Sección 3 del plan HR.

**Atlas:** Flyway `V1__init.sql`: `users`, `categories`, `articles`. Entidades JPA + repos. Índices: email, slug, `(status, published_at)`. Seed: `author@atlas.dev`, 2 categorías, 1 artículo published y 1 draft.

**Listo:** la app arranca, Flyway corre, ves las filas en Postgres. Cero endpoints de negocio.

---

## Día 3 — API

**HR:** STAR **A** (estrés / 500 en UAT). 90 s EN. Texto en el plan HR.

**Atlas:** DTOs (nunca la entidad al JSON). `@ControllerAdvice`.  
`GET /api/articles` (solo PUBLISHED, page/size).  
`GET /api/articles/{slug}` (404 si draft).  
`POST /api/articles` (DRAFT).  
`POST /api/articles/{id}/publish`.  
Capas: controller → service → repo.

**Listo:** 5 calls en Postman. El draft no sale en el GET público (aunque Security aún esté floja).

---

## Día 4 — Seguridad

**HR:** STAR **B** (deadline / recortar alcance) + **C** (conflicto HTML vs Markdown). 10 min cada una.

**Atlas:** register + login, BCrypt, JWT Bearer, roles `READER` / `AUTHOR`. CORS `http://localhost:5173`. Anónimo lee publicados. AUTHOR crea y publica. READER → 403 en publish. Sin token → 401.

**Listo:** las 5 calls de ayer con token. Un 401 y un 403 comprobados a mano. Sin refresh token.

---

## Día 5 — React lectura

**HR:** STAR **D** (error Flyway) + **E** (controller gordo, review).

**Atlas:** React Router: `/`, `/articles/:slug`, `/login`, `/register`. `api.js` con Bearer. Home lista publicados. Detalle. Login guarda token en `localStorage`.

**Listo:** lees los artículos seed en el browser. No hace falta editor todavía.

---

## Día 6 — La feature (el día que no se recorta)

**HR:** Why Konrad + why leaving (45 s cada uno). Luego STAR **G** (orgullo / caché 800→200 ms) — hoy implementas el patrón.

**Atlas:** `/editor` protegido. Form título, body, categoría. Crear draft. **Publish**. Redirect al slug. Home anónimo muestra el artículo. Spring Cache **Caffeine** en GET list y GET slug; `@CacheEvict` al publicar.

**Listo:** `DEMO.md` de 8 líneas. Una grabación de 2 min o un checklist que tú mismo pasas. **Si esto falla, el día 7 empieza aquí.**

---

## Día 7 — Tests

**HR:** STAR **F** (spike JWT, share en standup) + **I** (template de MR). Weakness 30 s.

**Atlas (4 tests, no 40):**

1. Service: body vacío no publica.
2. Service o API: slug duplicado → 409.
3. GET público no lista drafts.
4. READER publish → 403 (o sin token → 401).

**Listo:** `./mvnw test` verde. UI fea da igual.

---

## Día 8 — Poder hablarlo

**HR:** Strengths (2, con evidencia G e I). STAR **H** (requisitos del cliente) + **J** (CORS, daily). 5 years: una frase.

**Atlas:** `DECISIONS.md` (Postgres, JWT, Caffeine vs Redis, DTOs). Diagrama mermaid click → API → DB → cache. Arregla el bug más feo (CORS, refresh 404 de Vite, N+1). Template de PR en el repo (una de las historias I).

**Listo:** 3 minutos en inglés del flujo Publish sin leer el código. Luego señalas las clases.

---

## Día 9 — “Se puede correr” + web server

**HR:** 3 preguntas para ellos (squad, 90 días, mentorship). Salary/notice: rango, no un número suelto. WFH: overlap con el equipo.

**Atlas:** Dockerfile multi-stage del JAR. Compose: `postgres` + `api`. Frontend con `npm run dev` documentado (no pierdas la tarde en Nginx). `JWT_SECRET` por env. Healthcheck.

**Concepto para decir:** Tomcat embebido sirve el API; Vite (dev) o un proxy serviría el SPA; en prod iría HTTPS en el edge.

**Listo:** alguien clona, lee README, `compose up`, crea un artículo. Deploy a Render **solo** si Compose quedó en <2 h.

---

## Día 10 — Simulacro (HR + técnica)

**HR (45 min del bloque, hoy sí más):** timer 90 s por pregunta, en inglés:

1. Tell me about yourself.
2. Why Konrad?
3. Stressful situation (A).
4. Disagreement with a teammate (C).
5. A mistake (D).
6. Tight deadline (B).
7. What does fullstack mean for you? (G + Atlas).
8. Questions for me?

**Atlas (resto):** no features nuevas. Agujeros del simulacro: si no pudiste trazar Publish, arregla eso. Si no hubo 403, el test. Si el README miente, el README.

**Listo para aplicar / para la call:**

- [ ] README verdadero
- [ ] DEMO publish funciona
- [ ] Draft invisible en público
- [ ] 4 tests verdes
- [ ] Señalas controller, service, entity, migration, botón Publish
- [ ] Elevator + STAR A, B, D, G en inglés
- [ ] 2 preguntas para Konrad

---

## Si un día se tuerce

| Día roto | Qué recortas |
|---|---|
| 1–2 | No React hasta que Flyway arranque |
| 4 Security | Un `SecurityFilterChain` de la doc, login que emite JWT, sigue. Nada de OAuth |
| 5 React | Una sola página sin Router; Router el día 6 |
| 6 sin caché | Publish primero; Caffeine en 30 min al final o el día 8. En entrevista usa STAR G (Nova/Redis) |
| 7 tests | Mínimo: un 403 y “draft no sale” |
| 9 Docker | README con 3 comandos locales; Compose es suficiente para “web server” |
| Cualquiera | Nunca Next, GraphQL, admin, comentarios, Redis |

---

## Noche previa a HR

Relee ficha + A, B, D, G. Una pregunta de equipo. No reescribas historias.

## Noche previa a técnica

Pasa DEMO.md. Dibuja el flujo en papel. Una decisión a defender. Un bug de esta semana (Atlas) como STAR A técnico.
