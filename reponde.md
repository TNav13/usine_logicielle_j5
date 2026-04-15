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

