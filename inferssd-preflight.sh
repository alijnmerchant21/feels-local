#!/usr/bin/env sh
# InferSSD pre-flight check (unofficial). Checks the requirements listed in
# InferSSD's README and docs/quickstart.md before you install.
# Usage: sh inferssd-preflight.sh   (MODEL_DIR=/path/on/ssd NEED_GIB=475 to override)
NEED_GIB=${NEED_GIB:-475}
MODEL_DIR=${MODEL_DIR:-$HOME/.local/share/inferssd/models}
fail=0
ok()   { printf '  ok    %s\n' "$1"; }
miss() { printf '  MISS  %s\n' "$1"; fail=1; }
has()  { command -v "$1" >/dev/null 2>&1; }

os=$(uname -s); arch=$(uname -m)
echo "InferSSD pre-flight on $os $arch"
case "$os" in
  Darwin)
    if [ "$arch" = arm64 ]; then ok "Apple Silicon"; else miss "Apple Silicon Mac required (found $arch)"; fi
    if xcode-select -p >/dev/null 2>&1; then ok "Xcode Command Line Tools"; else miss "Xcode Command Line Tools: run xcode-select --install"; fi
    ;;
  Linux)
    if has nvidia-smi; then ok "NVIDIA driver: $(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null | head -n 1)"; else miss "NVIDIA GPU driver (nvidia-smi not found)"; fi
    if has nvcc || [ -x /usr/local/cuda/bin/nvcc ] || [ -n "$CUDACXX" ]; then ok "CUDA compiler (nvcc)"; else miss "CUDA toolkit: nvcc not on PATH, not in /usr/local/cuda, CUDACXX not set"; fi
    if [ -f /usr/include/liburing.h ]; then ok "liburing headers"; else miss "liburing headers (Debian/Ubuntu: sudo apt install liburing-dev)"; fi
    if [ "$(cat /proc/1/comm 2>/dev/null)" = systemd ]; then ok "systemd is the init system"; else miss "systemd as init (most containers, and WSL without systemd, fail here)"; fi
    if [ -f /sys/fs/cgroup/cgroup.controllers ]; then ok "cgroup v2"; else miss "cgroup v2 unified hierarchy"; fi
    ;;
  *)
    miss "Unsupported OS: $os. Use macOS on Apple Silicon or Linux with NVIDIA (Windows is in progress)"
    ;;
esac
if has git; then ok "git"; else miss "git"; fi
if has python3 && python3 -c 'import sys, venv; sys.exit(sys.version_info < (3, 9))' 2>/dev/null; then
  ok "Python $(python3 -c 'import sys; print("%d.%d" % sys.version_info[:2])') with venv"
else
  miss "Python 3.9 or later with venv"
fi
if has c++ || has g++ || has clang++; then ok "C++ compiler"; else miss "C/C++ compiler"; fi

probe=$MODEL_DIR
while [ ! -d "$probe" ]; do probe=$(dirname "$probe"); done
free_gib=$(df -Pk "$probe" | awk 'NR == 2 { printf "%d", $4 / 1048576 }')
if [ "$free_gib" -ge "$NEED_GIB" ]; then
  ok "Disk: $free_gib GiB free at $probe (need about $NEED_GIB)"
else
  miss "Disk: $free_gib GiB free at $probe, need about $NEED_GIB. Pass --model-dir to use a larger SSD"
fi

echo
if [ "$fail" -eq 0 ]; then
  echo "Ready. Install with:"
  echo "  curl -fsSL https://github.com/wici-ai/inferssd/releases/latest/download/install.sh | sh"
else
  echo "Fix the MISS lines above, then run the installer."
  exit 1
fi
