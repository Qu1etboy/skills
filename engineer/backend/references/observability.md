# Reference: Observability

**Load when:** writing or reviewing service code that needs logging, metrics, or
tracing — or when deciding what to instrument, what to log at which level, and what to
put on a dashboard.

**Stack:** OpenTelemetry for instrumentation; Prometheus + Grafana LGTM (Loki / Grafana
/ Tempo / Mimir) for storage and viz.

## Guiding question

**Would this help an on-call engineer at 2AM?** Every metric, log line, and span earns
its place by either telling on-call what to *do* or answering a question they'd *ask*
while investigating. If a signal does neither — or can be derived from something you
already emit — don't add it. Noise has a cost in storage *and* in time-to-diagnose.

## Principles

- **Instrument to the OpenTelemetry standard.** Use OTel SDKs and semantic conventions so signals are portable and the three pillars correlate. Reuse the codebase's existing instrumentation helpers first; **if none exists, ask before inventing one** — there may be a common lib, or the answer may be plain OTel.
- **Three signals, three jobs.** Logs = discrete events (what happened), metrics = cheap aggregates over time (how much / how often), traces = causal path of one request. Don't log what should be a metric; don't metric what should be a trace.
- **Make signals connect.** Put `trace_id` on logs and use metric exemplars so you can hop metric → trace → log. That navigation path is the point of LGTM — see "The 2AM path" below.
- **Mind cardinality.** High-cardinality identifiers (user_id, request_id, full paths with IDs) on *metric labels* explode series count and Mimir cost. They belong on traces and logs, not metric dimensions.
- **Avoid PII — cheaply.** Don't log whole request objects, tokens, passwords, or emails; redact known sensitive fields at the logging boundary, not per call site. If correct redaction would need complex free-text sanitization, that's not worth quietly building — flag it and ask, or drop the field.

## Logging

- **Levels are a contract, especially with alerting.**
  - `ERROR` — a failure that needs attention; broke a request or an invariant. Always logged. If ERROR pages someone, only log ERROR for things worth paging.
  - `WARN` — unexpected but handled/degraded (retry eventually succeeded, fell back, nearing a limit). Don't log a successfully-handled error as ERROR; don't bury a real failure as WARN to dodge the alert.
  - `INFO` — significant state/business events. This is the expensive one at request volume — be sparse.
  - `DEBUG` — detailed diagnostics, off in prod by default.
- **Cost awareness.** Per-request INFO logging gets expensive fast in Loki. Prefer `DEBUG` for that detail in staging, and lean on metrics/traces for the steady-state signal. `ERROR` always logs regardless of environment.
- **Format: searchable and filterable.** Keep a greppable, code-locating prefix in the message — `[class.method] message`, e.g. `[searchService.search] failed to query opensearch` — **and** emit the same locator as a structured field so Loki can filter on it rather than regex the message:
  - Fields: `level`, `service`, `caller="searchService.search"`, `trace_id`, plus event-specific keys.
  - Then on-call can do `{service="search-api"} | json | level="ERROR" | caller="searchService.search"` instead of scanning text.

## Tracing

- **Record the error *and* set span status to error** — status is what makes Tempo filterable by failure; a logged-but-green span hides the problem.
- **Low-cardinality span names**, operation-shaped, mirroring the log prefix (`searchService.search`, not the query text). Consistent naming across spans and logs makes cross-signal jumps obvious.
- **Propagate context across every boundary, including async** (queues, goroutines, callbacks). Broken propagation orphans spans — and is a classic cause of *suspiciously* long durations (alongside SDK retry multiplication).

## The 2AM path (why the wiring matters)

A symptom-based metric alert fires → jump via **exemplar** to an example trace in Tempo
→ jump via **`trace_id`** to that request's logs in Loki. Each hop needs its wiring:
exemplars on histograms, `trace_id` as a log field, and a Grafana data-link between
them. Build the path once; it pays back on every incident.

## Decision heuristics

- **What to measure on a service:** golden signals — latency, traffic, errors, saturation. For request-driven code, **RED** (Rate, Errors, Duration); for resources (pools, queues), **USE** (Utilization, Saturation, Errors).
- **What to alert on:** symptoms users feel (error rate, latency SLO burn), not causes (high CPU). Cause-alerts page for things that self-resolve and breed fatigue.
- **Sample traces, never drop errors.** Volume sampling is fine; error and slow traces always survive.

## Dashboard examples (RED on a request service)

> Metric names follow OTel HTTP semconv via the Prometheus exporter — **verify the exact
> names and label keys against your SDK/exporter version.** Shapes are correct; names
> may differ (`http_server_request_duration_seconds*`, `http_route`, `http_response_status_code`).

```promql
# Traffic — requests/sec by route
sum by (http_route) (rate(http_server_request_duration_seconds_count[5m]))

# Errors — 5xx ratio
  sum(rate(http_server_request_duration_seconds_count{http_response_status_code=~"5.."}[5m]))
/ sum(rate(http_server_request_duration_seconds_count[5m]))

# Duration — p95 latency by route (needs the _bucket histogram)
histogram_quantile(0.95,
  sum by (le, http_route) (rate(http_server_request_duration_seconds_bucket[5m])))
```

```logql
# Error log rate from Loki (label keys depend on your log schema)
sum(rate({service="search-api"} | json | level="ERROR" [5m]))
```

## Review checklist

- [ ] Every signal answers a 2AM question or drives an action; nothing derivable-elsewhere added.
- [ ] Inbound requests and outbound calls traced; context propagated across async hops.
- [ ] Span status set on failure; span names low-cardinality.
- [ ] Logs structured + correctly leveled; `trace_id` present; no PII/secrets.
- [ ] `[class.method]` locator in both message and a filterable field.
- [ ] No high-cardinality labels on metrics.
- [ ] Golden-signal dashboard exists; alerts are on symptoms; exemplars wired metric→trace.

## Smells & pitfalls

- **Log-and-throw / log-and-rethrow** → same error logged at every layer; log once, where it's handled.
- **Handled errors logged as ERROR** → pages for non-problems; demote to WARN/INFO.
- **High-cardinality metric labels** → series explosion and cost; move IDs to logs/traces.
- **Broken trace propagation across async boundaries** → orphaned spans, inflated durations.
- **Cause-based alerting** → noise, fatigue, ignored pages.
- **Per-item logging in hot loops** → the instrumentation becomes the performance problem.
