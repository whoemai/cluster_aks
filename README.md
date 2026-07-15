# Arquitetura Kubernetes com Terragrunt (AKS)

Este projeto contém a infraestrutura como código (IaC) para criar um cluster Kubernetes no Azure (AKS) e instalar aplicações (como ArgoCD) de forma orquestrada, usando o **Terragrunt** para gerenciar dependências e estado de múltiplos ambientes.

## Por que Terragrunt?
No Terraform puro, criar a infraestrutura (Cluster AKS) e inicializar aplicações via Helm/Kubernetes (ArgoCD) no mesmo módulo pode gerar erros críticos durante o `terraform destroy`, exigindo scripts manuais. 

O Terragrunt resolve isso separando os componentes em **micro-estados independentes** e controlando a ordem correta de execução através do bloco de `dependency`.

---

## Estrutura de Arquivos

A nova estrutura adota o padrão DRY (Don't Repeat Yourself) e separa o código (módulos) dos valores de ambiente (dev, prod).

*   `modules/`: Onde ficam os arquivos `.tf` "puros". Eles não conhecem as variáveis finais, apenas a lógica.
    *   `infra/`: Cria o Resource Group, a Rede Virtual (VNet, Subnet) e o Cluster AKS.
    *   `dns/`: Módulo dedicado para criar Zonas DNS na Azure e delegar permissões para o AKS (preparando para o external-dns).
    *   `apps/`: Conecta no Cluster AKS recém-criado e instala o ArgoCD (via Helm) já configurado com Ingress.
*   `environments/`: Onde nós definimos os ambientes (Dev, QA, Prod) e injetamos as variáveis.
    *   `terragrunt.hcl`: Arquivo mestre que injeta dinamicamente o provider do Azure.
    *   `dev/`: Pasta do ambiente de desenvolvimento.
        *   `env.hcl`: Contém as variáveis globais (ex: nome do cluster, domínio base, quantidade de nodes).
        *   `infra/terragrunt.hcl`: Realiza o deploy da infraestrutura.
        *   `dns/terragrunt.hcl`: Cria a Zona DNS baseada no `env.hcl` e possui dependência do `infra`.
        *   `apps/terragrunt.hcl`: Faz o deploy do ArgoCD e possui um bloco `dependency` dizendo que precisa esperar a pasta `infra` e `dns` terminarem.

---

## Como Utilizar (Orquestrando com Terragrunt)

### 1. Pré-requisitos
*   [Terraform instalado](https://developer.hashicorp.com/terraform/downloads) na sua máquina.
*   [Terragrunt instalado](https://terragrunt.gruntwork.io/docs/getting-started/install/).
*   Azure CLI instalado e autenticado (`az login`).

### 2. Verificar o Planejamento (Plan)
O comando `run --all` varre todas as sub-pastas e monta o plano de execução inteiro respeitando a ordem de dependência (primeiro Infra, depois DNS, depois Apps).

```bash
cd environments
terragrunt run --all plan
```

### 3. Aplicar as Alterações (Apply)
Para subir o ambiente inteiro de uma só vez (cluster e aplicações):

```bash
cd environments/dev
terragrunt run --all apply
```
*O fluxo de apply será executado na seguinte ordem pelo Terragrunt:*
1. **Infra**: Cria o AKS e a rede.
2. **DNS**: Extrai a identidade do AKS gerada pela etapa `Infra`, cria a Zona DNS e dá permissão de Contribuidor DNS para o cluster.
3. **Apps**: Extrai o endpoint/certificado do AKS, conecta no cluster e instala o ArgoCD configurado com as URLs e Ingress apropriados.

### 4. Conectar ao Cluster
Após concluir a criação, o AKS estará disponível no seu Resource Group (definido em `environments/dev/env.hcl`):
```bash
# Exemplo para se conectar (Ajuste o nome do cluster e do RG conforme o env.hcl)
az aks get-credentials --resource-group rg-aks-dev --name terragrunt-aks-dev
```

### 5. Destruir os Recursos (Destroy)
A maior vantagem da separação de estados! Para excluir **tudo** de forma segura (ele apagará na ordem reversa: Apps -> DNS -> Infraestrutura):
```bash
cd environments/dev
terragrunt run --all destroy
```
