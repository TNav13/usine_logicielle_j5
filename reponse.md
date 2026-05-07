# Compte-rendu - TP 5 : Livraison Continue (CD)

**Étudiant** : [Ton Nom]
**Cours** : Usine Logicielle - Master 1 DevOps
**Date** : 7 mai 2026

#### Question 1 : Expliquez chaque instruction du Dockerfile. Pourquoi copie-t-on requirements.txt avant le code source ?
- `FROM python:3.12-slim` : Image de base légère avec Python 3.12.
- `WORKDIR /app` : Définit le dossier de travail.
- `COPY requirements.txt .` : Copie le fichier de dépendances.
- `RUN pip install --no-cache-dir -r requirements.txt` : Installe les dépendances sans cache pour optimiser la taille.
- `COPY src/ ./src/` : Copie le code source.
- `HEALTHCHECK` : Vérifie la santé de l'application sur `/health`.
- `EXPOSE 5000` : Port d'écoute.
- `CMD` : Lance l'application avec gunicorn.

**Pourquoi copier `requirements.txt` avant ?** Pour utiliser le cache des couches de Docker. Les dépendances changent moins souvent que le code ; les installer avant permet de gagner du temps lors des builds suivants.

#### Question 2 : Quelle est la différence entre une VM et un container Docker ? Quel est l'avantage principal des containers ?
Une VM virtualise le matériel et embarque un OS complet, ce qui est lourd. Un conteneur partage le noyau de l'OS hôte et n'isole que l'application. L'avantage principal est la **légèreté** et la **portabilité**.

#### Question 3 : Quel est l'intérêt de Docker Compose par rapport à un simple docker run ? Dans quel cas Docker Compose devient-il indispensable ?
Docker Compose permet de centraliser la configuration dans un fichier YAML. Il devient indispensable pour gérer des applications **multi-services** (ex: API + Base de données) et leurs interactions.

#### Question 4 : Pourquoi tagger une image avec plusieurs tags (SHA, version, latest) ? Pourquoi ne doit-on pas utiliser :latest en production ?
Le SHA assure la traçabilité, la version la lisibilité, et `latest` la facilité d'accès à la dernière version. On évite `latest` en production car il est **muable** : un déploiement pourrait récupérer une version non testée par accident.

#### Question 5 : Qu'est-ce qu'un registre de conteneurs ? Comparez ghcr.io, Docker Hub et Google Artifact Registry.
C'est un entrepôt d'images. `ghcr.io` est intégré à GitHub, `Docker Hub` est le standard public, et `Artifact Registry` est la solution entreprise de Google Cloud.

#### Question 6 : Pourquoi teste-t-on le conteneur dans la CI avant de le pousser sur le registre ?
Pour garantir que l'image construite est réellement fonctionnelle et éviter de polluer le registre avec des images corrompues qui pourraient faire échouer les déploiements.

#### Question 7 : Expliquez la condition if: github.ref == 'refs/heads/main'. Pourquoi le build Docker ne se déclenche-t-il pas sur les Pull Requests ?
Cette condition limite l'exécution du job à la branche `main`. On ne déclenche pas le build/push sur les PR pour ne pas publier d'images provenant de code non encore validé et mergé.

#### Question 8 : Pourquoi utilise-t-on ${{ github.sha }} comme tag d'image ? Quel avantage par rapport à un numéro de version manuel ?
Le SHA est unique et généré automatiquement pour chaque commit, garantissant une **immuabilité** parfaite et une traçabilité directe entre une image et son code source exact, sans risque d'erreur humaine.

#### Question 9 : Qu'est-ce qu'un rollback ? Pourquoi est-il essentiel de versionner les images Docker avec des tags précis ?
Un **rollback** consiste à revenir à une version précédente fonctionnelle de l'application en cas d'erreur sur la nouvelle version. Versionner avec des tags précis (comme le SHA) est indispensable pour identifier sans ambiguïté l'image stable à laquelle on souhaite revenir.

#### Question 10 : Expliquez la différence entre Continuous Delivery et Continuous Deployment. Lequel avez-vous mis en place dans ce TP ?
La **Continuous Delivery** automatise le build et les tests jusqu'à la mise à disposition d'un livrable (l'image Docker sur le registre), mais le déploiement final nécessite une action humaine. Le **Continuous Deployment** automatise le déploiement jusqu'à la production. Dans ce TP, nous avons mis en place la **Continuous Delivery**.

#### Question 11 : Quels risques pose le déploiement automatique ? Comment les atténuer ?
Le déploiement automatique peut introduire des bugs en production si les tests ne sont pas parfaits. On atténue ces risques avec des **tests automatisés exhaustifs**, des **déploiements progressifs** et un **monitoring en temps réel** permettant un rollback rapide.

#### Question 12 : Expliquez le principe du multi-stage build. Quel est l'avantage en termes de taille et de sécurité ? Montrez votre Dockerfile modifié et la différence de taille.
Le **multi-stage build** permet d'utiliser plusieurs étapes de build. On utilise une image complète pour préparer l'environnement, puis on ne copie que le strict nécessaire dans une image finale ultra-légère.
- **Taille** : On gagne plusieurs centaines de Mo en supprimant les outils de build et les caches.
- **Sécurité** : L'image finale contient moins de binaires, ce qui réduit les vulnérabilités potentielles.

**Dockerfile optimisé :**
```dockerfile
# Stage 1: Build
FROM python:3.12-slim as builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# Stage 2: Run
FROM python:3.12-slim
WORKDIR /app
COPY --from=builder /root/.local /root/.local
COPY src/ ./src/
ENV PATH=/root/.local/bin:$PATH
EXPOSE 5000
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "src.app:app"]
```
Lien : https://docs.docker.com/build/building/multi-stage/
