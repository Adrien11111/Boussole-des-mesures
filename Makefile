.PHONY: dev test analyze web macos prod stop logs

dev:     ; flutter run -d chrome
test:    ; flutter test
analyze: ; flutter analyze
web:     ; flutter build web --release --no-web-resources-cdn
macos:   ; flutter build macos --release
prod:    ; docker compose --profile prod up -d --build
stop:    ; docker compose --profile prod down
logs:    ; docker compose --profile prod logs -f
