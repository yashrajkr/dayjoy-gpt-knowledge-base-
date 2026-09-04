# Project_Context/03_PRODUCT_CONTEXT.md

# Dayjoy Enterprise AI Platform — Product Context

> **Purpose:** Business and knowledge context for Dayjoy’s product ecosystem.  
> **Audience:** Product managers, AI assistants, engineers, support teams, and content owners.

---

## Table of Contents

1. [Purpose](#1-purpose)
2. [Product Portfolio Overview](#2-product-portfolio-overview)
3. [Product Categories](#3-product-categories)
4. [Verified Flagship Products](#4-verified-flagship-products)
5. [Product Business Role](#5-product-business-role)
6. [Product Knowledge Requirements](#6-product-knowledge-requirements)
7. [Product Pricing and Availability](#7-product-pricing-and-availability)
8. [Product Support Needs](#8-product-support-needs)
9. [Cross-Selling Context](#9-cross-selling-context)
10. [Known Gaps](#10-known-gaps)
11. [AI Usage Guidance](#11-ai-usage-guidance)
12. [Source References](#12-source-references)

---

## 1. Purpose

This document summarizes the Dayjoy product ecosystem so AI assistants and developers understand what the platform sells, how products are grouped, and what product knowledge must be available before building customer-facing or distributor-facing tools. [03_Product_Research.md][00_MASTER_CONTEXT.md]

---

## 2. Product Portfolio Overview

**VERIFIED:** Dayjoy’s public product presence includes health care, personal care, agriculture & veterinary, food products, home care, skin care, and other lifestyle categories. [03_Product_Research.md][01_Company_Research.md]

**VERIFIED:** Product pages exist for several flagship products and support business operations such as product discovery, distributor sales, customer education, and recommendations. [03_Product_Research.md][06_FAQs.md][11_AI_Opportunities.md]

---

## 3. Product Categories

| Category | Business Meaning | Status |
|---|---|---|
| Health Care | Core wellness and nutrition-related products | Verified |
| Personal Care | Oral care and self-care products | Verified |
| Agriculture & Veterinary | Soil / crop support products | Verified |
| Food Products | Consumer food items and related consumables | Partially verified |
| Home Care | Household use products | Partially verified |
| Skin Care | Cosmetic / skin-oriented products | Partially verified |
| Cloth / Lifestyle | Clothing or lifestyle category references | Partially verified |

**VERIFIED:** These categories are publicly referenced on Dayjoy web properties and related public references. [03_Product_Research.md][web:16][web:59][web:148]

---

## 4. Verified Flagship Products

| Product | Category | Brand | Description | Price / Availability | Status |
|---|---|---|---|---|---|
| Orthofix Oil (100ml) | Health Care | Curind | Natural pain relief solution for sore muscles and joints | ₹525, in stock | Verified |
| Asthprash (300g) | Health Care | Curind | Herbal respiratory support formula | Publicly available | Verified |
| Seabuckthorn Juice (1L) | Health Care | Curind | Supports digestion, immunity, liver and skin health | Publicly available | Verified |
| Super Rich Berry Juice (1L) | Health Care | Curind | Antioxidant-rich berry juice | Publicly available | Verified |
| HerboSmile Toothpaste | Personal Care | Wild Muse | Herbal oral care solution | Publicly available | Verified |
| JuniorJoy Kids Nutritional Drink (300g) | Health Care | Curind | Nutritional drink for children | Publicly available | Verified |
| Happy Soil - Humic (500ml) | Agriculture & Veterinary | Happygrow | Organic soil conditioner | ₹849, in stock | Verified |
| Liv-Ease (500ml) | Health Care | Curind | Liver support / detox product | Publicly available | Verified |
| Orthofix (60 Tab) | Health Care | Curind | Joint health support product | ₹1,199 | Verified |
| Adicardial Syrup (500ml) | Health Care | Curind | Herbal support product | Publicly available | Verified |
| JoyCalcium (2L) | Agriculture & Veterinary | Not fully confirmed | Specialized support product | Publicly available | Partially verified |

**Note:** Use the full product research document for SKU-level detail and the known facts repository for verified product facts. [03_Product_Research.md][02_KNOWN_FACTS.md]

---

## 5. Product Business Role

| Role | Meaning |
|---|---|
| Revenue Driver | Products are the core source of customer and distributor activity. |
| Education Driver | Products generate product questions, FAQs, and support needs. |
| Recommendation Driver | Products must be matched to customer needs and cross-sold intelligently. |
| Training Driver | Distributor training depends on product understanding. |
| Support Driver | Usage, safety, pricing, and availability questions create support demand. |

**VERIFIED:** Product knowledge is central to customer support, distributor training, and recommendation flows. [03_Product_Research.md][06_FAQs.md][07_Customer_Journey.md][10_Pain_Points.md]

---

## 6. Product Knowledge Requirements

To support AI systems, product knowledge must include:
- Product name and category.
- Brand mapping.
- Description and benefits.
- Ingredients where verified.
- Price where verified.
- Availability where verified.
- Certifications where verified.
- Safety and usage guidance where verified.

**PARTIALLY VERIFIED:** Several flagship products have these fields documented, but not all products have complete data. [03_Product_Research.md][12_Research_Gap_Analysis.md]

---

## 7. Product Pricing and Availability

| Fact | Status |
|---|---|
| Some product prices are publicly visible | Verified |
| Full price list for every SKU is not yet complete in the research corpus | Partially verified |
| Some products are shown as in stock | Verified |
| Region-by-region availability is not fully documented | Unknown |

**VERIFIED:** Public examples include Orthofix Oil at ₹525 and Happy Soil - Humic at ₹849. [03_Product_Research.md]

---

## 8. Product Support Needs

| Support Need | Why It Matters | AI Relevance |
|---|---|---|
| Product usage guidance | Prevent misuse and support customer success | Website AI, Voice AI |
| Ingredients and composition | Needed for trust and safety | Product Knowledge AI |
| Safety notes and contraindications | Needed for responsible answers | Support AI, RAG |
| Pricing clarification | Needed for purchase decisions | Website AI, WhatsApp AI |
| Availability / stock info | Needed to avoid failed orders | Order assistant |
| Related products / bundles | Needed for cross-sell | Recommendation engine |

---

## 9. Cross-Selling Context

**VERIFIED:** Product grouping supports complementary recommendations, especially among health care, oral care, liver support, respiratory support, and agriculture products. [03_Product_Research.md][11_AI_Opportunities.md]

**Example contexts:**
- Health care products may be recommended together.
- Personal care products may be paired in bundles.
- Distributor AI may suggest related products during sales conversations.

---

## 10. Known Gaps

| Gap | Status | Why It Matters |
|---|---|---|
| Full SKU catalog | Unknown / partial | Needed for product search and AI recommendations |
| Complete ingredients | Partial | Needed for safety and compliance |
| Product images | Unknown | Needed for UX and catalog experience |
| Product videos | Unknown | Needed for education |
| Full price list by channel | Partial | Needed for sales and support |
| Availability feed | Unknown | Needed for order assistance |
| Product-specific manuals | Partial | Needed for support and AI |

---

## 11. AI Usage Guidance

- Use product context only when the question is about products, packaging, benefits, or support.
- Do not infer missing ingredients or safety claims.
- Prefer verified product pages and known facts over promotional language.
- Escalate health/safety questions if the underlying data is incomplete or unclear.
- Use product context together with policies and FAQs for accurate customer-facing answers.

---

## 12. Source References

- `03_Product_Research.md`
- `02_KNOWN_FACTS.md`
- `03_UNKNOWN_INFORMATION.md`
- `06_FAQs.md`
- `11_AI_Opportunities.md`
- `01_Company_Research.md`
- `05_Policies.md`

---

**END OF DOCUMENT**