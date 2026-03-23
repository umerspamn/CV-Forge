# ─────────────────────────────────────────────
#  CVForge API — Dockerfile
#  Multi-stage build:
#    Stage 1 (builder): installs all dependencies
#    Stage 2 (runner):  only copies what is needed
#                       smaller final image, more secure
# ─────────────────────────────────────────────

# ── STAGE 1: Builder ──────────────────────────
FROM node:20-alpine AS builder

# Set working directory inside container
WORKDIR /app

# Copy package files first (Docker layer caching)
# If package.json hasn't changed, this layer is reused
COPY package*.json ./

# Install ALL dependencies including devDependencies
RUN npm ci

# Copy the rest of the source code
COPY . .

# ── STAGE 2: Production runner ────────────────
FROM node:20-alpine AS runner

# Install dumb-init for proper signal handling
# (allows graceful shutdown inside containers)
RUN apk add --no-cache dumb-init

# Create non-root user for security
# Running as root inside containers is bad practice
RUN addgroup -S cvforge && adduser -S cvforge -G cvforge

WORKDIR /app

# Copy only production dependencies from builder
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app .

# Set ownership to non-root user
RUN chown -R cvforge:cvforge /app

# Switch to non-root user
USER cvforge

# Expose the port the API runs on
EXPOSE 3000

# Health check — Docker will monitor this
# If it fails 3 times, container is marked unhealthy
HEALTHCHECK --interval=30s --timeout=10s --start-period=15s --retries=3 \
  CMD wget -qO- http://localhost:3000/health || exit 1

# Start the app using dumb-init for proper signal handling
CMD ["dumb-init", "node", "server.js"]
