# syntax=docker/dockerfile:1

# ---------- base commune ----------
FROM nginxinc/nginx-unprivileged:1.27-alpine AS prod
COPY nginx.prod.conf /etc/nginx/conf.d/default.conf
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget -qO- http://127.0.0.1:8080/healthz || exit 1

# ---------- dev : rechargement automatique ----------
FROM node:22-alpine AS dev
WORKDIR /app
RUN npm install -g browser-sync@3
EXPOSE 3000
CMD ["browser-sync", "start", "--server", "/app", "--files", "/app/index.html", "--host", "0.0.0.0", "--port", "3000", "--no-open", "--no-notify", "--no-ui"]
