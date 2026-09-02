-- Plaintext de todos los hashes: password (BCrypt llega en la fase JWT)
INSERT INTO users (email, password_hash, display_name, role, created_at) VALUES
    ('author@atlas.dev',  '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Maya Chen',     'AUTHOR', '2025-03-04 09:00:00'),
    ('andre@atlas.dev',   '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Andre Silva',   'AUTHOR', '2025-03-10 11:30:00'),
    ('reader@atlas.dev',  '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Luis Romero',   'READER', '2025-06-01 14:15:00'),
    ('admin@atlas.dev',   '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Jordan Blake',  'ADMIN',  '2025-03-01 08:00:00')
ON CONFLICT (email) DO NOTHING;

INSERT INTO categories (name, slug) VALUES
    ('Getting Started', 'getting-started'),
    ('Security',        'security'),
    ('Platform',        'platform'),
    ('FAQ',             'faq'),
    ('Internal',        'internal')
ON CONFLICT (slug) DO NOTHING;

INSERT INTO articles (title, slug, body, status, author_id, category_id, created_at, updated_at, published_at)
SELECT
    'How to sign in to the help center',
    'how-to-sign-in',
    'Use your company email and the password you set at first login.' || E'\n\n'
    || 'If you see 401, your session expired: sign in again. Do not share your password.',
    'PUBLISHED',
    u.id, c.id,
    '2025-04-01 10:00:00', '2025-04-01 10:00:00', '2025-04-01 10:05:00'
FROM users u, categories c
WHERE u.email = 'author@atlas.dev' AND c.slug = 'getting-started'
ON CONFLICT (slug) DO NOTHING;

INSERT INTO articles (title, slug, body, status, author_id, category_id, created_at, updated_at, published_at)
SELECT
    'Resetting your password',
    'resetting-your-password',
    'Open Forgot password, enter your email, and follow the link we send.' || E'\n\n'
    || 'The link expires in 60 minutes. If it already expired, request a new one.',
    'PUBLISHED',
    u.id, c.id,
    '2026-01-12 09:00:00', '2026-02-03 16:40:00', '2026-01-12 09:10:00'
FROM users u, categories c
WHERE u.email = 'author@atlas.dev' AND c.slug = 'security'
ON CONFLICT (slug) DO NOTHING;

INSERT INTO articles (title, slug, body, status, author_id, category_id, created_at, updated_at, published_at)
SELECT
    'SSO rollout notes',
    'sso-rollout-notes',
    'WIP: document IdP mapping and the fallback for users without SSO.' || E'\n\n'
    || 'Do not publish until security signs off.',
    'DRAFT',
    u.id, c.id,
    '2026-08-20 13:00:00', '2026-08-28 11:20:00', NULL
FROM users u, categories c
WHERE u.email = 'author@atlas.dev' AND c.slug = 'security'
ON CONFLICT (slug) DO NOTHING;

INSERT INTO articles (title, slug, body, status, author_id, category_id, created_at, updated_at, published_at)
SELECT
    'Using the article editor',
    'using-the-article-editor',
    'Authors create a draft, preview it, then click Publish.' || E'\n\n'
    || 'Published articles show on the home page. Drafts are only visible to the author.',
    'PUBLISHED',
    u.id, c.id,
    '2025-09-15 08:30:00', '2025-09-15 08:30:00', '2025-09-15 08:45:00'
FROM users u, categories c
WHERE u.email = 'andre@atlas.dev' AND c.slug = 'platform'
ON CONFLICT (slug) DO NOTHING;

INSERT INTO articles (title, slug, body, status, author_id, category_id, created_at, updated_at, published_at)
SELECT
    'Keyboard shortcuts (draft)',
    'keyboard-shortcuts',
    'Todo: Ctrl+S save draft, Ctrl+Enter publish. Confirm with design first.',
    'DRAFT',
    u.id, c.id,
    '2026-08-25 17:00:00', '2026-08-25 17:00:00', NULL
FROM users u, categories c
WHERE u.email = 'andre@atlas.dev' AND c.slug = 'platform'
ON CONFLICT (slug) DO NOTHING;

INSERT INTO articles (title, slug, body, status, author_id, category_id, created_at, updated_at, published_at)
SELECT
    'What is a slug?',
    'what-is-a-slug',
    'A slug is the unique, URL-safe name of an article, for example resetting-your-password. It does not change after publish.',
    'PUBLISHED',
    u.id, c.id,
    '2025-11-02 12:00:00', '2025-11-02 12:00:00', '2025-11-02 12:00:00'
FROM users u, categories c
WHERE u.email = 'author@atlas.dev' AND c.slug = 'faq'
ON CONFLICT (slug) DO NOTHING;

INSERT INTO articles (title, slug, body, status, author_id, category_id, created_at, updated_at, published_at)
SELECT
    'Why do I get 403 when I click Publish?',
    'why-403-on-publish',
    '403 means you are signed in but your role cannot publish. Readers can comment later; only authors publish.' || E'\n\n'
    || '401 means there is no valid token. Sign in again.',
    'PUBLISHED',
    u.id, c.id,
    '2026-03-18 10:00:00', '2026-03-21 09:15:00', '2026-03-18 10:20:00'
FROM users u, categories c
WHERE u.email = 'andre@atlas.dev' AND c.slug = 'faq'
ON CONFLICT (slug) DO NOTHING;

INSERT INTO articles (title, slug, body, status, author_id, category_id, created_at, updated_at, published_at)
SELECT
    'Incident playbook: help center down',
    'incident-playbook-help-center-down',
    '1. Check /api/health.' || E'\n'
    || '2. Look at application logs for 500s (LazyInitializationException is a common cause if we serialize JPA entities).' || E'\n'
    || '3. Roll back the last deploy if the error started after a release.' || E'\n'
    || '4. Post in the squad channel; do not debug live on a client call without telling the PM.' || E'\n\n'
    || 'After the fix: add a test so the same 500 cannot ship again.',
    'PUBLISHED',
    u.id, c.id,
    '2026-05-04 07:45:00', '2026-05-04 07:45:00', '2026-05-04 08:00:00'
FROM users u, categories c
WHERE u.email = 'author@atlas.dev' AND c.slug = 'platform'
ON CONFLICT (slug) DO NOTHING;
