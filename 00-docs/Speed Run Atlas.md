# Speed Run Atlas — 3 horas por día

El plan largo sigue en [Plan de Proyecto Atlas.md](./Plan%20de%20Proyecto%20Atlas.md). Este archivo es el recorte para una **técnica cercana**.

**Calendario canónico de 10×3 h:** [Plan 10 Dias.md](./Plan%2010%20Dias.md). Este archivo queda como recortes, triage y días 11–14.

HR y técnica se alimentan: el flujo **publicar un artículo** es la misma historia que Astrix / Nova en [Plan Entrevista HR.md](./Plan%20Entrevista%20HR.md). Atlas es el laboratorio donde puedes *mostrar* código.

---

## Qué significa “listo para la técnica”

El entrevistador (hiring manager / dev) va a pedir **una feature de punta a punta**. Ganas si puedes abrir el repo y decir:

1. Click Publish en React.
2. `POST /api/articles/{id}/publish` con JWT.
3. `ArticleService` cambia status, guarda en PostgreSQL.
4. Se invalida la caché del listado.
5. `GET /api/articles` público lo muestra.
6. Hay un test que rompe si un `READER` publica.

Si eso funciona, **ya puedes ir**. Comentarios, admin, ElasticSearch, GraphQL, Next.js, Spring Cloud: fuera.

---

## Recortes (no los negocies los primeros 10 días)

| Dentro | Fuera (hasta día 11+) |
|---|---|
| Auth JWT: AUTHOR vs anónimo | Panel admin de usuarios |
| Artículos DRAFT / PUBLISHED | Comentarios |
| Categorías seed (no CRUD admin) | ElasticSearch, GraphQL, Next.js |
| Listado + detalle + editor React | Diseño fino, Redux, Tailwind complejo |
| PostgreSQL + Flyway | Mongo / NoSQL |
| Caché: Caffeine in-memory (día 6). Redis si sobra | Redis el día 1 |
| Tests del service + 401/403 | Testcontainers, E2E Playwright |
| Docker Compose local | Kubernetes, AWS “de verdad” |
| README + DEMO.md | Blog, landing, CI perfecto |

Caché: el JD la nombra. Caffeine es Spring Cache real y te ahorra un servicio. El día 12, si vas bien, cambias a Redis. En la técnica dices: “en Atlas usé Caffeine; en Nova (Astrix) usamos Redis para el mismo patrón cache-aside + evict al publicar.”

---

## Cómo usar las 3 horas (no las negocies)

```
0:00–0:10  Ayer: ¿el último commit arranca?
0:10–0:25  HR (ver plan HR, 15 min). Días 1–14 del calendario HR.
0:25–2:40  Construir lo del día. Un objetivo. Si te atascas 25 min: recorta, no googles otra arquitectura.
2:40–2:55  Explícalo en voz alta en inglés (el request, la clase, el status HTTP).
2:55–3:00  Commit: feat: ...  /  Push.
```

Si un día solo tienes 3 h, **el bloque HR no se salta**: 15 min. La primera entrevista es HR.

---

## Calendario de 10 días (mínimo para la técnica)

Cada día = una sesión de ~2 h 15 de código.

### Día 1 — Esqueleto que arranca

**Meta:** `backend` responde `GET /api/health` y `frontend` muestra un h1. Postgres en Docker. Git.

- Spring Initializr: Java 17, Spring Boot 3.x, Maven, Web, Validation, Data JPA, Security (lo dejarás abierto), Cache, Flyway. *No* Redis todavía.
- `docker-compose.yml`: solo `postgres:16`.
- `application.yml`: datasource, `ddl-auto: validate`, Flyway on.
- Vite + React. Proxy `/api` → `localhost:8080`.
- README: cómo levantar Docker, backend, frontend.

**Salida:** tres terminales arriba. Commit. Si Initializr + Docker te comen el día, no empieces entidades.

### Día 2 — Modelo y migraciones

**Meta:** tablas `users`, `categories`, `articles`. Seed: 1 admin, 1 author (`author@atlas.dev` / password documentada), 2 categorías, 2 artículos (1 draft, 1 published).

Entidades JPA mínimas. Flyway `V1__init.sql` — tú escribes el SQL, no dejes que Hibernate cree prod.

Índices: `users(email)`, `articles(slug)`, `articles(status, published_at)`.

**Salida:** `GET` todavía no. Arranca sin error Flyway. Seed con `data.sql` o un `CommandLineRunner` de perfil `dev`.

### Día 3 — API pública + CRUD de autor (sin seguridad fina)

**Meta:**

- `GET /api/articles` → solo `PUBLISHED`, paginado simple (`page`, `size`).
- `GET /api/articles/{slug}` → 404 si draft o no existe.
- `POST /api/articles` → crea DRAFT (aún permitAll o un user hardcode; mañana JWT).
- `POST /api/articles/{id}/publish`
- DTOs, `@ControllerAdvice` (404, 400, 409 slug duplicado).

**Salida:** Postman/Insomnia con 5 calls. No React.

### Día 4 — JWT y roles

**Meta:** register + login. `READER` no publica. `AUTHOR` sí. Anónimo lee publicados.

- BCrypt.
- JWT en header `Authorization: Bearer`.
- CORS: `http://localhost:5173`.

Tests (aunque sean feos): sin token POST → 401; READER publish → 403.

**Salida:** las 5 calls de ayer ahora autenticadas. Este día es el más resbaladizo: si Security te come 3 h, deja un `SecurityFilterChain` mínimo que funcione y no “perfecciones” el refresh token.

### Día 5 — React: leer

**Meta:** Router: `/`, `/articles/:slug`, `/login`, `/register`.

- Home: lista de publicados (cards).
- Detalle: título, cuerpo, autor.
- Login guarda token (`localStorage` está bien; anótalo).
- `api.js`: `fetch` + header.

**Salida:** puedes leer artículos seed sin crear nada.

### Día 6 — React: escribir + caché

**Meta:** la feature de la entrevista.

- `/editor` y `/editor/:id` (protegido).
- Form: título, body, categoría.
- Botón **Publish**.
- Tras publicar: redirect al slug, home muestra el artículo.
- Spring Cache + Caffeine en GET listado y GET slug; `@CacheEvict` en publish/update.

**Salida:** demo de 2 minutos. Grábala. Escribe `DEMO.md` (usuarios seed, clicks).

### Día 7 — Tests que importan + calidad mínima

**Meta:** 4–6 tests, no cobertura cosmética.

- `ArticleService`: no publica body vacío; slug duplicado falla.
- API: GET público no lista drafts.
- Security: 401/403 (si no los hiciste el día 4).
- Un test React del form (submit llama publish) *si hay tiempo*; si no, sáltalo.

Lint no es el objetivo. Sí: no password en logs, no entidad JPA en el JSON.

**Salida:** `./mvnw test` verde.

### Día 8 — Pulido de entrevista técnica

**Meta:** poder narrar sin abrir Stack Overflow.

- `DECISIONS.md`: por qué Postgres, JWT, Caffeine, DTOs.
- Diagrama mermaid: click → controller → service → repo → cache.
- Arregla el bug más vergonzoso (CORS, 404 de React Router al refrescar, fechas null).
- Ensayo: 3 minutos en inglés del flujo publish.

**Salida:** si mañana te llaman, puedes compartir pantalla y no da vergüenza.

### Día 9 — Docker de verdad

**Meta:** `docker compose up` levanta postgres + api. Frontend: o `npm run dev` o un Nginx estático. Elige **una**.

Dockerfile multi-stage del JAR. Variables `POSTGRES_*`, `JWT_SECRET`.

Si Compose funciona, intenta un deploy gratis (Render/Railway) **solo si** te sobra una hora. Una URL HTTPS es un plus de HR/técnica; no es el slice.

### Día 10 — Simulacro técnico + huecos

**Meta:** cerrar el agujero más visible.

Orden de ataque si falta tiempo:

1. Publish no funciona de punta a punta → todo lo demás espera.
2. No hay JWT → no hay historia de seguridad.
3. No hay test de 403 → añádelo (30 min).
4. UI fea → ignórala.
5. Deploy → video de DEMO.md.

Simulacro (haz las preguntas en voz alta):

- Trace Publish from the button to the database.
- How is a draft hidden?
- What happens if two authors pick the same slug?
- Show me the test for roles.
- Why didn’t you use Spring Cloud / Kafka / microservices?

Respuesta honesta a lo último: un servicio, un equipo, Boot alcanza. Cloud cuando haya muchos servicios.

---

## Días 11–14 (si la técnica no es esta semana)

| Día | Qué | Por qué |
|---|---|---|
| 11 | Redis en Compose, mismo `@Cacheable` | Encaja con Nova/Astrix |
| 12 | GitHub Actions: `mvn test` + `npm test` | Workflows del JD |
| 13 | Comentarios *o* página “mis artículos” — **una** | Más carne fullstack |
| 14 | Ensayo técnico 20 min + relee STAR G y A | HR y técnica se tocan |

---

## Calendario de pánico (7 días / 21 h)

Solo si te escriben “entrevista técnica la semana que entra” y vas en cero.

| Día | Única meta |
|---|---|
| 1 | Skeleton + Postgres + entidades + Flyway + seed |
| 2 | GET list/detail + POST article + publish (sin JWT fino: un header `X-User-Role` **no**. Mejor JWT mínimo o HTTP Basic **un día**, JWT al día 3) |
| 3 | JWT + CORS |
| 4 | React list + detail + login |
| 5 | Editor + publish + DEMO |
| 6 | 3 tests + DECISIONS.md |
| 7 | Ensayo inglés del slice + arreglar lo que se rompió en el ensayo |

HTTP Basic no es ideal para el JD (hablan de apps modernas). Un JWT de tutorial copiado y *entendido* (qué va en el token, BCrypt, 403) gana a un Basic “por prisa”.

---

## Si vas tarde (reglas de triage)

A las 2 h de un día, mira la meta. Si no está:

- **Día 4 atascado en Security:** copia un `SecurityFilterChain` mínimo de la doc de Spring, haz login, sigue. No escribas tu propio crypto.
- **Día 5 atascado en React:** una página, sin Router, `useState` del token. Router al día 6.
- **Caché:** si el día 6 no llega, skip Caffeine y en la entrevista habla de Nova/Redis (STAR G) + “en Atlas es el siguiente ticket”. Mejor un publish sólido que una caché a medias.
- **Tests:** un test de service + un 403. El resto es lujo.
- **Nunca** empieces Next.js, GraphQL o un redesign.

---

## Checklist de la noche anterior a la técnica

- [ ] `docker compose up` + backend + frontend según README (lo hiciste tú, no de memoria)
- [ ] DEMO.md: login author → crear → publish → ventana anónima ve el artículo
- [ ] Un draft **no** sale en el GET público
- [ ] Puedes señalar: controller, service, entity, migration, componente Publish
- [ ] Una decisión que defenderías (JWT vs session, Caffeine vs Redis, UUID vs long)
- [ ] Un bug real que arreglaste esta semana (CORS, LazyInitialization, slug duplicado) — es tu STAR A versión Atlas
- [ ] Repo público o screen share listo; `.env` no tiene secretos reales

---

## Cómo Atlas y Astrix no se pisan

| | Astrix / Nova | Atlas |
|---|---|---|
| Qué es | Cliente Regeneron, equipo de 6, 18 meses | Tu lab para la entrevista |
| Feature | Publish de artículos | La misma, más limpia |
| Caché | Redis | Caffeine primero, Redis si hay día 11 |
| Cloud | AWS que montó el lead | Compose / un PaaS si hay tiempo |
| En HR | Historias STAR A–J | “También lo reconstruí para profundizar tests y seguridad” |
| En técnica | Contexto de equipo y cliente | El repo que abres |

No digas que Atlas está en producción de un cliente. Di: production-like, personal project, same problem as Nova.
