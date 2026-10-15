 
Dans l'explication suivante, pour des nombres comme 2^3*3^1, on dira "Le registre 2 contient la valeur 3, et le registre 3 la valeur 1", qu'on peut noté Reg2(3).

Ainsi, la fraction 1/X devient "si RegX > 0 then RegX = RegX - 1", et "X/1" devient "RegX = RegX + 1".

# Calcul du PGCD en Fractran

L'entrée du programme est sous la forme 2^x*3^y, et la sortie 5^pgcd(x,y)

On se basera sur l'algorithme d'Euclide et l'égalité suivante : pgcd(x,y) = pgcd(|x-y|,min(x,y))

## A) Soustraction

La premiere étape consiste a multiplier notre entrée par `5/2*3`.
En effet, cette fraction retire 1 aux deux registres Reg2 et Reg3, et ajoute 1 à Reg5, tant que Reg2 et Reg3 > 0.

Si x=y, a force d'application, on obtient Reg5(x), le programme s'arrete, et nous donne bien pgcd(x,x) = x.

Si on a x > y, a force de l'appliquer, on obtient Reg2(x-y) Reg5(y). Dans le cas inverse on a Reg3(y-x) Reg5(x).
Autrement dit, dans un registre, on a bien |x-y|, et dans l'autre min(x,y).



## B) Marqueur d'état, boucle pour recommencer

Pour recommencer, il faut remettre la valeur dans Reg5 dans le registre qui est libre.

Si Reg2 > 0, on multiple par  `23*3/2*5`, sinon, `31*2/3*5`.
On consomme 1 dans le registre qui existe encore pour rentrer dans le bon état (23 ou 31, le chiffre des dizaines me servant mentalement pour m'y retrouver) et ainsi pouvoir boucler correctement pour décaller tout le contenu de Reg5 dans le registre libre.

Il ne faudra pas oublier cependant, de restituer l'élément consommé, à la fin du processus de copie.



## C) et D) Boucle

Il aurait probablement été possible d'utiliser mon implémentation pour utiliser une seule fraction pour boucler, mais il est plus facile mentalement d'utiliser 2 valeurs.

### Cas Reg2 > 0

On veut transférer tout le Reg5 dans le Reg3, et grace a l'étape précedante, on sait que qu'on a le marqueur 23. Ainsi, on peut mettre dès le début du programme 

`3*23/29*5` et `29/23`

Pourquoi dès le début du programme? Parce que transférer Reg5 vers Reg3 va nous mettre dans l'état "Reg2 et Reg3 > 0", donc lancer le processus de soustraction A. 

Ainsi, ces deux boucles font le transfert de Reg5 vers Reg3, tout en gardant les bons indicateurs d'états.


Cela continue jusqu'a avoir  Reg2(|x-y| - 1 )  Reg3(min(x,y)) Reg29(1)


### Cas Reg3 > 0


Exactement comme le cas précedant, sauf que les fractions sont `2*31/37*5` et `37/31`

La boucle continue jusqu'a  Reg2(min(x,y)) Reg3(|x-y| - 1) Reg37(1)

## E) Retour a la situation initiale

On sort de l'état de boucle, et on restitue la valeur consommée, avec les fractions `2/29` et `3/37`

Ainsi, on est soit a l'état 

Reg2(x-y) Reg3(y)
ou
Reg2(x) Reg3(y-x)

Le programme va reboucler comme a l'état initial, jusqu'a arriver au cas x=y, et output le pgcd.

# Ordonnancement


Ecrire les fractions de façon naive ne suffit pas.

En effet, les étapes `5/2*3`  et `23*3/2*5` peuvent s'influencer entre elles si on les laisse dans cette ordre, c'est pour ca qu'il faut mettre les fractions les plus générale à la fin, et les plus specifique au début. Ainsi, on obtient l'ordre suivant :

C D E A B

donnant le programme visible dans pgcd.fr