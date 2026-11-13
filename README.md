# Boussole des mesures — Docker

- `index.html` : l'application (fichier unique).
- **Dev** : `make dev` (ou `docker compose --profile dev up --build`) → http://localhost:3000
  Le fichier `index.html` est monté en volume : chaque sauvegarde recharge le navigateur.
- **Prod** : `make prod` (ou `docker compose --profile prod up -d --build`) → http://localhost:8080
  Image nginx non-root, en lecture seule, avec en-têtes de sécurité et CSP stricte (aucune requête externe).
- Arrêt : `make stop`.

Les avis sont enregistrés dans le navigateur (localStorage) ; ils ne passent jamais par le serveur.
