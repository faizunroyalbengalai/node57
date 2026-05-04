# ─────────────────────────────────────────────
# Stage 1: Builder — install all dependencies
# ─────────────────────────────────────────────
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files first for layer caching
COPY package*.json ./

# Install all dependencies (including devDependencies for potential build steps)
RUN npm ci --frozen-lockfile

# Copy application source
COPY . .

# ─────────────────────────────────────────────
# Stage 2: Production — lean runtime image
# ─────────────────────────────────────────────
FROM node:20-alpine AS production

# Install dumb-init for proper signal handling
RUN apk add --no-cache dumb-init

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install only production dependencies
RUN npm ci --frozen-lockfile --omit=dev && \
    npm cache clean --force

# Copy application source from builder
COPY --from=builder --chown=nodejs:nodejs /app/src ./src

# Create logs directory with correct permissions
RUN mkdir -p logs && chown nodejs:nodejs logs

# Switch to non-root user
USER nodejs

# Expose application port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=15s --retries=3 \
  CMD wget -qO- http://localhost:3000/health || exit 1

# Use dumb-init to handle signals correctly
ENTRYPOINT ["dumb-init", "--"]

CMD ["node", "src/server.js"]