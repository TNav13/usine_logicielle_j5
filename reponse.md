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
