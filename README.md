-----

# 🌍 Language / Lingua

  * [🇮🇹 Leggi in Italiano](#-proxmox-lxc-dynamic-motd-banner-italiano)
  * [🇬🇧 Read in English](#-proxmox-lxc-dynamic-motd-banner-english)

-----

# 🇮🇹 Proxmox LXC Dynamic MOTD Banner (Italiano)

# 🚀 Proxmox LXC Dynamic MOTD Banner (v3.3.0)

[![Bash Script](https://img.shields.io/badge/language-Bash-4EAA25.svg)](https://www.gnu.org/software/bash/)
[![Proxmox](https://img.shields.io/badge/Platform-Proxmox-E57020.svg)](https://www.proxmox.com)
[![GitHub Code](https://img.shields.io/badge/GitHub-Repository-blue.svg?logo=github)](https://raw.githubusercontent.com/fcaronte/proxmox_lxc_update_terminal_welcome/refs/heads/main/update-terminal-welcome.sh)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Script avanzato per iniettare un banner informativo dinamico (MOTD) all'interno degli LXC Proxmox. Genera un riepilogo in tempo reale dello stato del sistema e rileva automaticamente gli URL di tutti i container Docker attivi, gestendo in modo intelligente anche le reti in modalità `host`.

---

## 🌟 Novità Versione 3.3.0

* **Interfaccia di Selezione (GUI)**: Menu interattivo grafico (`whiptail`) integrato per selezionare visivamente su quali LXC iniettare o aggiornare il banner.
* **Label-Based Compose Detection**: Rileva automaticamente i percorsi personalizzati dei file `compose.yaml` tramite le etichette interne di Dockge, estraendo le porte reali configurate dall'utente.
* **Host Network Bypass**: Supera i limiti di Docker isolando i metadati dei container che girano in modalità `network_mode: host` (es. Home Assistant ed ecosistema domotico).
* **Compatibilità Termix & Mobile**: Stringhe ANSI pulite senza conflitti grafici, ottimizzate per il rendering e l'interactivity automatica sui terminali smartphone.
* **Rilevamento Servizi Nativi**: Identifica se servizi locali come `FileBrowser` (servizi nativi di sistema) sono attivi e ne calcola dinamicamente la porta di ascolto locale.

---

## 🚀 Modalità di Esecuzione

Puoi scaricare ed eseguire lo script direttamente sul terminale del tuo **nodo Proxmox (Host PVE)** lanciando questo comando:

```bash
wget -qLO update-terminal-welcome.sh [https://raw.githubusercontent.com/fcaronte/proxmox_lxc_update_terminal_welcome/refs/heads/main/update-terminal-welcome.sh](https://raw.githubusercontent.com/fcaronte/proxmox_lxc_update_terminal_welcome/refs/heads/main/update-terminal-welcome.sh) && bash update-terminal-welcome.sh

```
Si aprirà un'interfaccia grafica dove potrai selezionare i singoli container o scegliere l'opzione ALL per automatizzare l'intero parco macchine.
## 📋 Architettura del Rilevamento Porte
Il motore inserito nel banner calcola gli indirizzi Web seguendo tre livelli prioritari di sicurezza:
 1. **Mappatura Standard**: Lettura diretta dei socket esposti dal demone Docker (modalità bridge/custom).
 2. **Analisi dello Stack**: Ispezione mirata del file Compose originario estratto dinamicamente tramite configurazione di Dockge.
 3. **Hardcoded Fallback**: Database interno delle porte standard per l'intero ecosistema Home Assistant (homeassistant, esphome, mosquitto, matter-server, wyoming-whisper/piper) e utility sussidiarie (stirling-pdf, gitea, qbittorrent, ecc.).
## 📝 Licenza
Sviluppato con il supporto di **Gemini AI**. Licenza MIT.
# 🇬🇧 Proxmox LXC Dynamic MOTD Banner (English)
# 🚀 Proxmox LXC Dynamic MOTD Banner (v3.3.0)
Bash Script

Proxmox

GitHub Code

License: MIT
Advanced script to inject a dynamic information banner (MOTD) into Proxmox LXCs. It generates a real-time system status overview and automatically detects web URLs for all active Docker containers, intelligently handling host network modes.
## 🌟 Version 3.3.0 Highlights
 * **Selection Interface (GUI)**: Built-in interactive graphical menu (whiptail) to visually select which LXCs to inject or update with the banner.
 * **Label-Based Compose Detection**: Automatically targets custom compose.yaml paths using Dockge's internal metadata labels, extracting user-configured host ports.
 * **Host Network Bypass**: Overcomes Docker engine limitations that hide port metadata when containers run in network_mode: host (e.g., Home Assistant ecosystem).
 * **Termix & Mobile Compatibility**: Clean ANSI escape strings preventing text distortion, fully optimized for rendering and automatic link detection on smartphone terminal apps.
 * **Native Service Detection**: Checks whether host-level utilities like FileBrowser are running as native system services and dynamically parses their active listening ports.
## 🚀 Execution
You can download and run the script directly on your **Proxmox Node (PVE Host)** terminal by running the following command:
```bash
wget -qLO update-terminal-welcome.sh [https://raw.githubusercontent.com/fcaronte/proxmox_lxc_update_terminal_welcome/refs/heads/main/update-terminal-welcome.sh](https://raw.githubusercontent.com/fcaronte/proxmox_lxc_update_terminal_welcome/refs/heads/main/update-terminal-welcome.sh) && bash update-terminal-welcome.sh

```
A graphical interface will pop up, allowing you to select individual containers or pick ALL to automate the entire environment.
## 📋 Port Detection Architecture
The embedded tracking engine computes Web links using a three-tier fallback pipeline:
 1. **Standard Mapping**: Direct lookup of container sockets exposed via the Docker daemon (bridge/custom network models).
 2. **Stack Inspection**: Targeted parsing of the original Compose file text block, fetched dynamically via Dockge configuration labels.
 3. **Hardcoded Fallback**: Internal database mapping default ports for the whole Home Assistant stack (homeassistant, esphome, mosquitto, matter-server, wyoming-whisper/piper) and standard containers (stirling-pdf, gitea, qbittorrent, etc.).
## 📝 License
Developed with **Gemini AI** support. MIT License.
```

```
