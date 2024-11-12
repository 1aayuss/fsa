FROM python:3.9-alpine

WORKDIR /app

RUN apk add --no-cache --virtual .build-deps \
    gcc \
    musl-dev \
    python3-dev \
    libffi-dev \
    postgresql-dev

RUN apk add --no-cache \
    libpq \
    gettext

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

RUN apk del .build-deps

COPY . .

RUN mkdir -p /app/staticfiles && \
    python manage.py collectstatic --noinput

RUN ls -la /app/staticfiles

EXPOSE 8010

CMD ["gunicorn", "--bind", "0.0.0.0:8010", "file_sharing.wsgi:application"]
