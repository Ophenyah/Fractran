# Analyse du programme 

Son principe est très proche du mien, il est donc recommandé de lire EXPLICATION.md avant, car je ne vais pas me répéter, juste comparer. 

Tout d'abord, la machine a choisit d'utiliser les premiers nombres premiers disponibles, tandis que j'ai utilisé ceux plus loin, pour donner plus de sens.

Il utilise aussi plus de fractions que moi, 10 au lieu de 9.

Il utilise en effet un registre temporaire, Reg7, tandis que je me sers du registre final Reg5 aussi comme registre temporaire.

Cependant, il distingue mieux que moi le changement d'état.

Tandis que je fais par exemple `31*2/3*5`, le llm fait `17/3`, et ensuite nous faisons le même principe de boucle.
Les deux façon de faire sont équivalentes dans ces conditions, et il est probablement mieux de faire comme le LLM sur ce point.


Le fonctionnement des boucles sont analogues, il rajoute juste à la fin `5/7`, pour transférer du registre temporaire au registre final.


# Analyse du résultat

Tout les tests passent. De plus, après analyse humaine, les programmes sont équivalent sous sémantique dénotationnelle, pour une meme entrée, ils auront la même sortie.


# Conclusion sur l'efficacité du LLM

Le LLM considéré est capable de générer du Fractran sans problème, mais cet exemple montre bien la différence d'approche entre un humain et un LLM.

Son choix des indicateurs d'état est optimal, toujours choisir le plus petit possible est clairement un bon choix. Cependant, ils ne font pas de "sens", Fractran étant un langage assez minimaliste, on ne peux pas nommer nos variables ou commenter un code (sauf mon implémentation), il faut donc essayer de leur donner du sens autrement, ce que j'ai fais en planifiant mon programme.

Ce langage pouvant être vu comme une machine a état avec une infinité de registre, il n'est pas si surprenant qu'un LLM arrive à générer des solutions, le langage est parfaitement bien défini, et assez simple pour générer des programmes.


Si je devais, à l'avenir, faire des programmes plus long en Fractran, avec l'aide de l'IA, je pense qu'il faudrait collaborer avec elle.

Juste la laisser tout générer mène a un code incompréhensible, et tout faire par l'humaine risque de mener a des tentative d'optimisation qui ne sont valide que dans de rares cas. 


# Note sur Chatgpt

Pendant que je réfléchissais a quel programme faire en Fractran, je demandais a des IA de m'en générer un peu, pour voir si elles en étaient capables, et juger en un coup d'oeil (sans copier evidemment) l'ordre de grandeur des programmes.

J'ai commencé au hasard par chatgpt, et très vite il refuse de me générer des programmes "qu'il ne peut pas vérifier". Par exemple, en lui demandant de faire un programme pour approximer la fonction exponentielle, il refuse tout bonnement d'essayer, peu importe comment je lui parle, tandis que d'autres comme Claude le font sans sourciller.