#!/usr/bin/env bash
set -Eeuo pipefail

fail=0
echo "=== RATECH / verification avant demarrage ==="

if [[ ! -f .env ]]; then
  echo "ERREUR : creer .env depuis .env.example avant de commencer."
  fail=1
elif grep -Eq '^WINDOWS_PASSWORD=(REMPLACER_PAR_UN_MOT_DE_PASSE_LONG_UNIQUE)?

if ! command -v docker >/dev/null 2>&1; then
  echo "ERREUR : Docker n'est pas installe."
  fail=1
elif ! docker info >/dev/null 2>&1; then
  echo "ERREUR : impossible de joindre le daemon Docker (essayer sudo)."
  fail=1
else
  docker --version
  docker compose version
fi

if [[ ! -c /dev/kvm ]]; then
  echo "ERREUR : /dev/kvm est absent ; Windows accelere ne pourra pas demarrer."
  fail=1
else
  echo "OK : /dev/kvm existe."
fi

if [[ ! -c /dev/net/tun ]]; then
  echo "ERREUR : /dev/net/tun est absent."
  fail=1
else
  echo "OK : /dev/net/tun existe."
fi

cpu_count="$(nproc)"
echo "CPU logiques disponibles : ${cpu_count} (4 demandes pour Windows)"
if (( cpu_count < 4 )); then
  echo "ATTENTION : moins de 4 CPU logiques disponibles."
fi

mem_kib="$(awk '/^MemTotal:/ {print $2}' /proc/meminfo)"
echo "RAM de l'hote : ${mem_kib} KiB (Windows : 4 GiB, prevoir de la marge pour Linux et Portainer)"
if (( mem_kib < 6 * 1024 * 1024 )); then
  echo "ATTENTION : 6 GiB de RAM hote recommandes au minimum, 8 GiB de preference."
fi

if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  docker_root="$(docker info --format '{{.DockerRootDir}}')"
  df -h "${docker_root}"
else
  df -h .
fi
echo "Prevoir au moins 64 GiB pour le disque Windows, et de l'espace libre supplementaire."

exit "${fail}"
 .env; then
  echo "ERREUR : modifier WINDOWS_PASSWORD dans .env avant toute installation."
  fail=1
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "ERREUR : Docker n'est pas installe."
  fail=1
elif ! docker info >/dev/null 2>&1; then
  echo "ERREUR : impossible de joindre le daemon Docker (essayer sudo)."
  fail=1
else
  docker --version
  docker compose version
fi

if [[ ! -c /dev/kvm ]]; then
  echo "ERREUR : /dev/kvm est absent ; Windows accelere ne pourra pas demarrer."
  fail=1
else
  echo "OK : /dev/kvm existe."
fi

if [[ ! -c /dev/net/tun ]]; then
  echo "ERREUR : /dev/net/tun est absent."
  fail=1
else
  echo "OK : /dev/net/tun existe."
fi

cpu_count="$(nproc)"
echo "CPU logiques disponibles : ${cpu_count} (4 demandes pour Windows)"
if (( cpu_count < 4 )); then
  echo "ATTENTION : moins de 4 CPU logiques disponibles."
fi

mem_kib="$(awk '/^MemTotal:/ {print $2}' /proc/meminfo)"
echo "RAM de l'hote : ${mem_kib} KiB (Windows : 4 GiB, prevoir de la marge pour Linux et Portainer)"
if (( mem_kib < 6 * 1024 * 1024 )); then
  echo "ATTENTION : 6 GiB de RAM hote recommandes au minimum, 8 GiB de preference."
fi

if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  docker_root="$(docker info --format '{{.DockerRootDir}}')"
  df -h "${docker_root}"
else
  df -h .
fi
echo "Prevoir au moins 64 GiB pour le disque Windows, et de l'espace libre supplementaire."

exit "${fail}"
