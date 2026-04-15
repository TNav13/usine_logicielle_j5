1. **Quelle est la différence entre un linter et un formatter ? Donnez un exemple de chaque en Python**

Un *linter* est un outil d'analyse de code à la recherche d'erreur de syntaxe, de bogue potentel... Ils signalent les erreurs, avertissmeents, suggestions.

Tandis qu'un *formatteur* sont des outils qui formatent automatiquement le code selon un ensemble de règles ou de guide de style. Ils peuvent corriger l'indentation, espacement, alignement et saute de ligne.

Formateur: `black`
Linter: `Ruff`

2.
Nous faisons un `--check` car il s'agit d'une vérification et non d'une modification. Le développeur doit modifier en local.

3.
Utilsiation de ruff car plus rapide, écrit en rust cumule: flake8 + black et trie les imports.
Un fichier en .toml permet d'indiquer les règles a activer pour le projet pour correction etc, permet de savoir rapidement comment il est actif.

Question 4 (compte-rendu) : Quelle est la différence entre Bandit et Semgrep ? Dans quel cas
utiliseriez-vous l'un ou l'autre ?

Question 5 (compte-rendu) : Qu'est-ce que l'analyse statique ? En quoi diffère-t-elle des tests
unitaires ?

Question 6 (compte-rendu) : Quel est l'intérêt des pre-commit hooks par rapport à la CI ?
Pourquoi utiliser les deux ?


Question 7 (compte-rendu) : Un collègue fait un git commit --no-verify pour contourner les
pre-commit hooks. Est-ce un problème ? Pourquoi ?

Question 8 (compte-rendu) : Qu'est-ce qu'un Quality Gate ? Donnez 3 exemples de conditions
qu'on pourrait y mettre.

Question 9 (compte-rendu) : Décrivez l'ordre des vérifications dans votre pipeline final et
expliquez pourquoi cet ordre est important.
