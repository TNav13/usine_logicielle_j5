# Stage 1: Build
FROM python:3.12-slim as builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# Stage 2: Run
FROM python:3.12-slim
WORKDIR /app
# Copie des dependances installees dans le stage precedent
COPY --from=builder /root/.local /root/.local
# Copie du code source
COPY src/ ./src/

# Ajout du path pour les binaires python (gunicorn)
ENV PATH=/root/.local/bin:$PATH

# Health check
HEALTHCHECK --interval=30s --timeout=5s --retries=3 CMD curl -f http://localhost:5000/health || exit 1

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "src.app:app"]
