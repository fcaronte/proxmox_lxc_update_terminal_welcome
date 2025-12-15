
-----

# 🚀 LXC Terminal Welcome Banner Updater

Questo script Bash (`update-terminal-welcome.sh`) automatizza l'aggiornamento del banner di benvenuto (MOTD) su uno o più container LXC Debian gestiti da Proxmox, fornendo informazioni dinamiche e colorate al momento del login.

## 🇮🇹 Italiano

### Caratteristiche Principali

  * **Aggiornamento Centralizzato:** Applica la configurazione a uno o più LXC in un'unica esecuzione.
  * **Discovery Automatica:** Trova tutti i container LXC **attivi** (running) sul tuo host Proxmox.
  * **Informazioni Dinamiche:** Il banner visualizzato include:
      * Hostname del container.
      * Versione del sistema operativo Debian.
      * Indirizzo IP LAN principale (ottimizzato per ignorare gli IP Docker/VPN).
  * **Pulizia Automatizzata:** Rimuove i vecchi script MOTD che potrebbero interferire con il nuovo banner.
  * **Affidabilità:** Utilizza la codifica Base64 per trasferire lo script complesso nel container, aggirando i problemi di *escaping* dei caratteri speciali.
  * **Riavvio:** Esegue il riavvio di ogni container dopo l'aggiornamento.

### Prerequisiti

  * Un host Proxmox.
  * Accesso alla shell come `root` o un utente con permessi `sudo`.
  * Container LXC Debian in esecuzione.

### Installazione

1.  Crea un file chiamato `update-terminal-welcome.sh` sul tuo host Proxmox.

2.  Copia e incolla il codice fornito nell'ultima versione dello script.

3.  Rendi lo script eseguibile:

    ```bash
    chmod +x update-terminal-welcome.sh
    ```
#### 🚀 Esecuzione Diretta da URL

Se lo script è ospitato su un repository remoto (ad esempio, GitHub), è possibile scaricarlo ed eseguirlo direttamente in un unico passaggio, senza salvarlo localmente. Questo è particolarmente utile per le esecuzioni *one-shot*:


```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/fcaronte/proxmox_lxc_update_terminal_welcome/main/update-terminal-welcome.sh)" -- all
```


### Utilizzo

Lo script supporta l'aggiornamento di singoli container, di un elenco di container, o di tutti i container attivi.

| Comando | Descrizione |
| :--- | :--- |
| `./update-terminal-welcome.sh 8001` | Aggiorna solo il container con VMID 8001. |
| `./update-terminal-welcome.sh 8001 8005` | Aggiorna i container 8001 e 8005. |
| `./update-terminal-welcome.sh all` | Aggiorna **tutti** i container LXC attivi (running) trovati tramite `pct list`. |

### Esempio di Output

Quando l'aggiornamento è completo e accedi al container, vedrai un banner simile a questo:

```bash
Syncthing LXC Container

  🖥️  OS: Debian GNU/Linux - Version: 12.5
  🏠  Hostname: Syncthing
  💡  IP Address: 192.168.1.206
```

-----

## 🇬🇧 English

# 🚀 LXC Terminal Welcome Banner Updater

This Bash script (`update-terminal-welcome.sh`) automates the update of the login welcome banner (MOTD) on one or more Debian LXC containers managed by Proxmox, providing dynamic and colored information upon login.

### Key Features

  * **Centralized Update:** Applies the configuration to one or more LXCs in a single execution.
  * **Automatic Discovery:** Finds all **active** (running) LXC containers on your Proxmox host.
  * **Dynamic Information:** The displayed banner includes:
      * Container Hostname.
      * Debian OS version.
      * Primary LAN IP address (optimized to ignore Docker/VPN IPs).
  * **Automated Cleanup:** Removes old MOTD scripts that might interfere with the new banner.
  * **Reliability:** Uses Base64 encoding to transfer the complex script into the container, bypassing special character *escaping* issues.
  * **Reboot:** Executes a reboot of each container after the update.

### Prerequisites

  * A Proxmox host.
  * Shell access as `root` or a user with `sudo` permissions.
  * Running Debian LXC containers.

### Installation

1.  Create a file named `update-terminal-welcome.sh` on your Proxmox host.

2.  Copy and paste the code provided in the latest script version.

3.  Make the script executable:

    ```bash
    chmod +x update-terminal-welcome.sh
    ```

---

### 🇬🇧 Aggiornamento del README (Inglese)

Aggiungi la seguente sottosezione nella sezione "Usage" (`### Usage`):

```markdown
#### 🚀 Direct Execution from URL

If the script is hosted on a remote repository (e.g., GitHub), you can download and run it directly in one step, without saving it locally. This is particularly useful for *one-shot* executions:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/fcaronte/proxmox_lxc_update_terminal_welcome/main/update-terminal-welcome.sh)" -- all
```


### Usage

The script supports updating single containers, a list of containers, or all active containers.

| Command | Description |
| :--- | :--- |
| `./update-terminal-welcome.sh 8001` | Updates only the container with VMID 8001. |
| `./update-terminal-welcome.sh 8001 8005` | Updates containers 8001 and 8005. |
| `./update-terminal-welcome.sh all` | Updates **all** active (running) LXC containers found via `pct list`. |

### Example Output

Once the update is complete and you log into the container, you will see a banner similar to this:

```bash
Syncthing LXC Container

  🖥️  OS: Debian GNU/Linux - Version: 12.5
  🏠  Hostname: Syncthing
  💡  IP Address: 192.168.1.206
```
