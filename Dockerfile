# Dockerfile pour simplon-finance4all-front-1

# Étape 1: Build de l'application
FROM node:18-alpine AS build-stage-front-1

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers de dépendances
COPY package*.json ./

# Installer les dépendances
RUN npm ci

# Copier le code source
COPY . .

# Construire l'application
RUN npm run build

# Étape 2: Serveur de production
FROM nginx:alpine AS production-stage-front-1

# Copier la configuration nginx personnalisée
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copier les fichiers build depuis l'étape précédente (Vite génère dans dist/)
COPY --from=build-stage-front-1 /app/dist /usr/share/nginx/html

# Exposer le port 80
EXPOSE 80

# Labels pour le metadata
LABEL maintainer="simplon-finance4all-team"
LABEL project="simplon-finance4all-front-1"
LABEL version="1.0"
LABEL description="Frontend application for Finance4All - Simplon project"

# Démarrer nginx
CMD ["nginx", "-g", "daemon off;"]