
# Travail pratique GLO-4008/7008
Ce répértoire contient l'application ***Sentence Analyzer*** qui sert de point de départ pour le travail pratique du cours GLO-4008/7008: Applications infonuagique et DevOps.

## Description de l'application
***Sentence Analyzer*** est une application très simple exposant une interface web permettant l'entrée d'une phrase (*sentence*) dont la polarité (*Polarity*) est analysée pour détérminer si celle-ci a une tonalité positive ou négative.

La polarité est représentée par un nombre décimal dans l'intervalle [-1, 1].

Par exemple, I hate it étant une phrase à tonalité negative, retourne un score de -0.8. À l'inverse, la phrase I love it retourne un score de 0.5. 

Suite à l'obtention d'un score, il est possible à l'usagé de répondre une question de rétroactions pour savoir si le score attribué est correct ou non. Cette rétroaction est ensuite stockée dans une base de donnée pour permettre une amélioration continue du service.

De plus, il est possible à un administrateur d'obtenir la liste des rétroactions en communiquant directement avec le service `feedback-api`.

## Vue globale du système
