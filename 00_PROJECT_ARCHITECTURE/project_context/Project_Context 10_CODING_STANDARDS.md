# Project_Context/10_CODING_STANDARDS.md

# Dayjoy Enterprise AI Platform — Coding Standards

> **Purpose:** Mandatory engineering standard for every developer, AI coding assistant, code review process, and future contributor.
>
> **Audience:** Backend developers, frontend developers, AI engineers, DevOps engineers, QA engineers, and AI coding assistants.
>
> **Enforcement:** All code must follow these standards. Deviations require explicit approval in code review.

---

## Table of Contents

1. [Project Structure](#1-project-structure)
2. [File Naming](#2-file-naming)
3. [Code Style](#3-code-style)
4. [Naming Conventions](#4-naming-conventions)
5. [Backend Standards](#5-backend-standards)
6. [Frontend Standards](#6-frontend-standards)
7. [AI Code Standards](#7-ai-code-standards)
8. [Database Standards](#8-database-standards)
9. [API Standards](#9-api-standards)
10. [Security Standards](#10-security-standards)
11. [Git Standards](#11-git-standards)
12. [Testing Standards](#12-testing-standards)
13. [Documentation Standards](#13-documentation-standards)
14. [Code Review Checklist](#14-code-review-checklist)
15. [AI Coding Assistant Guidelines](#15-ai-coding-assistant-guidelines)

---

## 1. Project Structure

### 1.1 Folder Hierarchy

| Standard ID | Category | Rule | Reason | Good Example | Bad Example | Enforcement |
|---|---|---|---|---|---|---|
| PS-001 | Structure | Use feature-based folder structure | Improves discoverability and modularity | `features/auth/`, `features/orders/` | `controllers/`, `services/` (scattered) | **Required** |
| PS-002 | Structure | Separate frontend, backend, and AI code | Clear boundaries, easier navigation | `frontend/`, `backend/`, `ai/` | All code in root | **Required** |
| PS-003 | Structure | Group by domain, not type | Domain-centric development | `features/distributors/` | `components/`, `api/` (type-based) | **Required** |
| PS-004 | Structure | Shared code in `shared/` or `common/` | Avoid circular dependencies | `shared/utils/`, `shared/types/` | Duplicated utilities | **Required** |
| PS-005 | Structure | Configuration in `config/` | Centralized configuration | `config/database.py`, `config/settings.py` | Hardcoded config in files | **Required** |
| PS-006 | Structure | Environment files at root | Standard location for env files | `.env`, `.env.example`, `.env.local` | `.env` in subfolders | **Required** |
| PS-007 | Structure | Tests adjacent to code | Easy to find and maintain | `features/auth/auth.test.ts` | Separate `tests/` folder | **Recommended** |
| PS-008 | Structure | Documentation in `docs/` | Centralized documentation | `docs/api/`, `docs/architecture/` | README-only documentation | **Required** |

### 1.2 Recommended Project Structure

```
dayjoy-enterprise-ai/
├── backend/
│   ├── features/
│   │   ├── auth/
│   │   │   ├── auth.controller.py
│   │   │   ├── auth.service.py
│   │   │   ├── auth.repository.py
│   │   │   ├── auth.routes.py
│   │   │   ├── auth.schemas.py
│   │   │   └── auth.test.py
│   │   ├── distributors/
│   │   ├── orders/
│   │   └── products/
│   ├── shared/
│   │   ├── db/
│   │   ├── utils/
│   │   └── middleware/
│   ├── config/
│   │   ├── settings.py
│   │   └── database.py
│   └── main.py
├── frontend/
│   ├── features/
│   │   ├── auth/
│   │   ├── dashboard/
│   │   └── orders/
│   ├── shared/
│   │   ├── components/
│   │   ├── hooks/
│   │   └── utils/
│   └── app.tsx
├── ai/
│   ├── agents/
│   │   ├── website_ai/
│   │   ├── whatsapp_ai/
│   │   └── voice_ai/
│   ├── tools/
│   ├── prompts/
│   └── rag/
├── docs/
│   ├── api/
│   ├── architecture/
│   └── guides/
├── config/
│   ├── docker/
│   └── k8s/
├── .env.example
├── .gitignore
└── README.md
```

### 1.3 Adding New Modules

When adding a new feature module:

1. Create folder under `backend/features/{feature_name}/` or `frontend/features/{feature_name}/`
2. Follow the standard file structure (controller, service, repository, routes, schemas, tests)
3. Update `docs/architecture/` with new module documentation
4. Add API documentation to `docs/api/`
5. Update this document if new patterns are introduced

---

## 2. File Naming

| Standard ID | Category | Rule | Reason | Good Example | Bad Example | Enforcement |
|---|---|---|---|---|---|---|
| FN-001 | Files | Use lowercase with underscores for Python files | Python convention, consistent imports | `user_service.py`, `auth_controller.py` | `UserService.py`, `user-service.py` | **Required** |
| FN-002 | Files | Use camelCase for TypeScript/JavaScript files | JS/TS convention | `userService.ts`, `AuthController.tsx` | `user_service.ts`, `auth-controller.tsx` | **Required** |
| FN-003 | Files | Prefix React components with PascalCase | Component clarity | `UserCard.tsx`, `OrderList.tsx` | `userCard.tsx`, `order_list.tsx` | **Required** |
| FN-004 | Files | Suffix test files with `.test.ext` | Clear test file identification | `auth.test.ts`, `user.test.py` | `test_auth.ts`, `auth_spec.ts` | **Required** |
| FN-005 | Files | Suffix utility files with `.utils.ext` or place in `utils/` | Clear utility identification | `date.utils.ts`, `string_utils.py` | `helpers.ts`, `misc.py` | **Recommended** |
| FN-006 | Files | Use descriptive names, avoid abbreviations | Clarity and searchability | `distributor_service.py`, `order_validator.ts` | `dist_svc.py`, `ord_val.ts` | **Required** |
| FN-007 | Folders | Use lowercase with underscores for folders | Consistent across platforms | `user_auth/`, `order_management/` | `UserAuth/`, `orderManagement/` | **Required** |
| FN-008 | Folders | Feature folders match domain name | Easy navigation | `features/distributors/` | `features/dist/`, `features/compensation/` | **Required** |
| FN-009 | Components | Component files match component name | Easy to find | `UserCard.tsx` exports `UserCard` | `UserCard.tsx` exports `Card` | **Required** |
| FN-010 | Services | Service files describe domain | Clear responsibility | `payment.service.ts`, `notification.service.py` | `api.ts`, `utils.py` | **Required** |
| FN-011 | APIs | Route files match feature | Clear API structure | `auth.routes.py`, `orders.routes.ts` | `api.ts`, `routes.py` | **Required** |
| FN-012 | Models | Model files match table/entity name | Easy to find | `user.model.py`, `order.schema.ts` | `models.py`, `schema.ts` | **Required** |
| FN-013 | Utilities | Utility files describe purpose | Clear usage | `date.utils.ts`, `validation.utils.py` | `utils.ts`, `helpers.py` | **Required** |
| FN-014 | Tests | Test files adjacent to code | Easy to maintain | `auth.test.ts` next to `auth.ts` | Separate `tests/` folder | **Recommended** |
| FN-015 | Documentation | Documentation files use `.md` | Standard markdown | `README.md`, `API.md` | `README.txt`, `API.doc` | **Required** |

---

## 3. Code Style

### 3.1 General Code Style

| Standard ID | Category | Rule | Reason | Good Example | Bad Example | Enforcement |
|---|---|---|---|---|---|---|
| CS-001 | Formatting | Use 4 spaces for Python, 2 spaces for TypeScript | Language conventions | Python: 4 spaces, TS: 2 spaces | Mixed tabs/spaces | **Required** |
| CS-002 | Formatting | Maximum line length: 100 characters | Readability | `def long_function_name(param1, param2):` | Single line with 200 chars | **Recommended** |
| CS-003 | Formatting | Use automatic formatting tools | Consistency | `black`, `prettier`, `eslint` | Manual formatting | **Required** |
| CS-004 | Imports | Group imports logically | Readability | stdlib, third-party, local (with blank lines) | Mixed imports | **Required** |
| CS-005 | Imports | Use absolute imports over relative | Clarity | `from features.auth import service` | `from ...auth import service` | **Required** |
| CS-006 | Functions | Maximum function length: 50 lines | Maintainability | Small, focused functions | 200-line monolithic functions | **Recommended** |
| CS-007 | Functions | One function = one responsibility | Single Responsibility Principle | `def validate_user():` | `def validate_and_save_and_notify():` | **Required** |
| CS-008 | Classes | Maximum class length: 300 lines | Maintainability | Focused classes with clear purpose | 1000-line god classes | **Recommended** |
| CS-009 | Constants | Use UPPER_CASE for constants | Clear identification | `MAX_RETRY_COUNT = 3` | `maxRetryCount = 3` | **Required** |
| CS-010 | Constants | Avoid magic numbers | Maintainability | `MAX_LOGIN_ATTEMPTS = 3` | `if attempts > 3:` | **Required** |
| CS-011 | Comments | Use docstrings for public functions | Documentation | `"""Validate user credentials."""` | No docstrings | **Required** |
| CS-012 | Comments | Avoid redundant comments | Clarity | Explain _why_, not _what_ | `x = x + 1  # increment x` | **Recommended** |
| CS-013 | Comments | Use TODO/FIXME/HACK tags | Track technical debt | `# TODO: Add rate limiting` | No tracking | **Recommended** |
| CS-014 | Error Handling | Always handle errors explicitly | Reliability | `try/except` with specific exceptions | Bare `except:` | **Required** |
| CS-015 | Error Handling | Log errors with context | Debugging | `logger.error("Payment failed", extra={"user_id": user_id})` | `print("error")` | **Required** |
| CS-016 | Logging | Use structured logging | Machine-parseable | JSON logging with context | Unstructured text logs | **Required** |
| CS-017 | Logging | Do not log sensitive data | Security | Log user_id, not password | Log full request body | **Required** |
| CS-018 | Type Hints | Use type hints in Python | Type safety | `def get_user(user_id: int) -> User:` | `def get_user(user_id):` | **Required** |
| CS-019 | Type Hints | Use TypeScript types/interfaces | Type safety | `interface User { id: number; }` | `any` everywhere | **Required** |
| CS-020 | Type Hints | Avoid `any` type | Type safety | Specific types | `const data: any` | **Required** |

### 3.2 Python-Specific Standards

| Standard ID | Category | Rule | Reason | Good Example | Bad Example | Enforcement |
|---|---|---|---|---|---|---|
| CS-PY-001 | Python | Use f-strings for string formatting | Modern, readable | `f"Hello {name}"` | `"Hello %s" % name` | **Required** |
| CS-PY-002 | Python | Use context managers for resources | Proper cleanup | `with open(file) as f:` | `f = open(file); f.close()` | **Required** |
| CS-PY-003 | Python | Use `pathlib` for file paths | Cross-platform | `Path("/tmp/file")` | `"/tmp/file"` | **Recommended** |
| CS-PY-004 | Python | Use `__name__ == "__main__"` guard | Proper entry point | `if __name__ == "__main__":` | No guard | **Required** |
| CS-PY-005 | Python | Use `dataclasses` for data containers | Clear data structures | `@dataclass class User:` | Plain classes for data | **Recommended** |

### 3.3 TypeScript-Specific Standards

| Standard ID | Category | Rule | Reason | Good Example | Bad Example | Enforcement |
|---|---|---|---|---|---|---|
| CS-TS-001 | TypeScript | Use `const` over `let`, avoid `var` | Immutability | `const x = 5` | `var x = 5` | **Required** |
| CS-TS-002 | TypeScript | Use arrow functions for callbacks | Lexical `this` | `items.map(item => item.id)` | `items.map(function(item) {` | **Required** |
| CS-TS-003 | TypeScript | Use optional chaining | Safety | `user?.address?.city` | `user && user.address && user.address.city` | **Required** |
| CS-TS-004 | TypeScript | Use nullish coalescing | Clearer defaults | `value ?? 'default'` | `value || 'default'` | **Recommended** |
| CS-TS-005 | TypeScript | Use `async/await` over promises | Readability | `const data = await fetch()` | `.then().catch()` chains | **Required** |

---

## 4. Naming Conventions

| Standard ID | Category | Rule | Reason | Good Example | Bad Example | Enforcement |
|---|---|---|---|---|---|---|
| NC-001 | Variables | Use snake_case for Python variables | Python convention | `user_name`, `order_total` | `userName`, `OrderTotal` | **Required** |
| NC-002 | Variables | Use camelCase for TypeScript variables | JS/TS convention | `userName`, `orderTotal` | `user_name`, `OrderTotal` | **Required** |
| NC-003 | Functions | Use verb-noun for functions | Clear action | `get_user()`, `calculateTotal()` | `user()`, `total()` | **Required** |
| NC-004 | Functions | Prefix boolean functions with `is/has/can` | Clear return type | `is_valid()`, `has_permission()` | `valid()`, `permission()` | **Required** |
| NC-005 | Classes | Use PascalCase for classes | Standard convention | `User`, `OrderService` | `user`, `orderService` | **Required** |
| NC-006 | Classes | Use noun for class names | Clear purpose | `User`, `Order` | `ManageUsers`, `DoOrders` | **Required** |
| NC-007 | Interfaces | Prefix with `I` or use descriptive noun | Clear identification | `IUser`, `User` | `user` | **Recommended** |
| NC-008 | Enums | Use PascalCase for enum names | Standard convention | `UserRole`, `OrderStatus` | `userRole`, `ORDER_STATUS` | **Required** |
| NC-009 | Enums | Use UPPER_CASE for enum values | Clear identification | `ADMIN`, `PENDING` | `admin`, `pending` | **Required** |
| NC-010 | Database Tables | Use snake_case plural | SQL convention | `users`, `order_items` | `Users`, `orderItems` | **Required** |
| NC-011 | Database Columns | Use snake_case | SQL convention | `user_id`, `created_at` | `userId`, `createdAt` | **Required** |
| NC-012 | API Endpoints | Use kebab-case in URLs | URL convention | `/api/v1/user-profiles` | `/api/v1/userProfiles` | **Required** |
| NC-013 | API Endpoints | Use plural nouns for resources | REST convention | `/api/v1/users`, `/api/v1/orders` | `/api/v1/user` | **Required** |
| NC-014 | Environment Variables | Use UPPER_CASE with prefix | Clear identification | `DAYJOY_DB_URL`, `DAYJOY_API_KEY` | `dbUrl`, `apiKey` | **Required** |
| NC-015 | Constants | Use UPPER_CASE | Clear identification | `MAX_RETRY_COUNT`, `DEFAULT_PAGE_SIZE` | `maxRetryCount`, `defaultPageSize` | **Required** |
| NC-016 | Private Members | Prefix with underscore | Clear visibility | `_internal_method()`, `__private` | `internal_method()` | **Recommended** |
| NC-017 | Generic Types | Use descriptive names | Clarity | `T`, `U`, `K`, `V` | `X`, `Y`, `Z` | **Recommended** |
| NC-018 | Events | Prefix with `on` for handlers | Clear purpose | `onUserClick`, `handle_order_submit` | `userClick`, `orderSubmit` | **Recommended** |

---

## 5. Backend Standards

### 5.1 API Design

| Standard ID | Category | Rule | Reason | Good Example | Bad Example | Enforcement |
|---|---|---|---|---|---|---|
| BE-001 | API | Use RESTful resource naming | Standard convention | `GET /api/v1/users`, `POST /api/v1/orders` | `GET /api/v1/getUsers` | **Required** |
| BE-002 | API | Use HTTP methods correctly | REST semantics | `GET` (read), `POST` (create), `PUT` (update), `DELETE` (delete) | `POST /api/v1/deleteUser` | **Required** |
| BE-003 | API | Use plural nouns for resources | Convention | `/api/v1/users`, `/api/v1/distributors` | `/api/v1/user` | **Required** |
| BE-004 | API | Version APIs in URL | Clear versioning | `/api/v1/`, `/api/v2/` | No versioning | **Required** |
| BE-005 | API | Use query params for filtering | Standard convention | `/api/v1/users?status=active&page=1` | `/api/v1/users/active` | **Required** |
| BE-006 | API | Use path params for IDs | Clear identification | `/api/v1/users/{user_id}` | `/api/v1/users?id=123` | **Required** |
| BE-007 | API | Return consistent response format | Predictability | `{ "data": {...}, "meta": {...} }` | Inconsistent formats | **Required** |
| BE-008 | API | Use pagination for list endpoints | Performance | `?page=1&limit=20` | Return all records | **Required** |
| BE-009 | API | Use standard HTTP status codes | Convention | `200` (OK), `201` (Created), `400` (Bad Request), `404` (Not Found), `500` (Server Error) | Always return `200` | **Required** |
| BE-010 | API | Include error details in response | Debugging | `{ "error": { "code": "VALIDATION_ERROR", "message": "...", "details": {...} } }` | `{ "error": "Something went wrong" }` | **Required** |

### 5.2 Controllers, Services, Repositories

| Standard ID | Category | Rule | Reason | Good Example | Bad Example | Enforcement |
|---|---|---|---|---|---|---|
| BE-011 | Architecture | Use Controller-Service-Repository pattern | Separation of concerns | Controller → Service → Repository | All logic in controller | **Required** |
| BE-012 | Controllers | Controllers handle HTTP only | Separation of concerns | Parse request, call service, return response | Business logic in controller | **Required** |
| BE-013 | Services | Services contain business logic | Reusability | `create_order()`, `calculate_commission()` | Business logic in controller | **Required** |
| BE-014 | Repositories | Repositories handle DB operations | Abstraction | `get_user()`, `save_order()` | Direct DB calls in service | **Recommended** |
| BE-015 | Dependency Injection | Use dependency injection | Testability | Inject services via constructor | Import and instantiate directly | **Recommended** |
| BE-016 | Validation | Validate input at API boundary | Security | Pydantic schemas, Zod validation | No validation | **Required** |
| BE-017 | Error Handling | Use global error handler | Consistency | Centralized error middleware | Try/catch in every function | **Required** |
| BE-018 | Logging | Log all API requests | Auditability | Log method, path, status, duration | No logging | **Required** |
| BE-019 | Configuration | Use environment variables for config | Security, flexibility | `os.getenv("DB_URL")` | Hardcoded config | **Required** |
| BE-020 | Configuration | Validate configuration on startup | Early error detection | `assert DB_URL` | No validation | **Required** |

---

## 6. Frontend Standards

### 6.1 Components

| Standard ID | Category | Rule | Reason | Good Example | Bad Example | Enforcement |
|---|---|---|---|---|---|---|
| FE-001 | Components | Use functional components | Modern React standard | `const UserCard = () => {...}` | Class components | **Required** |
| FE-002 | Components | One component = one responsibility | Single Responsibility | `UserCard`, `OrderList` | God components doing everything | **Required** |
| FE-003 | Components | Use TypeScript for components | Type safety | `interface UserCardProps { user: User; }` | `any` props | **Required** |
| FE-004 | Components | Keep components small (<200 lines) | Maintainability | Small, focused components | 500-line components | **Recommended** |
| FE-005 | Components | Use composition over inheritance | React best practice | `<Layout><Header /><Content /></Layout>` | Deep inheritance chains | **Required** |
| FE-006 | Components | Export components with same name as file | Easy to find | `UserCard.tsx` exports `UserCard` | `UserCard.tsx` exports `Card` | **Required** |
| FE-007 | Hooks | Use custom hooks for reusable logic | Reusability | `useAuth()`, `useOrders()` | Duplicated logic | **Recommended** |
| FE-008 | Hooks | Prefix custom hooks with `use` | Clear identification | `useAuth`, `useOrders` | `auth`, `orders` | **Required** |
| FE-009 | State | Use Zustand/Jotai for global state | Simple state management | `useAuthStore()` | Redux for simple state | **Recommended** |
| FE-010 | State | Use TanStack Query for server state | Caching, background refetch | `useQuery`, `useMutation` | Manual fetch + state | **Required** |
| FE-011 | Forms | Use React Hook Form | Performance, validation | `useForm()` | Manual form state | **Required** |
| FE-012 | Forms | Validate forms on client | UX, security | Zod schema validation | No validation | **Required** |
| FE-013 | Styling | Use Tailwind CSS classes | Consistency, utility-first | `className="p-4 bg-blue-500"` | Inline styles | **Required** |
| FE-014 | Styling | Use shadcn/ui components | Consistency, accessibility | `<Button>`, `<Card>` | Custom components | **Recommended** |
| FE-015 | Accessibility | Use semantic HTML | Accessibility | `<button>`, `<nav>`, `<main>` | `<div>` for everything | **Required** |
| FE-016 | Accessibility | Include ARIA labels | Accessibility | `aria-label="Close modal"` | No ARIA labels | **Required** |
| FE-017 | Accessibility | Ensure keyboard navigation | Accessibility | Tab order, Enter/Space for buttons | Mouse-only interactions | **Required** |
| FE-018 | Routing | Use Next.js App Router | Modern routing | `app/users/page.tsx` | `pages/users.tsx` | **Required** |
| FE-019 | Routing | Use layout components | Reusability | `layout.tsx` with shared UI | Duplicated layouts | **Required** |
| FE-020 | Error Boundaries | Use error boundaries | Graceful error handling | `<ErrorBoundary>` wrapper | No error handling | **Required** |

---

## 7. AI Code Standards

### 7.1 Prompt Management

| Standard ID | Category | Rule | Reason | Good Example | Bad Example | Enforcement |
|---|---|---|---|---|---|---|
| AI-001 | Prompts | Store prompts in versioned files | Traceability, review | `prompts/product_qa.v1.json` | Hardcoded prompt strings | **Required** |
| AI-002 | Prompts | Use LCEL for prompt chains | Composability, testing | `prompt = base_prompt | parser | llm` | Long concatenated strings | **Required** |
| AI-003 | Prompts | Include few-shot examples | Better output quality | Include examples in prompt | No examples | **Recommended** |
| AI-004 | Prompts | Document prompt purpose | Clarity | `# Prompt for product Q&A with citation` | No documentation | **Required** |
| AI-005 | Prompts | Version prompts on change | Track changes | `product_qa.v1.json`, `product_qa.v2.json` | Overwrite prompts | **Required** |

### 7.2 Tool Calling

| Standard ID | Category | Rule | Reason | Good Example | Bad Example | Enforcement |
|---|---|---|---|---|---|---|
| AI-006 | Tools | Define tools with clear schemas | Reliable tool calling | Pydantic schemas for tool args | Loose dict arguments | **Required** |
| AI-007 | Tools | Validate tool inputs | Safety | `ToolInputSchema.parse(args)` | No validation | **Required** |
| AI-008 | Tools | Log all tool calls | Debugging, audit | Log tool name, args, result | No logging | **Required** |
| AI-009 | Tools | Handle tool errors gracefully | Reliability | `try/except` around tool calls | No error handling | **Required** |
| AI-010 | Tools | Limit tool call recursion | Prevent infinite loops | `max_recursion_depth=3` | No limit | **Required** |

### 7.3 Context & Memory

| Standard ID | Category | Rule | Reason | Good Example | Bad Example | Enforcement |
|---|---|---|---|---|---|---|
| AI-011 | Context | Use RAG for factual queries | Grounding, prevent hallucinations | `retrieve_docs(query) → generate(docs)` | Generate without retrieval | **Required** |
| AI-012 | Context | Limit context window usage | Cost, performance | Summarize old messages | Include full conversation | **Recommended** |
| AI-013 | Memory | Use Redis for session memory | Fast, TTL support | `redis.set(f"session:{id}", data, ex=3600)` | In-memory storage | **Required** |
| AI-014 | Memory | Clear memory after session | Privacy, cost | Delete session on logout | Accumulate forever | **Required** |
| AI-015 | Memory | Do not store sensitive data in memory | Security | Store user_id, not PII | Store full user data | **Required** |

### 7.4 RAG Integration

| Standard ID | Category | Rule | Reason | Good Example | Bad Example | Enforcement |
|---|---|---|---|---|---|---|
| AI-016 | RAG | Chunk documents semantically | Better retrieval | Chunk by section, not fixed size | Fixed 500-char chunks | **Required** |
| AI-017 | RAG | Include metadata in chunks | Filtering, citation | `{ "text": "...", "source": "policy.md", "page": 5 }` | Just text | **Required** |
| AI-018 | RAG | Use hybrid search (keyword + semantic) | Better recall | BM25 + cosine similarity | Cosine only | **Recommended** |
| AI-019 | RAG | Cite sources in AI responses | Trust, verification | `[source: policy.md, page: 5]` | No citations | **Required** |
| AI-020 | RAG | Handle no-results gracefully | User experience | "I couldn't find information about..." | Hallucinate answer | **Required** |

### 7.5 AI Output Validation

| Standard ID | Category | Rule | Reason | Good Example | Bad Example | Enforcement |
|---|---|---|---|---|---|---|
| AI-021 | Validation | Validate AI output with schema | Structured output | `Instructor.parse(response, schema)` | Parse raw string | **Required** |
| AI-022 | Validation | Use Guardrails for critical output | Safety | Guardrails for medical claims | No guardrails | **Required** |
| AI-023 | Validation | Implement hallucination checks | Accuracy | RAGAS faithfulness score | No checks | **Recommended** |
| AI-024 | Validation | Mark uncertain answers | Honesty | "I'm not certain, but..." | Confident wrong answer | **Required** |
| AI-025 | Validation | Escalate sensitive topics | Safety | Detect medical/legal, escalate to human | Handle all topics | **Required** |

### 7.6 Hallucination Prevention

| Standard ID | Category | Rule | Reason | Good Example | Bad Example | Enforcement |
|---|---|---|---|---|---|---|
| AI-026 | Hallucination | Never generate facts without RAG | Accuracy | `retrieve() → generate()` | Generate from training data | **Required** |
| AI-027 | Hallucination | Mark unknowns explicitly | Honesty | "I don't have information about..." | Make up answer | **Required** |
| AI-028 | Hallucination | Use temperature=0 for factual queries | Consistency | `temperature=0` | `temperature=0.7` for facts | **Required** |
| AI-029 | Hallucination | Verify numerical claims | Accuracy | Check calculations, cite source | Generate numbers | **Recommended** |
| AI-030 | Hallucination | Implement fact-checking pipeline | Quality | RAGAS + human review | No checks | **Recommended** |

---

## 8. Database Standards

| Standard ID | Category | Rule | Reason | Good Example | Bad Example | Enforcement |
|---|---|---|---|---|---|---|
| DB-001 | Tables | Use snake_case plural for table names | SQL convention | `users`, `order_items` | `Users`, `orderItems` | **Required** |
| DB-002 | Columns | Use snake_case for column names | SQL convention | `user_id`, `created_at` | `userId`, `createdAt` | **Required** |
| DB-003 | Primary Keys | Use `id` as primary key name | Consistency | `id SERIAL PRIMARY KEY` | `user_id PRIMARY KEY` | **Required** |
| DB-004 | Foreign Keys | Use `{table}_id` for FK columns | Clear relationships | `user_id`, `order_id` | `uid`, `oid` | **Required** |
| DB-005 | Indexes | Index frequently queried columns | Performance | `CREATE INDEX idx_user_id ON orders(user_id)` | No indexes | **Required** |
| DB-006 | Indexes | Use composite indexes for multi-column queries | Performance | `CREATE INDEX idx_status_date ON orders(status, created_at)` | Single indexes only | **Recommended** |
| DB-007 | Migrations | Use Alembic for schema migrations | Version control | `alembic revision --autogenerate` | Manual SQL scripts | **Required** |
| DB-008 | Migrations | Write reversible migrations | Rollback capability | `upgrade()` and `downgrade()` | Only `upgrade()` | **Required** |
| DB-009 | Migrations | Test migrations on staging | Safety | Test on staging before production | Deploy directly to prod | **Required** |
| DB-010 | Soft Deletes | Use `deleted_at` column for soft deletes | Data recovery | `deleted_at TIMESTAMP NULL` | Hard delete all | **Recommended** |
| DB-011 | Audit Fields | Include `created_at`, `updated_at` on all tables | Auditability | `created_at`, `updated_at` columns | No timestamps | **Required** |
| DB-012 | Audit Fields | Auto-update `updated_at` on change | Accuracy | `onupdate=datetime.utcnow` | Manual updates | **Required** |
| DB-013 | Audit Fields | Include `created_by`, `updated_by` | Accountability | `created_by UUID`, `updated_by UUID` | No user tracking | **Recommended** |
| DB-014 | Relationships | Use SQLAlchemy relationships | ORM clarity | `relationship("Order")` | Manual joins | **Required** |
| DB-015 | Relationships | Use `lazy="select"` or `lazy="joined"` | Performance control | Explicit lazy loading | No lazy loading | **Recommended** |
| DB-016 | Constraints | Use database constraints | Data integrity | `UNIQUE`, `CHECK`, `FOREIGN KEY` | Application-level only | **Required** |
| DB-017 | Constraints | Use `NOT NULL` where appropriate | Data quality | `name VARCHAR(255) NOT NULL` | All nullable | **Recommended** |
| DB-018 | Naming | Prefix indexes with `idx_` | Clear identification | `idx_user_id`, `idx_status_date` | `user_id_idx` | **Required** |
| DB-019 | Naming | Prefix unique constraints with `uq_` | Clear identification | `uq_email` | `email_unique` | **Required** |
| DB-020 | Naming | Prefix foreign keys with `fk_` | Clear identification | `fk_user_id` | `user_id_fk` | **Required** |

---

## 9. API Standards

| Standard ID | Category | Rule | Reason | Good Example | Bad Example | Enforcement |
|---|---|---|---|---|---|---|
| API-001 | REST | Use RESTful resource naming | Convention | `GET /api/v1/users`, `POST /api/v1/orders` | `GET /api/v1/getUsers` | **Required** |
| API-002 | REST | Use HTTP methods correctly | REST semantics | `GET` (read), `POST` (create), `PUT/PATCH` (update), `DELETE` (delete) | `POST /api/v1/deleteUser` | **Required** |
| API-003 | Status Codes | Use standard HTTP status codes | Convention | `200` (OK), `201` (Created), `400` (Bad Request), `404` (Not Found), `500` (Server Error) | Always `200` | **Required** |
| API-004 | Status Codes | Use `4xx` for client errors, `5xx` for server errors | Clarity | `400` (bad input), `500` (server bug) | `400` for everything | **Required** |
| API-005 | Response Format | Use consistent response structure | Predictability | `{ "data": {...}, "meta": {...} }` | Inconsistent formats | **Required** |
| API-006 | Response Format | Include pagination metadata | Clarity | `{ "data": [...], "meta": { "page": 1, "total": 100 } }` | No pagination info | **Required** |
| API-007 | Error Response | Use consistent error format | Debugging | `{ "error": { "code": "VALIDATION_ERROR", "message": "...", "details": {...} } }` | `{ "error": "Something went wrong" }` | **Required** |
| API-008 | Error Response | Include error code | Programmatic handling | `VALIDATION_ERROR`, `NOT_FOUND` | No error code | **Required** |
| API-009 | Validation | Validate all inputs | Security | Pydantic schemas, Zod validation | No validation | **Required** |
| API-010 | Validation | Return `400` with validation details | Clarity | `400 Bad Request` with field errors | `500 Internal Server Error` | **Required** |
| API-011 | Pagination | Use query params for pagination | Standard | `?page=1&limit=20` | `/api/v1/users/page/1` | **Required** |
| API-012 | Pagination | Use `page` and `limit` params | Consistency | `?page=1&limit=20` | `?offset=0&count=20` | **Required** |
| API-013 | Filtering | Use query params for filtering | Standard | `?status=active&role=admin` | `/api/v1/users/active/admin` | **Required** |
| API-014 | Filtering | Support multiple filters | Flexibility | `?status=active&role=admin&created_after=2024-01-01` | Single filter only | **Recommended** |
| API-015 | Sorting | Use `sort` param for sorting | Standard | `?sort=-created_at` (desc), `?sort=name` (asc) | `/api/v1/users/sort/created_at` | **Recommended** |
| API-016 | Versioning | Version APIs in URL | Clear versioning | `/api/v1/`, `/api/v2/` | No versioning | **Required** |
| API-017 | Versioning | Support at least one previous version | Backward compatibility | Support v1 when v2 is released | Immediate deprecation | **Recommended** |
| API-018 | Authentication | Use JWT for authentication | Stateless, scalable | `Authorization: Bearer <token>` | Session-based | **Required** |
| API-019 | Authentication | Include expiration in JWT | Security | `exp` claim in JWT | No expiration | **Required** |
| API-020 | Rate Limiting | Implement rate limiting | Prevent abuse | `100 requests/minute` | No rate limiting | **Required** |
| API-021 | Rate Limiting | Return `429` on rate limit | Standard | `429 Too Many Requests` | `400 Bad Request` | **Required** |
| API-022 | Rate Limiting | Include rate limit headers | Clarity | `X-RateLimit-Limit`, `X-RateLimit-Remaining` | No headers | **Recommended** |
| API-023 | Documentation | Use OpenAPI/Swagger | Auto-generated docs | FastAPI auto OpenAPI | Manual docs | **Required** |
| API-024 | Documentation | Include examples in docs | Clarity | Example requests/responses | No examples | **Required** |
| API-025 | Documentation | Document all error responses | Completeness | Document `400`, `404`, `500` | Document `200` only | **Required** |

---

## 10. Security Standards

| Standard ID | Category | Rule | Reason | Good Example | Bad Example | Enforcement |
|---|---|---|---|---|---|---|
| SEC-001 | Authentication | Use JWT for authentication | Stateless, scalable | `Authorization: Bearer <token>` | Session cookies | **Required** |
| SEC-002 | Authentication | Set JWT expiration | Security | `exp` claim (1 hour) | No expiration | **Required** |
| SEC-003 | Authentication | Use refresh tokens for long sessions | Security, UX | Short-lived access + long-lived refresh | Long-lived access tokens | **Required** |
| SEC-004 | Authorization | Implement RBAC | Least privilege | Check user role before action | No authorization | **Required** |
| SEC-005 | Authorization | Validate ownership of resources | Security | Check `user_id == resource.user_id` | No ownership check | **Required** |
| SEC-006 | Input Validation | Validate all inputs | Security (SQL injection, XSS) | Pydantic schemas, Zod validation | No validation | **Required** |
| SEC-007 | Input Validation | Sanitize user input | Security (XSS) | Escape HTML, use parameterized queries | Use raw input | **Required** |
| SEC-008 | Input Validation | Use parameterized queries | Security (SQL injection) | `SELECT * FROM users WHERE id = $1` | `f"SELECT * FROM users WHERE id = {id}"` | **Required** |
| SEC-009 | Secret Management | Use environment variables for secrets | Security | `os.getenv("DB_PASSWORD")` | Hardcoded secrets | **Required** |
| SEC-010 | Secret Management | Use secret manager for production | Security | AWS Secrets Manager | `.env` files in production | **Required** |
| SEC-011 | Secret Management | Never commit secrets to git | Security | `.gitignore` `.env` | Commit `.env` | **Required** |
| SEC-012 | SQL Injection | Use parameterized queries | Security (SQL injection) | `db.execute("SELECT * FROM users WHERE id = $1", id)` | `db.execute(f"SELECT * FROM users WHERE id = {id}")` | **Required** |
| SEC-013 | SQL Injection | Use ORM for queries | Security (SQL injection) | SQLAlchemy queries | Raw SQL | **Required** |
| SEC-014 | XSS | Escape user input in frontend | Security (XSS) | React escapes by default | `dangerouslySetInnerHTML` | **Required** |
| SEC-015 | XSS | Use Content Security Policy | Security (XSS) | CSP headers | No CSP | **Recommended** |
| SEC-016 | Rate Limiting | Implement rate limiting | Prevent abuse, DoS | `100 requests/minute` | No rate limiting | **Required** |
| SEC-017 | Rate Limiting | Use Redis for rate limiting | Performance | Redis-based rate limiter | In-memory rate limiter | **Required** |
| SEC-018 | Logging | Do not log sensitive data | Security, privacy | Log `user_id`, not `password` | Log full request body | **Required** |
| SEC-019 | Logging | Mask sensitive fields in logs | Security, privacy | `password=****` | `password=secret123` | **Required** |
| SEC-020 | Logging | Log all authentication attempts | Auditability | Log login attempts (success/failure) | No logging | **Required** |
| SEC-021 | HTTPS | Use HTTPS for all traffic | Security (encryption) | `https://` | `http://` | **Required** |
| SEC-022 | HTTPS | Enforce HTTPS redirect | Security | Redirect HTTP to HTTPS | Allow HTTP | **Required** |
| SEC-023 | CORS | Configure CORS properly | Security | Allow specific origins | `*` (allow all) | **Required** |
| SEC-024 | CORS | Do not allow all origins in production | Security | `https://dayjoy.com` | `*` | **Required** |
| SEC-025 | Headers | Use security headers | Security | `X-Frame-Options`, `X-Content-Type-Options`, `Strict-Transport-Security` | No security headers | **Recommended** |

---

## 11. Git Standards

| Standard ID | Category | Rule | Reason | Good Example | Bad Example | Enforcement |
|---|---|---|---|---|---|---|
| GIT-001 | Branching | Use `main` as primary branch | Standard convention | `main` | `master` | **Required** |
| GIT-002 | Branching | Use feature branches | Isolation, review | `feature/auth-login`, `fix/order-bug` | Commit to `main` | **Required** |
| GIT-003 | Branching | Use descriptive branch names | Clarity | `feature/distributor-kyc`, `fix/payment-bug` | `branch1`, `fix` | **Required** |
| GIT-004 | Branching | Prefix branch with type | Clear identification | `feature/`, `fix/`, `chore/`, `docs/` | No prefix | **Required** |
| GIT-005 | Commits | Use conventional commits | Clear history | `feat: add user login`, `fix: resolve payment bug` | `update code`, `fix stuff` | **Required** |
| GIT-006 | Commits | Use imperative mood | Standard convention | `Add user login` | `Added user login` | **Required** |
| GIT-007 | Commits | Keep commits atomic | Clarity, revertability | One logical change per commit | Multiple changes in one commit | **Required** |
| GIT-008 | Commits | Limit commit message to 50 chars (subject) | Readability | `feat: add user login` | `feat: add user login and also update the database schema and add new tests` | **Recommended** |
| GIT-009 | Commits | Include body for complex commits | Context | `feat: add user login\n\nImplemented JWT auth with refresh tokens` | No body | **Recommended** |
| GIT-010 | Pull Requests | Use descriptive PR titles | Clarity | `feat: Add user login with JWT` | `Update code` | **Required** |
| GIT-011 | Pull Requests | Include PR description | Context | Describe changes, testing, screenshots | Empty description | **Required** |
| GIT-012 | Pull Requests | Link related issues | Traceability | `Closes #123` | No linking | **Required** |
| GIT-013 | Pull Requests | Require code review | Quality | At least 1 reviewer approval | No review | **Required** |
| GIT-014 | Pull Requests | Pass CI before merge | Quality | Green CI checks | Ignore CI | **Required** |
| GIT-015 | Merging | Use squash merge for feature branches | Clean history | Squash and merge | Merge commit | **Recommended** |
| GIT-016 | Merging | Use rebase for small fixes | Clean history | `git rebase main` | `git merge main` | **Recommended** |
| GIT-017 | Tagging | Use semantic versioning for releases | Standard | `v1.0.0`, `v1.2.3` | `release`, `v1` | **Required** |
| GIT-018 | Tagging | Tag production releases | Traceability | `git tag -a v1.0.0 -m "Release v1.0.0"` | No tags | **Required** |
| GIT-019 | Versioning | Follow SemVer | Standard | `MAJOR.MINOR.PATCH` | `1.0`, `v1` | **Required** |
| GIT-020 | Versioning | Increment MAJOR for breaking changes | Standard | `1.0.0` → `2.0.0` | `1.0.0` → `1.0.1` | **Required** |

---

## 12. Testing Standards

| Standard ID | Category | Rule | Reason | Good Example | Bad Example | Enforcement |
|---|---|---|---|---|---|---|
| TEST-001 | Unit Tests | Write unit tests for business logic | Correctness | Test services, utilities | Test only controllers | **Required** |
| TEST-002 | Unit Tests | Use Pytest for Python, Jest for TypeScript | Standard | `test_auth.py`, `auth.test.ts` | `unittest`, `mocha` | **Required** |
| TEST-003 | Unit Tests | Use descriptive test names | Clarity | `test_login_with_valid_credentials()` | `test_login()` | **Required** |
| TEST-004 | Unit Tests | Follow AAA pattern (Arrange-Act-Assert) | Structure | `setup`, `action`, `verify` | No structure | **Recommended** |
| TEST-005 | Unit Tests | Mock external dependencies | Isolation | Mock DB, API calls | Real DB calls | **Required** |
| TEST-006 | Integration Tests | Write integration tests for APIs | End-to-end correctness | Test API endpoints | Unit tests only | **Required** |
| TEST-007 | Integration Tests | Use test database | Isolation | Test DB, not production | Production DB | **Required** |
| TEST-008 | API Tests | Test all API endpoints | Coverage | Test `GET`, `POST`, `PUT`, `DELETE` | Test `GET` only | **Required** |
| TEST-009 | API Tests | Test error cases | Robustness | Test `400`, `404`, `500` | Test `200` only | **Required** |
| TEST-010 | UI Tests | Use Playwright for E2E tests | Reliability | `test_login.spec.ts` | Selenium | **Required** |
| TEST-011 | UI Tests | Test critical user journeys | Coverage | Login, order, payment | Random tests | **Required** |
| TEST-012 | AI Evaluation | Use RAGAS for RAG evaluation | Quality | Measure faithfulness, answer relevance | No evaluation | **Recommended** |
| TEST-013 | AI Evaluation | Use LangSmith for tracing | Debugging | Trace LLM calls, prompts | No tracing | **Recommended** |
| TEST-014 | AI Evaluation | Test hallucination rate | Accuracy | Measure hallucination on test set | No testing | **Recommended** |
| TEST-015 | Coverage | Aim for 80%+ code coverage | Quality | `pytest --cov=80` | No coverage requirement | **Recommended** |
| TEST-016 | Coverage | Prioritize critical path coverage | Business value | Cover auth, orders, payments | 100% on utilities | **Required** |
| TEST-017 | CI/CD | Run tests on every PR | Quality | GitHub Actions CI | Manual testing | **Required** |
| TEST-018 | CI/CD | Block merge on test failure | Quality | CI status check | Ignore CI | **Required** |
| TEST-019 | Load Testing | Use Locust for load testing | Performance | Test API under load | No load testing | **Recommended** |
| TEST-020 | Security Testing | Use OWASP ZAP for security testing | Security | Automated security scan | No security testing | **Recommended** |

---

## 13. Documentation Standards

| Standard ID | Category | Rule | Reason | Good Example | Bad Example | Enforcement |
|---|---|---|---|---|---|---|
| DOC-001 | README | Every feature must have README | Discoverability | `features/auth/README.md` | No README | **Required** |
| DOC-002 | README | Include purpose, usage, examples | Clarity | Purpose, API endpoints, examples | One-liner | **Required** |
| DOC-003 | API Docs | Document all API endpoints | Usability | OpenAPI/Swagger | No docs | **Required** |
| DOC-004 | API Docs | Include request/response examples | Clarity | Example curl, JSON | No examples | **Required** |
| DOC-005 | Architecture | Update architecture docs on changes | Traceability | `docs/architecture/` updated | No updates | **Required** |
| DOC-006 | Architecture | Include diagrams | Clarity | Mermaid diagrams | Text only | **Recommended** |
| DOC-007 | Comments | Use docstrings for public functions | Documentation | `"""Validate user credentials."""` | No docstrings | **Required** |
| DOC-008 | Comments | Explain _why_, not _what_ | Clarity | `# Use Redis for caching to reduce DB load` | `# Increment counter` | **Recommended** |
| DOC-009 | Comments | Keep comments up-to-date | Accuracy | Update comments with code | Outdated comments | **Required** |
| DOC-010 | Examples | Include usage examples | Clarity | Example code, API calls | No examples | **Recommended** |
| DOC-011 | Changelog | Maintain CHANGELOG.md | Traceability | `CHANGELOG.md` with version history | No changelog | **Required** |
| DOC-012 | Changelog | Follow changelog format | Standard | `## [1.0.0] - 2024-01-01\n### Added\n- Feature X` | Random format | **Recommended** |
| DOC-013 | Migration | Document breaking changes | Migration guide | `docs/migrations/v2.md` | No documentation | **Required** |
| DOC-014 | Migration | Include migration steps | Actionable | Step-by-step migration | High-level only | **Required** |
| DOC-015 | Configuration | Document all environment variables | Clarity | `.env.example` with comments | No documentation | **Required** |
| DOC-016 | Configuration | Document default values | Clarity | `DAYJOY_DB_URL=postgresql://... # Default: localhost` | No defaults | **Required** |
| DOC-017 | Deployment | Document deployment process | Reproducibility | `docs/deployment.md` | No documentation | **Required** |
| DOC-018 | Deployment | Include rollback steps | Safety | Rollback procedure | No rollback | **Required** |
| DOC-019 | Troubleshooting | Include troubleshooting guide | Support | `docs/troubleshooting.md` | No guide | **Recommended** |
| DOC-020 | Troubleshooting | Document common issues | Support | FAQ, solutions | No documentation | **Recommended** |

---

## 14. Code Review Checklist

### Architecture

- [ ] Follows feature-based folder structure (PS-001 to PS-008)
- [ ] No circular dependencies
- [ ] Proper separation of concerns (controller/service/repository)
- [ ] Reuses existing modules, no duplication
- [ ] Follows dependency injection principles

### Security

- [ ] No hardcoded secrets (SEC-009 to SEC-011)
- [ ] Input validation implemented (SEC-006 to SEC-008)
- [ ] Parameterized queries used (SEC-012 to SEC-013)
- [ ] Authentication/authorization implemented (SEC-001 to SEC-005)
- [ ] No sensitive data in logs (SEC-018 to SEC-019)
- [ ] HTTPS enforced (SEC-021 to SEC-022)
- [ ] CORS configured properly (SEC-023 to SEC-024)

### Performance

- [ ] Database indexes added for queries (DB-005 to DB-006)
- [ ] No N+1 queries (DB-014 to DB-015)
- [ ] Caching implemented where appropriate
- [ ] Rate limiting implemented (SEC-016 to SEC-017)
- [ ] Pagination implemented for list endpoints (API-011 to API-012)

### Testing

- [ ] Unit tests written for business logic (TEST-001 to TEST-005)
- [ ] Integration tests for APIs (TEST-006 to TEST-009)
- [ ] Error cases tested (TEST-009)
- [ ] Tests pass on CI (TEST-017 to TEST-018)
- [ ] Coverage meets requirements (TEST-015 to TEST-016)

### Documentation

- [ ] README updated (DOC-001 to DOC-002)
- [ ] API documentation updated (DOC-003 to DOC-004)
- [ ] Architecture docs updated if needed (DOC-005 to DOC-006)
- [ ] Docstrings added for public functions (DOC-007 to DOC-009)
- [ ] Environment variables documented (DOC-015 to DOC-016)

### AI-Specific Validation

- [ ] Prompts stored in versioned files (AI-001 to AI-005)
- [ ] RAG used for factual queries (AI-011, AI-016 to AI-020)
- [ ] Tool inputs validated (AI-006 to AI-010)
- [ ] AI output validated with schema (AI-021 to AI-025)
- [ ] Hallucination prevention implemented (AI-026 to AI-030)
- [ ] Sensitive topics escalated to human (AI-025)

### Business Rule Compliance

- [ ] Follows Dayjoy business rules (e.g., 30-day return, ₹500 threshold)
- [ ] Compensation logic matches documented plan
- [ ] Policy compliance verified (e.g., no bulk purchases, single PAN)
- [ ] Escalation paths implemented for sensitive issues

---

## 15. AI Coding Assistant Guidelines

**Permanent instructions for all AI coding assistants:**

### 1. Read Project Context First

- Read `Project_Context/` documents before generating code
- Understand business rules, constraints, and architecture
- Check existing modules to avoid duplication

### 2. Follow Standards

- Follow all standards in this document
- Use correct naming conventions (Section 4)
- Follow code style (Section 3)
- Implement security standards (Section 10)

### 3. Reuse Existing Modules

- Check for existing utilities, services, components
- Do not duplicate functionality
- Extend existing modules when appropriate

### 4. Keep Code Modular

- Small, focused functions (<50 lines)
- Single responsibility per function/class
- Use dependency injection

### 5. Generate Production-Ready Code

- Include error handling
- Include logging
- Include type hints
- Include docstrings
- Do not generate TODOs for critical functionality

### 6. Explain Assumptions

- If information is missing, explain assumptions
- Ask clarifying questions if needed
- Document assumptions in code comments

### 7. Test Your Code

- Include unit tests for business logic
- Include integration tests for APIs
- Test error cases

### 8. Document Your Code

- Update README if adding new feature
- Update API documentation
- Include usage examples
- Add docstrings to public functions

### 9. Security First

- Never hardcode secrets
- Use parameterized queries
- Validate all inputs
- Do not log sensitive data

### 10. AI-Specific Rules

- Use RAG for factual queries
- Validate AI output with schema
- Mark unknowns explicitly
- Escalate sensitive topics
- Cite sources in AI responses

---

## Related Documents

- `Project_Context/00_MASTER_CONTEXT.md`
- `Project_Context/04_AI_VISION.md`
- `Project_Context/05_PERSONAS.md`
- `Project_Context/06_FEATURE_WISHLIST.md`
- `Project_Context/07_BUSINESS_PROCESSES.md`
- `Project_Context/08_CONSTRAINTS.md`
- `Project_Context/09_TECH_STACK.md`
- `Project_Context/11_ARCHITECTURE.md` (future)

---

## Appendix A: Quick Reference

### Python Naming

```python
# Variables
user_name = "John"  # snake_case

# Functions
def get_user(user_id: int) -> User:
    """Get user by ID."""

# Classes
class UserService:
    """Service for user operations."""

# Constants
MAX_RETRY_COUNT = 3

# Private
_internal_method()
```

### TypeScript Naming

```typescript
// Variables
const userName = "John";  // camelCase

// Functions
function getUser(userId: number): User {
  // ...
}

// Classes/Components
class UserService {
  // ...
}

// Components
const UserCard = () => {
  // ...
};

// Interfaces
interface User {
  id: number;
  name: string;
}

// Types
type UserRole = "ADMIN" | "USER";  // PascalCase for type, UPPER_CASE for values
```

### API Endpoints

```
GET    /api/v1/users              # List users
GET    /api/v1/users/{id}         # Get user by ID
POST   /api/v1/users              # Create user
PUT    /api/v1/users/{id}         # Update user
DELETE /api/v1/users/{id}         # Delete user
```

### Git Workflow

```bash
# Create feature branch
git checkout -b feature/user-login

# Commit with conventional commits
git commit -m "feat: add user login with JWT"

# Push and create PR
git push origin feature/user-login

# After review, squash and merge
```

---

**END OF DOCUMENT**