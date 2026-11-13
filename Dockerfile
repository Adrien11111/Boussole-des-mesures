# syntax=docker/dockerfile:1

# ---------- build : Flutter web ----------
# L'image fournit Flutter 3.44 / Dart 3.12 (pubspec : sdk ^3.12.0).
ARG FLUTTER_IMAGE=ghcr.io/cirruslabs/flutter:3.44.0
FROM ${FLUTTER_IMAGE} AS build
WORKDIR /app
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get
COPY . .
# --no-web-resources-cdn : CanvasKit est embarqué, aucune requête externe (CSP stricte).
RUN flutter build web --release --no-web-resources-cdn

# ---------- prod : nginx non-root ----------
FROM nginxinc/nginx-unprivileged:1.27-alpine AS prod
COPY nginx.prod.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget -qO- http://127.0.0.1:8080/healthz || exit 1
