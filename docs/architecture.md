# Architecture de départ pour WextraChess

Ce document sert de base de travail pour construire une application type chess.com pour `ft_transcendence`.

## 1. Objectif produit

Construire une application web d'échecs jouable, stable et évolutive, avec:

- authentification et gestion de profils,
- parties en temps réel,
- historique et statistiques,
- classement,
- chat et présence en ligne,
- base technique propre pour ajouter des modules plus tard.

## 2. Stack conseillée

### Frontend

- React
- TypeScript
- Vite
- Socket.IO client
- UI simple mais soignée, responsive dès le début

### Backend

- NestJS
- TypeScript
- Socket.IO
- validation des données côté serveur
- gestion centralisée de l'auth, du jeu et des notifications

### Base de données

- PostgreSQL
- Prisma comme ORM

### Infra

- Docker Compose
- Nginx en reverse proxy
- HTTPS via certificat local ou configuration d'infra dédiée

## 3. Pourquoi cette architecture

- React + Vite donne une base rapide à développer et facile à maintenir.
- NestJS force une structure claire, utile pour une équipe débutante.
- Prisma simplifie les modèles de données et les migrations.
- Socket.IO est adapté aux parties en temps réel, au chat et au statut connecté.
- PostgreSQL reste fiable pour les relations entre utilisateurs, parties, classements et statistiques.

## 4. Découpage des grandes parties

### 4.1 Authentification et utilisateurs

Fonctions prévues:

- inscription et connexion,
- déconnexion,
- profil utilisateur,
- avatar,
- mot de passe hashé,
- gestion de session ou jeton sécurisé,
- éventuellement OAuth 42 plus tard.

### 4.2 Moteur de jeu

Fonctions prévues:

- création d'une partie,
- gestion des coups légaux,
- horloge si vous la gardez dans le scope,
- fin de partie,
- abandon,
- match nul,
- victoire/défaite,
- historique complet de la partie.

### 4.3 Temps réel

Fonctions prévues:

- matchmaking,
- entrée dans une room de jeu,
- synchronisation des coups,
- chat de partie,
- présence en ligne,
- mode spectateur si ajouté.

### 4.4 Social et progression

Fonctions prévues:

- liste d'amis,
- invitations,
- statistiques,
- classement Elo ou système équivalent,
- historique des parties,
- achievements si vous avez le temps.

### 4.5 Infra et qualité

Fonctions prévues:

- dockerisation complète,
- lancement unique du projet,
- logs de base,
- validations,
- séparation claire des responsabilités,
- documentation propre.

## 5. Structure de dossier cible

```text
WextraChess/
├── backend/
│   ├── src/
│   │   ├── auth/
│   │   ├── users/
│   │   ├── games/
│   │   ├── matchmaking/
│   │   ├── chat/
│   │   ├── leaderboard/
│   │   ├── notifications/
│   │   ├── prisma/
│   │   └── main.ts
│   └── Dockerfile
├── frontend/
│   ├── src/
│   │   ├── pages/
│   │   ├── components/
│   │   ├── features/
│   │   ├── hooks/
│   │   ├── services/
│   │   └── main.tsx
│   └── Dockerfile
├── database/
│   └── Dockerfile
├── docs/
│   └── architecture.md
└── docker-compose.yml
```

## 6. Modèle de données initial

Tables principales à prévoir:

- users
- sessions ou refresh_tokens
- profiles
- friendships
- games
- game_moves
- game_participants
- chat_messages
- leaderboard_snapshots ou computed_rating
- notifications

Champs utiles au départ:

- `users.id`
- `users.email`
- `users.username`
- `users.password_hash`
- `users.avatar_url`
- `users.created_at`
- `games.id`
- `games.status`
- `games.white_player_id`
- `games.black_player_id`
- `games.winner_id`
- `games.started_at`
- `games.finished_at`
- `game_moves.game_id`
- `game_moves.move_number`
- `game_moves.from_square`
- `game_moves.to_square`
- `game_moves.promotion_piece`

## 7. Choix techniques de gameplay

Pour éviter de se bloquer trop tôt:

- le backend doit rester source de vérité pour l'état de partie,
- le frontend affiche l'état et envoie les actions,
- le moteur d'échecs peut être implémenté côté backend d'abord,
- la gestion de board peut être un module séparé pour rester testable.

## 8. Roadmap conseillée

### Phase 1: socle

- créer le monorepo,
- lancer Docker Compose,
- connecter PostgreSQL,
- préparer NestJS et React,
- mettre la base de l'auth.

### Phase 2: jeu local

- afficher un échiquier,
- déplacer les pièces,
- valider les coups,
- détecter les fins de partie,
- stocker une partie en base.

### Phase 3: temps réel

- ajouter Socket.IO,
- synchroniser deux joueurs,
- gérer les rooms,
- ajouter le chat.

### Phase 4: progression

- historique,
- classement,
- profil public,
- matchmaking,
- amis et notifications.

### Phase 5: polish

- accessibilité,
- responsive,
- sécurité,
- documentation,
- déploiement propre.

## 9. Modules à privilégier

Priorité élevée pour ce projet:

- Web
- User Management
- Gaming and user experience
- Devops
- Accessibility and Internationalization

Priorité secondaire si le socle est déjà stable:

- Data and Analytics
- Artificial Intelligence
- Cybersecurity

Modules à éviter au début si l'équipe débute:

- Blockchain

## 10. Règle de travail recommandée

- ne pas commencer par les bonus,
- livrer une partie jouable rapidement,
- garder chaque module indépendant,
- documenter chaque décision technique,
- tester le moteur d'échecs dès qu'il existe.
