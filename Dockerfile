# Stage 1: Build
FROM python:3.12-slim as builder
WORKDIR /app
COPY requirements.txt .
# Installation des dependances dans un dossier local utilisateur
RUN pip install --no-cache-dir --user -r requirements.txt

# Stage 2: Run
FROM python:3.12-slim
WORKDIR /app

# On ne copie que les dependances installees (sans les outils de build)
COPY --from=builder /root/.local /root/.local
COPY src/ ./src/

# Mise a jour du PATH pour trouver gunicorn
ENV PATH=/root/.local/bin:$PATH

# Health check
HEALTHCHECK --interval=30s --timeout=5s --retries=3 CMD curl -f http://localhost:5000/health || exit 1

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "src.app:app"]
