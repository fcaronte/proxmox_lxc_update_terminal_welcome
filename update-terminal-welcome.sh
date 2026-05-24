#!/bin/bash

# ======================================================================
# SCRIPT: update-terminal-welcome.sh
# Descrizione: Configura un banner MOTD DINAMICO (Live) negli LXC.
# Versione: 3.3.0 (Rimozione codici speciali per compatibilità Termix)
# Autore: Proxmox LXC Docker Updater Mod
# ======================================================================

# --- CONFIGURAZIONE DINAMICA INTERFACCIA (UI) ---
TERM_WIDTH=$(tput cols)
TERM_HEIGHT=$(tput lines)

IFACE_WIDTH=$(( TERM_WIDTH * 80 / 100 ))
IFACE_HEIGHT=$(( TERM_HEIGHT * 80 / 100 ))

[ $IFACE_WIDTH -gt 75 ] && IFACE_WIDTH=75
[ $IFACE_WIDTH -lt 50 ] && IFACE_WIDTH=50
[ $IFACE_HEIGHT -gt 25 ] && IFACE_HEIGHT=25
[ $IFACE_HEIGHT -lt 12 ] && IFACE_HEIGHT=12

LIST_HEIGHT=$(( IFACE_HEIGHT - 7 ))

NODE_NAME=$(hostname)

if ! command -v whiptail &> /dev/null; then echo "Errore: whiptail non trovato."; exit 1; fi

# --- GENERAZIONE MENU ---
MENU_ITEMS="ALL [Tutti_i_Container_attivi] off $(pct list | awk 'NR>1 {print $1 " [LXC_" $3 "] off"}')"
CHOICES=$(whiptail --title "System & Service Inspector (LIVE)" --checklist "Seleziona i container da rendere dinamici:" \
    $IFACE_HEIGHT $IFACE_WIDTH $LIST_HEIGHT $MENU_ITEMS 3>&1 1>&2 2>&3)

[ $? -ne 0 ] && exit 0
CHOICES=$(echo "$CHOICES" | tr -d '"')

[[ "$CHOICES" == *"ALL"* ]] && TARGET_IDS=$(pct list | awk 'NR>1 && $2 == "running" {print $1}') || TARGET_IDS=$CHOICES

# --- INIEZIONE BANNER VIA BASE64 ---
for LXC_ID in $TARGET_IDS; do
    echo "Installazione motore Live nel container $LXC_ID..."

    cat << 'EOF' > /tmp/raw_banner.sh
#!/bin/bash
clear

# 1. Calcolo Risorse Live dell'LXC
OS_V=$(cat /etc/debian_version 2>/dev/null || echo "N/A")
IP_V=$(hostname -I | awk '{print $1}' | tr -d '[:space:]')
HN_V=$(hostname)

# Controllo FileBrowser e autodetect della porta
FB_V="❌ No"
if [ -f "/usr/local/bin/filebrowser" ] || command -v filebrowser &>/dev/null; then
    FB_PORT=$(ps aux | grep -i filebrowser | grep -oP '(-p|--port)\s+\K[0-9]+' | head -n1)
    if [ -z "$FB_PORT" ] && command -v ss &>/dev/null; then
        FB_PORT=$(ss -tlnp | grep -i filebrowser | grep -oP ':\K[0-9]+(?=\s)' | head -n1)
    fi
    [ -z "$FB_PORT" ] && FB_PORT="8080"
    
    FB_V="✅ Sì \033[0;36mhttp://$IP_V:$FB_PORT\033[0m"
fi

DK_V="❌ No"
if command -v docker &>/dev/null; then
    DK_V="✅ Sì"
fi

# Sostituito da Proxmox al momento dell'installazione
NODE_NAME="REPLACE_NODE_NAME"

echo -e "\033[1;36m$NODE_NAME\033[0m"
echo -e " 🏠 \033[33mHostname:\033[0m $HN_V"
echo -e " 🖥️  \033[33mOS:\033[0m Debian $OS_V"
echo -e " 💡 \033[33mIP:\033[0m $IP_V"
echo -e " 📂 \033[33mFileBrowser:\033[0m $FB_V"
echo -e " 🐳 \033[33mDocker:\033[0m $DK_V"
echo -e " 📊 \033[33mRAM Usage:\033[0m $(free -h | awk '/^Mem:/ {print $3 "/" $2}')"
echo -e " 💾 \033[33mDisk Usage:\033[0m $(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')"

# 2. Analisi Live Container Docker
if [ "$DK_V" == "✅ Sì" ]; then
    CT_DATA=$(docker ps --format "{{.Names}}|{{.Ports}}")
    
    if [ -n "$CT_DATA" ]; then
        echo -e "\n\033[1;32mContainer Attivi (Link Live):\033[0m"
        
        echo "$CT_DATA" | while read -r line; do
            [ -z "$line" ] && continue
            
            line=$(echo "$line" | sed 's/\x1b\[[0-9;]*m//g')
            
            NAME=$(echo "$line" | cut -d'|' -f1 | tr -d '[:space:]')
            PORTS_RAW=$(echo "$line" | cut -d'|' -f2)
            
            PORT=""
            
            # Strategia 1: standard docker ps
            if [ -n "$PORTS_RAW" ]; then
                PORT=$(echo "$PORTS_RAW" | grep -oP '(0\.0\.0\.0:|\[::\]:)\K[0-9]+(?=->)' | head -n1)
            fi
            
            # Strategia 2: Host mode via Label
            if [ -z "$PORT" ] || [[ "$(docker inspect --format='{{.HostConfig.NetworkMode}}' "$NAME" 2>/dev/null)" == "host" ]]; then
                COMPOSE_FILE=$(docker inspect --format='{{index .Config.Labels "com.docker.compose.project.config_files"}}' "$NAME" 2>/dev/null)
                
                if [ -n "$COMPOSE_FILE" ] && [ -f "$COMPOSE_FILE" ]; then
                    PORT=$(awk "/container_name:.*$NAME/,/^[^ ]/" "$COMPOSE_FILE" 2>/dev/null | grep -A 2 -E "ports:" | grep -oP '\s*-\s*\K[0-9]+(?=:[0-9]+)' | head -n1)
                    if [ -z "$PORT" ]; then
                        PORT=$(awk "/container_name:.*$NAME/,/^[^ ]/" "$COMPOSE_FILE" 2>/dev/null | grep -oP '(PORT|Port|PORT_WEB)=\K[0-9]+' | head -n1)
                    fi
                fi
            fi
            
            # Strategia 3: Fallbacks storici HomeAssistant / altri core
            if [ -z "$PORT" ]; then
                case "$NAME" in
                    "homeassistant")       PORT="8123" ;;
                    "dockge")              PORT="5001" ;;
                    "syncthing")           PORT="8384" ;;
                    "wakeonlan"|"gptwol")  PORT="1234" ;;
                    "esphome")             PORT="6052" ;;
                    "mosquitto")           PORT="1883" ;;
                    "matter-server")       PORT="5580" ;;
                    "wyoming-whisper")     PORT="10200" ;;
                    "wyoming-piper")       PORT="10300" ;;
                    "stirling-pdf")        PORT="8888" ;;
                    "rustdesk_web")        PORT="5000" ;;
                    "qbittorrent")         PORT="6881" ;;
                    "gitea")               PORT="3000" ;;
                    "jdownloader2")        PORT="3129" ;;
                    "rustdesk_server")     PORT="21116" ;;
                    "openspeedtest")       PORT="3004" ;;
                esac
            fi
            
            PORT=$(echo "$PORT" | tr -d -c '0-9')
            
            if [ -n "$PORT" ]; then
                # Stampiamo il link pulito: Termix lo evidenzierà da solo rendendolo interattivo
                echo -e "  - \033[1;37m$NAME\033[0m \033[0;36mhttp://$IP_V:$PORT\033[0m"
            else
                echo -e "  - \033[1;37m$NAME\033[0m"
            fi
        done
    fi
fi
EOF

    # Inseriamo il nome corretto del nodo Proxmox
    sed -i "s/REPLACE_NODE_NAME/$NODE_NAME/g" /tmp/raw_banner.sh

    # Conversione in stream Base64 sicuro
    B64_STREAM=$(base64 -w 0 /tmp/raw_banner.sh)

    # Scrittura del file decodificato dentro l'LXC
    pct exec "$LXC_ID" -- bash -c "echo '$B64_STREAM' | base64 -d > /etc/profile.d/00_lxc-details.sh"
    pct exec "$LXC_ID" -- chmod +x /etc/profile.d/00_lxc-details.sh
    
    # Pulizia vecchi residui e aggancio al .bashrc
    pct exec "$LXC_ID" -- sed -i '/00_lxc-details.sh/d' /root/.bashrc
    pct exec "$LXC_ID" -- bash -c "echo '/etc/profile.d/00_lxc-details.sh' >> /root/.bashrc"
    
    echo "✅ Container $LXC_ID aggiornato con successo."
done

# --- PULIZIA FINALE SUL NODO ---
[ -f /tmp/raw_banner.sh ] && rm /tmp/raw_banner.sh
echo "--------------------------------------------------------"
echo "Aggiornamento completato! Stringhe pulite e compatibilità Termix al 100%."
