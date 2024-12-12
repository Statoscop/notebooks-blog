# Data Science avec Python : configurer son environnement de travail

Python est un __langage de programmation extrêmement complet__ et souvent plébiscité pour conduire ses projets en Data Science. Sa grande flexibilité, le nombre très important de [modules développés](https://pypi.org/) et de logiciels permettant de le faire tourner constitue à la fois sa richesse et est souvent source de beaucoup de difficultés pour ses nouvelles utilisatrices et utilisateurs. Il est en effet parfois difficile de reproduire un __environnement de travail simple et minimaliste__, identique à ce qu'on aurait plus naturellement en utilisant R et RStudio.  
Une des réponses à cette problématique est la solution [Anaconda](https://www.anaconda.com/download/), mais elle nous semble trop lourde et souvent source de complications. C'est pour cela que cette semaine, on vous recommande __un environnement de travail pour la Data Science avec Python__, en se focalisant sur les outils qui nous semblent les plus __pratiques et utiles__ au quotidien.  

# Installer Python et VSCode

## Installation de Python  

La première étape est bien sûr d'installer Python. Avant cela, vous pouvez tout de même vérifier que ça n'est pas déjà le cas en ouvrant le terminal de votre système d'exploitation et en tapant :  

```bash
python --version
```

> Attention, parfois l'alias utilisé par votre système ne sera pas `python` mais `python3`, il faut donc modifier les instructions données dans cette note en conséquence, ou [modifier l'alias](https://www.askpython.com/python/examples/python3-alias-as-python).  

Si Python est installé, sa version va s'afficher dans la console, sinon vous recevrez un message d'erreur. Dans ce cas, rendez-vous sur la [page du site officiel](https://www.python.org/downloads/) pour télécharger la version de Python qui vous convient. Je vous conseille la 3.12, qui est assez récente mais a déjà été éprouvée. Surtout, n'oubliez pas de cocher la case `Add Python to PATH` quand cela vous est demandé, afin de pouvoir accéder à Python en ligne de commande.  

Une fois Python installé, vous pouvez vérifier que Pyton est bien __accessible en ligne de commande__ en tapant à nouveau `python --version` depuis un terminal. Vous pouvez alors lancer depuis votre terminal une session Python en lançant l'instruction `python`. Mais nous allons préférer passer par un __environnement de développement intégré, ou IDE__.

## Installation de VSCode  

Le choix de l'IDE est déjà une première étape pas évidente, puisqu'il en existe de nombreux :  [Pycharm](https://www.jetbrains.com/pycharm/), (Spyder)[https://www.spyder-ide.org/], [Jupyer Notebook](https://jupyter.org/)... Nous vous proposons d'installer VSCode, parce qu'il est sans doute __le plus populaire__ en ce moment, et qu'il peut être utilisé __pour des scripts Python, mais aussi des notebooks Jupyter__. Il supporte également de __nombreux autres langages que Python__ (HTML/CSS, Javascript, C/C++, Ruby....) et pourra donc vous servir pour des projets plus tournés vers le développement Web. Enfin, il a un module intégré permettant d'utiliser Git sans ligne de commande, ce qui peut être très pratique pour une première prise en main d'un outil de gestion de versions.  

Pour installer VSCode, [suivez les instructions correspondant à l'OS que vous utilisez](https://code.visualstudio.com/download). Une fois installé, ouvrez-le et rendez vous dans l'onglet extensions que vous trouverez sur la barre latérale à gauche de votre écran :  
![image-2.png](python-data-science_files/image-2.png)

Ce sont ces extensions de VSCode qui lui permettent de __gérer tant de langages différents__. Vous pouvez d'ores et déjà installer les extensions __Python et Jupyter__.  

## Bonus : installation de git  

Ça n'est pas l'objectif de cet article, mais on vous conseille fortement d'utiliser Git pour tous vos projets de Data Science. Pour cela, commencez par [télécharger Git](https://git-scm.com/downloads) et créez-vous un compte sur [Gitlab](https://about.gitlab.com/) ou [Github](https://github.com/).  
Si vous n'êtez pas à l'aise avec les lignes de commande, VSCode propose justement __un outil intégré permettant de gérer vos fichiers et commits__ en clic-bouton, toujours accessible depuis la barre latérale :  

![image-6.png](python-data-science_files/image-6.png)

Pour se lancer avec Git sur vos projets de Data Science en Python, on vous conseille cet [excellent article de Lino Galiana](https://pythonds.linogaliana.fr/content/git/introgit.html).

# Travailler avec Python sur vos projets  

Ok, maintenant vous êtes prêts à vous lancer dans vos projets de Data Science. Il ne vous reste plus qu'à choisir et configurer un gestionnaire d'environnements avant de vous lancer enfin dans votre code Python!

## Gestionnaire d'environnements   
Un gestionnaire d'environnements vous permet de gérer les dépendances de votre projet afin que ceux-ci soient indépendants les uns des autres et plus reproductibles. En dehors du fait d'avoir des bibliothèques de packages propres à chaque projet, il vous permet également de gérer différentes versions de Python en fonction des besoins de chaque projet.  
Là aussi, il existe différentes possibilités : `virtualenv`, `pyenv`, `pipenv`... Nous optons de notre côté pour le gestionnaire `conda`, qui nous semble pratique d'utilisation, notamment pour changer de versions de python simplement. Pour l'installer, nous vous proposons d'[installer `miniconda`](https://docs.anaconda.com/miniconda/miniconda-install/) qui est une version allégée d'Anaconda nous permettant de faire tourner `conda`. Une fois conda installé, rendez-vous sur le terminal, accessible directement sur VSCode en bas de votre écran :  

![image-4.png](python-data-science_files/image-4.png)

Tu peux maintenant créer ton premier environnement virtuel, en tapant dans la console :  

```bash
conda create --name mon_premier_env python=3.12 
```
Il n'est pas nécessaire de spécifier la version de python pour créer l'environnement mais c'est une bonne pratique, pour clarifier la version qui sera utilisée dans celui-ci. Tu peux aussi installer des packages directement à la création en mettant leurs noms à la suite de la version de Python.   
Une fois créé, il ne reste plus qu'à l'activer avec :  

```bash
conda activate mon_premier_env 
```
Dans ton terminal, la mention `(base)` devrait être remplacée par `(mon_premier_env)`, t'indiquant que ton environnement est bien activé. 
Dorénavant, les packages que tu installeras seront installés seulement pour celui-ci. Nous allons ici installer pandas avec : 

```bash
conda install pandas
```
> Attention, ça n'est pas parce que vous utilisez `conda` comme gestionnaire d'environnements que  vous ne pouvez pas utiliser `pip` pour installer des packages. On préfèrera cependant utiliser `conda` quand cela est possible pour faciliter les gestions de dépendances entre packages.  

Enfin, pour sortir de ton environnement il te suffit de taper :  

```bash
conda deactivate
```

## Les notebooks jupyter

Normalement, vous avez déjà installé les extensions Jupyter et Python sur VSCode. Vous pouvez donc cliquer sur `File -> New File... -> Jupyter Notebook`. Cela va vous créer votre premier notebook, avec une extension `.ipynb`. 
On vous recommande les notebooks pour la partie exploration de vos données car ils vous permettent de faire tourner des blocs de Python et aussi d'intégrer du Markdown pour la mise en forme. C'est d'ailleurs des notebooks que l'on utilise pour rédiger nos [notes de blog sur Python](https://blog.statoscop.fr). Une fois votre notebook ouvert, cliquez sur `Select kernel` en haut à droite de votre fichier :  

![image-3.png](python-data-science_files/image-3.png)

Dans `Python Environments...` vous allez normalement trouver votre environnement conda. Maintenant, créez une cellule de code et lancez :  

```python
import pandas as pd
```
Et là... catastrophe :  

![image-5.png](python-data-science_files/image-5.png)

Mais non, c'est normal! On a juste oublié de vous expliquer quelque chose. Les notebooks s'appuient sur une version améliorée de Python, que l'on appelle IPython. C'est une surcouche interactive de python qui permet notamment de faire tourner Python par blocs de code, comme dans les notebooks. Vous pouvez l'installer en clic-bouton comme cela vous est suggéré, ou revenir dans le terminal, activer votre environnement et lancer :  

```bash
conda install ipykernel
```

Maintenant, vous pouvez importer votre package `pandas` depuis votre notebook et lancer vos premières analyses exploratoires. Il vous reste encore probablement de nombreux problèmes à résoudre, mais on espère que cet article vous aura bien accompagné pour vous lancer!  

C'est la fin de cet article! N'hésitez pas à [visiter notre site](https://www.statoscop.fr) et à nous suivre sur [Twitter](https://twitter.com/stato_scop) et [Linkedin](https://www.linkedin.com/company/statoscop). Pour retrouver l'ensemble du code ayant servi à générer cette note, vous pouvez vous rendre sur le [github de Statoscop](https://github.com/Statoscop/notebooks-blog).  



