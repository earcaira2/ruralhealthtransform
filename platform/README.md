# RHTP Decision Support Platform

**Rural Health Transformation Program · A&M Public Sector Services**  
Montana Implementation · v0.1.0

---

## Stack
- **Database:** PostgreSQL 16 (Docker)
- **ORM:** Prisma
- **Backend:** Node.js + Express
- **Frontend:** React + D3.js + Mapbox GL *(Phase 3)*

---

## Quick Start

### 1. Prerequisites
- Docker Desktop running
- Node.js 20+

### 2. Environment setup
```bash
cp .env.example .env
```

### 3. Start the database
```bash
docker-compose up -d
```
PostgreSQL available at `localhost:5432`  
pgAdmin UI available at `http://localhost:5050`

### 4. Install backend dependencies
```bash
cd backend
npm install
```

### 5. Run database migrations
```bash
npx prisma migrate dev --schema=../db/schema.prisma --name init
```

### 6. Seed data
```bash
npm run db:seed
```

### 7. Start the API server
```bash
npm run dev
```
API available at `http://localhost:3001`  
Health check: `http://localhost:3001/health`

---

## Database Schema Layers
| Layer | Purpose |
|-------|---------|
| 1 — Reference | State-agnostic reusable models (states, counties, service lines) |
| 2 — Montana Data | Implementation data (facilities, financials, flows, pricing) |
| 3 — Scenario Engine | Scenarios, assumptions, network states, results |
| 4 — Optimization | Recommendations, Pareto frontiers, policy levers |

---

## API Routes
| Route | Description |
|-------|-------------|
| `GET /health` | Server health check |
| `GET /api/facilities` | All facilities |
| `GET /api/pricing` | Pricing records |
| `GET /api/flows` | Patient flows |
| `GET /api/finance` | Financial data |
| `GET /api/scenarios` | Scenarios |
| `GET /api/network` | Network graph data |

---

## Build Sequence
- [x] Phase 1 — Foundation (DB + API skeleton)
- [ ] Phase 2 — Data seeding (pricing, finance, flows)
- [ ] Phase 3 — Network model + cascade logic
- [ ] Phase 4 — Scenario engine
- [ ] Phase 5 — Optimization + Pareto
- [ ] Phase 6 — React frontend
