# Edge-case catalog

Reference for `bug-hunt` step 4. For each changed symbol, walk the sections that apply and ask the question in each bullet. A hit becomes a candidate finding with its concrete failing input.

## Inputs and values

- **Missing**: `null`, `undefined`, absent key, empty string, empty array, empty object, `0`, `false`, `NaN`. Which of these does the code treat as "no value" by accident (`if (!x)` on a legitimate `0`)?
- **Boundaries**: first, last, one past the end, exactly at a limit, limit ± 1, negative, zero, maximum safe integer. Off-by-one in loops, slices, pagination and ranges.
- **Size**: one element, very many elements, very long strings, deeply nested data. Does anything load everything into memory, or loop per item over the network (N+1)?
- **Shape and type**: wrong type from untyped input (query strings are strings, JSON numbers can be floats), extra fields, arrays where a single value was expected, duplicate keys or IDs.
- **Text**: unicode, emoji, combining characters, RTL, whitespace-only, leading and trailing spaces, case differences in comparisons, `.toLowerCase()` locale traps.
- **Numbers and money**: floating-point totals, rounding direction, currency minor units, division by zero, overflow, percentages over 100 or below 0.

## State and sequence

- **Ordering**: is the result order relied on but never specified (DB rows without `ORDER BY`, object keys, `Promise.all` results vs completion order)?
- **State transitions**: every state the entity can be in when this code runs, including deleted, archived, suspended, half-created. Can an action run twice, or out of order (cancel before create, refund before capture)?
- **First and last**: first-ever user, empty database, last item removed, the only admin demoting themselves.
- **Stale data**: cached values, optimistic UI, a record read and later written without a version check.

## Failure

- **Errors**: every `await`, network call, parse and DB write that can throw. Is each one caught, surfaced, and is the caller left in a consistent state?
- **Partial failure**: step 2 of 3 fails. What has already been written, charged, sent, or queued? Is there a transaction or compensation?
- **Retries and idempotency**: webhooks and jobs delivered twice, a user double-clicking submit, a client retrying after a timeout that actually succeeded.
- **Timeouts and slowness**: no timeout on outbound calls, a slow dependency holding a lock or connection, UI with no loading or error state.
- **Swallowed errors**: empty `catch`, `.catch(() => {})`, errors logged but reported to the user as success.

## Concurrency and time

- **Races**: two requests updating the same record (lost update), check-then-act (`if not exists then insert`), counters incremented without atomic ops, jobs running in parallel on the same entity.
- **Time**: time zones (server vs user), DST transitions, end of month and leap years, dates compared as strings, `new Date()` vs DB time, expiry checks with `<` vs `<=`.
- **Async ordering**: un-awaited promises, effects that run after unmount, event handlers firing before initialization.

## Security and trust

- **Authorization**: can user A read or change user B's record by changing an ID? Is the check on the server, on every path (including bulk and export endpoints)?
- **Trust boundaries**: client-supplied prices, roles, user IDs, or redirect URLs trusted by the server.
- **Injection**: string-built queries, shell commands, HTML rendering of user input, template injection, path traversal in file names.
- **Exposure**: secrets or personal data in logs, error messages, responses, or client bundles.

## Data and contracts

- **Schema changes**: a new non-null column on a table with existing rows, a renamed column still read by old code during deploy, a destructive migration with no backfill.
- **Changed contracts**: a function's return shape, error behaviour, or units changed while callers still assume the old ones; an API response field removed or renamed under a client.
- **Invariants**: totals that must equal the sum of their parts, unique constraints enforced only in code, soft-deleted rows leaking into queries.
- **Config and environment**: a new env var with no default and no validation, a feature that behaves differently in production (caching, CDN, edge runtime).

## UI (when the diff touches it)

- Loading, empty, error and partial states; double submit; back button and refresh mid-flow; very long text breaking layout; keyboard-only and screen-reader paths; narrow screens.
