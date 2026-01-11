# Changelog

Toutes les modifications notables de ce chart Helm seront documentées dans ce fichier.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/),
et ce projet adhère à [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-01-02

### Ajouté
- Chart Helm initial pour JustBenchThatLLM
- Support pour Redis avec StatefulSet et volumes persistants
- Support pour MongoDB avec StatefulSet et volumes persistants
- Support pour Backend avec Deployment
- Support pour Worker avec Deployment
- Support pour Frontend avec Deployment
- Labels et annotations personnalisables pour chaque pod
- Healthchecks pour tous les composants
- Configuration des ressources (requests/limits)
- Support Ingress pour le frontend
- Tests Helm intégrés
- Documentation complète

### Caractéristiques
- Labels et annotations personnalisables par composant
- Persistence configurable pour Redis et MongoDB
- Support pour nodeSelector, tolerations et affinity
- Configuration flexible via values.yaml
- Respect des bonnes pratiques Helm

