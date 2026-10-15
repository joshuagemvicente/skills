# Secure coding checklist (default)

Used when the config names no team checklist. Based on the OWASP Top 10 and ASVS. Mark each item Pass, N/A or Fail, with evidence.

| # | Item | What to check in the diff |
|---|---|---|
| 1 | Input validation | Every external input (body, query, params, headers, files, webhooks) is validated server-side against an allowlist schema |
| 2 | Injection | Queries are parameterized or go through the ORM; no string-built SQL, shell commands, or dynamic `eval` |
| 3 | Output encoding | User-controlled data rendered in HTML is escaped; no raw-HTML rendering of user input |
| 4 | Authentication | New routes and actions require an authenticated session unless intentionally public, and that intent is stated |
| 5 | Authorization | Every read and write checks the caller may act on that specific record (object-level), not just that they're logged in |
| 6 | Session and tokens | Tokens are verified, expire, and never appear in URLs or logs; cookies are `HttpOnly`, `Secure`, `SameSite` |
| 7 | Secrets | No keys, passwords or connection strings in code, config committed to git, or client bundles |
| 8 | Sensitive data | Personal and payment data is minimized, not logged, and not returned in responses that don't need it |
| 9 | Cryptography | Passwords use a slow hash (argon2/bcrypt/scrypt); no homemade crypto; randomness for tokens comes from a CSPRNG |
| 10 | Error handling | Errors returned to clients carry no stack traces, SQL, or internal paths; failures don't leave partial writes |
| 11 | CSRF and CORS | State-changing requests are CSRF-protected; CORS origins are an explicit allowlist |
| 12 | Files and uploads | Type and size are validated, names are not trusted, and stored files are not executable or publicly listable |
| 13 | Outbound requests | URLs built from user input are allowlisted (SSRF); redirects go only to allowlisted destinations |
| 14 | Abuse limits | Login, signup, password reset, OTP and other expensive endpoints are rate-limited |
| 15 | Dependencies | New packages are maintained, needed, and free of known vulnerabilities (`npm audit` or equivalent); the lockfile is committed |
| 16 | Security logging | Auth failures, permission denials and admin actions are logged without sensitive values |
