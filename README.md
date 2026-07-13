# Terraform AKS Cluster Modularizado

Este projeto contém a infraestrutura como código (IaC) para criar um cluster Kubernetes no Azure (AKS) de forma modularizada e seguindo boas práticas de infraestrutura.

## Estrutura de Arquivos

*   `providers.tf`: Define os provedores necessários (`azurerm`).
*   `variables.tf`: Define as variáveis globais de entrada.
*   `main.tf`: Instancia os módulos principais.
*   `outputs.tf`: Expõe os resultados gerados após a criação do cluster.
*   `modules/`:
    *   `resource_group/`: Módulo dedicado à criação e gestão do Grupo de Recursos.
    *   `network/`: Módulo de infraestrutura de rede, criando uma VNet e Subnet específicas para o AKS.
    *   `aks/`: Módulo do cluster AKS integrado à rede customizada.

## Como Utilizar

### 1. Pré-requisitos
*   [Terraform instalado](https://developer.hashicorp.com/terraform/downloads) na sua máquina.
*   Azure CLI instalado e autenticado (`az login`).

### 2. Inicializar o Terraform
Navegue até a pasta `cluster_aks` e execute o comando abaixo. Ele baixará os provedores e inicializará a estrutura dos módulos:
```bash
cd cluster_aks
terraform init
```

### 3. Verificar o Planejamento
Veja o plano detalhado de execução (serão criados 4 recursos: RG, VNet, Subnet e AKS):
```bash
terraform plan
```

### 4. Aplicar as Alterações (Criar os Recursos)
Para subir o ambiente no Azure:
```bash
terraform apply
```
*Digite `yes` quando solicitado para confirmar.*

### 5. Conectar ao Cluster
Após concluir, use o comando de saída (`connect_command`) para configurar o `kubectl`:
```bash
az aks get-credentials --resource-group $(terraform output -raw resource_group_name) --name $(terraform output -raw kubernetes_cluster_name)
```

### 6. Destruir os Recursos
Para excluir tudo o que foi provisionado e evitar custos:
```bash
terraform destroy
```
*Digite `yes` quando solicitado para confirmar.*
