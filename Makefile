dev:   ; docker compose --profile dev up --build
prod:  ; docker compose --profile prod up -d --build
stop:  ; docker compose --profile dev --profile prod down
logs:  ; docker compose --profile prod logs -f
