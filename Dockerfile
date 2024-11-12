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

# Create STATIC_ROOT directory and collect static files
RUN mkdir -p /app/staticfiles && \
    python manage.py collectstatic --noinput

# Debugging: Check static files and directory contents
RUN ls -la /app/staticfiles

# Expose application port
EXPOSE 8010

# Run the application
CMD ["gunicorn", "--bind", "0.0.0.0:8010", "file_sharing.wsgi:application"]
