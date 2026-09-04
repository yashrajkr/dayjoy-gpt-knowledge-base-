# Project_Context/08_CONSTRAINTS.md

# Dayjoy Enterprise AI Platform — Constraints & Assumptions

> **Purpose:** Official reference for all limitations, assumptions, restrictions, compliance requirements, and design boundaries that must be respected throughout the project lifecycle.
>
> **Audience:** Architects, developers, AI engineers, security reviewers, operations, and future AI assistants.

---

## Table of Contents

1. [How to Use This Document](#1-how-to-use-this-document)
2. [Business Constraints](#2-business-constraints)
3. [Technical Constraints](#3-technical-constraints)
4. [AI Constraints](#4-ai-constraints)
5. [Knowledge Base Constraints](#5-knowledge-base-constraints)
6. [Security Constraints](#6-security-constraints)
7. [Privacy & Compliance Constraints](#7-privacy--compliance-constraints)
8. [Integration Constraints](#8-integration-constraints)
9. [Infrastructure Constraints](#9-infrastructure-constraints)
10. [Operational Constraints](#10-operational-constraints)
11. [Documentation Constraints](#11-documentation-constraints)
12. [Constraint Dependency Matrix](#12-constraint-dependency-matrix)
13. [Risk Assessment](#13-risk-assessment)
14. [Design Guidelines](#14-design-guidelines)
15. [Future Constraint Review](#15-future-constraint-review)

---

## 1. How to Use This Document

Each constraint entry follows a consistent template:

| Field | Purpose |
|---|---|
| Constraint ID | Unique identifier (e.g., BUS-001, SEC-003) |
| Constraint Name | Short, descriptive name |
| Category | Business, Technical, AI, Security, etc. |
| Description | What the constraint is |
| Reason | Why it exists |
| Business Impact | Effect on business operations |
| Technical Impact | Effect on architecture/implementation |
| Risk Level | Low / Medium / High / Critical |
| Related Components | Systems affected |
| Mitigation Strategy | How to handle it |
| Status | Confirmed / Assumed / Needs Validation |

**VERIFIED:** All business and policy constraints are based on 05_Policies.md, 04_Distributor_System.md, 06_FAQs.md, and related research. [05_Policies.md][04_Distributor_System.md][06_FAQs.md]

**ASSUMED / NEEDS VALIDATION:** Some technical, infrastructure, and integration constraints are based on common enterprise patterns and require client confirmation.

---

## 2. Business Constraints

| ID | Name | Category | Description | Reason | Business Impact | Technical Impact | Risk Level | Related Components | Mitigation Strategy | Status |
|---|---|---|---|---|---|---|---|---|---|---|---|
| BUS-001 | Business Scope: Dayjoy-Only | Business | Platform is exclusively for Dayjoy operations | Single-tenant enterprise design | Clear focus, no multi-tenant complexity | Architecture can be Dayjoy-specific | Low | All components | Keep single-tenant design | Confirmed |
| BUS-002 | No Multi-Tenant Support | Business | No other companies will use this platform | Business model is Dayjoy-only | No multi-tenant isolation required | Simplified access control and data model | Low | Authentication, RBAC | Do not build multi-tenant abstractions | Confirmed |
| BUS-003 | India-Focused Operations | Business | Primary market is India (policies, shipping, support) | Company location and policies designed for India | Shipping, support, payments must work for India | Timezone, currency, language considerations | Medium | Website, Payments, Support | Start with India-first, then expand | Confirmed |
| BUS-004 | Direct Selling Compensation Model | Business | Distributor compensation is defined by BV/PV and incentive slabs | Compensation plan is a core business rule | All commission features must follow this model | Requires accurate BV/PV tracking and calculations | High | Compensation engine, Distributor portal | Implement exact compensation logic; avoid simplifications | Confirmed |
| BUS-005 | 30-Day Cooling-Off Return Policy | Business | Customers can return within 30 days of billing | Required by company policy | Affects all return/refund workflows | Return eligibility logic must enforce this | High | Returns, Refunds, Order system | Implement 30-day check; no exceptions without approval | Confirmed |
| BUS-006 | 15 Business Days Refund TAT | Business | Refunds must be processed within 15 business days | Policy and legal expectation | Customer satisfaction and compliance | Payment gateway and finance workflows must support this | High | Payments, Finance, Refunds | Design refund SLA tracking and alerts | Confirmed |
| BUS-007 | ₹500 Minimum Payout Threshold | Business | Distributor payouts below ₹500 are clubbed with next cycle | Business rule for small payouts | Affects payout logic and distributor expectations | Payment logic must implement threshold and clubbing | High | Payouts, Distributor portal | Implement threshold logic; provide clear communication | Confirmed |
| BUS-008 | No Bulk Purchases by Distributors | Business | Bulk purchases are not allowed | Prevents abuse of distributor pricing | Order validation must reject bulk orders | Order system must detect and block bulk attempts | Medium | Order system, Distributor portal | Implement bulk detection rules | Confirmed |
| BUS-009 | Single PAN per Business Centre | Business | One PAN can only be used for one Business Centre | Prevents duplicate distributor accounts | KYC verification must enforce this | Requires PAN duplicate check | High | KYC, Distributor registration | Implement PAN uniqueness validation | Confirmed |
| BUS-010 | GST-Billed Stock Non-Returnable | Business | GST-billed stock cannot be returned | Tax and policy compliance | Return system must reject GST-billed stock returns | Requires tracking of GST-billed orders | High | Returns, Finance | Flag GST-billed orders; block returns | Confirmed |
| BUS-011 | No Sunday/Holiday Delivery | Business | No delivery operations on Sundays and holidays | Operational policy | Tracking and delivery estimates must exclude these days | Date calculations must account for holidays | Medium | Shipping, Delivery tracking | Implement holiday-aware delivery estimation | Confirmed |
| BUS-012 | Grievance Officer: Gaurav Sharma | Business | Specific person named for grievance redressal | Policy requirement | Complaint escalation must route to this person | Support workflow must include this escalation path | High | Complaint resolution, Support | Hard-code Grievance Officer contact; ensure 24-hr TAT | Confirmed |
| BUS-013 | Budget Limitations | Business | Project operates within startup budget constraints | Resource management | Feature prioritization must be pragmatic | Prefer cost-effective solutions; avoid over-engineering | Medium | All components | Prioritize MVP features; use managed services where cost-effective | Assumed |
| BUS-014 | Timeline: Phased Rollout | Business | Platform will be rolled out in phases | Risk management | Features must be prioritized into MVP, Phase 2, Phase 3 | Architecture must support incremental deployment | Medium | All components | Design for modular, phased releases | Assumed |
| BUS-015 | Resource Availability | Business | Limited team size initially | Startup constraints | Focus on high-impact features first | Avoid building low-priority features | Medium | All components | Focus on core AI features first | Assumed |

---

## 3. Technical Constraints

| ID | Name | Category | Description | Reason | Business Impact | Technical Impact | Risk Level | Related Components | Mitigation Strategy | Status |
|---|---|---|---|---|---|---|---|---|---|---|---|
| TEC-001 | Technology Stack Flexibility | Technical | No mandatory stack; choose based on requirements | Not specified by client | Freedom to choose best tools | Must document chosen stack | Medium | All components | Document stack decisions; maintain consistency | Assumed |
| TEC-002 | API-First Architecture | Technical | All services must expose APIs | Enables integration and AI tool calling | Faster integration | Requires well-designed API contracts | High | Backend, AI agents | Design RESTful APIs; document with OpenAPI | Assumed |
| TEC-003 | RAG-First AI Design | Technical | AI must use RAG for factual queries | Prevents hallucinations | Trustworthy AI responses | Requires vector database and knowledge indexing | High | Knowledge AI, All AI agents | Implement RAG pipeline; enforce retrieval before generation | Confirmed |
| TEC-004 | Performance Expectations | Technical | Sub-second response times for AI queries | User experience | Customer satisfaction | Requires efficient retrieval and caching | High | Website AI, WhatsApp AI, Voice AI | Implement caching, optimize embeddings | Assumed |
| TEC-005 | Scalability Requirements | Technical | Must handle growth in users and queries | Business growth | Platform must not degrade | Requires scalable infrastructure (auto-scaling, load balancing) | Medium | All components | Use cloud-native services; design for horizontal scaling | Assumed |
| TEC-006 | Browser Support: Modern Browsers | Technical | Support latest versions of Chrome, Firefox, Safari, Edge | Market coverage | Most users covered | No need for legacy browser support | Low | Website, Dashboard | Test on latest browsers only | Assumed |
| TEC-007 | Mobile Support: Mobile-First | Technical | Must work well on mobile devices | India market is mobile-heavy | Better UX for majority | Responsive design required | Medium | Website, Distributor portal | Design mobile-first; test on common devices | Assumed |
| TEC-008 | API Rate Limiting | Technical | APIs must enforce rate limits | Prevent abuse | Protects system stability | Requires rate limiting middleware | Medium | All APIs | Implement rate limiting; monitor usage | Assumed |
| TEC-009 | Error Handling Standards | Technical | All APIs must return consistent error formats | Debugging and client handling | Better developer experience | Requires standardized error schema | Low | All APIs | Define error response schema | Assumed |
| TEC-010 | Logging Requirements | Technical | All services must log actions | Audit and debugging | Compliance and troubleshooting | Requires logging infrastructure | Medium | All components | Implement structured logging (e.g., JSON) | Assumed |
| TEC-011 | Context Window Limitations | Technical | LLM context windows are finite | LLM limitation | Cannot load entire knowledge base per query | Requires intelligent chunking and retrieval | High | Knowledge AI, All AI agents | Implement smart chunking; use RAG efficiently | Confirmed |
| TEC-012 | Latency Requirements | Technical | AI responses must be fast (<2s for chat) | User experience | Customer satisfaction | Requires optimized retrieval and caching | High | Website AI, WhatsApp AI, Voice AI | Implement caching, optimize query pipeline | Assumed |

---

## 4. AI Constraints

| ID | Name | Category | Description | Reason | Business Impact | Technical Impact | Risk Level | Related Components | Mitigation Strategy | Status |
|---|---|---|---|---|---|---|---|---|---|---|---|
| AI-001 | No Hallucinations on Factual Queries | AI | AI must not make up facts | Trust and compliance | Legal and reputation risk | Requires RAG and strict grounding | Critical | All AI agents | Implement RAG; require citations; mark unknowns | Confirmed |
| AI-002 | Verified Information Only | AI | AI can only use verified/approved content | Business policy | Prevents misinformation | Requires knowledge governance | Critical | Knowledge AI, All AI agents | Implement VERIFIED/UNKNOWN labeling; enforce retrieval | Confirmed |
| AI-003 | Human Approval for Sensitive Topics | AI | Refunds, disputes, legal issues require human escalation | Policy and risk management | Prevents AI errors on critical issues | Requires escalation detection logic | High | All AI agents, Support | Implement escalation triggers; train AI to detect sensitive topics | Confirmed |
| AI-004 | Prompt Governance Required | AI | Prompts must be versioned and reviewed | Consistency and safety | Prevents prompt drift | Requires prompt management system | Medium | Admin AI, AI configuration | Implement prompt versioning; require review before deployment | Assumed |
| AI-005 | Memory Limitations | AI | Conversation memory is session-based and finite | LLM limitation | Cannot remember infinite history | Requires session management and summarization | Medium | All AI agents | Implement session memory; summarize long conversations | Assumed |
| AI-006 | Response Accuracy Requirements | AI | AI must be accurate on product, policy, and compensation | Business trust | Customer and distributor trust | Requires thorough testing and validation | High | All AI agents | Implement evaluation pipeline; test against known facts | Assumed |
| AI-007 | No Medical Claims Beyond Verified Data | AI | AI cannot make medical claims not in product data | Legal compliance | Prevents liability | Requires medical claim detection and blocking | Critical | All AI agents, Product Q&A | Implement medical claim guardrails; escalate to human | Confirmed |
| AI-008 | Escalation Required for Serious Health Issues | AI | Serious health conditions must be escalated to consultation | Policy requirement | Legal and safety | Requires detection of serious health queries | High | Voice AI, Website AI, WhatsApp AI | Implement health query classification; escalate appropriately | Confirmed |
| AI-009 | Tool/Function Calling Must Be Authorized | AI | AI can only call authorized tools/functions | Security and safety | Prevents unauthorized actions | Requires permission checks on tool calls | High | All AI agents, Tool layer | Implement RBAC for tool calls; log all invocations | Assumed |
| AI-010 | AI Behavior Must Follow AI_VISION.md | AI | All AI agents must follow documented behavior principles | Consistency | Trustworthy AI | Requires alignment with AI_VISION.md | Medium | All AI agents | Reference AI_VISION.md in all AI design | Confirmed |

---

## 5. Knowledge Base Constraints

| ID | Name | Category | Description | Reason | Business Impact | Technical Impact | Risk Level | Related Components | Mitigation Strategy | Status |
|---|---|---|---|---|---|---|---|---|---|---|---|
| KB-001 | Verified Information Only | KB | Only verified content can be published | Prevents misinformation | Trust and compliance | Requires verification workflow | Critical | Knowledge AI, All AI agents | Implement VERIFIED/UNKNOWN labeling; require approval | Confirmed |
| KB-002 | Version Control Required | KB | All knowledge documents must be versioned | Track changes and rollback | Auditability | Requires version control system | High | Knowledge base | Use Git or similar for version control | Assumed |
| KB-003 | Metadata Standards Required | KB | All documents must have metadata (source, date, owner) | Retrieval quality and governance | Better searchability | Requires metadata schema | Medium | Knowledge base | Define metadata schema; enforce on upload | Assumed |
| KB-004 | Document Ownership Required | KB | Every document must have an owner | Accountability | Clear responsibility | Requires owner tracking | Medium | Knowledge base | Track document owner in metadata | Assumed |
| KB-005 | Update Workflow Required | KB | Changes must follow review and approval | Quality control | Prevents errors | Requires approval workflow | Medium | Knowledge base | Implement review workflow before publishing | Assumed |
| KB-006 | Retrieval Quality Standards | KB | RAG retrieval must be accurate and relevant | AI accuracy | Trustworthy AI | Requires good chunking and indexing | High | Knowledge AI | Implement semantic chunking; test retrieval quality | Assumed |
| KB-007 | No Conflicting Information | KB | Knowledge base must not contain conflicting facts | Consistency | Prevents confusion and errors | Requires conflict detection | High | Knowledge base | Implement conflict detection; flag for resolution | Assumed |
| KB-008 | Regular Review Cycle | KB | Knowledge must be reviewed periodically | Freshness | Prevents outdated information | Requires review scheduling | Medium | Knowledge base | Implement review reminders; track last review date | Assumed |

---

## 6. Security Constraints

| ID | Name | Category | Description | Reason | Business Impact | Technical Impact | Risk Level | Related Components | Mitigation Strategy | Status |
|---|---|---|---|---|---|---|---|---|---|---|---|
| SEC-001 | Authentication Required | Security | All users must authenticate | Access control | Prevents unauthorized access | Requires authentication system | Critical | All components | Implement secure authentication (e.g., OAuth2, JWT) | Assumed |
| SEC-002 | Role-Based Access Control (RBAC) | Security | Access must be role-based | Least privilege | Prevents data leakage | Requires RBAC system | Critical | All components | Implement RBAC; enforce on all endpoints | Assumed |
| SEC-003 | Data Encryption in Transit and at Rest | Security | All data must be encrypted | Data protection | Compliance and security | Requires TLS and storage encryption | Critical | All components | Enable TLS; use encrypted storage | Assumed |
| SEC-004 | Secret Management Required | Security | Secrets (API keys, passwords) must be managed securely | Prevents credential leakage | Security | Requires secret management system | High | All components | Use environment variables or secret manager (e.g., AWS Secrets Manager) | Assumed |
| SEC-005 | Audit Logging Required | Security | All actions must be logged | Compliance and debugging | Audit trail | Requires logging infrastructure | High | All components | Implement structured logging; log all critical actions | Assumed |
| SEC-006 | API Security Required | Security | APIs must be secured (authentication, authorization, rate limiting) | Prevents abuse | Security | Requires API gateway and security middleware | High | All APIs | Implement API gateway; enforce auth and rate limiting | Assumed |
| SEC-007 | Access Control on Tool/Function Calls | Security | AI tool calls must respect RBAC | Prevents unauthorized actions | Security | Requires permission checks on tool layer | High | AI agents, Tool layer | Implement RBAC for tool calls; log all invocations | Assumed |
| SEC-008 | Input Validation Required | Security | All inputs must be validated | Prevents injection attacks | Security | Requires input validation on all endpoints | Medium | All APIs | Implement input validation; use parameterized queries | Assumed |
| SEC-009 | No Hardcoded Credentials | Security | Credentials must not be hardcoded in code | Security | Prevents credential leakage | Requires configuration management | High | All components | Use environment variables or config files (not in code) | Assumed |
| SEC-010 | Regular Security Audits | Security | Security must be audited periodically | Risk management | Prevents vulnerabilities | Requires security review process | Medium | All components | Schedule regular security audits | Assumed |

---

## 7. Privacy & Compliance Constraints

| ID | Name | Category | Description | Reason | Business Impact | Technical Impact | Risk Level | Related Components | Mitigation Strategy | Status |
|---|---|---|---|---|---|---|---|---|---|---|---|
| PRI-001 | Customer Data Protection | Privacy | Customer personal data must be protected | Privacy and trust | Legal compliance | Requires data protection measures | Critical | All components | Implement data encryption; minimize data collection | Assumed |
| PRI-002 | Distributor Information Protection | Privacy | Distributor data must be protected | Privacy and trust | Legal compliance | Requires access control on distributor data | High | Distributor portal, Admin | Implement RBAC; encrypt distributor data | Assumed |
| PRI-003 | Consent Requirements | Privacy | User consent required for data collection | Legal compliance | User trust | Requires consent management | High | Website, WhatsApp, All user-facing | Implement consent collection; document consent | Assumed |
| PRI-004 | Data Retention Policy | Privacy | Data must be retained only as long as needed | Legal compliance | Storage management | Requires retention policy and deletion | Medium | All components | Define data retention policy; implement automated deletion | Assumed |
| PRI-005 | Compliance Obligations | Privacy | Platform must comply with applicable laws | Legal requirement | Business continuity | Requires compliance review | High | All components | Consult legal counsel; document compliance | Assumed |
| PRI-006 | Internal Policy Alignment | Privacy | Platform must align with internal policies | Business governance | Consistency | Requires policy review | Medium | All components | Review internal policies; ensure alignment | Assumed |
| PRI-007 | No Storage of Sensitive Payment Data | Privacy | Payment data (e.g., full card numbers) must not be stored | PCI-DSS compliance | Legal requirement | Requires payment gateway integration (no storage) | Critical | Payments | Use payment gateway; do not store card data | Assumed |
| PRI-008 | Data Minimization | Privacy | Only collect necessary data | Privacy best practice | Reduces risk | Requires careful data design | Medium | All components | Minimize data collection; document what is collected | Assumed |

---

## 8. Integration Constraints

| ID | Name | Category | Description | Reason | Business Impact | Technical Impact | Risk Level | Related Components | Mitigation Strategy | Status |
|---|---|---|---|---|---|---|---|---|---|---|---|
| INT-001 | Vapi Integration for Voice AI | Integration | Voice AI uses Vapi platform | Chosen technology | Voice capabilities | Requires Vapi API integration | High | Voice AI | Follow Vapi documentation; test thoroughly | Assumed |
| INT-002 | WhatsApp Business API | Integration | WhatsApp AI uses WhatsApp Business API | Chosen channel | WhatsApp support | Requires WhatsApp Business API integration | High | WhatsApp AI | Follow Meta documentation; comply with policies | Assumed |
| INT-003 | Payment Gateway Integration | Integration | Payments via payment gateway | Business requirement | Payment processing | Requires payment gateway integration | Critical | Payments | Choose gateway (e.g., Razorpay); follow integration guide | Assumed |
| INT-004 | Email Provider Integration | Integration | Email notifications via email provider | Business requirement | Email support | Requires email provider integration | Medium | Notifications | Choose provider (e.g., SendGrid, AWS SES); integrate | Assumed |
| INT-005 | CRM Integration (Future) | Integration | CRM may be integrated for lead management | Business growth | Better sales tracking | Requires CRM API integration | Medium | Sales AI, CRM | Design for future CRM integration; document requirements | Future |
| INT-006 | ERP Integration (Future) | Integration | ERP may be integrated for order/inventory | Business growth | Better operations | Requires ERP API integration | High | Orders, Inventory | Design for future ERP integration; document requirements | Future |
| INT-007 | Calendar Integration (Future) | Integration | Calendar may be integrated for scheduling | Business requirement | Appointment booking | Requires calendar API integration | Medium | Scheduling | Design for future calendar integration | Future |
| INT-008 | n8n Integration for Automation | Integration | n8n may be used for workflow automation | Chosen technology | Automation capabilities | Requires n8n integration | Medium | Automation | Follow n8n documentation; design workflows | Assumed |
| INT-009 | Webhooks for Event Notifications | Integration | Webhooks for event notifications | Real-time updates | Better integration | Requires webhook implementation | Medium | All integrations | Implement webhook support; document events | Assumed |
| INT-010 | Third-Party API Limitations | Integration | Third-party APIs have rate limits and restrictions | API provider policies | May limit functionality | Requires handling rate limits and errors | Medium | All integrations | Implement rate limiting; handle errors gracefully | Assumed |
| INT-011 | Dependency on Third-Party Services | Integration | Platform depends on third-party services (Vapi, WhatsApp, payment gateway) | Chosen technologies | Service outages affect platform | Requires fallback and monitoring | High | All integrations | Implement monitoring; design fallbacks | Assumed |

---

## 9. Infrastructure Constraints

| ID | Name | Category | Description | Reason | Business Impact | Technical Impact | Risk Level | Related Components | Mitigation Strategy | Status |
|---|---|---|---|---|---|---|---|---|---|---|---|
| INF-001 | Cloud Hosting | Infrastructure | Platform hosted on cloud | Scalability and reliability | Business continuity | Requires cloud infrastructure setup | Medium | All components | Use cloud provider (e.g., AWS, Azure); design for cloud-native | Assumed |
| INF-002 | Database Choice | Infrastructure | Database to be chosen based on requirements | Not specified | Flexibility | Requires database selection and setup | Medium | Backend | Choose database (e.g., PostgreSQL, Supabase); document decision | Assumed |
| INF-003 | Storage Requirements | Infrastructure | Storage for documents, media, logs | Business requirement | Data management | Requires storage solution | Medium | Knowledge base, Logging | Use cloud storage (e.g., S3); implement lifecycle policies | Assumed |
| INF-004 | Backup Requirements | Infrastructure | Regular backups required | Data protection | Disaster recovery | Requires backup strategy | High | All components | Implement automated backups; test restoration | Assumed |
| INF-005 | Disaster Recovery | Infrastructure | Disaster recovery plan required | Business continuity | Minimizes downtime | Requires DR planning | High | All components | Document DR plan; test periodically | Assumed |
| INF-006 | Monitoring Required | Infrastructure | System monitoring required | Operational visibility | Proactive issue detection | Requires monitoring tools | Medium | All components | Implement monitoring (e.g., Prometheus, Grafana); set up alerts | Assumed |
| INF-007 | Load Balancing | Infrastructure | Load balancing for high availability | Scalability | Prevents single point of failure | Requires load balancer | Medium | All components | Use cloud load balancer; configure health checks | Assumed |
| INF-008 | Auto-Scaling | Infrastructure | Auto-scaling for demand spikes | Scalability | Handles traffic spikes | Requires auto-scaling configuration | Medium | All components | Configure auto-scaling; set appropriate thresholds | Assumed |
| INF-009 | CDN for Static Assets | Infrastructure | CDN for website assets | Performance | Faster load times | Requires CDN setup | Low | Website | Use CDN (e.g., Cloudflare); configure caching | Assumed |
| INF-010 | Environment Separation | Infrastructure | Separate environments (dev, staging, prod) | Best practice | Prevents production issues | Requires environment management | Medium | All components | Set up separate environments; enforce deployment process | Assumed |

---

## 10. Operational Constraints

| ID | Name | Category | Description | Reason | Business Impact | Technical Impact | Risk Level | Related Components | Mitigation Strategy | Status |
|---|---|---|---|---|---|---|---|---|---|---|---|
| OPS-001 | Business Hours: Standard Indian Business Hours | Operational | Support and operations follow standard business hours | Company policy | Customer expectations | Requires clear communication of hours | Medium | Support, Operations | Document business hours; set up after-hours handling | Confirmed |
| OPS-002 | Human Escalation Required for Certain Issues | Operational | Some issues require human escalation | Policy and complexity | Customer satisfaction | Requires escalation workflow | High | Support, AI agents | Implement escalation triggers; train support team | Confirmed |
| OPS-003 | Manual Approvals Required for Exceptions | Operational | Policy exceptions require manual approval | Governance | Prevents unauthorized exceptions | Requires approval workflow | High | Returns, Refunds, Admin | Implement approval workflow; document approvers | Assumed |
| OPS-004 | Support Availability: Multi-Channel | Operational | Support available via phone, WhatsApp, email | Business policy | Customer satisfaction | Requires multi-channel support setup | Medium | Support, AI agents | Implement multi-channel support; ensure coverage | Confirmed |
| OPS-005 | Knowledge Update Process | Operational | Knowledge updates follow review process | Quality control | Accurate information | Requires update workflow | Medium | Knowledge base | Document update process; implement workflow | Assumed |
| OPS-006 | Training Required for Support Team | Operational | Support team must be trained on platform and policies | Quality support | Customer satisfaction | Requires training program | Medium | Support | Develop training program; conduct regular training | Assumed |
| OPS-007 | Incident Response Process | Operational | Incident response process required | Business continuity | Minimizes downtime | Requires incident response plan | High | All components | Document incident response; test periodically | Assumed |
| OPS-008 | Change Management Process | Operational | Changes must follow change management | Stability | Prevents production issues | Requires change management workflow | Medium | All components | Implement change management; document process | Assumed |

---

## 11. Documentation Constraints

| ID | Name | Category | Description | Reason | Business Impact | Technical Impact | Risk Level | Related Components | Mitigation Strategy | Status |
|---|---|---|---|---|---|---|---|---|---|---|---|
| DOC-001 | Naming Conventions | Documentation | Consistent naming conventions required | Maintainability | Easier navigation | Requires naming standards | Low | All components | Define naming conventions; enforce in code reviews | Assumed |
| DOC-002 | Folder Structure | Documentation | Consistent folder structure required | Maintainability | Easier navigation | Requires folder structure standards | Low | All components | Define folder structure; document in project | Assumed |
| DOC-003 | Versioning Required | Documentation | Documents must be versioned | Track changes | Auditability | Requires version control | Medium | All documents | Use Git for version control; tag releases | Assumed |
| DOC-004 | Documentation Quality Standards | Documentation | Documentation must be clear and complete | Maintainability | Easier onboarding | Requires documentation review | Medium | All documents | Review documentation; ensure clarity | Assumed |
| DOC-005 | Change Management for Documentation | Documentation | Documentation changes must be tracked | Auditability | Track updates | Requires change tracking | Low | All documents | Use Git for change tracking; require commit messages | Assumed |
| DOC-006 | Markdown Format | Documentation | All documentation in Markdown | Consistency | Easier maintenance | Requires Markdown authoring | Low | All documents | Use Markdown for all documentation | Confirmed |
| DOC-007 | Cross-Referencing | Documentation | Documents must cross-reference related docs | Maintainability | Easier navigation | Requires linking between docs | Low | All documents | Use relative links; maintain document map | Assumed |
| DOC-008 | Document Ownership | Documentation | Every document must have an owner | Accountability | Clear responsibility | Requires owner tracking | Low | All documents | Track document owner in metadata | Assumed |

---

## 12. Constraint Dependency Matrix

| Constraint | Affects | Related Module | Risk | Priority |
|---|---|---|---|---|
| BUS-005 (30-Day Return Policy) | Returns, Refunds, Order system | CP-09, CP-10 | High | High |
| BUS-006 (15 Business Days Refund TAT) | Payments, Finance, Refunds | CP-10 | High | High |
| BUS-007 (₹500 Minimum Payout) | Payouts, Distributor portal | DP-07 | High | High |
| BUS-009 (Single PAN per Business Centre) | KYC, Distributor registration | DP-01, DP-02 | High | High |
| BUS-010 (GST-Billed Stock Non-Returnable) | Returns, Finance | CP-09 | High | High |
| AI-001 (No Hallucinations) | All AI agents | AI-01 to AI-09 | Critical | Critical |
| AI-002 (Verified Information Only) | Knowledge AI, All AI agents | KB-001, AI-01 to AI-09 | Critical | Critical |
| AI-007 (No Medical Claims) | Product Q&A, All AI agents | CP-02, AI-01 to AI-09 | Critical | Critical |
| SEC-001 (Authentication Required) | All components | All modules | Critical | Critical |
| SEC-002 (RBAC) | All components | All modules | Critical | Critical |
| SEC-003 (Data Encryption) | All components | All modules | Critical | Critical |
| PRI-001 (Customer Data Protection) | All components | All user-facing modules | Critical | Critical |
| PRI-007 (No Storage of Sensitive Payment Data) | Payments | Payment processing | Critical | Critical |
| INT-001 (Vapi Integration) | Voice AI | AI-01 | High | High |
| INT-002 (WhatsApp Business API) | WhatsApp AI | AI-02 | High | High |
| INT-003 (Payment Gateway) | Payments | CP-05 | Critical | Critical |
| KB-001 (Verified Information Only) | Knowledge AI, All AI agents | Knowledge base | Critical | Critical |
| INF-004 (Backup Requirements) | All components | Infrastructure | High | High |
| OPS-002 (Human Escalation) | Support, AI agents | AI-07, CP-11 | High | High |

---

## 13. Risk Assessment

### High-Risk Constraints

| Constraint | What Could Go Wrong | Business Consequences | Technical Consequences | Recommended Mitigation |
|---|---|---|---|---|
| AI-001 (No Hallucinations) | AI provides incorrect product/policy info | Legal liability, customer harm, reputation damage | Loss of trust, increased support load | Implement RAG; require citations; mark unknowns; human escalation for sensitive topics |
| AI-007 (No Medical Claims) | AI makes unauthorized medical claims | Legal liability, regulatory issues | Platform shutdown risk | Implement medical claim detection; escalate to human; strict guardrails |
| SEC-001/SEC-002 (Authentication/RBAC) | Unauthorized access to data | Data breach, legal issues | System compromise | Implement strong auth; enforce RBAC; audit logs |
| PRI-007 (No Storage of Payment Data) | Payment data stored improperly | PCI-DSS violation, fines | Legal and financial penalties | Use payment gateway; never store card data |
| BUS-006 (15 Business Days Refund TAT) | Refunds not processed within SLA | Customer dissatisfaction, legal issues | Increased support load | Implement refund SLA tracking; alerts; automate where possible |
| BUS-009 (Single PAN per Business Centre) | Duplicate PANs allowed | Fraud, compensation errors | Financial loss | Implement PAN uniqueness validation; check against existing records |
| INT-011 (Third-Party Service Dependency) | Third-party service outage | Platform downtime | Service unavailability | Implement monitoring; design fallbacks; document dependencies |
| INF-004 (Backup Requirements) | No backups or failed restoration | Data loss | Business continuity risk | Implement automated backups; test restoration regularly |
| OPS-002 (Human Escalation) | Sensitive issues not escalated | Customer harm, legal issues | Reputation damage | Implement escalation triggers; train support team; monitor escalation rate |

---

## 14. Design Guidelines

Based on the documented constraints, here are engineering guidelines for developers and AI assistants:

### 14.1 General Design Principles

1. **Single-Tenant Design:** Do not build multi-tenant abstractions; the platform is Dayjoy-only. [BUS-001][BUS-002]
2. **India-First:** Design for India market first (timezone, currency, language, shipping policies). [BUS-003]
3. **API-First:** All services must expose well-documented RESTful APIs. [TEC-002]
4. **RAG-First AI:** All factual AI queries must use RAG; never generate facts without retrieval. [TEC-003][AI-001][AI-002]
5. **Mobile-First:** Design for mobile devices; majority of users will access via mobile. [TEC-007]
6. **Security by Design:** Implement authentication, RBAC, encryption, and audit logging from day one. [SEC-001][SEC-002][SEC-003]
7. **Privacy by Design:** Minimize data collection; implement consent management; do not store sensitive payment data. [PRI-001][PRI-003][PRI-007]
8. **Knowledge Governance:** Only verified content in knowledge base; implement VERIFIED/UNKNOWN labeling. [KB-001][KB-002]
9. **Escalation for Sensitive Topics:** Implement escalation triggers for refunds, disputes, legal issues, and serious health conditions. [AI-003][AI-007][AI-008][OPS-002]
10. **Phased Rollout:** Design for MVP, Phase 2, Phase 3; prioritize high-impact features first. [BUS-014]

### 14.2 AI Design Guidelines

1. **No Hallucinations:** AI must not make up facts; use RAG for all factual queries. [AI-001][AI-002]
2. **Verified Information Only:** Only use verified/approved content; mark unknowns clearly. [AI-002][KB-001]
3. **Human Approval for Sensitive Topics:** Escalate refunds, disputes, legal issues, and serious health conditions to human. [AI-003][AI-007][AI-008]
4. **Prompt Governance:** Version prompts; require review before deployment. [AI-004]
5. **Tool/Function Authorization:** AI can only call authorized tools/functions; enforce RBAC on tool layer. [AI-009][SEC-007]
6. **Follow AI_VISION.md:** All AI agents must follow documented behavior principles. [AI-010]

### 14.3 Security Design Guidelines

1. **Authentication Required:** All users must authenticate; use secure methods (OAuth2, JWT). [SEC-001]
2. **RBAC Enforcement:** Enforce role-based access control on all endpoints. [SEC-002]
3. **Data Encryption:** Encrypt data in transit (TLS) and at rest. [SEC-003]
4. **Secret Management:** Use environment variables or secret manager; never hardcode credentials. [SEC-004][SEC-009]
5. **Audit Logging:** Log all critical actions; use structured logging. [SEC-005]
6. **API Security:** Implement API gateway; enforce auth, authorization, and rate limiting. [SEC-006]
7. **Input Validation:** Validate all inputs; use parameterized queries. [SEC-008]

### 14.4 Integration Design Guidelines

1. **Third-Party API Handling:** Handle rate limits and errors gracefully; implement retry logic. [INT-010]
2. **Dependency Monitoring:** Monitor third-party service health; design fallbacks. [INT-011]
3. **Webhooks:** Implement webhook support for event notifications. [INT-009]
4. **Future Integration Design:** Design for future CRM, ERP, calendar integration; document requirements. [INT-005][INT-006][INT-007]

### 14.5 Infrastructure Design Guidelines

1. **Cloud-Native:** Use cloud services; design for horizontal scaling. [INF-001][TEC-005]
2. **Backup and DR:** Implement automated backups; document disaster recovery plan. [INF-004][INF-005]
3. **Monitoring:** Implement monitoring and alerting; set up dashboards. [INF-006]
4. **Environment Separation:** Use separate environments (dev, staging, prod); enforce deployment process. [INF-010]

### 14.6 Documentation Guidelines

1. **Markdown Format:** Use Markdown for all documentation. [DOC-006]
2. **Cross-Referencing:** Link related documents; maintain document map. [DOC-007]
3. **Version Control:** Use Git for version control; tag releases. [DOC-003]
4. **Document Ownership:** Track document owner in metadata. [DOC-008]

---

## 15. Future Constraint Review

### Permanent Constraints (Unlikely to Change)

| Constraint | Reason |
|---|---|
| BUS-001 (Business Scope: Dayjoy-Only) | Core business model |
| BUS-004 (Direct Selling Compensation Model) | Core business rule |
| AI-001 (No Hallucinations) | Trust and safety requirement |
| AI-002 (Verified Information Only) | Trust and compliance |
| SEC-001/SEC-002/SEC-003 (Authentication/RBAC/Encryption) | Security best practices |
| PRI-001 (Customer Data Protection) | Legal requirement |
| PRI-007 (No Storage of Sensitive Payment Data) | PCI-DSS compliance |
| KB-001 (Verified Information Only) | Trust and quality |

### Temporary Constraints (May Change as Platform Grows)

| Constraint | Potential Change | When |
|---|---|---|
| BUS-003 (India-Focused Operations) | May expand to international markets | Future expansion |
| BUS-013 (Budget Limitations) | May increase with funding | As business grows |
| BUS-015 (Resource Availability) | Team may expand | As business grows |
| TEC-001 (Technology Stack Flexibility) | Stack may be standardized | As platform matures |
| INT-005/INT-006/INT-007 (Future CRM/ERP/Calendar Integration) | May become required | As business needs evolve |
| INF-002 (Database Choice) | Database may be standardized | As platform matures |

### Future Review Required

| Constraint | Review Trigger | Notes |
|---|---|---|
| BUS-014 (Timeline: Phased Rollout) | MVP completion | Re-evaluate priorities |
| AI-006 (Response Accuracy Requirements) | After initial deployment | Refine based on real-world performance |
| TEC-004 (Performance Expectations) | After load testing | Adjust based on actual performance |
| TEC-005 (Scalability Requirements) | After user growth | Adjust based on actual usage |
| INT-010 (Third-Party API Limitations) | After integration | Adjust based on actual API behavior |
| INF-006 (Monitoring Required) | After initial deployment | Refine based on operational needs |

---

## Related Documents

- `00_MASTER_CONTEXT.md`
- `02_KNOWN_FACTS.md`
- `03_UNKNOWN_INFORMATION.md`
- `06_DECISIONS.md`
- `03_Product_Research.md`
- `04_Distributor_System.md`
- `05_Policies.md`
- `06_FAQs.md`
- `07_Customer_Journey.md`
- `08_Business_Processes.md`
- `10_Pain_Points.md`
- `11_AI_Opportunities.md`
- `Project_Context/04_AI_VISION.md`
- `Project_Context/05_PERSONAS.md`
- `Project_Context/06_FEATURE_WISHLIST.md`
- `Project_Context/07_BUSINESS_PROCESSES.md`

---

**END OF DOCUMENT**