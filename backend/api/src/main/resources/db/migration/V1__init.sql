CREATE TABLE users (
    id              BIGSERIAL PRIMARY KEY,
    email           VARCHAR(255) NOT NULL UNIQUE,
    password_hash   VARCHAR(255) NOT NULL,
    display_name    VARCHAR(255) NOT NULL,
    role            VARCHAR(32)  NOT NULL,
    created_at      TIMESTAMP    NOT NULL DEFAULT now()
);

CREATE TABLE categories (
    id    BIGSERIAL PRIMARY KEY,
    name  VARCHAR(255) NOT NULL,
    slug  VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE articles (
    id            BIGSERIAL PRIMARY KEY,
    title         VARCHAR(255) NOT NULL,
    slug          VARCHAR(255) NOT NULL UNIQUE,
    body          TEXT         NOT NULL,
    status        VARCHAR(32)  NOT NULL,
    author_id     BIGINT       NOT NULL,
    category_id   BIGINT       NOT NULL,
    created_at    TIMESTAMP    NOT NULL DEFAULT now(),
    updated_at    TIMESTAMP    NOT NULL DEFAULT now(),
    published_at  TIMESTAMP,
    CONSTRAINT fk_articles_author
        FOREIGN KEY (author_id) REFERENCES users (id) ON DELETE RESTRICT,
    CONSTRAINT fk_articles_category
        FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE RESTRICT
);