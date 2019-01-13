# Terrafomr AKS Project

![alt](https://dev.azure.com/jungopro/Terraform/_apis/build/status/Terraform) ![alt](https://vsrm.dev.azure.com/jungopro/_apis/public/Release/badge/2d4b16f3-b3f8-4c2a-90d1-b25057964e1a/1/1)

## General

This projet will deploy AKS in Terraform alongside supporting services with secure access to each service 
In addition, it will configure the client machine to securely authenticate to AKS, deploy and configure helm for charts deployment and install istio using helm chart on the AKS cluster

## Services

- Resource Group
- Azure Container Registry
- Azure Virtual Network
- Azure Key Vault
  - Grant "read" access to the AD group using KV policy
- Azure SPN (azurerm_azuread_application + azurerm_azuread_service_principle)
- Azure AD Group
  - Assing SPN to the AD group
- Azure AKS
- Helm
- Helm istio chart
- Helm istio sample app chart
- Helm Jenkins X chart
- Helm Spinnaker chart