# devsecops-demo
> A real-world DevSecOps learning project. 
> Documenting my journey from Java Developer to DevSecOps Engimeer, one sprint at time.


## About
This is not  tutorial project. It's a living codebase where every future intentionally introduces security vulnerabilities, the pipeline catches them, and I fix and document the decisions. 

The goal is to simulate the full secure SDLC as it happens in real teams: Shift-left security, automated scanning and reasoned remediation.

Each sprint adds a new feature and a new class of security concern.

---

## Pipeline

Every push and pull request triggers a security pipeline that must pass before anything reaches `main`.

```
push / PR
    │
    ├── SAST ──────────────────────────── Semgrep
    │   └── static analysis of Java source code
    │
    └── Build (Maven)
            │
            ├── SCA ────────────────────── OWASP Dependency Check
            │   └── CVE scan of Maven dependencies
            │
            └── Container Scan ─────────── Trivy
                └── CVE scan of Docker image (exit-code: 1 on HIGH/CRITICAL)
```

![Pipeline](<docs/images/jobs.png>)

### Branch protection

`main` and `develop` are protected. No direct pushes. All changes go through a pull request. Pipeline must pass before merge.

![Branch protection](<docs/images/main-branch-protection.png>)

---

## Security findings log

A record of every CVE found, analyzed, and resolved.

| Sprint | CVE | Severity | Component | Decision |
|--------|-----|----------|-----------|----------|
| Setup | CVE-2018-1258 | HIGH | spring-security-web 7.1.0 | **Suppressed** — false positive. Requires Spring Framework 5.0.5 AND Spring Security. This project uses Spring Framewoek 7.0.8, AND condition not met. |
| Setup | CVE-2026-45447 | HIGH | openssl 3.5.6-r0 (Alpine) | **Fixed** — `apk upgrade --no-cache` in Dockerfile upgrades to 3.5.7-r0. |
| Setup | CVE-2026-45186 | HIGH | libexpat 2.7.5-r0 (Alpine) | **Fixed** — same `apk upgrade --no-cache` resolves to 2.8.1-r0. |

![Dependency Check report](<docs/images/dependency-check.png>)

---

## Stack

| Layer | Technology |
|-------|-----------|
| Application | Java 21, Spring Boot 3 |
| Security pipeline | GitHub Actions |
| SAST | Semgrep (`p/java`) |
| SCA | OWASP Dependency Check |
| Container scanning | Trivy |
| Containerisation | Docker, Docker Compose |
| Orchestration | Kubernetes (Minikube) |


---

## Project structure

```
devsecops-demo/
├── .github/
│   └── workflows/
│       └── security.yml       # SAST + SCA + container scan
├── src/
│   └── main/java/pl/nowakpawel/devsecops_demo/
│       └── ...                # application code (grows each sprint)
├── suppression.xml            # documented false positive suppressions
├── Dockerfile
└── pom.xml
```

---

## Sprints

| Sprint | Feature | Security focus | Status |
|--------|---------|----------------|--------|
| 0 | Pipeline setup, branch protection, Docker hardening | CI/CD security gates, CVE analysis | ✅ Done |
| 1 | User registration & login (JWT) | A07 — Authentication failures | 🚧 In progress |
| 2 | Document CRUD | A01 — IDOR, A03 — Injection | ⬜ Planned |
| 3 | File upload | A04 — Path traversal | ⬜ Planned |
| 4 | Search | A03 — SQL Injection | ⬜ Planned |
| 5 | Audit log | Forensics, compliance | ⬜ Planned |
| 6 | Kubernetes deployment | Pod security, RBAC, NetworkPolicy | ⬜ Planned |
| 7 | Secrets management | K8s Secrets, external secrets | ⬜ Planned |
| 8 | DAST integration | OWASP ZAP in pipeline | ⬜ Planned |

---
## Background

I have five years of Java backend experience in regulated environments — financial sector (BNY Mellon, UBS), EU government systems (Ministry of Agriculture). I understand how vulnerabilities get introduced because I have written the systems that contained them.

This project is the practical side of my transition into DevSecOps and Application Security.

More context: [linkedin.com/in/pawel-nowak](https://linkedin.com/in/pawel-nowak) · [nowakpawel.github.io](https://nowakpawel.github.io)

---

## Run locally

```bash
git clone https://github.com/nowakpawel/devsecops-demo.git
cd devsecops-demo
./mvnw spring-boot:run
```

---

*Each sprint is documented as a blog post at [nowakpawel.github.io](https://nowakpawel.github.io). (blog written in my native polish language )*