# Compte-rendu - TP4 Sécurité dans l'usine logicielle

**Auteur :** Binôme d'étudiants M1 DevOps (Sup de Vinci)

## Partie 1 — Scan de dépendances avec pip-audit

### 1.1 et 1.2 — Expérimentation locale
J'ai testé `pip-audit` sur notre projet. Bien que quelques vulnérabilités mineures soient présentes dans l'environnement global, l'outil est très efficace. En simulant une vulnérabilité avec `flask==2.0.0`, j'ai pu observer que l'outil identifie précisément la version fautive, l'ID de la vulnérabilité (CVE/GHSA) et les versions de correction (2.2.5 ou 2.3.2).

### Questions
**Question 1 : Qu'est-ce qu'une CVE ? Expliquez le score CVSS et donnez un exemple de CVE avec son impact.**

*   **CVE (Common Vulnerabilities and Exposures) :** C'est un dictionnaire de vulnérabilités de sécurité informatique rendu public. Chaque entrée (ex: CVE-2023-30861) décrit une faille spécifique dans un logiciel ou un matériel.
*   **Score CVSS (Common Vulnerability Scoring System) :** C'est un système de notation (de 0 à 10) qui permet d'évaluer la sévérité d'une vulnérabilité. Il prend en compte des critères comme la facilité d'exploitation, l'impact sur la confidentialité, l'intégrité et la disponibilité des données. Un score au-dessus de 7.0 est généralement considéré comme critique ou élevé.
*   **Exemple :** La CVE-2023-30861 dans Flask (CVSS 7.5). Elle permettait une fuite de cookies de session via des serveurs proxy de mise en cache, ce qui pouvait permettre à un attaquant de voler une session utilisateur.

**Question 2 : Pourquoi est-il important de scanner les dépendances et pas seulement votre propre code ?**

Il est crucial de scanner les dépendances car une application moderne repose majoritairement sur du code tiers (bibliothèques open-source). On parle de **sécurité de la "Supply Chain"**. Même si mon propre code est parfaitement sécurisé, si une bibliothèque que j'utilise (comme Flask ou Requests) possède une faille connue, mon application devient vulnérable. Les attaquants ciblent souvent ces dépendances populaires car elles offrent un point d'entrée sur de très nombreux systèmes simultanément.

## Partie 2 — Dependabot : mises à jour automatiques

J'ai configuré Dependabot pour automatiser la surveillance et la mise à jour de nos dépendances Python et de nos Actions GitHub.

### Question
**Question 3 : Quel est l'avantage de Dependabot par rapport à un scan manuel avec pip-audit ? Pourquoi configure-t-on aussi l'écosystème github-actions ?**

*   **Avantage de Dependabot :** Contrairement à `pip-audit` qui est un outil de détection (il nous dit ce qui ne va pas), Dependabot est un outil de **remédiation proactive**. Il surveille les dépôts en continu et, dès qu'une mise à jour (de sécurité ou non) est disponible, il crée automatiquement une Pull Request avec les changements nécessaires. Cela réduit la "dette de sécurité" sans intervention manuelle constante.
*   **Écosystème github-actions :** Les Actions GitHub que nous utilisons sont aussi des logiciels tiers qui peuvent avoir des vulnérabilités ou devenir obsolètes. Les scanner permet de s'assurer que notre infrastructure de CI/CD est toujours basée sur des versions stables et sécurisées.

## Partie 3 — Gestion des secrets avec GitHub Secrets

J'ai intégré l'utilisation des secrets GitHub pour éviter de stocker des informations sensibles en dur dans le code.

### Question
**Question 4 : Pourquoi ne doit-on jamais mettre un secret directement dans le code source ? Citez 3 endroits où stocker des secrets de manière sécurisée.**

*   **Pourquoi pas en dur ?** Si un secret est dans le code source, toute personne ayant accès au dépôt (même en lecture) peut le voir. Si le dépôt est public, il est exposé au monde entier. De plus, une fois commités, les secrets restent dans l'historique Git même si on les supprime plus tard. Des outils automatisés scannent en permanence GitHub à la recherche de clés API fuyant ainsi.
*   **3 endroits sécurisés :**
    1.  **Gestionnaires de secrets (Vaults) :** HashiCorp Vault, AWS Secrets Manager, GCP Secret Manager.
    2.  **Secrets de plateforme CI/CD :** GitHub Secrets, GitLab CI/CD Variables.
    3.  **Variables d'environnement locales :** Chargées via un fichier `.env` (exclu du commit via `.gitignore`) ou configurées sur le serveur d'exécution.
