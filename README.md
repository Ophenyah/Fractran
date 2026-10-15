## DM de DSL : Fractran

https://esolangs.org/wiki/Fractran

Fractran est un programme inventé par le génialissime John Conway, il consiste en une suite de fonction, multipliées successivement si possible à une entrée, jusqu'à ce qu'aucune fraction multipliée par l'entrée ne retourne de nombre entier.

L'interpréteur utilisé est celui que j'ai codé en ocaml 5.4.0 avec dune, dans */interpreteur*. 
On execute un programme contenant l'input suivit du programme par  `dune exec Fractran "path"`, et on execute un programme scindé en 2 fichier input/program part `dune exec Fractran "inputPath" "programPath"`, et imprime dans la sortie standard le résultat.

Un autre interpréteur en ligne peut être utilisé, pour tester pas à pas le code : https://pimlu.github.io/fractran/

Pour lancer les tests, il faut executer les commande `./run.sh "../pgcd.fr"` et `./run.sh  "../llm/p1.fr"`


Mon implémentation differe sur plusieurs points:
- Seuls les 60 premiers nombre premiers sont utilisable, codés en dur.  Chacun nombre est donc, en realité, une liste de 60 élément, avec les valeurs l'exposant correspondant au nombre premier, de façon analogue à la décomposition en nombre premiers.
- Mon interpréteur accepte les fractions non irréductible, en appliquant de façon indépendante la division et la multiplication. Par exemple, `11*2/11`, transforme 11 en 2*11. Ceci peut être utile lors de l'utilisation de certains nombres comme "indicateur d'état", qui évite de rajouter une fraction en plus pour osciller. Dans un interpréteur classique, cette unique fraction devrait être remplacée par `13*2/11, 11/13`.
- Conséquence du point précédant, mon interpréteur n'effectue pas de calcul sur les fractions du programme. Il faut donc que le programme soit écrit comme décomposition en produit de nombres premiers.


L'interpréteur se comporte bien tant qu'on reste dans la limite des entiers d'ocaml. Comme il ne fait aucune optimisation, contrairement à celui cité precedemment, des programmes prenant en entrée des nombres avec des exponsants dépassant le million devient vite très long.


