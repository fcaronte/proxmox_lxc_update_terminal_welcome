#!/bin/bash

# =========================================================
# Script: update-terminal-welcome.sh - Versione definitiva e documentata
# Versione: 1.0.4
# Autore: (Generato con l'assistenza di Gemini AI)
#
# Descrizione:
#   Questo script automatizza l'aggiornamento del banner di benvenuto
#   del terminale (MOTD) su uno o più container LXC Debian.
#
# Uso:
#   - Aggiorna LXC specifici: ./update-terminal-welcome.sh 8001 8005
#   - Aggiorna tutti gli LXC attivi: ./update-terminal-welcome.sh all
# =========================================================

# Variabili per l'autodiscovery
# ORA: Usa 'pct list' e cerca gli ID (colonna 1) dove lo stato (colonna 2) è 'running'
LXC_DISCOVERY_COMMAND="pct list | awk 'NR>1 && \$2 == \"running\" {print \$1}'"
LXC_CONFIG_FILE="/etc/profile.d/00_lxc-details.sh"

# --- LOGICA DI SELEZIONE LXC ---
if [ -z "$1" ] || [ "$1" == "all" ]; then
    echo "Modalità: Aggiornamento di TUTTI i container LXC attivi."
    
    # Esegue il comando di discovery
    LXC_IDS=$(eval ${LXC_DISCOVERY_COMMAND})
    
    if [ -z "${LXC_IDS}" ]; then
        echo "Nessun container LXC attivo trovato. Esco."
        exit 1
    fi
    
    CONTAINER_LIST=(${LXC_IDS})
else
    # Usa gli ID forniti come argomenti
    CONTAINER_LIST=("$@")
fi
# --------------------------------

# Definizione del contenuto dello script (usando il metodo base64 robusto)
SCRIPT_CONTENT=$(cat <<'EOF_SCRIPT_TEMPLATE'
#!/bin/bash
# Script generato da update-terminal-welcome.sh

# Definizioni variabili dinamiche all'interno dello script stesso
DEBIAN_VERSION=$(cat /etc/debian_version)
# IP Address ottenuto in modo robusto
MAIN_IP=$(ip route get 1.1.1.1 | awk '{print $7; exit}')

echo -e ""
echo -e "\033[1;36m$(hostname) LXC Container\033[0m"
echo ""
echo -e "  \033[1;36m🖥️ \033[0m \033[33mOS:\033[0m \033[1;32mDebian GNU/Linux - Version: \033[1;36m${DEBIAN_VERSION}\033[0m"
echo -e "  \033[1;36m🏠 \033[0m \033[33mHostname:\033[0m \033[1;32m$(hostname)\033[0m"
echo -e "  \033[1;36m💡 \033[0m \033[33mIP Address:\033[0m \033[1;32m${MAIN_IP}\033[0m"
EOF_SCRIPT_TEMPLATE
)
ENCODED_CONTENT=$(echo "${SCRIPT_CONTENT}" | base64 -w 0)

# --------------------------------------------------------
# CICLO DI ESECUZIONE PER OGNI LXC
# --------------------------------------------------------

for LXC_ID in "${CONTAINER_LIST[@]}"; do
    
    echo "Avvio aggiornamento sul container LXC ID: ${LXC_ID}..."
    
    # 1. Pulizia del MOTD
    CLEANUP_COMMAND="echo '' > /etc/motd; rm -f /etc/update-motd.d/10-uname; rm -f /etc/update-motd.d/99-custom;"
    echo "  -> Pulizia del MOTD..."
    pct exec "${LXC_ID}" -- bash -c "${CLEANUP_COMMAND}"

    # 2. Scrittura dello script tramite BASE64
    WRITE_COMMAND="echo ${ENCODED_CONTENT} | base64 -d > ${LXC_CONFIG_FILE} && chmod +x ${LXC_CONFIG_FILE}"
    echo "  -> Aggiornamento dello script banner..."
    pct exec "${LXC_ID}" -- bash -c "${WRITE_COMMAND}"

    # 3. Riavvio
    REBOOT_COMMAND="reboot"
    echo "  -> Riavvio dell'LXC per applicare le modifiche..."
    pct exec "${LXC_ID}" -- bash -c "${REBOOT_COMMAND}"

    echo "--- LXC ${LXC_ID} completato ---"
done

echo "--------------------------------------------------------"
echo "Tutti gli LXC selezionati sono stati elaborati e riavviati."
