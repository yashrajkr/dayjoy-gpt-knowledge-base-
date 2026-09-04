# 00_MASTER_CONTEXT.md

# Dayjoy Enterprise AI Platform — Master Context

> **Status:** VERIFIED / PARTIALLY VERIFIED / UNKNOWN / REQUIRES CLIENT INPUT  
> **Purpose:** Single authoritative context document for the Dayjoy Enterprise AI Platform.  
> **Audience:** Developers, architects, project managers, analysts, and AI coding assistants.  
> **Instruction:** Any AI working on this project should read this document first.

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Company Overview](#2-company-overview)
3. [Problem Statement](#3-problem-statement)
4. [Project Goals](#4-project-goals)
5. [Project Scope](#5-project-scope)
6. [AI Platform Overview](#6-ai-platform-overview)
7. [Major User Groups](#7-major-user-groups)
8. [Business Capabilities](#8-business-capabilities)
9. [High-Level System Modules](#9-high-level-system-modules)
10. [Technology Vision](#10-technology-vision)
11. [Current Project Status](#11-current-project-status)
12. [Key Decisions Made](#12-key-decisions-made)
13. [Known Constraints](#13-known-constraints)
14. [Risks](#14-risks)
15. [Success Criteria](#15-success-criteria)
16. [Current Folder & Document Structure](#16-current-folder--document-structure)
17. [Document Reference Map](#17-document-reference-map)
18. [Glossary](#18-glossary)
19. [Open Questions](#19-open-questions)
20. [Immediate Next Steps](#20-immediate-next-steps)
21. [Master AI Instructions](#21-master-ai-instructions)

---

## 1. Project Overview

**VERIFIED:** The project is the **Dayjoy Enterprise AI Platform**, a production-oriented AI system designed to support Voice AI, WhatsApp AI, Website AI, Internal AI, CRM/workflow automation, analytics, and a RAG knowledge base for Dayjoy Marketing Pvt. Ltd. [file:01_Company_Research][file:11_AI_Opportunities][file:12_Research_Gap_Analysis]

**VERIFIED:** The platform is intended to support Dayjoy’s wellness direct selling business, including customers, distributors, employees, support operations, and management decision-making. [file:02_Business_Model][file:04_Distributor_System][file:07_Customer_Journey][file:08_Business_Processes]

**VERIFIED:** The long-term mission is to make Dayjoy’s knowledge, processes, support, and operational workflows AI-assisted, scalable, compliant, and consistent across channels. [file:05_Policies][file:06_FAQs][file:11_AI_Opportunities]

**Current Project Status:**
- Research completed across company, business model, products, distributor system, policies, FAQs, journeys, processes, competitor landscape, pain points, AI opportunities, and research gaps. [file:01_Company_Research–file:12_Research_Gap_Analysis]
- Architecture and implementation planning are the next major phase. [file:12_Research_Gap_Analysis]

**Expected Business Outcomes:**
- Faster customer response and resolution.  
- Better distributor onboarding and support.  
- Lower support cost through automation.  
- More consistent answers across channels.  
- Better management visibility and decision-making. [file:10_Pain_Points][file:11_AI_Opportunities]

---

## 2. Company Overview

**VERIFIED:** Dayjoy Marketing Private Limited is an Indian private limited company incorporated in 2018 with its registered office in Kota, Rajasthan. [file:01_Company_Research][web:5][web:12][web:7]

**VERIFIED:** Dayjoy operates as a direct selling wellness brand with product categories that include Health Care, Personal Care, Agriculture & Veterinary, Home Care, Food Products, Skin Care, and more. [file:02_Business_Model][file:03_Product_Research][web:16][web:59]

**VERIFIED:** The distributor model allows free registration for independent distributors, subject to KYC and policy compliance. [file:04_Distributor_System][web:69]

**VERIFIED:** Dayjoy’s target audience includes customers seeking wellness products, distributor prospects seeking income opportunities, and current distributors needing business support. [file:02_Business_Model][file:07_Customer_Journey][file:04_Distributor_System]

**PARTIALLY VERIFIED:** Geographic scope includes India with public state registrations and some Nepal references in public web material, but the core project focus is Dayjoy India. [file:01_Company_Research][web:68][web:146]

**Core Value Proposition:**  
Dayjoy combines wellness products, direct selling opportunity, training, and customer support into a distributor-led commerce model. [file:02_Business_Model][file:04_Distributor_System][file:05_Policies]

---

## 3. Problem Statement

**VERIFIED:** Research identified significant pain points across customers, distributors, support teams, operations, management, technology, and knowledge management. [file:10_Pain_Points]

**Key Issues:**
- Customers need better product discovery, clearer product explanations, faster support, and clearer shipping/return/refund guidance. [file:06_FAQs][file:05_Policies][file:10_Pain_Points]
- Distributors need simpler compensation explanations, onboarding support, product knowledge, and business coaching. [file:04_Distributor_System][file:10_Pain_Points]
- Employees need faster access to policies, processes, and product information. [file:06_FAQs][file:08_Business_Processes]
- Management needs visibility into KPIs, operations, and system performance. [file:10_Pain_Points][file:11_AI_Opportunities]

**Why the AI platform is being built:** To reduce friction, standardize knowledge, automate repetitive workflows, and provide a scalable enterprise-grade support and growth system. [file:10_Pain_Points][file:11_AI_Opportunities]

---

## 4. Project Goals

### Business Goals
- Increase customer conversion and repeat purchase.
- Reduce support cost.
- Improve distributor productivity and retention.
- Improve management decision-making.

### Customer Goals
- Faster answers.
- Easier product discovery.
- Clear order and shipping status.
- Easier returns/refunds support.

### Distributor Goals
- Faster onboarding.
- Easier compensation understanding.
- Better training and product knowledge.
- Better support for sales and customer management.

### Employee Goals
- Faster policy lookup.
- Consistent answers.
- Reduced manual work.

### Technical Goals
- Build modular AI services.
- Use RAG for knowledge accuracy.
- Integrate with CRM/ERP/APIs where needed.
- Design for scale and maintainability.

### AI Goals
- Deploy Voice AI, WhatsApp AI, Website AI, Internal AI, Distributor AI, Sales AI, Marketing AI, Admin AI, and Analytics AI.

### Long-Term Strategic Goals
- Make Dayjoy AI-first in customer experience and distributor experience.
- Create a reusable enterprise AI platform.
- Build a data-driven operating model.

---

## 5. Project Scope

### In Scope
- Research documentation pack.
- Master context and knowledge base design.
- AI strategy and opportunity mapping.
- Customer journey and process mapping.
- Future implementation planning.

### Out of Scope
- Final production code.
- Live CRM/ERP integration implementation until systems are confirmed.
- Public-facing launch of AI agents before prototype validation.

### Future Scope
- Multi-language AI.
- Advanced analytics and forecasting.
- Voice biometrics.
- Vision-based product/document verification.
- Autonomous workflow orchestration.

---

## 6. AI Platform Overview

**VERIFIED:** The platform is intended to combine knowledge, conversational AI, and workflow automation to support Dayjoy across customer, distributor, employee, sales, marketing, operations, and management use cases. [file:11_AI_Opportunities]

### Planned AI Capabilities
- **Voice AI:** Handles phone-based FAQs, support, and basic guidance.
- **WhatsApp AI:** Handles chat-based support, order help, and quick answers.
- **Website AI:** Handles self-service FAQs, product discovery, and policy guidance.
- **Distributor AI:** Helps distributors onboard, understand commissions, sell products, and train.
- **Employee AI:** Helps staff find policies, product data, and process guidance.
- **Sales AI:** Supports lead qualification, follow-up, and recommendations.
- **Marketing AI:** Supports content creation, campaigns, and distributor marketing enablement.
- **Admin AI:** Supports internal admin tasks and reporting.
- **Analytics AI:** Summarizes KPIs, trends, and management insights.
- **Knowledge Base (RAG):** Central trusted knowledge source for all AI assistants.

---

## 7. Major User Groups

| Persona | Primary Goals | Common Tasks | AI Interactions |
|---|---|---|---|
| Customer | Buy the right product, get support | Product research, ordering, returns, support | Website AI, WhatsApp AI, Voice AI |
| Prospect | Understand brand and trust | Verify company, compare products, ask FAQs | Website AI, Voice AI |
| Distributor | Sell products and build business | Onboarding, training, commission, customer support | Distributor AI, Sales AI |
| Employee | Support operations | Find policy/process answers, handle cases | Internal AI |
| Customer Support | Resolve issues | Tickets, escalation, FAQ answers | Support AI, RAG assistant |
| Sales | Convert leads | Follow-up, recommendation, qualification | Sales AI |
| Marketing | Launch campaigns | Create content, track performance | Marketing AI |
| Management | Monitor business | Dashboards, reports, decisions | Analytics AI, Admin AI |
| Administrator | Manage systems | Governance, access, maintenance | Admin AI |

---

## 8. Business Capabilities

**VERIFIED:**
- Product discovery and education. [file:03_Product_Research][file:06_FAQs]
- Distributor onboarding and support. [file:04_Distributor_System]
- Order assistance and shipping updates. [file:05_Policies][file:08_Business_Processes]
- Customer support and complaint handling. [file:05_Policies][file:08_Business_Processes]
- Policy guidance and compliance-aware answers. [file:05_Policies][file:04_Distributor_System]
- Sales enablement and follow-up support. [file:10_Pain_Points][file:11_AI_Opportunities]
- Marketing support and content generation. [file:11_AI_Opportunities]
- Reporting and analytics. [file:10_Pain_Points][file:11_AI_Opportunities]

---

## 9. High-Level System Modules

| Module | Purpose | Status |
|---|---|---|
| Knowledge Base | Single source of truth for AI answers | Planned |
| AI Gateway | Routes requests to agents/tools | Planned |
| Conversation Engine | Handles dialogue state, intents, context | Planned |
| API Layer | Connects AI to internal/external systems | Planned |
| CRM Integration | Customer/distributor records and activity | Needs Client Input |
| Workflow Automation | Automates approvals and routine steps | Planned |
| Authentication | Secure user and role access | Needs Client Input |
| Analytics | KPI dashboards and insights | Planned |
| Administration | Content governance and access control | Planned |

---

## 10. Technology Vision

### Confirmed / Strongly Supported
- Web-based Dayjoy presence already exists. [web:16][web:59]
- WhatsApp support number exists publicly. [web:3]
- Email and grievance contacts exist publicly. [web:3][web:4]

### Recommendations (Not Yet Confirmed)
- **Frontend:** Web app, admin console, distributor portal.
- **Backend:** API-first service layer.
- **AI Models:** LLM + RAG for knowledge, workflow models for automation, recommendation engines for product guidance.
- **Voice Platform:** Vapi.
- **Workflow Automation:** n8n.
- **Databases:** Operational DB + analytics store.
- **Vector Database:** For embeddings and retrieval.
- **Hosting:** Scalable cloud hosting.
- **Authentication:** Role-based access control.
- **Monitoring:** Logs, analytics, tracing, AI evaluation.

**REQUIRES CLIENT INPUT:** Exact current stack, preferred cloud, and approved tools.

---

## 11. Current Project Status

| Stage | Status |
|---|---|
| Research completed | Completed |
| Current documentation pack | In progress / mostly completed |
| Architecture design | Planned |
| Implementation | Planned |
| Testing | Planned |
| Deployment | Planned |

---

## 12. Key Decisions Made

| Decision | Reason | Status | Date |
|---|---|---|---|
| Use RAG as the knowledge foundation | To reduce hallucinations and preserve source truth | Confirmed | 2026-08 |
| Build modular AI assistants by function | To support scalable enterprise rollout | Confirmed | 2026-08 |
| Separate customer, distributor, internal AI use cases | Different needs and permissions | Confirmed | 2026-08 |
| Maintain VERIFIED / PARTIALLY VERIFIED / UNKNOWN labels | To preserve research integrity | Confirmed | 2026-08 |

---

## 13. Known Constraints

- Exact CRM/ERP stack is unknown. [file:12_Research_Gap_Analysis]
- Product master data is incomplete for some SKUs. [file:03_Product_Research]
- Distributor portal capabilities are not fully documented. [file:04_Distributor_System]
- Final implementation budget and timeline are not yet confirmed. [file:12_Research_Gap_Analysis]
- System integrations depend on client-provided APIs and credentials. [file:12_Research_Gap_Analysis]

---

## 14. Risks

**VERIFIED / PARTIALLY VERIFIED:**
- Business risk: poor adoption or unclear value. [file:10_Pain_Points]
- Technical risk: missing API/integration details. [file:12_Research_Gap_Analysis]
- AI risk: hallucinations or policy misstatements. [file:05_Policies][file:11_AI_Opportunities]
- Security risk: unauthorized access to internal data. [file:12_Research_Gap_Analysis]
- Data risk: outdated or inconsistent knowledge. [file:12_Research_Gap_Analysis]

---

## 15. Success Criteria

- Faster customer response times.
- Reduced support ticket volume.
- Higher distributor onboarding completion.
- Better AI adoption across channels.
- Improved CSAT and distributor satisfaction.
- Better operational efficiency and reporting.
- Positive ROI through automation and reduced manual effort.

---

## 16. Current Folder & Document Structure

> The exact repository structure is still evolving. The current knowledge pack is organized around numbered mission documents.

### Current logical structure

- **Research/**: 01–12 research documents.
- **Documentation/**: Policies, FAQs, process docs.
- **AI/**: AI opportunity documents and strategy.
- **Knowledge/**: Master context and RAG sources.
- **Architecture/**: Planned architecture docs.
- **Backend/**: Planned implementation docs.
- **Frontend/**: Planned implementation docs.
- **Deployment/**: Planned deployment docs.
- **Docs/**: Project governance and summaries.

**Status:** Partially implemented; some sections are planned.

---

## 17. Document Reference Map

| File Name | Purpose | Status | Related Documents |
|---|---|---|---|
| 01_Company_Research.md | Company foundation | Completed | 02, 04, 12 |
| 02_Business_Model.md | Business model | Completed | 01, 04, 10 |
| 03_Product_Research.md | Product data | Completed | 05, 06, 11, 12 |
| 04_Distributor_System.md | Distributor system | Completed | 02, 04, 06, 10, 11 |
| 05_Policies.md | Policies | Completed | 06, 08, 12 |
| 06_FAQs.md | FAQ knowledge base | Completed | 05, 07, 08, 10, 11 |
| 07_Customer_Journey.md | Journey mapping | Completed | 06, 08, 10, 11 |
| 08_Business_Processes.md | Operational workflows | Completed | 05, 07, 10, 11 |
| 09_Competitor_Analysis.md | Competitive intelligence | Completed | 02, 10, 11 |
| 10_Pain_Points.md | Pain-point analysis | Completed | 06, 07, 08, 11, 12 |
| 11_AI_Opportunities.md | AI strategy blueprint | Completed | 03, 04, 05, 06, 07, 08, 10, 12 |
| 12_Research_Gap_Analysis.md | Discovery and gaps | Completed | All prior docs |

---

## 18. Glossary

| Term | Meaning |
|---|---|
| RAG | Retrieval-Augmented Generation; AI answers grounded in retrieved documents. |
| Vapi | Voice AI platform used for phone-based conversational agents. |
| Embeddings | Numeric representations used for semantic search and retrieval. |
| Intent | The user’s purpose or goal in a message. |
| Function Calling | Structured tool invocation from an AI model. |
| Workflow | A sequence of steps that accomplishes a business task. |
| CRM | Customer Relationship Management system. |
| Vector Database | Database optimized for embedding-based semantic search. |
| Knowledge Base | Curated content source for AI and humans. |
| Agent | An AI assistant specialized for a task. |
| Tool | An external function, API, or workflow used by an AI agent. |
| Webhook | Event-driven HTTP callback for automation. |

---

## 19. Open Questions

**REQUIRES CLIENT INPUT / UNKNOWN:**
- What CRM is currently in use?
- What ERP/order system is currently in use?
- Is there a ticketing platform already deployed?
- What is the preferred cloud/hosting provider?
- What data can be exposed to AI systems?
- What are the governance and approval rules for AI responses?
- Which languages must be supported first?
- What are the target KPIs and business priorities?
- What integrations are already available?
- What budget and timeline constraints apply?

Reference: [file:12_Research_Gap_Analysis]

---

## 20. Immediate Next Steps

1. **Complete Research Documentation Pack**  
   Ensure all mission documents are finalized and synchronized.

2. **Create Project Context Pack**  
   Use this master context plus research files as the front door for all future AI work.

3. **Design System Architecture**  
   Define AI gateway, knowledge base, APIs, workflows, and integration strategy.

4. **Design Knowledge Architecture**  
   Define content governance, RAG indexing, embeddings, metadata, and update workflows.

5. **Begin Implementation**  
   Start with internal RAG, website AI, then WhatsApp/Voice AI, then CRM/workflow automation.

---

## 21. Master AI Instructions

### Instructions for Any AI Working on This Project

1. **Always read this document first.**
2. Use the uploaded research documents as the primary source of truth.
3. Never invent business facts.
4. Clearly mark assumptions and unknowns.
5. Keep documentation modular and RAG-friendly.
6. Preserve consistent terminology across all files.
7. Design for scalability, maintainability, and enterprise use.
8. Prefer reusable components and documented decisions.
9. Reference related documents instead of duplicating content.
10. When information conflicts, document the conflict explicitly.
11. Respect the VERIFIED / PARTIALLY VERIFIED / UNKNOWN / REQUIRES CLIENT INPUT taxonomy.
12. Build with compliance, security, and auditability in mind.

---

## Source References

- [file:01_Company_Research]
- [file:02_Business_Model]
- [file:03_Product_Research]
- [file:04_Distributor_System]
- [file:05_Policies]
- [file:06_FAQs]
- [file:07_Customer_Journey]
- [file:08_Business_Processes]
- [file:09_Competitor_Analysis]
- [file:10_Pain_Points]
- [file:11_AI_Opportunities]
- [file:12_Research_Gap_Analysis]

**END OF DOCUMENT**