FROM python:3.9-alpine

WORKDIR /app

# Install build dependencies
RUN apk add --no-cache --virtual .build-deps \
    gcc \
    musl-dev \
    python3-dev \
    libffi-dev \
    postgresql-dev

# Install runtime dependencies
RUN apk add --no-cache \
    libpq \
    gettext

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Remove build dependencies
RUN apk del .build-deps

# Copy project files into the container
COPY . .

RUN mkdir -p /app/staticfiles && \
    python manage.py collectstatic --noinput

RUN ls -la /app/staticfiles

# Expose application port
EXPOSE 8010

CMD ["gunicorn", "--bind", "0.0.0.0:8010", "file_sharing.wsgi:application"]
