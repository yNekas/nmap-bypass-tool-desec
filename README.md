# Nmap Bypass Tool

Ferramenta para detectar quais portas podem ser acessadas quando o Nmap utiliza portas de origem específicas (bypass de regras de firewall).

## Como usar

1. Baixe o script:
   
   wget https://github.com/yNekas/nmap-bypass-tool/bypass_scan.sh

3. Dê permissão:

   chmod +x bypass_scan.sh

5. Execute:
   
   ./bypass_scan.sh

Os resultados serão salvos em:

`resultados_bypass.log`

## Requisitos
- Nmap
- Bash (Linux ou WSL)

## Finalidade
Ferramenta educacional para CTF e estudos de segurança.
