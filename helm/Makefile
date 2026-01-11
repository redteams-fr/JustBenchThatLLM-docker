# Makefile pour gérer le Helm chart JustBenchThatLLM
# Usage: make <target>

# Variables
CHART_NAME := justbenchthatllm
CHART_DIR := $(CHART_NAME)
RELEASE_NAME ?= justbenchthatllm
NAMESPACE ?= default
VALUES_FILE ?= $(CHART_DIR)/values.yaml
VALUES_OVERRIDE ?=

# Couleurs pour l'affichage
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m # No Color

.PHONY: help lint template dry-run install upgrade uninstall test clean validate

help: ## Affiche l'aide
	@echo "$(GREEN)Makefile pour le Helm chart $(CHART_NAME)$(NC)"
	@echo ""
	@echo "Usage: make <target>"
	@echo ""
	@echo "Cibles disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "Variables:"
	@echo "  RELEASE_NAME  Nom de la release Helm (défaut: $(RELEASE_NAME))"
	@echo "  NAMESPACE     Namespace Kubernetes (défaut: $(NAMESPACE))"
	@echo "  VALUES_FILE   Fichier de valeurs (défaut: $(CHART_DIR)/values.yaml)"
	@echo ""
	@echo "Exemples:"
	@echo "  make lint"
	@echo "  make template"
	@echo "  make dry-run RELEASE_NAME=my-release"
	@echo "  make install NAMESPACE=justbenchthatllm VALUES_FILE=values-example.yaml"
	@echo "  make uninstall NAMESPACE=justbenchthatllm"

lint: ## Lint le Helm chart
	@echo "$(GREEN)Linting du chart Helm...$(NC)"
	@helm lint $(CHART_DIR)
	@echo "$(GREEN)✓ Lint réussi$(NC)"

validate: lint ## Valide le chart (alias pour lint)
	@echo "$(GREEN)✓ Validation réussie$(NC)"

template: ## Affiche les templates Helm générés
	@echo "$(GREEN)Génération des templates Helm...$(NC)"
	@echo "$(YELLOW)========================================$(NC)"
	@helm template $(RELEASE_NAME) $(CHART_DIR) $(if $(VALUES_OVERRIDE),-f $(VALUES_OVERRIDE),$(if $(filter-out $(CHART_DIR)/values.yaml,$(VALUES_FILE)),-f $(VALUES_FILE),))
	@echo "$(YELLOW)========================================$(NC)"
	@echo "$(GREEN)✓ Templates générés$(NC)"

template-debug: ## Affiche les templates Helm avec debug
	@echo "$(GREEN)Génération des templates Helm (mode debug)...$(NC)"
	@helm template $(RELEASE_NAME) $(CHART_DIR) $(if $(VALUES_OVERRIDE),-f $(VALUES_OVERRIDE),$(if $(filter-out $(CHART_DIR)/values.yaml,$(VALUES_FILE)),-f $(VALUES_FILE),)) --debug

dry-run: ## Simule une installation (dry-run)
	@echo "$(GREEN)Simulation d'installation (dry-run) dans le namespace '$(NAMESPACE)'...$(NC)"
	@echo "$(YELLOW)Release: $(RELEASE_NAME)$(NC)"
	@helm install $(RELEASE_NAME) $(CHART_DIR) \
		--namespace $(NAMESPACE) \
		--create-namespace \
		--dry-run \
		$(if $(VALUES_OVERRIDE),-f $(VALUES_OVERRIDE),$(if $(filter-out $(CHART_DIR)/values.yaml,$(VALUES_FILE)),-f $(VALUES_FILE),))
	@echo "$(GREEN)✓ Dry-run réussi$(NC)"

install: lint ## Installe le chart Helm (crée le namespace si nécessaire)
	@echo "$(GREEN)Installation du chart Helm dans le namespace '$(NAMESPACE)'...$(NC)"
	@echo "$(YELLOW)Release: $(RELEASE_NAME)$(NC)"
	@echo "$(YELLOW)Namespace: $(NAMESPACE)$(NC)"
	@kubectl create namespace $(NAMESPACE) 2>/dev/null || echo "$(YELLOW)Namespace $(NAMESPACE) existe déjà$(NC)"
	@helm install $(RELEASE_NAME) $(CHART_DIR) \
		--namespace $(NAMESPACE) \
		--create-namespace \
		$(if $(VALUES_OVERRIDE),-f $(VALUES_OVERRIDE),$(if $(filter-out $(CHART_DIR)/values.yaml,$(VALUES_FILE)),-f $(VALUES_FILE),))
	@echo "$(GREEN)✓ Chart installé avec succès$(NC)"
	@echo "$(YELLOW)Pour voir les notes d'installation: helm get notes $(RELEASE_NAME) -n $(NAMESPACE)$(NC)"
	@echo "$(YELLOW)Pour voir le statut: make status NAMESPACE=$(NAMESPACE)$(NC)"

upgrade: lint ## Met à jour le chart Helm
	@echo "$(GREEN)Mise à jour du chart Helm dans le namespace '$(NAMESPACE)'...$(NC)"
	@echo "$(YELLOW)Release: $(RELEASE_NAME)$(NC)"
	@helm upgrade $(RELEASE_NAME) $(CHART_DIR) \
		--namespace $(NAMESPACE) \
		$(if $(VALUES_OVERRIDE),-f $(VALUES_OVERRIDE),$(if $(filter-out $(CHART_DIR)/values.yaml,$(VALUES_FILE)),-f $(VALUES_FILE),))
	@echo "$(GREEN)✓ Chart mis à jour avec succès$(NC)"

uninstall: ## Désinstalle le chart Helm
	@echo "$(YELLOW)Désinstallation du chart Helm...$(NC)"
	@echo "$(YELLOW)Release: $(RELEASE_NAME)$(NC)"
	@echo "$(YELLOW)Namespace: $(NAMESPACE)$(NC)"
	@if helm list --namespace $(NAMESPACE) 2>/dev/null | grep -q "^$(RELEASE_NAME)"; then \
		helm uninstall $(RELEASE_NAME) --namespace $(NAMESPACE); \
		echo "$(GREEN)✓ Chart désinstallé avec succès$(NC)"; \
	else \
		echo "$(RED)Release '$(RELEASE_NAME)' non trouvée dans le namespace '$(NAMESPACE)'$(NC)"; \
		exit 1; \
	fi

uninstall-ns: uninstall ## Désinstalle le chart Helm et supprime le namespace
	@echo "$(YELLOW)Suppression du namespace '$(NAMESPACE)'...$(NC)"
	@kubectl delete namespace $(NAMESPACE) 2>/dev/null || echo "$(YELLOW)Namespace '$(NAMESPACE)' déjà supprimé ou inexistant$(NC)"
	@echo "$(GREEN)✓ Namespace supprimé$(NC)"

status: ## Affiche le statut de la release
	@echo "$(GREEN)Statut de la release $(RELEASE_NAME)...$(NC)"
	@helm status $(RELEASE_NAME) --namespace $(NAMESPACE) || echo "$(RED)Release non trouvée$(NC)"

list: ## Liste toutes les releases
	@echo "$(GREEN)Liste des releases Helm...$(NC)"
	@helm list --namespace $(NAMESPACE)

test: lint template ## Test complet (lint + template)
	@echo "$(GREEN)✓ Tests réussis$(NC)"

clean: ## Nettoie les fichiers temporaires
	@echo "$(GREEN)Nettoyage...$(NC)"
	@find $(CHART_DIR) -type f -name "*.bak" -delete || true
	@find $(CHART_DIR) -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	@echo "$(GREEN)✓ Nettoyage terminé$(NC)"

diff: ## Affiche les différences entre la release installée et le chart
	@echo "$(GREEN)Différence entre la release installée et le chart...$(NC)"
	@helm diff upgrade $(RELEASE_NAME) $(CHART_DIR) \
		--namespace $(NAMESPACE) \
		$(if $(VALUES_OVERRIDE),-f $(VALUES_OVERRIDE),$(if $(filter-out $(CHART_DIR)/values.yaml,$(VALUES_FILE)),-f $(VALUES_FILE),)) || \
		echo "$(YELLOW)Note: helm-diff plugin requis. Installez-le avec: helm plugin install https://github.com/databus23/helm-diff$(NC)"

show-values: ## Affiche les valeurs qui seront utilisées
	@echo "$(GREEN)Valeurs qui seront utilisées...$(NC)"
	@echo "$(YELLOW)========================================$(NC)"
	@helm get values $(RELEASE_NAME) --namespace $(NAMESPACE) 2>/dev/null || \
		helm show values $(CHART_DIR)
	@echo "$(YELLOW)========================================$(NC)"

package: lint ## Empaquette le chart Helm
	@echo "$(GREEN)Emballage du chart Helm...$(NC)"
	@helm package $(CHART_DIR)
	@echo "$(GREEN)✓ Chart empaqueté: $(CHART_NAME)-*.tgz$(NC)"

verify: lint template dry-run ## Vérification complète (lint + template + dry-run)
	@echo "$(GREEN)✓ Vérification complète réussie$(NC)"

.DEFAULT_GOAL := help

