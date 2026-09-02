# Atlas

Knowledge base (mini CMS): Java 17, Spring Boot 4, PostgreSQL, React + TypeScript.

## Cómo levantar

1. **PostgreSQL** — instancia local (p. ej. 18). Crea una database llamada `Atlas`. Usuario y password: los de [`backend/api/src/main/resources/application.properties`](backend/api/src/main/resources/application.properties) (`jdbc:postgresql://localhost:5432/Atlas`).

2. **API** — Git Bash, desde `backend/api`:

   `./mvnw spring-boot:run`

   Flyway crea las tablas; `data.sql` inserta el seed. Health: [http://localhost:8080/actuator/health](http://localhost:8080/actuator/health) → `{"status":"UP"}`.

3. **Frontend** — otra terminal, desde `frontend`:

   `npm install` (solo la primera vez)  
   `npm run dev`

   UI: [http://localhost:5173](http://localhost:5173) → título Atlas. Vite proxifica `/api` y `/actuator` al puerto 8080.

## Usuario seed

`author@atlas.dev` / `password` (rol AUTHOR). Hay más cuentas en `data.sql` (misma password).

Plan de aprendizaje: [01-planning/bootstrap-spring-boot.md](01-planning/bootstrap-spring-boot.md).
