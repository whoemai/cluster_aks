#!/usr/bin/env python3

import subprocess
import sys

def run_command(command):
    print(f"\n[+] Executando: {' '.join(command)}")
    print("-" * 40)
    try:
        subprocess.run(command, check=True)
    except subprocess.CalledProcessError as e:
        print(f"\n[!] Erro ao executar o comando Terraform. Codigo de saida: {e.returncode}")
        sys.exit(e.returncode)

def prompt_yes_no(question, default="y"):
    """Faz uma pergunta de Sim ou Nao."""
    valid = {"y": True, "yes": True, "n": False, "no": False}
    prompt = " [Y/n] " if default == "y" else " [y/N] "
    while True:
        sys.stdout.write(question + prompt)
        choice = input().lower().strip()
        if choice == "":
            return valid[default]
        if choice in valid:
            return valid[choice]
        print("Por favor, responda com 'y' (yes) ou 'n' (no).")

def prompt_int(question, default):
    """Pede um numero inteiro."""
    while True:
        sys.stdout.write(f"{question} [{default}]: ")
        choice = input().strip()
        if choice == "":
            return default
        if choice.isdigit():
            return int(choice)
        print("Por favor, insira um numero valido.")

def prompt_choice(question, choices, default):
    """Pede para escolher entre algumas opcoes especificas."""
    options_str = "/".join(choices)
    while True:
        sys.stdout.write(f"{question} ({options_str}) [{default}]: ")
        choice = input().lower().strip()
        if choice == "":
            return default
        if choice in choices:
            return choice
        print(f"Por favor, escolha uma opcao valida: {options_str}.")

def main():
    print("=" * 50)
    print("   Orquestrador Interativo do Cluster AKS")
    print("=" * 50 + "\n")
    
    # 1. Pergunta qual a acao principal
    action = prompt_choice("O que voce deseja fazer com o cluster?", ["plan", "apply", "destroy"], "plan")
    
    cmd = ["terraform", action]
    
    if action == "destroy":
        # Se for destruir, nao precisa perguntar configuracoes do cluster
        auto = prompt_yes_no("Deseja destruir sem pedir confirmacao final (-auto-approve)?", "n")
        if auto:
            cmd.append("-auto-approve")
    else:
        # Se for plan ou apply, fazer as perguntas sobre o cluster
        print("\n--- Configuracoes do Cluster ---")
        
        node_count = prompt_int("Quantos nodes voce deseja no cluster?", 2)
        use_cilium = prompt_yes_no("Deseja um cluster robusto com Cilium (se Nao, usa kube-proxy)?", "y")
        use_argocd = prompt_yes_no("Deseja instalar o ArgoCD automaticamente?", "y")
        
        # Converte as respostas em variaveis do Terraform
        cmd.append(f"-var=node_count={node_count}")
        cmd.append(f"-var=enable_cilium={'true' if use_cilium else 'false'}")
        cmd.append(f"-var=enable_argocd={'true' if use_argocd else 'false'}")
        
        if action == "apply":
            print("\n--- Confirmacao ---")
            auto = prompt_yes_no("Deseja aplicar sem pedir confirmacao final do Terraform (-auto-approve)?", "n")
            if auto:
                cmd.append("-auto-approve")

    print("\n--- Inicializando Terraform (Isso garante que tudo esta atualizado) ---")
    run_command(["terraform", "init"])
    
    print(f"\n--- Iniciando Terraform {action.upper()} ---")
    
    if action == "destroy":
        print("\n[*] Dica: Executando destroy em duas etapas para evitar o erro do provider Kubernetes (localhost).")
        # Roda um destroy direcionado ao ArgoCD primeiro
        target_cmd = ["terraform", "destroy", "-target=module.argocd"]
        if auto:
            target_cmd.append("-auto-approve")
        
        # Ignoramos erros no target, pois o ArgoCD pode nao estar instalado
        print("\n[+] Destruindo workloads do Kubernetes (ArgoCD)...")
        subprocess.run(target_cmd)
        
        print("\n[+] Destruindo o restante da infraestrutura (Cluster e Rede)...")
    
    run_command(cmd)
    
    print("\n" + "=" * 50)
    print("   Orquestracao finalizada com sucesso!")
    print("=" * 50)

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        # Captura se o usuario apertar CTRL+C para sair graciosamente
        print("\n\n[!] Operacao cancelada pelo usuario.")
        sys.exit(1)
