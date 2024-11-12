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

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Remove build dependencies
RUN apk del .build-deps

COPY . .

# Create STATIC_ROOT directory
RUN mkdir -p /app/staticfiles

# Collect static files
RUN python manage.py collectstatic --noinput

# Debugging: Check environment variables and directories
RUN ls -la /app/staticfiles

EXPOSE 8010

CMD ["gunicorn", "--bind", "0.0.0.0:8010", "file_sharing.wsgi:application"]
