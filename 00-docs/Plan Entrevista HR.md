# Plan: entrevista de HR — Full Stack Java Developer (Konrad)

Este documento es el guion de la **primera ronda** (recruiter / HR). No es la técnica. HR en una consultora como Konrad no te pide escribir un `@RestController`. Te pide saber si puedes **trabajar en un equipo cercano**, **comunicar**, **entregar bajo deadline de cliente**, y si tu stack encaja lo bastante como para pasarte al hiring manager.

Las historias de “tu último puesto” son un **banco de práctica coherente**. Úsalas para ensayar. No improvises nombres distintos en cada pregunta.

---

## 1. Cómo piensa el reclutador

Un recruiter de HR que contrata Java fullstack para Konrad escucha tres capas a la vez:

1. **Filtro de stack (90 segundos).** ¿Java + Spring Boot? ¿React o Angular? ¿Has entregado algo en equipo, no solo un curso? Si aquí tartamudeas, la ronda muere aunque seas simpático.
2. **Filtro de agencia.** Konrad hace apps **consumer y enterprise** para clientes. Quieren a alguien que aguante cambios de alcance, hable con PM/diseño/QA, y no se esconda detrás del código.
3. **Filtro de cultura (el JD lo dice en claro).** Comunicación, proactividad, code review, ganas de mejorar procesos, mentorship. Un genio técnico que “prefiero no hablar, solo codeo” es un **no**.

Lo que HR **anota** (no lo dice en voz alta):

| Busca | Cómo se oye | Red flag |
|---|---|---|
| Dueño de un slice | “Yo hice el publish: form React, API, tabla, test” | “El equipo hizo un portal…” (tú desapareces) |
| Junior creíble | Un bug, un PR, un número modesto | “Arquitecté la plataforma”, “lideré 12 personas” |
| Calma bajo estrés | Pediste ayuda, recortaste alcance, avisaste | Héroes de madrugada sin avisar al lead |
| Coachable | Un feedback que aplicaste | “Los reviewers se equivocaban” |
| Inglés usable | Standup y STAR en inglés, imperfecto pero claro | Solo español y pánico al cambiar de idioma |
| Motivación hacia Konrad | Equipo fuerte, cliente + producto, aprendizaje | “Busco 100% remote y más sueldo” como única razón |

HR **casi nunca** profundiza en Hibernate. Si te pregunta “¿qué es Spring Boot?”, quiere una frase de negocio, no el classpath.

---

## 2. Ficha del último puesto (memoriza esto)

Trátalo como un personaje. Si te preguntan un detalle que no está aquí, di “no lo tengo presente; lo que sí recuerdo es…” — no inventes un cuarto sistema en vivo.

| Campo | Valor |
|---|---|
| Empresa | **Astrix** — consultora de tecnología para life sciences (~70 personas en el squad/delivery que conociste). Modelo parecido a Konrad: squads en cliente. |
| Rol | Full Stack Java Developer |
| Periodo | Marzo 2025 – agosto 2026 (~18 meses) |
| Reporting | Tech lead (Maya Chen). Squad de 6: 1 PM, 1 diseño, 1 QA, 1 backend senior, 1 frontend senior, tú fullstack. |
| Cliente | **Regeneron** |
| Producto | **Nova Help Center** — knowledge base interno para usuarios Regeneron (artículos de plataforma, SOPs de uso, training). Autores de knowledge/training publican; científicos y staff los leen. |
| Stack | Java 17, Spring Boot, React, PostgreSQL, Redis (listados), GitLab CI, Jira, Figma, AWS (Elastic Beanstalk + RDS, el lead lo montó; tú variables y logs). |
| Rituales | Scrum 2 semanas, daily 15 min en inglés, PRs obligatorios, retro. |
| Tu % | ~60% backend / 40% frontend en el último año. |
| Feature estrella | Flujo **draft → publish** de artículos (la misma historia que Atlas, a escala de cliente). |
| Motivo de salida | Quieres un equipo más senior, más consumer + enterprise, y mentorship formal. Astrix está bien; te quedaste corto de techo. Nunca hables mal de ellos. |

**Una línea de elevator (inglés, ~40 s):**

> I’m a fullstack developer with about a year and a half at Astrix, a tech consultancy. I was on a Regeneron engagement — Nova Help Center, a knowledge base for their users — Java, Spring Boot, React, and PostgreSQL. I owned the article publish flow: authors write a draft in React, the API validates and saves it, and published articles show on the internal help site. I’m looking at Konrad because you ship consumer and enterprise apps with a strong engineering bar, and I want more of that — code review, quality, and a team I can learn from.

**La misma en español (~40 s):**

> Soy fullstack, año y medio en Astrix. Estuve en un engagement con Regeneron: Nova Help Center, un knowledge base interno — Java, Spring Boot, React y PostgreSQL. Me dueñé del flujo de publicar artículos: el autor escribe el draft en React, el API valida y guarda, y el sitio interno muestra lo publicado. Miro Konrad porque entregan apps consumer y enterprise con un listón de ingeniería alto, y quiero más de eso: review, calidad y un equipo de quien aprender.

---

## 3. Conceptos y tecnologías que HR sí pregunta

No estudies para un quiz de arquitectura. Estudia **frases de 20–30 segundos** en inglés y español. Si el recruiter es no-técnico, esto basta. Si es un technical recruiter, usará tu frase para decidir si te pasa.

### Frases listas (ensaya en voz alta)

**Full stack.** I work on both sides of a web app: the React UI the user sees and the Java Spring Boot API and database behind it. On Nova, a click on Publish went from the form to the API to PostgreSQL and back to the public list.

**Spring Boot.** It’s the Java framework we used to build the API. It gives us HTTP endpoints, security, and database access without setting up a server from scratch. The app runs as a single JAR with an embedded Tomcat.

**Spring Cloud.** I haven’t used it in production. My work was one Spring Boot service. I know Cloud is the Netflix/stack for many services — gateway, config, discovery. Happy to learn; Boot was the right size for Nova.

**React vs Angular.** Nova was React: components, React Router, forms talking to REST. I can read Angular; I haven’t shipped a large Angular app. Konrad’s JD accepts either.

**REST API.** JSON over HTTP. GET to read, POST to create, PUT to update. We returned 201 on create, 404 if an article slug didn’t exist, 403 if a reader tried to publish.

**PostgreSQL vs NoSQL.** We used PostgreSQL because articles, users, and categories are relational — foreign keys, unique slugs. I’d consider NoSQL for messy documents or very high write volumes; Nova wasn’t that.

**JWT / security.** After login we send a token. The API checks it on protected routes. Passwords are hashed with BCrypt, never stored in plain text. Roles: reader, author, admin.

**Caching / Redis.** The public article list was hit constantly. We cached it in Redis and cleared the cache when someone published, so the home page stayed fast without showing stale drafts.

**Git / code review.** Feature branch, merge request, at least one approval. I treat review comments as part of the work, not as a personal attack.

**CI.** GitLab CI ran tests on every push. If tests failed, we didn’t merge.

**Agile.** Two-week sprints, story points, daily standup. I flag blockers the same day, not on Friday.

**CMS (WordPress, AEM, Sitefinity).** We didn’t run AEM. Nova *was* a small CMS: draft, publish, categories. I understand AEM’s author vs publish idea because we had the same split.

**Cloud (AWS).** Nova ran on AWS. I didn’t design the account. I used env vars, looked at logs, and restarted the service when a deploy went wrong. I want more hands-on cloud.

**Testing.** JUnit on the publish rules (empty body cannot publish) and MockMvc on the API. On the UI we had a few React Testing Library checks on the form. QA still did the client UAT.

**HTTP / HTTPS.** The browser talks to the API with HTTP methods and status codes. In production we used HTTPS so traffic is encrypted. CORS is why a React app on another origin needs the API to allow it.

Si te piden **nivel** (junior / mid):  
> I’d say strong junior / early mid. I own features across the stack, I don’t design the whole system. I’m fast at picking up team conventions.

---

## 4. Método STAR (cómo no naufragar)

HR hace preguntas de **comportamiento**. La respuesta útil dura **60–90 segundos**, no 5 minutos.

| Letra | Qué es | Truco |
|---|---|---|
| **S** Situation | Contexto en 2 frases | Cliente, sprint, qué se rompía |
| **T** Task | Tu responsabilidad | “A mí me tocaba…” |
| **A** Action | 3 acciones **tuyas** | Verbos: traced, asked, cut scope, wrote, flagged |
| **R** Result | Hecho + aprendizaje | Número chico o “demo salió”; “la próxima vez…” |

**Reglas para este JD:**

- Siempre nombra **React o Spring** cuando la historia sea técnica. HR está chequeando el stack de oído.
- Siempre hay **otra persona** (Maya, el PM, QA, el cliente). Konrad trabaja “very closely together”.
- El héroe solitario que no avisa es un no. Avisa al lead.
- Resultado creíble: “el review bajó de 3 rondas a 2”, no “incrementamos revenue 40%”.
- Cierra con **qué harías distinto**. Coachability.
- Prepara cada STAR en **inglés**. Konrad entrevista en inglés con el equipo.

**Si te piden más detalle:** añade *un* archivo, *un* status HTTP o *un* ticket. Si no lo tienes, no lo fabriques en caliente.

---

## 5. Banco STAR (último puesto: Astrix / Nova)

Cada historia cubre varias preguntas. No memorices 20 cuentos; memoriza **estos 10** y reetiquétalos.

### A — Estrés / producción / “cuéntame una situación estresante”

**Preguntas que cubre:** stressful situation, production issue, pressure, a time you handled a crisis.

**S.** Día del UAT con Regeneron. El listado de artículos empezó a devolver 500. El PM y el cliente estaban en la call.

**T.** Yo había tocado el endpoint de listado esa sprint (añadí categoría y autor). Me tocó encontrar la causa y tener algo estable antes de que terminara la demo.

**A.** Dije en el chat del squad: “estoy en el 500, no sigo la demo a ciegas”. En logs vi `LazyInitializationException` — el JSON tocaba `author` fuera de la transacción. Reproduje en local, cambié la query a un `JOIN FETCH` (o `@EntityGraph`) para artículo + autor + categoría, añadí un test MockMvc del GET público, pedí review express a Maya, desplegamos el hotfix.

**R.** La demo siguió 25 minutos tarde con el listado vivo. Postmortem: no devolver entidades JPA; DTOs + fetch explícito. Eso lo llevé a Atlas después.

**Inglés (cierre):** The stressful part wasn’t the stack trace — it was the client on the call. The useful part was flagging it immediately, fixing the query, and adding a test so it wouldn’t come back.

---

### B — Deadline / alcance / “el cliente lo quiere para ayer”

**Preguntas:** tight deadline, competing priorities, said no, managed expectations.

**S.** Regeneron pidió publish de artículos tres días antes del sprint review: training tenía que colgar contenido para un rollout de plataforma.

**T.** El ticket original incluía comentarios y un panel admin. No cabía.

**A.** Hablé con el PM (Luis) el mismo día: “si recortamos comentarios y admin, el draft/publish llega al review; si no, llega a medias”. Acordamos MVP. Yo cerré API `POST /articles`, `POST /{id}/publish`, el form React y el listado público. Comentarios al sprint siguiente. Daily: progreso en porcentajes, no “estoy en eso”.

**R.** Publicaron 12 artículos de training a tiempo. Comentarios salieron la sprint siguiente. Aprendí a negociar alcance en voz alta, no a morir en silencio.

---

### C — Conflicto con un compañero

**Preguntas:** conflict, disagreement with a peer, difficult coworker.

**S.** El frontend senior (Andre) quería que el API aceptara el body del artículo como HTML crudo. Yo no quería guardar HTML sin sanitizar (XSS en el help center).

**T.** Teníamos que acordar un contrato antes del jueves, si no el PR de Andre y el mío no mergeaban.

**A.** No lo discutí en el daily. Pedí 20 minutos, abrí el DTO y un ejemplo de payload. Propuse Markdown en el API y render escapado en React (o sanitizar en servidor). Andre quería velocidad para el diseño rico. Llegamos a: Markdown ahora, HTML sanitizado si Regeneron lo pide. Lo escribí en el ticket para que no se reabriera.

**R.** Mergeamos al día siguiente. La relación siguió bien porque el desacuerdo fue del contrato, no de ego. En Konrad van a querer eso: conflicto de diseño, no de personas.

---

### D — Error tuyo / fracaso

**Preguntas:** failure, mistake, something you’d do differently.

**S.** Mergeé un cambio de entidad `Article` (nuevo campo `published_at`) y olvidé la migración Flyway. Staging cayó al arrancar.

**T.** Era mi PR. Me tocaba revertir o arreglar y avisar.

**A.** Revertí el deploy, escribí `V12__add_published_at.sql`, lo corrí en staging, añadí al checklist del MR template: “¿hay migración?”. Lo dije en el next daily sin maquillaje.

**R.** Staging volvió en ~40 minutos. Nadie más rompió eso esa quarter. El aprendizaje: el esquema no vive solo en la entidad Java.

---

### E — Feedback / code review

**Preguntas:** feedback you received, time you improved, code review.

**S.** Maya rechazó mi primer PR de `ArticleController`: validación, mapeo y SQL de búsqueda en el controller (~200 líneas).

**T.** Rehacerlo para que pasara review sin pelearme con el comentario.

**A.** Moví reglas a `ArticleService`, DTOs de entrada/salida, query en el repositorio. Pregunté en el MR: “¿esto es el nivel de capa que quieres?”. Segunda ronda: dos nits, merge.

**R.** Los PRs siguientes de artículos salieron en 1–2 rondas. Me volví el que recuerda “nada de SQL en el controller” en reviews de otros.

---

### F — No sabías algo / aprendizaje / “research and share” (JD)

**Preguntas:** learned something new, out of your comfort zone, shared with the team.

**S.** Había que proteger rutas de autor. Yo había usado HTTP Basic en un tutorial, nunca JWT en un proyecto de equipo.

**T.** Spike de un día que el lead me dio, y una decisión para el squad.

**A.** Leí la referencia de Spring Security 6, hice un spike en una rama, documenté en Confluence: login devuelve Bearer, roles en el token, CSRF off porque somos SPA. Lo mostré en 10 minutos al final del standup. Maya eligió JWT.

**R.** Ese patrón quedó en Nova y es el que uso en Atlas. Encaja con “research new technology and share those findings with the team”.

---

### G — Orgullo / logro / “tell me about a time you delivered”

**Preguntas:** achievement, proud of, impact.

**S.** El help center interno tardaba ~800 ms en el home (query con N+1 + sin caché). Regeneron se quejaba en UAT.

**T.** Acelerar el listado sin cachear drafts.

**A.** DTOs + fetch join, índice en `(status, published_at)`, Redis en el GET público, `@CacheEvict` al publicar. Verifiqué con un GET anónimo que un draft no aparecía.

**R.** Home ~200 ms en staging. El cliente dejó de reportar “página lenta”. Historia fullstack: UI igual, API y datos distintos.

---

### H — Stakeholder difícil / cambio de requisitos

**Preguntas:** difficult client, ambiguity, changing requirements.

**S.** El cliente cambió dos veces el workflow: primero “todo se publica al guardar”, luego “queremos preview”, luego “draft y un botón Publish”.

**T.** Evitar reescribir el modelo tres veces en una sprint.

**A.** Pedí al PM un workshop de 30 min. Dibujé estados: `DRAFT` / `PUBLISHED`. Pregunté qué pasa si editas un publicado (nueva versión vs editar en vivo). Eligieron editar en vivo solo autores. Lo escribí en Jira y no acepté más cambios por Slack sin ticket.

**R.** Paró el zigzag. Entregamos un modelo. Aprendí que ambigüedad se mata con una pregunta concreta, no con más código.

---

### I — Proceso / workflow (JD: love for improving workflows)

**Preguntas:** improved a process, initiative, proactive.

**S.** Los MRs volvían 3 veces: “¿cómo lo pruebo?”, “falta screenshot”, “no hay colección Postman”.

**T.** Nadie me lo pidió. Me molestaba el idle time.

**A.** Propuse un template de MR (qué cambió, cómo probar, flag de migración) y una colección Postman de artículos en el repo. Lo llevé a retro, el equipo votó sí.

**R.** Mis PRs y varios ajenos bajaron a 1–2 rondas. Es el tipo de iniciativa que Konrad escribe en el JD.

---

### J — Bloqueo / pedir ayuda / reliability

**Preguntas:** when you were stuck, asked for help, reliability.

**S.** CORS: el form de publish funcionaba en Postman y fallaba en el browser (`Origin localhost:5173`).

**T.** Llevaba más de una hora. El ticket era del sprint.

**A.** En el daily: “bloqueado en CORS, no en la lógica de publish”. Maya me pasó el `CorsConfiguration` correcto. Lo dejé en `application-dev.yml` y en el README.

**R.** El ticket salió ese día. Preferí parecer “básico” en daily que esconder el bloqueo hasta Friday.

---

## 6. Preguntas clásicas que no son STAR (guion corto)

### Tell me about yourself / Cuéntame de ti

Usa el elevator de la ficha. 40–60 s. Cierra con por qué Konrad. No recites el CV entero.

### Why Konrad? Why this role?

Tres puntos, no diez:

1. Consumer **y** enterprise, no solo un CRUD interno.
2. Equipo “highly-skilled”, code review, mentorship — lo que ya te gustó en Astrix y quieres a más nivel.
3. Stack del JD = tu stack: Java, Spring Boot, React, bases relacionales.

Evita: “me gustó el paquete de beneficios” como razón #1. Los perks se mencionan al final si preguntan what attracts you (flex, learning culture).

### Why are you leaving Astrix?

> I learned a lot — I shipped real client features. The squad is small and I want more senior neighbors, more variety of products, and a clearer mentorship path. I’m leaving on good terms.

Nunca: “mi lead era tóxico”, “no me pagaban”.

### Strengths

Elige **dos** que el JD nombra: (1) cruzar el stack en una feature, (2) comunicación / avisar blockers, (3) mejorar el proceso de PRs. Una frase de evidencia cada una (historias G, J, I).

### Weakness (la que no te mata)

> I used to hold PRs until they felt perfect, which delayed review. I now open MRs smaller and flag “please look at X”. I’m still tighter on naming than I need to be; I ask for that in review on purpose.

Mala weakness: “soy perfeccionista” sin ejemplo. Pésima: “se me dificulta trabajar en equipo”.

### Where do you see yourself in 5 years?

> A strong fullstack who can own a client feature with less supervision, still in the code, maybe helping juniors the way Maya helped me. Not a people-manager pitch unless they ask.

### Salary / compensación

HR lo pregunta pronto. Rango, no un número único. Investiga el mercado Toronto/remote de Konrad antes de la call. Guion:

> I’m focused on the fit first. For this level I’m looking at a range of [X–Y] CAD, but I’m open if the total package and growth make sense. What’s the band for this role?

Si no tienes número, no inventes uno hoy en el ensayo: deja un placeholder y fíjalo 24 h antes de la call.

### Notice / start date

> I would handle the transition professionally with Astrix. I can start in [2–4] weeks after an offer.

### Work from home / hours (el JD lo ofrece)

> I’m fine with overlap with the core team. Flex is useful; I’m not looking to disappear. I prefer knowing standup time and core hours.

### Do you have questions for us? (prepara 4, haz 2–3)

1. How is the squad set up — one client vs several, and how fullstack is split with specialists?
2. What does the first 90 days look like for someone at this level?
3. How do you run code review and QA before something goes to a client?
4. Mentorship program — is it a named mentor, or more informal pairing?
5. How much of the work is React vs Angular vs other frontends today?

No preguntes primero por vacaciones o WFH. Eso después, o si ellos lo abren.

---

## 7. Plan de estudio HR (speed run, 20–30 min al día)

Hazlo **antes** del bloque de Atlas, no a medianoche cuando ya no razonas. 14 días, en paralelo al [Speed Run Atlas.md](./Speed%20Run%20Atlas.md).

| Día | 20–30 min | Entregable |
|---|---|---|
| 1 | Ficha Astrix + elevator EN + ES. Grábate. | Audio de 60 s |
| 2 | Frases de stack (sección 3). 10 términos en inglés. | Lista tachada |
| 3 | STAR A (estrés) EN + ES | 90 s grabados |
| 4 | STAR B (deadline) + C (conflicto) | Igual |
| 5 | STAR D (error) + E (feedback) | Igual |
| 6 | Why Konrad + why leaving. Lee 1 página de la web de Konrad (work, industries). | 45 s cada una |
| 7 | STAR F (aprender) + G (orgullo / Redis) | Conecta con Atlas |
| 8 | Strengths, weakness, 5 years | Sin monólogo |
| 9 | STAR H + I (stakeholder + proceso) | — |
| 10 | STAR J (bloqueo). Preguntas para ellos. | — |
| 11 | Simulacro: 8 preguntas seguidas, reloj 90 s | Notas de dónde te alargas |
| 12 | Solo inglés: tell me about yourself + stressful situation + why Konrad | — |
| 13 | Salary/notice/WFH + “any questions?” | Placeholder de rango |
| 14 | Descanso activo: relee ficha, no reescribas historias | Listo para la call |

**Día de la entrevista HR:**

- Relee la ficha y STAR A, B, D, G (las más usadas).
- Ten 1 pregunta de equipo y 1 de mentorship.
- Agua, auriculares, silencio. Respuestas cortas; ellos preguntarán más.
- Si no oíste la pregunta: “Let me make sure I got that — you’re asking about X?”

---

## 8. Lo que HR va a sospechar (y cómo no alimentarlo)

| Señal | Qué oyen | Qué hacer |
|---|---|---|
| Historia genérica sin nombres | ChatGPT | Maya, Luis, Andre, Nova, Regeneron, Astrix |
| Solo “nosotros” | No se sabe qué hiciste | “My part was the API and the Publish button” |
| Culpar al cliente / al lead | Drama | Hechos + lo que tú cambiaste |
| Stack inflado | “Spring Cloud, Kafka, k8s…” | JD pide Boot y React. Quédate ahí. |
| Atlas y Astrix se contradicen | Mentira | Mismo dominio: help center. Atlas = tu lab; Nova = cliente |
| Inglés perfecto escrito y oral congelado | Script | Ensaya en voz alta, acepta un acento; claridad > perfección |
| No preguntas al final | No te interesa | 2 preguntas reales |

---

## 9. Mini simulacro (hazlo con un timer)

Que alguien (o Cursor en modo reclutador) te lance **en este orden**, una pregunta a la vez:

1. Tell me about yourself.
2. Walk me through your last role and stack — very briefly.
3. Why Konrad?
4. Tell me about a stressful situation and how you handled it.
5. Describe a time you and a teammate disagreed.
6. Tell me about a mistake.
7. How do you handle tight deadlines from a client?
8. What does “fullstack” mean in your day to day?
9. What’s a weakness you’re working on?
10. Do you have questions for me?

Si una respuesta pasa de 2 minutos, te cortan. En la real, HR sonríe y deja de escuchar.

---

## 10. Map rápido: pregunta → historia

| Te preguntan | Usas |
|---|---|
| Estrés, prod, crisis | **A** |
| Deadline, presión, priorizar | **B** |
| Conflicto, teammate | **C** |
| Fracaso, error | **D** |
| Feedback, review | **E** |
| Aprender, compartir, iniciativa técnica | **F** |
| Logro, impacto, caching | **G** |
| Cliente difícil, requisitos | **H** |
| Mejorar procesos | **I** |
| Bloqueo, pedir ayuda | **J** |
| Fullstack end-to-end | **G** o **B** (publish) |
| Why you / fit | Elevator + **I** + mentorship |

Cuando Atlas tenga demo, añade una frase: “I’m also building Atlas, a smaller help center, to go deeper on security and tests.” Eso es proactividad. No sustituye a Astrix: es el side project.
