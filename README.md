# RATECH — Docker, Portainer et Windows

Configuration reproductible pour installer **Docker Engine + Docker Compose** sur un hote **Ubuntu Linux**, puis lancer :

- **Portainer CE** : interface de gestion Docker sur le port **9443 (HTTPS)**.
- **Windows 11**, via l'image `dockurr/windows:latest` : **4 vCPU, 4 Gio de RAM, disque de 64 Gio**, bureau dans le navigateur (port **8006**) et RDP (port **3389 TCP**).
- Deux volumes Docker persistants : donnees Portainer et disque Windows.

> **Important :** un depot GitHub heberge les fichiers, pas une machine Windows active. L'execution exige un **hote Linux x86_64 avec /dev/kvm** (CPU virtuel/nested virtualization autorises). GitHub Actions n'est pas un hebergement Windows permanent ; ne pas supposer KVM disponible sur Codespaces.

## Prerequis

- Ubuntu 22.04/24.04 (ou version prise en charge par Docker), droits `sudo`.
- Idealement **4 vCPU de l'hote, 8 Gio de RAM et 80 Gio ou plus d'espace disque disponible**. 4 Gio sont reserves a Windows ; l'hote a besoin de RAM additionnelle.
- `/dev/kvm` et `/dev/net/tun` accessibles, virtualisation materielle activee.
- Acces Internet pour telecharger les images et le systeme Windows.
- Licence Windows valide pour activer le systeme selon les conditions Microsoft.

## Installation sur la VM Ubuntu

```bash
git clone https://github.com/ELMRABET-Abdelali/ratech.git
cd ratech
sudo bash scripts/install-docker-ubuntu.sh
cp .env.example .env
chmod 600 .env
nano .env
```

**Dans `.env`, remplacer obligatoirement `WINDOWS_PASSWORD` par un mot de passe long, unique et prive**, puis :

```bash
sudo bash scripts/preflight.sh
sudo docker compose config --quiet
sudo docker compose up -d
sudo docker compose ps
```

Le premier demarrage de Windows telecharge les fichiers d'installation et peut prendre un certain temps. Les parametres `USERNAME` et `PASSWORD` sont notamment pris en compte lors de sa premiere installation : leur changement dans `.env` apres coup ne reinitialise pas automatiquement le compte Windows.

## Acces aux interfaces (prive, via SSH)

Sur ton PC, executer la commande suivante en remplacant l'utilisateur et l'IP :

```bash
ssh -N -L 9443:127.0.0.1:9443 -L 8006:127.0.0.1:8006 -L 3389:127.0.0.1:3389 ubuntu@IP_DU_SERVEUR
```

Puis ouvrir :

| Service | URL / connexion |
| --- | --- |
| Portainer | **https://localhost:9443** (certificat auto-signe possible ; creer le compte admin a la premiere visite) |
| Bureau Windows | **http://localhost:8006** (protection activee) |
| RDP Windows | `localhost:3389` dans `mstsc`, avec le compte Windows configure |

Tous les ports sont lies a **127.0.0.1 sur le serveur** : ils ne sont volontairement pas exposes directement a Internet. Ne pas ouvrir 3389, 8006 ou Portainer publiquement sans controle d'acces solide (VPN, pare-feu, authentification et TLS). Portainer a acces au socket Docker, ce qui donne des privileges tres eleves sur l'hote.

## Allumer / eteindre independamment

```bash
sudo docker compose stop windows
sudo docker compose start windows
sudo docker compose stop portainer
sudo docker compose start portainer
sudo docker compose logs -f windows
```

La commande `docker compose down` stoppe les conteneurs mais conserve normalement les volumes ; **ne pas executer `docker compose down -v`**, car cela supprimerait les donnees persistantes.

## Limites et diagnostic

- **KVM obligatoire pour une utilisation fluide**. Si `/dev/kvm` n'existe pas sur ton VPS, demander la virtualisation imbriquee a l'hebergeur ou choisir un autre serveur.
- `CPU_CORES=4` definit 4 vCPU **dans Windows**, sans creer 4 CPU physiques supplementaires sur l'hote.
- Les images doivent etre choisies suivant la compatibilite de l'hote ; `dockurr/windows:latest` est l'image utilisee, Windows 11 est le systeme choisi par defaut.
- Le RDP est plus reactif que la visionneuse web ; celle-ci convient pour l'installation et l'acces occasionnel.
- Faire des sauvegardes des volumes Docker `ratech_windows_storage` et `ratech_portainer_data`. Une suppression de Codespace ou de VM peut effacer des donnees non sauvegardees.

## Documentation officielle

- [Docker Engine pour Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
- [Portainer CE avec Docker](https://docs.portainer.io/start/install-ce/server/docker/linux)
- [dockur/windows](https://github.com/dockur/windows)
