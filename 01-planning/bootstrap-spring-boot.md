# Bootstrap: tu primer Spring Boot (desde cero)

Esta guía es el **esqueleto vacío** de Atlas. No hay login, no hay “publicar artículo”, no hay pantallas de verdad. Al terminar, tres programas corren a la vez y se saludan:

1. **PostgreSQL** — guarda las tablas
2. **Spring Boot** (puerto 8080) — responde `GET /api/health`
3. **Vite + React** (puerto 5173) — muestra un título “Atlas” y, si pides `/api/...`, reenvía al 8080

Si algo de ayer no arranca, eso es el trabajo de hoy. Rama: `feature/bootstrap`.

---

## 1. Mapa mental (léelo antes de instalar nada)

Una app web fullstack no es “un programa”. Son capas que hablan por HTTP.

```text
Navegador  →  Vite (:5173)  →  proxy /api  →  Spring Boot (:8080)  →  PostgreSQL (:5432)
                (HTML/JS)                      (Java, JSON)              (tablas)
```

- El **navegador** no habla SQL. Habla HTTP (`GET`, `POST`) y recibe JSON o HTML.
- **Spring Boot** es un servidor Java: recibe el HTTP, ejecuta código, pregunta a la base, responde.
- **PostgreSQL** no sabe de React. Solo tablas y SQL. Eso ya lo practicaste en la Fase 1.

Hoy **no** construyes la API de artículos. Solo dejas los cimientos para no pelearte con “no arranca” en la fase siguiente.

---



## 2. Palabras que vas a ver todo el rato

Léelas una vez. No hace falta memorizarlas; vuelve aquí cuando te atascas.

**JDK / Java 17.** El compilador y la máquina virtual que ejecutan tu código. Spring Boot 3 pide 17 o más. Comprueba: `java -version`.

**Spring.** Un conjunto de librerías Java para hacer aplicaciones (web, seguridad, datos…). Nació para no escribir un servidor HTTP a mano.

**Spring Boot.** Spring “con pilas incluidas”: te genera un **JAR ejecutable** (un `.jar` que ya trae un servidor web adentro, Tomcat). Por eso no instalas Tomcat aparte. Arrancas con `./mvnw spring-boot:run` y ya hay alguien escuchando en el 8080.

**Maven.** El gestor de dependencias y de build en Java. Lees un `pom.xml` (“quiero Spring Web y Flyway”) y Maven descarga esas librerías. El wrapper `mvnw` / `mvnw.cmd` es Maven embebido en el repo: quien clone no necesita instalar Maven global.

**JAR.** Un zip con tu bytecode y librerías. “Packaging jar” en Initializr = “quiero un archivo que se pueda ejecutar”, no un WAR para un Tomcat externo.

**Dependencia.** Un ladrillo que no escribes tú. “Spring Web” es una dependencia. Se declara en el `pom.xml`.

**Controller.** Una clase Java con anotaciones (`@RestController`, `@GetMapping`) que dice: “cuando llegue este HTTP, corre este método”.

**Actuator.** Dependencia opcional de Spring que expone `/actuator/health` (¿está viva la app?). Puedes no usarla y hacer un controller de una línea. Las dos valen.

**JPA / Hibernate.** JPA es el estándar Java de “clases ↔ tablas”. Hibernate es la implementación que usa Spring Data JPA. **Hoy no hace falta que escribas entidades.** Solo lo configuras para que **no invente** tablas (`ddl-auto: validate`).

**Flyway.** Corre archivos SQL versionados (`V1__init.sql`, `V2__...`) al arrancar. La base queda igual en tu máquina, en la de un compañero y en producción. **Flyway es la fuente de verdad del esquema**, no Hibernate.

**ddl-auto.** Instrucción a Hibernate:

- `update` — “si falta una columna, créala tú”. Cómodo y sucio: el esquema vive escondido en Java.
- `validate` — “comprueba que las entidades coincidan con las tablas; si no, falla”. Obliga a que Flyway (o tú) haya creado las tablas.
- `none` — ni valida ni cambia.

En Atlas usas `validate`. En entrevistas se oye muy bien: “el SQL de Flyway manda; Hibernate no altera prod”.

**Perfil (**`dev`**,** `prod`**).** Un interruptor de Spring: `spring.profiles.active=dev`. El seed (datos de prueba) solo debe correr en `dev`, no en un servidor real.

**Spring Security.** Desde que la añades, **todo está cerrado** hasta que digas lo contrario. Por eso un `GET /api/health` te puede devolver **401** el primer día. Hoy abres todo con un `SecurityFilterChain` mínimo. En la Fase 3 lo cierras con JWT.

**CORS.** El navegador no deja que una página en `http://localhost:5173` llame a `http://localhost:8080` si el servidor no lo autoriza (son “orígenes” distintos). En **dev**, Vite puede **proxificar** `/api` hacia el 8080: el browser cree que habla con el 5173, y no hay CORS. Más adelante configurarás CORS en Spring para producción.

**Swagger / springdoc.** Una UI en `/swagger-ui.html` que lista tus endpoints y te deja probarlos. Hoy casi no hay endpoints; igual la dejas instalada para la Fase 2.

**Caffeine.** Caché en memoria. La usa la Fase 5. **Hoy no la necesitas**; el plan dice que puedes añadirla después.

**Docker Compose.** Un YAML que levanta contenedores. Hoy: **solo Postgres**. Spring y Vite siguen en tu Windows, no dentro de Docker.

---



## 3. Qué vas a tener en el disco (cuando termines)

```text
Atlas/
  docker-compose.yml          ← solo Postgres
  backend/
    pom.xml                   ← Maven + dependencias
    src/main/java/...         ← una clase @SpringBootApplication + health
    src/main/resources/
      application.yml         ← url de la DB, Flyway, ddl-auto
      db/migration/
        V1__init.sql          ← el CREATE TABLE de la Fase 1 (sin DROP)
  frontend/
    package.json
    vite.config.ts            ← proxy /api → 8080
    src/App.tsx               ← un <h1>Atlas</h1>
```

Tu SQL de práctica (`backend/db/schema.sql` y `data.sql`) **no desaparece**. Es el laboratorio de la Fase 1. Flyway es la copia que la **app** ejecuta sola al arrancar.

---



## 4. Paso a paso (en este orden)



### Paso 0 — Rama y Java

```text
git checkout -b feature/bootstrap
java -version          → 17 o más
```

Si no hay 17, instálalo antes. Spring Boot 3 no arranca en Java 8/11.

---



### Paso 1 — Generar el proyecto con Spring Initializr

Spring Initializr no es magia: es un formulario que te descarga un zip con `pom.xml` y una clase `main`.

Ve a [https://start.spring.io/](https://start.spring.io/) y elige:


| Campo            | Valor                                    | Por qué                                   |
| ---------------- | ---------------------------------------- | ----------------------------------------- |
| Project          | Maven                                    | Más común en entrevistas Java que Gradle  |
| Language         | Java                                     | —                                         |
| Spring Boot      | 3.4.x o 3.5.x (3.x, no 2.x ni “13”)      | Boot 3 = Jakarta EE, pide Java 17         |
| Packaging        | Jar                                      | Servidor embebido                         |
| Java             | 17                                       | —                                         |
| Group / Artifact | lo que quieras (`com.atlas` / `backend`) | Paquete Java                              |
| Location         | la carpeta `backend/` del repo           | El plan ya tiene `backend/` y `frontend/` |


Dependencias a marcar **ahora**:

- **Spring Web** — HTTP, `@RestController`, Tomcat embebido
- **Validation** — `@NotBlank` en DTOs (Fase 2); no estorba hoy
- **Spring Data JPA** — repositorios y Hibernate
- **Flyway Migration** — corre `V1__init.sql`
- **Spring Security** — la dejas abierta hoy; la configuras en Fase 3
- **Spring Cache** — anotaciones `@Cacheable`; Caffeine es la implementación (Fase 5)
- **PostgreSQL Driver** — el JDBC que habla con Postgres

Genera, descomprime **dentro de** `backend/`. Deberías ver `pom.xml` y `src/`.

**A mano en el** `pom.xml` (búscalo en [Maven Central](https://central.sonatype.com/) si no recuerdas el XML):

1. `springdoc-openapi-starter-webmvc-ui` — Swagger UI
2. `caffeine` — opcional hoy; si no quieres ruido, déjala para la Fase 5

Después, desde `backend/`:

```text
.\mvnw.cmd -v
```

Si eso imprime la versión de Maven, el wrapper está bien.

---



### Paso 2 — Flyway: el SQL entra a la app

Crea:

```text
backend/src/main/resources/db/migration/V1__init.sql
```

El nombre **no es decoración**:

- `V1` — versión 1 (entero, en orden)
- `__` — **dos** guiones bajos
- `init` — descripción
- `.sql`

Flyway crea una tabla `flyway_schema_history`. Si `V1` ya corrió, **no la vuelve a ejecutar**. Por eso:

- Copia los `CREATE TABLE` de `[backend/db/schema.sql](../backend/db/schema.sql)`
- **No copies** los `DROP TABLE` al `V1`. Un drop en una migración que ya se aplicó no se re-ejecuta; y si alguien corre Flyway en una base con datos, un drop en V1 sería una trampa si re-generaras el historial
- Primera vez, base vacía: Flyway aplica V1 y aparecen `users`, `categories`, `articles`

Si cambias V1 **después** de que ya corrió, Flyway se queja (checksum). Lo correcto entonces es un `V2__algo.sql`, no reescribir V1. Hoy, si estás experimentando en local y rompiste todo: borra la base (o las tablas) y la tabla `flyway_schema_history`, y vuelve a arrancar.

---



### Paso 3 — `application.yml` (tú lo escribes)

Archivo: `backend/src/main/resources/application.yml`.

Spring lee esto al arrancar. Ideas que **tiene** que tener, en tus palabras / tu máquina:

1. **Datasource** — URL, usuario, password de Postgres.
  - Si usas Compose: host `localhost`, puerto `5432`, base la que definiste en el YAML (`atlas` o `postgres`).  
  - Si usas tu PostgreSQL 18 local: la misma idea, con el usuario que ya tienes (`postgres` y tu password).
2. `spring.jpa.hibernate.ddl-auto: validate` — Hibernate no crea tablas.
3. **Flyway encendido** — en Boot 3, con la dependencia en el `pom`, suele activarse solo. Si hace falta: `spring.flyway.enabled: true`.
4. **Perfil** — `spring.profiles.active: dev` en local (o un `application-dev.yml`).

Ejemplo **orientativo** (ajusta usuario, password y nombre de la base):

```yaml
spring:
  profiles:
    active: dev
  datasource:
    url: jdbc:postgresql://localhost:5432/atlas
    username: atlas
    password: atlas
  jpa:
    hibernate:
      ddl-auto: validate
    open-in-view: false
  flyway:
    enabled: true
```

`open-in-view: false` evita un hábito feo (sesión Hibernate abierta durante todo el HTTP). Hoy no tienes entidades; igual es una buena default.

**Nunca** subas passwords reales. Si más adelante hay secretos, van en variables de entorno.

---



### Paso 4 — Postgres: Compose **o** el 18 que ya tienes

El plan menciona `docker-compose.yml` en la **raíz** del repo, **solo** el servicio Postgres. Spring y Vite no van en Docker hoy.

Esquema mínimo (nombres a tu gusto; deben coincidir con el `application.yml`):

```yaml
services:
  postgres:
    image: postgres:16
    environment:
      POSTGRES_DB: atlas
      POSTGRES_USER: atlas
      POSTGRES_PASSWORD: atlas
    ports:
      - "5432:5432"
```

`docker compose up -d` levanta la base.

**Si ya tienes PostgreSQL 18 en Windows y el puerto 5432 ocupado:** no instales un segundo Postgres. Apunta el `datasource` a tu 18, crea una base vacía `atlas` (o usa la que ya usaste en la Fase 1). El plan dice 16 por ser una imagen conocida; **18 te sirve**. No mezcles Compose 16 y el 18 local en el mismo puerto.

---



### Paso 5 — Health: “¿está viva la API?”

Dos caminos; elige **uno**.

**A — Controller de una línea.** Una clase `@RestController` con `@GetMapping("/api/health")` que devuelva `{"status":"UP"}` o el texto `"OK"`. Aprendes qué es un controller, que es lo que contarás en la entrevista.

**B — Actuator.** Añades la dependencia `Spring Boot Actuator` y llamas a `/actuator/health`. Menos código, un poquito más de “magia”.

Checkpoint de este paso: en el navegador o con curl:

```text
GET http://localhost:8080/api/health
→ 200
```

Si ves **401 Unauthorized**, no está “roto el health”: **Security está haciendo su trabajo**. Paso 6.

---



### Paso 6 — Security en modo “puerta abierta”

Al añadir Spring Security, aparece un password random en la consola y todo pide login.

Hoy quieres **permitAll**: una clase `@Configuration` con un bean `SecurityFilterChain` que autorice **cualquier** request. Es temporal y consciente. En la Fase 3 esa misma clase pasa a: anónimo lee artículos; `AUTHOR` publica; el resto 401/403.

Busca en la doc de **Spring Security 6** el ejemplo con lambda (`http.authorizeHttpRequests(...)`). No copies un tutorial de Spring Boot 2 (`WebSecurityConfigurerAdapter` está muerto).

También: **CORS**. Puedes dejar un `CorsConfiguration` que permita `http://localhost:5173`, o apoyarte solo en el proxy de Vite (paso 8) durante el bootstrap. Las dos cosas no se pisan: el proxy evita CORS en dev; CORS en Spring te hará falta cuando el front no pase por Vite.

**Swagger:** con springdoc, abre `http://localhost:8080/swagger-ui.html` (a veces `/swagger-ui/index.html`). Si Security lo bloquea, incluye esas rutas en el `permitAll` de hoy.

---



### Paso 7 — Seed de perfil `dev` (poco, y una sola vez)

El plan pide datos mínimos para más adelante:

- 1 AUTHOR: `author@atlas.dev` (password **documentada en el README**; hoy puede ser texto dummy, BCrypt es Fase 3)
- 2 categorías
- 1 artículo `PUBLISHED`
- 1 artículo `DRAFT`

Ya tienes un seed rico en `[backend/db/data.sql](../backend/db/data.sql)`. Opciones:

1. `data.sql` **de Spring** en `src/main/resources/` — Spring puede ejecutarlo al arrancar. Cuidado: si corre **siempre**, el segundo arranque choca con `UNIQUE` en email/slug.
2. `CommandLineRunner` **+** `@Profile("dev")` — código Java que inserta **solo si** no existe `author@atlas.dev`. Más control.
3. Correr a mano `data.sql` en psql **después** de Flyway, solo en local.

Lo que **no** quieres: cada `spring-boot:run` crea otro `how-to-sign-in` y luego la API responde **409**.

Para el bootstrap, con que al terminar veas filas en Postgres basta. No hace falta el seed perfecto el mismo día que Initializr.

---



### Paso 8 — Frontend vacío (Vite + React + TypeScript)

En la carpeta `frontend/` (vacía hoy):

```text
npm create vite@latest . -- --template react-ts
npm install
```

Deja un `<h1>Atlas</h1>`. Nada de router, nada de login.

En `vite.config.ts` configura **proxy**:

```text
el browser pide  http://localhost:5173/api/health
Vite reenvía a    http://localhost:8080/api/health
```

Sin proxy, si en React escribes `fetch('/api/health')`, Vite busca un archivo en el 5173 → **404**. Si escribes `fetch('http://localhost:8080/api/health')` sin CORS en Spring → el browser bloquea.

`npm run dev` → suele ser `http://localhost:5173`.

---



### Paso 9 — README de 10 líneas

En el README raíz, en español o inglés (consistente):

- Cómo levantar Postgres (Compose **o** “usa tu 18 local, base `atlas`”)
- Cómo arrancar backend (`.\mvnw.cmd spring-boot:run` desde `backend/`)
- Cómo arrancar frontend (`npm run dev` desde `frontend/`)
- Usuario seed cuando lo tengas (`author@atlas.dev` / la password que elijas)

---



## 5. Cómo se ve un día “listo” (los 3 procesos)

Terminal 1 — Postgres (Compose o servicio Windows).  
Terminal 2 — `backend/`: la app arranca, Flyway dice que aplicó `V1`, no hay stacktrace de `ddl-auto`.  
Terminal 3 — `frontend/`: Vite compiled.

Compruebas:

- [x] `GET http://localhost:8080/api/health` → **200** (no 401)
- [x] En Postgres: `\dt` o el cliente gráfico → tablas `users`, `categories`, `articles`
- [x] Tabla `flyway_schema_history` con una fila `V1`
- [x] Si hay seed: `SELECT * FROM users;`
- [x] `http://localhost:5173` → ves “Atlas”
- [ ] `http://localhost:8080/swagger-ui.html` abre (aunque esté casi vacío)

Commit: `feat: add Spring Boot and Vite skeleton`.

---



## 6. Errores típicos (léelos cuando algo falle)

**401 en** `/api/health`**.** Security. `permitAll` en el `SecurityFilterChain`. No “quites la dependencia Security”: la vas a necesitar.

`relation "users" does not exist`**.** Flyway no corrió o apuntas a otra base (otra URL, otro `search_path`, te quedó el schema `atlas` viejo). Mira `flyway_schema_history` y el nombre de la base en el `yml`.

**Flyway checksum mismatch.** Editaste `V1__init.sql` después de aplicarlo. En local de aprendizaje: drop de tablas + `flyway_schema_history`, o crea `V2`. No uses `ddl-auto: update` para “arreglarlo”.

`ddl-auto: update` **“para ir rápido”.** No. El JD de Konrad se gana diciendo Flyway en voz alta.

**Puerto 5432 already in use.** Tu Postgres 18 y Compose quieren el mismo puerto. Elige uno.

**Puerto 8080 in use.** Otra app Java. Ciérrala o `server.port: 8081` (y cambia el proxy de Vite).

**Seed duplicado / 409 después.** El insert corre en cada arranque. `ON CONFLICT DO NOTHING`, `IF NOT EXISTS`, o el runner que pregunta antes de insertar.

**Vite 404 en** `/api`**.** Falta el proxy, o el `fetch` va a un path distinto.

**Swagger 401 o 404.** Ruta exacta (`/swagger-ui/index.html`) y `permitAll` para `/swagger-ui/`** y `/v3/api-docs/**`.

`backend/` **con un zip mal descomprimido.** Un `backend/backend/pom.xml` extra. El `pom.xml` debe estar **justo** en `Atlas/backend/pom.xml`.

---



## 7. Qué no hagas hoy (aunque tengas ganas)

- Endpoints de artículos, DTOs, JWT, Redis, Next.js, GraphQL
- Poner React y Spring en el mismo puerto “para simplificar”
- Entidades JPA completas (eso es Fase 2)
- Perfeccionar CSS

El bootstrap **terminó** cuando health, Flyway y Vite conviven. La API de negocio es el día siguiente.

---



## 8. Cómo lo contarías en 30 segundos (para más adelante)

> Atlas es un JAR de Spring Boot 3 con Tomcat embebido. Flyway crea las tablas al arrancar; Hibernate solo valida. En local el front es Vite en 5173 con proxy a `/api`. Security está en el classpath pero el health está abierto hasta que pongamos JWT.

Si puedes decir eso señalando archivos, el esqueleto cumplió su trabajo.