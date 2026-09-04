# 06_DECISIONS.md

# Dayjoy Enterprise AI Platform — Enterprise Decision Register

> **Status:** Confirmed / Recommended / Pending  
> **Purpose:** Official decision register for business, technical, AI, security, infrastructure, and documentation decisions.

---

## Table of Contents

1. [Document Purpose](#1-document-purpose)
2. [Executive Summary](#2-executive-summary)
3. [Business Decisions](#3-business-decisions)
4. [Technical Decisions](#4-technical-decisions)
5. [AI Decisions](#5-ai-decisions)
6. [Integration Decisions](#6-integration-decisions)
7. [Security Decisions](#7-security-decisions)
8. [Infrastructure Decisions](#8-infrastructure-decisions)
9. [Documentation Decisions](#9-documentation-decisions)
10. [Pending Decisions](#10-pending-decisions)
11. [Decision Dependency Matrix](#11-decision-dependency-matrix)
12. [Decision Timeline](#12-decision-timeline)
13. [Change History](#13-change-history)
14. [Review Schedule](#14-review-schedule)
15. [Summary](#15-summary)

---

## 1. Document Purpose

### Why a decision register exists

**VERIFIED:** This document creates a traceable record of the choices made for the Dayjoy Enterprise AI Platform so future teams can understand what was decided, why, and what it affects. [00_MASTER_CONTEXT.md][04_DOCUMENT_MAP.md][05_RESEARCH_LOG.md]

### Who should use it

- Leadership / management
- Product managers
- Solution architects
- Engineers
- AI developers
- Project managers
- Documentation owners

### How decisions should be updated

- Add new decisions as they are approved.
- Update status when a decision changes.
- Link every decision to supporting research and documents.
- Keep pending items visible until resolved.

---

## 2. Executive Summary

**Confirmed decisions from research and planning:**
- Use research-first, fact-checked documentation as the foundation. [00_MASTER_CONTEXT.md][02_KNOWN_FACTS.md]
- Use RAG as the core knowledge approach. [11_AI_Opportunities.md]
- Separate verified facts from unknowns to avoid assumptions. [02_KNOWN_FACTS.md][03_UNKNOWN_INFORMATION.md]
- Design modular AI assistants by function and audience. [11_AI_Opportunities.md]
- Prioritize customer support, distributor support, and knowledge retrieval first. [10_Pain_Points.md][11_AI_Opportunities.md]

**Recommended decisions already identified:**
- Build Website AI first, then WhatsApp AI, then Voice AI, then deeper CRM/ERP automation. [11_AI_Opportunities.md]
- Establish strict documentation governance and naming conventions. [01_PROJECT_INDEX.md][04_DOCUMENT_MAP.md]

**Pending client decisions:**
- Exact CRM, ERP, payment, and hosting stack. [03_UNKNOWN_INFORMATION.md][12_Research_Gap_Analysis.md]
- Final AI rollout scope and permissions. [03_UNKNOWN_INFORMATION.md][12_Research_Gap_Analysis.md]
- Data access and compliance boundaries. [03_UNKNOWN_INFORMATION.md][05_Policies.md]

---

## 3. Business Decisions

| Decision ID | Title | Category | Description | Background | Problem Being Solved | Selected Option | Alternatives Considered | Why Alternatives Were Rejected | Supporting Research | Business Impact | Technical Impact | Risks | Dependencies | Owner | Status | Review Date |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| DEC-001 | AI Platform Focus | Business | Build an enterprise AI platform for customers, distributors, employees, and management. | Research showed multi-audience needs. | Fragmented support and knowledge. | Multi-audience AI platform. | Single-purpose chatbot; no AI platform. | Too limited for enterprise needs. | 00_MASTER_CONTEXT.md, 10_Pain_Points.md, 11_AI_Opportunities.md | High | High | Scope creep | All later modules | Leadership | Confirmed | 2026-08 |
| DEC-002 | Research-First Strategy | Business | Complete documentation before implementation. | Many unknowns still exist. | Avoid assumptions and rework. | Research pack first. | Start coding immediately. | Too risky without validated facts. | 12_Research_Gap_Analysis.md, 03_UNKNOWN_INFORMATION.md | High | High | Delayed start | All implementation work | PM / Leadership | Confirmed | 2026-08 |
| DEC-003 | Audience Segmentation | Business | Separate customer, distributor, employee, and management AI use cases. | Different users have different needs and permissions. | Confusing one-size-fits-all design. | Role-based AI. | One universal assistant. | Poor fit and weak governance. | 07_Customer_Journey.md, 04_Distributor_System.md, 11_AI_Opportunities.md | High | Medium | Complexity | Knowledge architecture | Product / Architecture | Confirmed | 2026-08 |
| DEC-004 | Knowledge-Driven Support | Business | Use centralized knowledge as the source of truth. | FAQs, policies, and processes are documented. | Inconsistent answers across channels. | RAG-backed knowledge base. | Manual support only; static docs only. | Not scalable. | 02_KNOWN_FACTS.md, 06_FAQs.md, 05_Policies.md | Very High | High | Outdated content | Knowledge governance | Knowledge Engineer | Confirmed | 2026-08 |

---

## 4. Technical Decisions

| Decision ID | Title | Category | Description | Background | Problem Being Solved | Selected Option | Alternatives Considered | Why Alternatives Were Rejected | Supporting Research | Business Impact | Technical Impact | Risks | Dependencies | Owner | Status | Review Date |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| DEC-101 | API-First Architecture | Technical | Expose core functions through APIs. | AI and automation need reusable interfaces. | Hard-to-maintain point-to-point logic. | API-first. | UI-only integration; direct DB access. | Not scalable or safe. | 11_AI_Opportunities.md, 08_Business_Processes.md, 12_Research_Gap_Analysis.md | High | Very High | Integration effort | Backend/API design | Solution Architect | Recommended | 2026-08 |
| DEC-102 | Modular Services | Technical | Separate modules for AI, workflows, data, and integrations. | Many use cases and future growth. | Monolithic complexity. | Modular design. | Single monolith. | Harder to scale and maintain. | 11_AI_Opportunities.md, 04_DOCUMENT_MAP.md | High | High | Coordination overhead | Architecture planning | CTO / Architect | Recommended | 2026-08 |
| DEC-103 | Markdown Documentation Standard | Technical | Use Markdown for all project documentation. | Repository already uses Markdown. | Inconsistent documentation formats. | Markdown standard. | Mixed formats. | Poor governance. | 00_MASTER_CONTEXT.md, 01_PROJECT_INDEX.md | Medium | Low | None | Documentation rules | Documentation owner | Confirmed | 2026-08 |
| DEC-104 | Numbered File Naming | Technical | Use numbered files for core docs. | Existing docs use numbered structure. | Hard to read order. | Numeric order. | Freeform names. | Reduces discoverability. | 01_PROJECT_INDEX.md, 04_DOCUMENT_MAP.md | Medium | Low | None | Folder conventions | Documentation owner | Confirmed | 2026-08 |

---

## 5. AI Decisions

| Decision ID | Title | Category | Description | Background | Problem Being Solved | Selected Option | Alternatives Considered | Why Alternatives Were Rejected | Supporting Research | Business Impact | Technical Impact | Risks | Dependencies | Owner | Status | Review Date |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| DEC-201 | Use RAG for Knowledge Answers | AI | AI should answer from verified sources. | Product, policy, FAQ, and process documents exist. | Hallucination risk. | RAG. | Pure prompting without retrieval. | Less accurate and less auditable. | 02_KNOWN_FACTS.md, 06_FAQs.md, 05_Policies.md | Very High | High | Stale content | Knowledge base | Knowledge Engineer | Confirmed | 2026-08 |
| DEC-202 | Separate AI Assistants by Function | AI | Use dedicated agents for support, distributor, sales, marketing, internal, analytics. | Different workflows require different tools. | Confusing general assistant. | Specialized agents. | One generic assistant. | Lower quality and weaker control. | 11_AI_Opportunities.md | High | High | Orchestration complexity | Agent architecture | AI Architect | Confirmed | 2026-08 |
| DEC-203 | Human Escalation for Sensitive Cases | AI | AI must escalate legal, payment, refund exception, and misconduct issues. | Policies identify sensitive cases. | Risk of unsafe autonomy. | Human-in-the-loop. | Fully autonomous handling. | Compliance and trust risk. | 05_Policies.md, 10_Pain_Points.md | High | Medium | Slower resolution in edge cases | Support process design | Support lead / Compliance | Confirmed | 2026-08 |
| DEC-204 | Voice AI as Phase 4 | AI | Voice AI is a later phase after KB and text AI. | Needs reliable knowledge and routing. | Premature voice deployment risk. | Phased rollout. | Launch voice first. | Too risky without support maturity. | 11_AI_Opportunities.md, 12_Research_Gap_Analysis.md | High | Medium | Timeline shift | KB and web/WhatsApp AI | CAIO / Architect | Recommended | 2026-08 |

---

## 6. Integration Decisions

| Decision ID | Title | Category | Description | Background | Problem Being Solved | Selected Option | Alternatives Considered | Why Alternatives Were Rejected | Supporting Research | Business Impact | Technical Impact | Risks | Dependencies | Owner | Status | Review Date |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| DEC-301 | CRM Integration Required | Integration | CRM is needed for customer/distributor workflows. | Customer journeys and support flows depend on records. | No single view of customer/distributor interactions. | CRM integration. | Manual records only. | Not scalable. | 07_Customer_Journey.md, 08_Business_Processes.md, 12_Research_Gap_Analysis.md | Very High | High | Unknown vendor | CRM discovery | IT / Leadership | Pending | TBD |
| DEC-302 | ERP / Order System Integration Required | Integration | ERP/order system needed for order, inventory, shipment. | Business processes require live operational data. | No visibility into order lifecycle. | ERP integration. | File-based/manual tracking. | Inefficient and error-prone. | 08_Business_Processes.md, 12_Research_Gap_Analysis.md | Very High | High | Unknown vendor | Ops + IT discovery | Operations / IT | Pending | TBD |
| DEC-303 | WhatsApp Business API | Integration | Needed for WhatsApp AI. | Public WhatsApp support exists. | Scalable chat support. | WhatsApp API integration. | Manual chat handling. | Not scalable. | 05_Policies.md, 06_FAQs.md, 11_AI_Opportunities.md | High | High | API availability unknown | Vendor confirmation | IT / Support | Pending | TBD |
| DEC-304 | Vapi for Voice AI | Integration | Needed for Voice AI. | Public phone support exists. | Scalable phone support. | Vapi. | Custom IVR only. | Less flexible AI support. | 05_Policies.md, 11_AI_Opportunities.md | High | Medium | Telephony integration unknown | Telephony stack | CAIO / IT | Pending | TBD |
| DEC-305 | n8n for Workflow Automation | Integration | Needed for orchestration of support and approval flows. | Processes have clear workflow logic. | Manual approvals and routing. | n8n. | Custom-built workflow engine only. | Slower to implement initially. | 08_Business_Processes.md, 11_AI_Opportunities.md | High | Medium | Workflow complexity | API layer | Solution Architect | Recommended | 2026-08 |

---

## 7. Security Decisions

| Decision ID | Title | Category | Description | Background | Problem Being Solved | Selected Option | Alternatives Considered | Why Alternatives Were Rejected | Supporting Research | Business Impact | Technical Impact | Risks | Dependencies | Owner | Status | Review Date |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| DEC-401 | Role-Based Access Control | Security | Restrict access based on role and purpose. | Different user groups need different access levels. | Data leakage risk. | RBAC. | Shared access / no roles. | Unsafe and non-compliant. | 03_UNKNOWN_INFORMATION.md, 02_KNOWN_FACTS.md | High | High | Misconfiguration | Auth design | IT / Security | Recommended | 2026-08 |
| DEC-402 | Audit Logging | Security | Log key AI actions, approvals, and data access. | Governance requires traceability. | No accountability trail. | Audit logs. | Minimal logs. | Hard to investigate issues. | 12_Research_Gap_Analysis.md, 05_Policies.md | High | Medium | Storage overhead | Monitoring design | Security / IT | Recommended | 2026-08 |
| DEC-403 | Data Privacy Controls | Security | Protect personal, transaction, and support data. | Privacy policy already exists. | Compliance risk. | Privacy controls. | Open data access. | Not acceptable. | 05_Policies.md, 12_Research_Gap_Analysis.md | Very High | High | Misuse of data | Legal + IT | Legal / Security | Confirmed | 2026-08 |

---

## 8. Infrastructure Decisions

| Decision ID | Title | Category | Description | Background | Problem Being Solved | Selected Option | Alternatives Considered | Why Alternatives Were Rejected | Supporting Research | Business Impact | Technical Impact | Risks | Dependencies | Owner | Status | Review Date |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| DEC-501 | Cloud Hosting Needed | Infrastructure | Hosting provider to be selected. | Platform needs scalable hosting. | No confirmed infrastructure yet. | Pending decision. | On-prem / managed / cloud. | Not enough evidence to choose. | 12_Research_Gap_Analysis.md | High | High | Vendor lock-in | Architecture discovery | IT | Pending | TBD |
| DEC-502 | Containerized Deployment | Infrastructure | Use containers for repeatable deployment. | Enterprise platform requires predictable environments. | Deployment inconsistency. | Recommended container approach. | Direct host deployment. | Harder to manage and scale. | 11_AI_Opportunities.md, 12_Research_Gap_Analysis.md | Medium | Medium | DevOps maturity | Hosting choice | Architect / DevOps | Recommended | 2026-08 |
| DEC-503 | Backup and Restore Strategy | Infrastructure | Define backup policy for documents, data, and configs. | Enterprise knowledge and data must be recoverable. | Data loss risk. | Backup strategy required. | Manual backups. | Unsafe. | 12_Research_Gap_Analysis.md | High | Medium | Recovery gaps | Data design | IT | Pending | TBD |

---

## 9. Documentation Decisions

| Decision ID | Title | Category | Description | Background | Problem Being Solved | Selected Option | Alternatives Considered | Why Alternatives Were Rejected | Supporting Research | Business Impact | Technical Impact | Risks | Dependencies | Owner | Status | Review Date |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| DEC-601 | Numbered Documentation System | Documentation | Use numbered docs for governance and navigation. | Existing docs use numbered structure. | Confusing navigation. | Numbered docs. | Unnumbered documents. | Harder to manage. | 01_PROJECT_INDEX.md, 04_DOCUMENT_MAP.md | Medium | Low | None | Documentation rules | Documentation owner | Confirmed | 2026-08 |
| DEC-602 | Single Source of Truth Principle | Documentation | Facts, unknowns, decisions, and context each have dedicated docs. | Need clean governance. | Duplication and inconsistency. | Dedicated repositories. | Everything in one doc. | Too messy. | 00_MASTER_CONTEXT.md, 02_KNOWN_FACTS.md, 03_UNKNOWN_INFORMATION.md, 04_DOCUMENT_MAP.md | High | Low | None | Governance discipline | Documentation owner | Confirmed | 2026-08 |
| DEC-603 | Markdown as Standard | Documentation | All major docs are Markdown. | Easy to maintain and AI-friendly. | Format fragmentation. | Markdown standard. | Mixed file types. | Poor consistency. | 01_PROJECT_INDEX.md | Medium | Low | None | Repo conventions | Documentation owner | Confirmed | 2026-08 |

---

## 10. Pending Decisions

| Decision ID | Topic | Why It Matters | Status | Owner |
|---|---|---|---|---|
| DEC-P01 | CRM vendor selection | Determines data model and integrations | Pending | IT / Leadership |
| DEC-P02 | ERP / inventory system selection | Determines order and stock automation | Pending | Operations / IT |
| DEC-P03 | Payment gateway provider | Needed for checkout and refund flows | Pending | Finance / IT |
| DEC-P04 | Hosting provider / cloud strategy | Needed for deployment architecture | Pending | IT / Leadership |
| DEC-P05 | Exact AI rollout scope | Determines phase plan and budget | Pending | Leadership |
| DEC-P06 | Data access and permissions | Determines governance and security | Pending | Compliance / IT |
| DEC-P07 | Voice AI call handling rules | Needed for safe call automation | Pending | Support / Leadership |
| DEC-P08 | Support SLA targets | Needed for workflow design | Pending | Support |
| DEC-P09 | Knowledge governance ownership | Needed for KB maintenance | Pending | Leadership |
| DEC-P10 | Analytics KPI definitions | Needed for dashboards | Pending | Management |

---

## 11. Decision Dependency Matrix

| Decision | Depends On | Affects | Priority |
|---|---|---|---|
| DEC-001 AI Platform Focus | Research pack | All architecture and implementation | High |
| DEC-002 Research-First Strategy | Gap analysis | Project sequencing | High |
| DEC-004 Knowledge-Driven Support | FAQ/policy/product docs | RAG and support AI | Very High |
| DEC-101 API-First Architecture | Context and process docs | Backend, integrations | High |
| DEC-201 RAG for Knowledge Answers | Facts and docs | All AI assistants | Very High |
| DEC-301 CRM Integration Required | Business process mapping | Customer, distributor AI | Critical |
| DEC-302 ERP / Order System Integration Required | Operational process docs | Order, shipping, inventory AI | Critical |
| DEC-403 Data Privacy Controls | Policy and legal docs | All AI and data handling | Critical |
| DEC-P01 CRM vendor selection | Leadership decision | Architecture and integrations | Critical |

---

## 12. Decision Timeline

| Order | Decision ID | Date | Title | Status |
|---|---|---|---|---|
| 1 | DEC-001 | 2026-08 | AI Platform Focus | Confirmed |
| 2 | DEC-002 | 2026-08 | Research-First Strategy | Confirmed |
| 3 | DEC-003 | 2026-08 | Audience Segmentation | Confirmed |
| 4 | DEC-004 | 2026-08 | Knowledge-Driven Support | Confirmed |
| 5 | DEC-103 | 2026-08 | Markdown Documentation Standard | Confirmed |
| 6 | DEC-104 | 2026-08 | Numbered File Naming | Confirmed |
| 7 | DEC-201 | 2026-08 | Use RAG for Knowledge Answers | Confirmed |
| 8 | DEC-202 | 2026-08 | Separate AI Assistants by Function | Confirmed |
| 9 | DEC-203 | 2026-08 | Human Escalation for Sensitive Cases | Confirmed |
| 10 | DEC-301+ | TBD | Integration and infrastructure decisions | Pending |

---

## 13. Change History

| Version | Date | Updated By | Changes Made | Reason |
|---|---|---|---|---|
| 1.0 | 2026-08-04 | Perplexity | Initial decision register created | Establish traceable governance |
| 1.1 | TBD | TBD | Add new confirmed decisions | Ongoing project governance |

---

## 14. Review Schedule

| Item | Recommendation |
|---|---|
| Review frequency | Weekly during discovery; biweekly during architecture; monthly during implementation |
| Update trigger | Any approved decision, major assumption change, or new dependency |
| Approval workflow | Draft → reviewed by owner → approved by leadership |
| Storage | Keep this document in the documentation governance folder and mirror in the master context references |

---

## 15. Summary

**VERIFIED:** A structured decision register improves governance, traceability, AI consistency, onboarding, and long-term maintainability by keeping business, technical, AI, security, infrastructure, and documentation decisions visible and auditable. [00_MASTER_CONTEXT.md][04_DOCUMENT_MAP.md][05_RESEARCH_LOG.md]

**VERIFIED:** For the Dayjoy Enterprise AI Platform, this register is essential because many implementation-critical topics remain pending and must be decided before architecture and deployment. [03_UNKNOWN_INFORMATION.md][12_Research_Gap_Analysis.md]

---

**END OF DOCUMENT**