FROM python:3.12-slim

# Install minimal dependencies (uv binary)
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

# Create non-root user
RUN addgroup --system appuser && adduser --system --ingroup appuser appuser

# Copy project files
COPY requirements.txt .
COPY pyproject.toml* uv.lock* ./

# Install dependencies using uv (as root)
RUN uv sync --frozen --no-cache

# Copy source code
COPY src ./src
COPY scripts ./scripts

# Pre-download Hugging Face models (as root so cache is created)
RUN uv run python scripts/download_models.py

# Give ownership to appuser
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

EXPOSE 8000

# Health check
HEALTHCHECK CMD curl -f http://localhost:8000/health || exit 1

# Run application   
CMD ["uv", "run", "uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
