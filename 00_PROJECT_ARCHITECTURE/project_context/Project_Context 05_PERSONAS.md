# Project_Context/05_PERSONAS.md

# Dayjoy Enterprise AI Platform — Persona & User Context

> **Purpose:** Authoritative reference for all user types interacting with the Dayjoy Enterprise AI Platform.
>
> **Audience:** AI engineers, UX/UI designers, frontend/backend developers, product managers, QA engineers, conversation designers, and future AI assistants.

---

## Table of Contents

1. [Executive Overview](#1-executive-overview)
2. [Persona Classification](#2-persona-classification)
3. [Customer Persona](#3-customer-persona)
4. [Distributor Persona](#4-distributor-persona)
5. [Employee Personas](#5-employee-personas)
6. [Management Personas](#6-management-personas)
7. [Administrator Persona](#7-administrator-persona)
8. [AI Agent Personas](#8-ai-agent-personas)
9. [Persona Journey Maps](#9-persona-journey-maps)
10. [Permissions Matrix](#10-permissions-matrix)
11. [Communication Preferences](#11-communication-preferences)
12. [Accessibility & Language](#12-accessibility--language)
13. [Persona Pain Points & AI Opportunities](#13-persona-pain-points--ai-opportunities)
14. [Future Personas](#14-future-personas)
15. [Summary](#15-summary)

---

## 1. Executive Overview

Personas define **who uses the platform, why they use it, what they need, and how AI should behave for them**. In this project, personas influence:
- Product design.
- AI behavior.
- Security and permissions.
- Workflow automation.
- UX decisions.
- Support escalation.
- Personalization.

**VERIFIED:** The project already identifies customers, distributor prospects, distributors, employees, customer support users, sales, marketing, administration, and management as the key human groups in the operating model. [07_Customer_Journey.md][08_Business_Processes.md][04_Distributor_System.md][10_Pain_Points.md]

---

## 2. Persona Classification

| Persona Group | Examples | Primary Interaction Type | Status |
|---|---|---|---|
| External Users | Customers, prospects, distributors | Public and semi-public AI channels | Verified |
| Internal Users | Employees, support staff, sales, marketing, operations | Internal AI and role-based tools | Verified |
| Administrative Users | Admins, system owners, knowledge owners | Governance and control | Partially verified |
| AI Agents | Voice AI, WhatsApp AI, Website AI, Knowledge AI, etc. | Digital assistants | Planned |
| Future Personas | Regional managers, suppliers, developers, external integrators | Future expansion | Future consideration |

---

## 3. Customer Persona

### Who they are
Customers are people who buy Dayjoy products for personal, family, wellness, or household use. [02_Business_Model.md][06_FAQs.md]

### Demographics
**PARTIALLY VERIFIED:** Public research suggests Dayjoy serves Indian consumers across multiple wellness categories, but detailed demographic segmentation is not documented in the sources. [02_Business_Model.md][12_Research_Gap_Analysis.md]

### Goals
- Find the right product.
- Understand benefits and usage.
- Place orders easily.
- Track delivery.
- Get support and returns/refunds help.

### Pain Points
- Product complexity.
- Confusing policy details.
- Support delays.
- Unclear shipping and refund status. [10_Pain_Points.md][05_Policies.md][06_FAQs.md]

### Typical Questions
- What is this product used for?
- How do I order?
- Where is my order?
- Can I return it?
- How long will the refund take?

### Buying Journey
Awareness → Interest → Product research → Comparison → Purchase → Shipping → Delivery → Usage → Support → Repeat purchase. [07_Customer_Journey.md]

### AI Interactions
- Website AI for product discovery.
- WhatsApp AI for quick support.
- Voice AI for urgent questions.
- Knowledge AI for policy and product facts.

### Preferred Channels
Website, WhatsApp, phone, email, distributor.

### Permissions
Public access to product and support content; account-level access for order-specific actions.

### Success Metrics
- Faster answers.
- Successful orders.
- Higher satisfaction.
- Repeat purchases.

---

## 4. Distributor Persona

### Who they are
Independent distributors join Dayjoy to sell products and build business income. [04_Distributor_System.md]

### Onboarding Journey
Discovery → Registration → Verification → Training → First order → Selling → Customer management → Commission tracking → Business growth. [04_Distributor_System.md][07_Customer_Journey.md]

### Daily Activities
- Share products.
- Answer customer questions.
- Place orders.
- Track commission and rank progress.
- Follow up on prospects.

### Business Goals
- Earn retail profit and incentives.
- Grow customer base.
- Build team and increase rank.
- Stay compliant.

### Challenges
- Compensation complexity.
- Product knowledge gaps.
- Training load.
- Income uncertainty. [10_Pain_Points.md][04_Distributor_System.md]

### AI Support Needs
- Compensation explainer.
- Product recommendation support.
- Business coaching.
- Order assistant.
- Training assistant.

### Reporting Needs
- BV/PV.
- Rank progress.
- Payout visibility.
- Team activity.

### Notifications
- Order updates.
- Training reminders.
- Payout reminders.
- Compliance alerts.

### Training Requirements
- Product modules.
- Business workshops.
- Compensation plan understanding.
- Policy compliance.

### Performance Metrics
- Onboarding completion.
- Active selling rate.
- BV/PV growth.
- Customer conversion.
- Retention.

---

## 5. Employee Personas

| Persona | Responsibilities | Daily Workflow | AI Assistance | Required Permissions | KPIs |
|---|---|---|---|---|---|
| Customer Support | Resolve queries, complaints, refunds | Ticket handling, call/email follow-up | Support AI, Knowledge AI | Read support records | FCR, response time, CSAT |
| Sales | Lead follow-up, conversion support | Lead contact, product recommendation | Sales AI | Sales leads, customer profiles | Conversion rate, lead response time |
| Marketing | Campaign content and planning | Content creation, campaign review | Marketing AI | Brand assets, campaign data | Campaign output, engagement |
| Operations | Order and workflow management | Shipment, returns, approvals | Operations AI | Order and process data | Processing time, error rate |
| Finance | Refunds, payouts, reconciliation | Review transactions, approvals | Finance assistant | Financial records | Accuracy, turnaround time |
| Logistics | Dispatch and delivery coordination | Shipping updates, exceptions | Tracking AI | Delivery data | On-time delivery |
| HR | Employee support and policies | Policy questions, onboarding | HR AI | HR docs | Resolution time |
| IT | System support, integrations, security | Troubleshooting, access, monitoring | Internal AI, Admin AI | Systems, logs, admin tools | Uptime, incident response |

**VERIFIED:** These functional areas align with the documented business process and pain-point research. [08_Business_Processes.md][10_Pain_Points.md]

---

## 6. Management Personas

### Managers
- Need operational visibility.
- Need KPI reporting and exception handling.
- Need AI summaries and alerts.

### Executives
- Need strategic dashboards.
- Need cross-functional performance insight.
- Need confidence in business and AI governance.

### Business Owners
- Need growth, risk management, and ROI visibility.
- Need decisions grounded in verified knowledge and business metrics.

**AI interactions:** Analytics AI, executive summaries, decision support, alerts.

**Approval workflows:** Policy exceptions, major changes, system go-live approvals.

---

## 7. Administrator Persona

Administrators manage:
- User management.
- Permissions.
- Knowledge base content.
- AI configuration.
- System monitoring.
- Audit responsibilities.

**Permissions:** elevated or system-level, with careful governance and audit logging. [03_UNKNOWN_INFORMATION.md][06_DECISIONS.md]

**AI needs:** Admin AI for content review, access management support, and operational summaries.

---

## 8. AI Agent Personas

| AI Agent | Purpose | Responsibilities | Boundaries | Inputs | Outputs | Escalation Rules |
|---|---|---|---|---|---|---|
| Voice AI | Phone-based support | Answer FAQs, route cases | No unsupported claims | Calls, KB | Spoken answers | Escalate sensitive/legal/refund issues |
| Website AI | Website support | Product and policy guidance | No guessing | Web queries, KB | Answers, recommendations | Escalate unclear cases |
| WhatsApp AI | Chat support | Quick support, order help | Must follow policy | Messages, KB | Chat replies | Escalate complaints/complex issues |
| Knowledge AI | Grounded fact retrieval | Retrieve verified info | No assumptions | Docs, metadata | Citations, summaries | Escalate missing evidence |
| Sales AI | Sales support | Lead follow-up, product suggestions | Must avoid overpromising | Lead data, product context | Follow-up guidance | Escalate complex/medical issues |
| Marketing AI | Content help | Draft compliant content | Must obey brand rules | Brand docs, product info | Drafts | Escalate for approval |
| Analytics AI | Reporting | Summaries, trends, alerts | Use approved metrics | KPI data | Insights | Escalate anomalies |
| Admin AI | Administration support | Permissions, monitoring, content | Must respect access control | Admin data | Admin summaries | Escalate security issues |

---

## 9. Persona Journey Maps

### Customer
```mermaid
flowchart LR
    A[Discover] --> B[Research] --> C[Buy] --> D[Track] --> E[Use] --> F[Support] --> G[Repeat]
```

### Distributor
```mermaid
flowchart LR
    A[Discover] --> B[Register] --> C[Verify] --> D[Train] --> E[Sell] --> F[Track Earnings] --> G[Grow]
```

### Employee
```mermaid
flowchart LR
    A[Need Info] --> B[Search] --> C[Use AI] --> D[Act] --> E[Escalate if needed]
```

### Administrator
```mermaid
flowchart LR
    A[Review Access] --> B[Approve Changes] --> C[Monitor AI] --> D[Audit] --> E[Maintain]
```

---

## 10. Permissions Matrix

| Persona | Read | Create | Update | Delete | AI Features | Admin Rights |
|---|---|---|---|---|---|---|
| Customer | Public product/policy info, own orders | Support tickets | Profile info (if enabled) | Limited | Website/WhatsApp/Voice AI | No |
| Distributor | Distributor content, own activity | Leads, orders, support cases | Own profile data | Limited | Distributor AI, Sales AI | No |
| Employee | Internal docs by role | Tickets, notes | Work items | Limited | Internal AI | No |
| Manager | Reports, dashboards | Approvals, comments | Decisions | Limited | Analytics AI | Limited |
| Admin | System content, users, logs | System configs | Roles, knowledge | Yes (controlled) | Admin AI | Yes |

---

## 11. Communication Preferences

| Persona | Voice | WhatsApp | Website Chat | Email | Mobile App | Dashboard |
|---|---|---|---|---|---|---|
| Customer | Yes | Yes | Yes | Yes | Preferred | No |
| Distributor | Yes | Yes | Yes | Yes | Preferred | Yes |
| Employee | Optional | Optional | No | Yes | Optional | Yes |
| Manager | Optional | Optional | No | Yes | Optional | Yes |
| Admin | No | No | No | Yes | No | Yes |

---

## 12. Accessibility & Language

**VERIFIED:** The business operates in India and public communication is already multilingual in practice across public web properties, but detailed language policy is not fully documented. [05_Policies.md][12_Research_Gap_Analysis.md]

### Requirements
- Support clear, simple language.
- Support mobile-first usage.
- Allow multilingual support over time.
- Keep accessibility in mind for support flows.

### Status
- **Verified:** India-facing communication exists.
- **Recommended:** Multilingual and accessible by design.
- **Unknown:** Exact language priority list requires client input.

---

## 13. Persona Pain Points & AI Opportunities

| Persona | Top Pain Points | AI Capabilities | Business Value | Priority |
|---|---|---|---|---|
| Customer | Product confusion, shipping, returns | Website AI, WhatsApp AI, Voice AI | Better CX | High |
| Distributor | Compensation, onboarding, training | Distributor AI, comp explainer | Better DX | High |
| Employee | Finding answers, process steps | Internal AI | Better productivity | High |
| Support | Repetitive questions, slow resolution | Support AI, Knowledge AI | Lower support cost | Very High |
| Management | Limited visibility | Analytics AI | Better decisions | High |
| Admin | Knowledge and content maintenance | Admin AI | Better governance | Medium |

---

## 14. Future Personas

**Future considerations only:**
- Regional Managers.
- Franchise Partners.
- Suppliers.
- International Customers.
- External Integrations.
- Third-party Developers.

These personas are not yet fully defined in the current research and should be treated as future expansion. [03_UNKNOWN_INFORMATION.md][12_Research_Gap_Analysis.md]

---

## 15. Summary

Persona-driven design improves:
- AI conversations.
- User experience.
- Security and permissions.
- Personalization.
- Workflow automation.
- Product scalability.

**VERIFIED:** The project already identifies the major user groups and the need for differentiated AI experiences across customer, distributor, employee, support, and management contexts. [07_Customer_Journey.md][08_Business_Processes.md][10_Pain_Points.md][11_AI_Opportunities.md]

---

**END OF DOCUMENT**