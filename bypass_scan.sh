#!/bin/bash

alvo="172.16.1.59"
log="resultados_bypass.log"

# Paleta de cores
V="\e[32m"  # Verde
A="\e[33m"  # Amarelo
R="\e[31m"  # Vermelho
B="\e[34m"  # Azul
N="\e[0m"   # Reset cor

echo -e "${B}##########################################################${N}"
echo -e "${B}#     DETECTOR AVANCADO DE BYPASS – PORT-SPOOFING        #${N}"
echo -e "${B}##########################################################${N}"
echo

echo "[+] Log: $log"
echo "[+] Alvo: $alvo"
echo

> "$log"

top_ports=(1 100 200 400 500)
candidate_ports=(53 80 123 443 587 8080)

declare -A resultados

echo -e "${A}[!] Executando scan de controle (sem spoof)...${N}"
controle=$(nmap -Pn -sS --top-ports=500 $alvo --max-retries=0 -T4 --open | grep "/tcp")
echo "$controle" >> "$log"
echo

for spoof_port in "${candidate_ports[@]}"; do
    echo -e "${B}==> Testando porta de origem $spoof_port ${N}"
    echo "-----------------------------------------------------"

    for t in "${top_ports[@]}"; do

        # Executa o scan com a porta de origem alterada
        resultado=$(nmap -Pn -sS --top-ports=$t \
            $alvo --source-port=$spoof_port \
            --max-retries=0 -T4 --open 2>/dev/null | grep "/tcp")

        echo -e "${A}[Top $t] Resposta usando source-port $spoof_port:${N}"
        [[ -z "$resultado" ]] && echo -e "  ${R}Nenhuma porta responde${N}" \
                               || echo -e "  ${V}$resultado${N}"

        # Log
        echo "[TOP $t] Porta origem $spoof_port:" >> "$log"
        echo "$resultado" >> "$log"
        echo >> "$log"

        # Detecta bypass automaticamente
        if [[ -n "$resultado" && "$resultado" != "$controle" ]]; then
            resultados["$spoof_port"]="SIM"
        fi

        echo
    done
done

echo -e "${B}##########################################################${N}"
echo -e "${B}#                    RELATORIO FINAL                      #${N}"
echo -e "${B}##########################################################${N}"
echo

bypass_found=0

for porta in "${!resultados[@]}"; do
    if [[ "${resultados[$porta]}" == "SIM" ]]; then
        echo -e "${V}[+] Porta vulneravel detectada: $porta ${N}"
        bypass_found=1
    fi
done

if [[ $bypass_found -eq 0 ]]; then
    echo -e "${R}Nenhuma porta vulneravel detectada automaticamente.${N}"
else
    echo -e "${A}Log completo salvo em: $log${N}"
fi

echo -e "${B}##########################################################${N}"
echo -e "${V}Concluido.${N}"
