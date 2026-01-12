# JustBenchThatLLM Helm Chart

Ce chart Helm déploie l'application JustBenchThatLLM sur Kubernetes.

## Description

JustBenchThatLLM est une application de benchmark pour endpoints LLM (vLLM, LM Studio, APIs compatibles OpenAI). Elle permet d'exécuter des benchmarks de charge, de suivre l'exécution en temps réel et d'analyser les métriques de performance.

## Installation

```bash
helm install my-release ./helm/justbenchthatllm
```

## Configuration

Les valeurs par défaut sont définies dans `values.yaml`. Vous pouvez les surcharger lors de l'installation :

```bash
helm install my-release ./helm/justbenchthatllm -f my-values.yaml
```

### Labels et Annotations personnalisés

Chaque composant (Redis, MongoDB, Backend, Worker, Frontend) peut avoir des labels et annotations personnalisés :

```yaml
redis:
  podLabels:
    custom.label/key: "value"
  podAnnotations:
    custom.annotation/key: "value"

backend:
  podLabels:
    environment: "production"
  podAnnotations:
    prometheus.io/scrape: "true"
```

### Pull Secret pour images privées

Pour utiliser des images Docker privées, configurez le pullSecret :

```yaml
pullSecret:
  create: true
  username: "your-registry-username"
  password: "your-registry-password"
  registry: "docker.io"  # ou "registry.example.com" pour un registry privé
```

Le secret sera automatiquement créé et référencé dans les pods Redis et MongoDB.

Pour backend, worker et frontend, vous pouvez spécifier un secret existant par composant :

```yaml
backend:
  pullSecret: "my-existing-secret"

worker:
  pullSecret: "my-existing-secret"

frontend:
  pullSecret: "my-existing-secret"
```

### Exemple de configuration complète

```yaml
# Exemple de values.yaml personnalisé
pullSecret:
  create: true
  username: "myuser"
  password: "mypassword"
  registry: "docker.io"

redis:
  persistence:
    size: 16Gi
    storageClass: "fast-ssd"
  podLabels:
    tier: "cache"
  podAnnotations:
    backup.enabled: "true"

mongo:
  persistence:
    size: 50Gi
    storageClass: "fast-ssd"
  podLabels:
    tier: "database"
  podAnnotations:
    backup.enabled: "true"

backend:
  replicaCount: 2
  resources:
    limits:
      memory: "1Gi"
      cpu: "1000m"
  podLabels:
    tier: "application"
  podAnnotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "8000"

worker:
  replicaCount: 3
  podLabels:
    tier: "worker"
  podAnnotations:
    prometheus.io/scrape: "true"

frontend:
  ingress:
    enabled: true
    className: "nginx"
    hosts:
      - host: benchmark.example.com
        paths:
          - path: /
            pathType: Prefix
    tls:
      - secretName: benchmark-tls
        hosts:
          - benchmark.example.com
  podLabels:
    tier: "frontend"
  podAnnotations:
    prometheus.io/scrape: "true"
```

## Composants

Le chart déploie les composants suivants :

- **Redis** : Cache et queue (StatefulSet avec volumes persistants)
- **MongoDB** : Base de données (StatefulSet avec volumes persistants)
- **Backend** : API backend (Deployment)
- **Worker** : Workers de traitement (Deployment)
- **Frontend** : Interface web (Deployment)

## Persistence

Redis et MongoDB utilisent des PersistentVolumes pour stocker les données. Par défaut :
- Redis : 8Gi
- MongoDB : 20Gi

Vous pouvez configurer la classe de stockage et la taille dans `values.yaml`.

## Ingress

L'ingress est désactivé par défaut. Pour l'activer :

```yaml
frontend:
  ingress:
    enabled: true
    className: "nginx"
    hosts:
      - host: your-domain.com
        paths:
          - path: /
            pathType: Prefix
```

## Dépendances

Le chart configure automatiquement les dépendances entre les services :
- Backend dépend de Redis et MongoDB
- Worker dépend de Redis et MongoDB
- Frontend dépend du Backend

## Maintien

Maintenu par **Eric RICHARD** (contact@redteams.fr)

## Licence

Voir le fichier LICENSE dans le repository source.

