# CVForge — Full-Stack DevOps Portfolio Project

> A production-grade CV builder deployed on AWS EC2 with
> a complete DevOps pipeline from code to live infrastructure.

---

## 🏗️ Architecture Overview
```
                    Internet
                       │
                  ┌────▼─────┐
                  │  nginx   │  SSL/TLS termination
                  │container │  Rate limiting
                  └────┬─────┘  Security headers
                       │
          ┌────────────┼────────────┐
          │                         │
    ┌─────▼──────┐         ┌───────▼──────┐
    │  Node.js   │         │  PostgreSQL  │
    │  Express   │◄────────│  Database    │
    │  container │         │  container   │
    └────────────┘         └──────────────┘
          │
    Docker Network (bridge)
    All containers isolated
    Only ports 80/443 exposed
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Frontend | HTML, CSS, Vanilla JavaScript |
| Backend | Node.js, Express.js |
| Database | PostgreSQL 16 |
| Authentication | JWT + bcrypt |
| Containerization | Docker, Docker Compose |
| Web Server | nginx (reverse proxy + SSL) |
| CI/CD | GitHub Actions |
| Cloud | AWS EC2 (Ubuntu 22.04) |
| SSL | Let's Encrypt (auto-renew) |
| Process Manager | PM2 → replaced by Docker |

---

## 🚀 DevOps Highlights

### Docker Multi-Stage Build
- Stage 1 builds dependencies
- Stage 2 runs as non-root user
- Final image is minimal and secure

### Docker Compose Orchestration
- 3 isolated containers (nginx, api, postgres)
- Health checks on all services
- Automatic restart on failure
- Named volumes for data persistence
- Private bridge network — only nginx exposed

### CI/CD Pipeline (GitHub Actions)
- Triggers on every push to main
- SSH into EC2 and pulls latest code
- Rebuilds Docker containers automatically
- Verifies deployment health
- Zero manual deployment steps

### nginx Configuration
- SSL/TLS termination with Let's Encrypt
- HTTP → HTTPS redirect
- Rate limiting (10 req/s per IP)
- Stricter limits on auth endpoints
- Security headers (HSTS, XSS, CSP)
- Static asset caching

### Security Best Practices
- Non-root user inside containers
- Secrets via environment variables
- .env never committed to git
- PostgreSQL not exposed to internet
- JWT token blacklisting on logout
- bcrypt password hashing (12 rounds)

---

## 📁 Project Structure
```
cvforge/
├── .github/
│   └── workflows/
│       └── deploy.yml        ← CI/CD pipeline
├── config/
│   └── db.js                 ← PostgreSQL connection pool
├── controllers/
│   ├── authController.js     ← JWT auth logic
│   └── recruiterController.js← Search logic
├── middleware/
│   └── auth.js               ← JWT verification
├── routes/
│   ├── auth.js               ← /api/auth/*
│   └── recruiter.js          ← /api/recruiter/*
├── sql/
│   └── auth_schema.sql       ← Database schema (11 tables)
├── nginx/
│   └── nginx.conf            ← Production nginx config
├── frontend/
│   ├── index.html            ← CV Builder (no login needed)
│   ├── auth.html             ← Login / Register
│   └── recruiter.html        ← Recruiter search
├── Dockerfile                ← Multi-stage build
├── docker-compose.yml        ← 3-container orchestration
└── server.js                 ← Express entry point
```

---

## ⚡ Run Locally with Docker
```bash
# Clone the repo
git clone https://github.com/umerspamn/CV-Forge.git
cd CV-Forge

# Create environment file
cp .env.example .env
# Fill in DB_PASSWORD and JWT_SECRET

# Start all 3 containers
docker compose up -d

# Check status
docker compose ps

# View logs
docker compose logs -f
```

App runs at `http://localhost`

---

## 🗄️ Database Schema

11 PostgreSQL tables:
```
users               → authentication + profiles
sessions            → JWT token blacklisting
cvs                 → CV documents
experience          → work history
education           → qualifications
skills              → skill groups with levels
projects            → portfolio projects
skill_project_links → many-to-many junction table
certifications      → certificates
public_profiles     → recruiter search index
pdf_downloads       → analytics
```

---

## 🔄 CI/CD Flow
```
Developer pushes to main branch
           │
           ▼
   GitHub Actions triggered
           │
           ▼
   SSH into EC2 server
           │
           ▼
   git pull origin main
           │
           ▼
   docker compose up -d --build
           │
           ▼
   Health check verification
           │
           ▼
   ✅ Deployment complete
```

---

## 📊 API Endpoints
```
POST   /api/auth/register    Register new account
POST   /api/auth/login       Login + get JWT token
POST   /api/auth/logout      Revoke token
GET    /api/auth/me          Get current user
POST   /api/auth/change-password

GET    /api/recruiter/search          Search public profiles
GET    /api/recruiter/profile/:cvId   View full CV
GET    /api/recruiter/stats           Dashboard stats
GET    /health                        Server health check
```

---

## 🔐 Environment Variables
```env
PORT=3000
DB_HOST=postgres
DB_PORT=5432
DB_NAME=cvforge
DB_USER=cvforge_app
DB_PASSWORD=***
JWT_SECRET=***
JWT_EXPIRES_IN=7d
CORS_ORIGINS=https://yourdomain.com
BCRYPT_ROUNDS=12
```

---

## 👨‍💻 Author

**Umer** — Undergraduate Software Engineering Student  
Sir Syed University of Engineering and Technology, Karachi  
Seeking Cloud Engineering / DevOps opportunities

[![GitHub](https://img.shields.io/badge/GitHub-umerspamn-black)](https://github.com/umerspamn)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue)](https://linkedin.com/in/YOUR_LINKEDIN)# CVForge — ATS CV Builder
Live at: https://cvforge.duckdns.org
# CVForge — Full-Stack DevOps Portfolio Project

> A production-grade CV builder deployed on AWS EC2 with
> a complete DevOps pipeline from code to live infrastructure.
