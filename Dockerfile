FROM python:3.12-slim

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

# Create app directory first
RUN mkdir -p /app

# Create non-root user WITH home directory
RUN addgroup --system appuser && \
    adduser --system --ingroup appuser --home /app --shell /bin/sh appuser

# Set proper HOME and cache
ENV HOME=/app
ENV XDG_CACHE_HOME=/app/.cache

# Copy dependency files
COPY requirements.txt .
COPY pyproject.toml* uv.lock* ./

# Install dependencies (as root)
RUN uv sync --frozen --no-cache

# Copy source
COPY src ./src
COPY scripts ./scripts

# Create cache directory
RUN mkdir -p /app/.cache && \
    chown -R appuser:appuser /app

# Switch to non-root
USER appuser

EXPOSE 8000

HEALTHCHECK CMD curl -f http://localhost:8000/health || exit 1

CMD ["uv", "run", "uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
