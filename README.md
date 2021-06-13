
# Travail pratique GLO-4008/7008
Ce répértoire contient l'application ***Sentence Analyzer*** qui sert de point de départ pour le travail pratique du cours GLO-4008/7008: Applications infonuagique et DevOps.

## Pré-requis
Pour ce travail, vous aurez besoin d'un cluster Kubernetes supportant les Ingress Controllers et éventuellement les Services Mesh. Nous assumons que vous utilisez [l'environnement local fourni](https://github.com/medmouine/vagrant-k3s-HA-cluster). Celui-ci est configuré à l'aide d'un registre d'images local, accèssible au travers d'un service NodePort (30500) et de l'url `localregistry.lc`. Cela a principalement pour but de contourner les limitations de dockerhub et de faciliter la correction. C'est pour cela que les images qui seront utilisées par Kubernetes pour le déploiment du système sont tous sous la forme `localregistry.lc:30500/service:submission`. Le tag `submission` est celui qui sera utilisé lors de la correction. Si vous changez ces configurations pour une utilisation dans un environnement différent de celui fourni, assurez-vous de remettre celles-ci tel que présenté.

Un script [`./initialize_submission.sh`](./initialize_submission.sh) vous est fourni dans ce répértoire et vous permettera de construire les images de tous les services et de les push au registrie local du cluster.

## Description de l'application
***Sentence Analyzer*** est une application très simple exposant une interface web permettant l'entrée d'une phrase (*sentence*) dont la polarité (*Polarity*) est analysée pour détérminer si celle-ci a une tonalité positive ou négative.

La polarité est représentée par un nombre décimal dans l'intervalle [-1, 1].

Par exemple, I hate it étant une phrase à tonalité negative, retourne un score de -0.8. À l'inverse, la phrase I love it retourne un score de 0.5. 

Suite à l'obtention d'un score, il est possible à l'usagé de répondre une question de rétroactions pour savoir si le score attribué est correct ou non. Cette rétroaction est ensuite stockée dans une base de donnée pour permettre une amélioration continue du service.

De plus, il est possible à un administrateur d'obtenir la liste des rétroactions en communiquant directement avec le service `feedback-api`.

## Vue globale du système
![overview diagram](./doc/images/feature_diagram.png "Overview diagram")

## Description des services
| Service                       | Port                      |  Endpoints                    | Requests                  | Type | From          |
| -------------                 |-------------              | -----                         |-------                    |----|----           |
| [api-gateway](./api-gateway)   | 8080     | POST `/polarity` <br> POST `/feedback`   | `/analyse/sentence` <br> `/feedback` | POST <br> POST| [logic-api](/logic-api)  <br>  [feedback-api](/feedback-api)            |
| [logic-api](./logic-api)   | 5000     | POST  `/polarity`   | NA | NA | NA |
| [feedback-api](./feedback-api)   | 9000     | POST `/feedback` <br> GET `/feedback`   | Insert <br> Get all | query | Database (sqlite) |
| [frontend](./api-gateway)   | 80     | GET `/`   | `/api/polarity` <br> `/api/feedback` | POST <br> POST| [api-gateway](/api-gateway)            |

## Travail demandé
La tâche principale que vous aurez à effectuer est de définir les manifestes Kubernetes pour ce système. 

Voici une liste des ressources que vous devriez avoir pour un fonctionnement adéquat du système. Libre à vous de diverger de ces directives, tant que le fonctionnement est maintenu et que vous respectez les consignes spécifiées ci-bas. 30### api-gateway
#### Critères d'acceptation

- 2 Replicas
- LivenessProbe ***HTTP***
- Exposé à l'extérieur du cluster sous le prefix `/api` (***Note importante: Il vous est interdit de modifier le code de l'application directement, cela doit être fait au travers des ressources que vous offre Kubernetes***)

#### Ressources attendues

- Deployment
- service
- Ingress

### logic-api
#### Critères d'acceptation

- 2 Replicas
- LivenessProbe ***HTTP***

#### Ressources attendues

- Deployment
- service

### feedback-api
#### Critères d'acceptation

- 2 Replicas
- LivenessProbe ***HTTP***
- Persistance utilisant une base de donnée SQLite
- Admin path pour obtenir tous les feedbacks stockés (`/admin/feedback`) (Cette endpoint n'est pas sécurisé par défaut)

#### Ressources attendues

- Deployment
- service
- PersistentVolumeClaim
- Ingress Admin

***Note importante*** L'ingress Admin ne devrait pas être spécifique au service feedback-api. En effet, nous vous demandons de définir un ingress générique qui pourrait être étendu pour l'ajout de nouveaux endpoints d'admin.

### frontend
#### Critères d'acceptation

- 1 Replica
- Exposé à l'extérieur du cluster sous le prefix `/`

#### Ressources attendues

- Deployment
- service
- Ingress

## Barème

- `/` retourne l'interface web = ***10%***
- Soumission d'une *Sentence* pour analyse fonctionnelle = ***10%***
- Retour de la polarité lors d'une soumission = ***10%***
- Soumission d'un *feedback* suite à une soumission = ***10%***
- Stockage des feedback dans la persistance SQLite = ***10%***
- Obtenir la liste des feedbacks grâce à une requête `GET /admin/feedback` = ***15%***
- Pénalités pour non respect de spécificités et/ou des critères de qualité (i.e ingress Admin non générique, absence ou mauvaise configuration de la DB SQLite...) = ***15%***

*==> Nous nous réservons le droit de juger de ce qui se mérite ou non une pénalité et du poids de celle-ci. Utilisez votre bon-sens lors de l'exécution du travail. Gardez toujours en tête les principaux concepts du DevOps et de l'ingénierie logiciel (Scalability...). En cas de doute, n'hésitez pas à poser la question lors d'un laboratoire ou sur le forum.*

### Fonctionnalités avancées ***20%***

Pour obtenir les derniers ***20%***, il vous faudra sélectionner dans la liste suivante des fonctionnalités à implémenter cumulant un total d'au moins 20 points. Si vous décidez d'aller plus loin et d'avoir un total de points plus élevé, ces points seront convertis en bonus jusqu'à un maximum de 10 points. C'est à dire que si vous implémentez (correctement) un total de 40 points, vous obtiendrez 30 sur cette section.

- (FA1) Sécuriser et encrypter les communications au travers de certificats SSL. ==> ***10%***
- (FA2) Intégration du [Service Mesh Consul-Connect](https://www.consul.io/docs/connect) ==> ***5%***
  - (FA21) Intégration de la fonctionnalité de Service Discovery de Consul-Connect ==> ***5%***
  - (FA22) Observabilité des services et de leurs états (healthcheck) au travers du UI de Consul ==> ***5%***
  - (FA23) Définition d'[Intentions](https://www.consul.io/docs/k8s/connect/ingress-gateways#defining-an-intention) limitant la communication entre les services au strict nécessaire ==> ***10%***
  - (FA24) Configuration de [Canary Deployment](https://martinfowler.com/bliki/CanaryRelease.html) et/ou [Blue-green/A-B Deployment](https://martinfowler.com/bliki/BlueGreenDeployment.html) ==> ***10%***
- (FA3) Observabilité et monitoring
  - (FA31) Intégration d'un outil de gestion de journaux ([Loki](https://github.com/grafana/loki), [Fluentd](https://www.fluentd.org/), [Logstash](https://www.elastic.co/logstash), ...) ==> ***5%***
  - (FA32) Intégration de monitoring des ressources ([Prometheus](https://github.com/prometheus/prometheus)...) ==> ***5%***
  - (FA32) Intégration de tracing des communications ([Jaeger](https://www.jaegertracing.io/)...) ==> ***5%***
  - (FA33) Visualisation ([Grafana](https://grafana.com/), [Kibana](https://www.elastic.co/kibana), ...) ==> ***10%***
- (FA4) Intégration d'une platforme Git au cluster ([Gitlab](https://docs.gitlab.com/ee/install/), [Gitea](https://gitea.io/en-us/), ...) ==> ***5%***
  - (FA41) Pipeline CI/CD pour tester, builder et publier les applications automatiquement ([Tekton](https://tekton.dev/), [Jenkins](https://www.jenkins.io/), Gitlab CI,...) ==> ***25%*** (5% intégration + 5% par pipeline/service)
  - (FA42) Intégration de Continuous Delivery ([ArgoCD](https://argoproj.github.io/argo-cd/)) ==> ***25%*** (5% intégration + 5% par pipeline/service)

- (FAC) Fonctionnalité(s) avancée(s) de votre choix. Vous devrez contacter l'équipe d'enseignants pour déterminer si votre idée peut être considérée ou non comme une fonctionnalité avancée et pour déterminer le pointage de celle-ci.


## Consigne de remise

Nous vous demandons de compresser votre soumission en une seule archive (avec le `.git`). De plus, Nous vous demanderons de remplir le fichier [`submission.md`](./submission.md) avec tout commentaire ou directive nécessaire au fonctionnement de votre système. Normalement, votre soumission devrait être fonctionnelle d'office. Autrement, cela pourrait engendrer des pénalités. Les directives additionnelles en liens avec les fonctionnalités avancées n'engendreront pas de pénalité.

Il vous faudra aussi remplir le fichier [`submission.json`](./submission.json) avec les informations spécifiées (nom, idul, FA,...).
