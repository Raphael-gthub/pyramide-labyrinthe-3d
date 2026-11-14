# Pyramide et labyrinthe en 3D

Exploration en vue subjective d'une pyramide à neuf étages, dont chaque étage est un labyrinthe gardé par une momie. Écrit avec Processing (Java, OpenGL) et des shaders GLSL.
Projet du cours d'informatique graphique pour la science des données (L2, double licence informatique-mathématiques, Université Paris-Saclay, 2025), réalisé en binôme.

## Ce que fait le programme

- Une pyramide texturée posée sur un sol de sable, vue de l'extérieur avant d'y entrer.
- Neuf labyrinthes superposés, de plus en plus petits en montant, construits en `PShape` avec murs, sol et plafond texturés.
- Des téléporteurs en forme de tore pour passer d'un étage à l'autre.
- Une mini-carte qui se dévoile au fur et à mesure de l'exploration.
- Une momie modélisée à partir de primitives (corps, jambes, cou, tête, bras, yeux, bandelettes) qui se déplace au hasard dans le labyrinthe, avec des rotations et des déplacements animés. La croiser efface la mini-carte.
- Des systèmes de particules autour de la momie et des téléporteurs.
- Deux shaders GLSL : un éclairage diffus et spéculaire pour le sol extérieur, et un shader pour l'intérieur dont la lumière faiblit avec le temps passé à chaque étage.
- Des déplacements et des rotations de caméra animés.

## Lancer le programme

1. Installer [Processing 4](https://processing.org/download).
2. Ouvrir `pyramide_labyrinthe/labyrinthe_version_ok.pde` dans Processing.
3. Cliquer sur « Exécuter ».

## Commandes

| Touche | Action |
| --- | --- |
| `e` | entrer dans la pyramide |
| `o` | sortir de la pyramide |
| `z` `q` `s` `d` ou flèches | avancer, tourner à gauche, reculer, tourner à droite |
| espace | utiliser le téléporteur (à l'entrée ou à la sortie d'un étage) |
| `r` | revenir au départ de l'étage |
| `h` | afficher l'aide dans la console |
| `j` / `k` | descendre ou monter d'un étage directement (raccourci de test) |

Le but est d'atteindre la sortie de chaque labyrinthe, à l'opposé de l'entrée, puis de prendre le téléporteur jusqu'au sommet.

## Organisation du code

| Fichier | Contenu |
| --- | --- |
| `labyrinthe_version_ok.pde` | Variables globales, `setup`, boucle `draw`, caméra, lumières |
| `lab.pde` | Génération aléatoire des labyrinthes et construction de leur géométrie |
| `pyramide.pde` | Géométrie de la pyramide, des blocs et du sol extérieur |
| `Momie.pde` | Modélisation de la momie |
| `MomieDeplacement.pde` | Choix de direction et animation de la momie |
| `Particules.pde` | Systèmes de particules |
| `TP.pde` | Téléporteurs |
| `MiniMap.pde` | Mini-carte |
| `KeyPressed.pde` | Gestion du clavier |
| `*.glsl` | Shaders de sommets et de fragments |

L'algorithme de génération d'un labyrinthe vient du squelette fourni en cours ; le reste a été écrit pendant le projet.

## Limites connues

- La fin de partie n'est pas gérée : arriver au sommet affiche seulement un message dans la console.
- Le programme repose sur de nombreuses variables globales, comme c'est l'usage dans un sketch Processing.

## Auteurs

Projet réalisé en binôme avec Oscar Cavalieros.
