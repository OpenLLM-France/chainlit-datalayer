FROM python:3.12-slim

# Install system dependencies and Node.js
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       curl \
       ca-certificates \
       gnupg \
    # Add NodeSource repo for Node.js 18.x
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*


# Set working directory
WORKDIR /app

# Copy dependency descriptors
COPY pyproject.toml uv.lock package.json package-lock.json /app/

# Install Node dependencies (Prisma CLI)
RUN npm ci --omit=optional

# Install Poetry (if your project uses Poetry) and project dependencies
RUN pip3 install uv && \
uv python install 3.12.7 && \
    uv python pin 3.12.7 && \
    uv sync --no-dev

# Copy application source code
COPY . /app
ENV PYTHONPATH=/app

RUN chmod +x /app/entrypoint.sh
ENTRYPOINT ./entrypoint.sh