#!/bin/bash
# KALI-GHOST PRO v1.1 - Utils

CONFIG_DIR="$HOME/.kali-ghost-pro"
SESSION_DIR="$CONFIG_DIR/sessions"
LOG_DIR="$CONFIG_DIR/logs"
CONFIG_FILE="$CONFIG_DIR/config.json"
DRY_RUN=false

# Colors
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; PURPLE='\033[0;35m'; CYAN='\033[0;36m'; NC='\033[0m'

# Logging
log() {
    mkdir -p "$LOG_DIR"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_DIR/activity.log"
}

info() { echo -e "${CYAN}ℹ️ $1${NC}"; log "$1"; }
success() { echo -e "${GREEN}✅ $1${NC}"; log "$1"; }
warn() { echo -e "${YELLOW}⚠️ $1${NC}"; log "$1"; }
error() { echo -e "${RED}❌ $1${NC}"; log "$1"; }

# Run command
run_cmd() {
    if [[ "$DRY_RUN" == true ]]; then
        warn "DRY-RUN: $1"
    else
        eval "$1"
        log "EXEC: $1"
    fi
}

# Initialize config
init_config() {
    mkdir -p "$CONFIG_DIR" "$SESSION_DIR" "$LOG_DIR"
    [[ ! -f "$CONFIG_FILE" ]] && echo '{"theme":"dark","proxy_dns":true,"dry_run":false}' > "$CONFIG_FILE"
}

# Generate session
init_session() {
    SESSION_ID=$(date '+%Y%m%d%H%M%S')
    CURRENT_SESSION="$SESSION_DIR/$SESSION_ID"
    mkdir -p "$CURRENT_SESSION"
    SESSION_KEY=$(openssl rand -hex 16)
    echo "$SESSION_KEY" > "$CURRENT_SESSION/session.key"
    success "Session $SESSION_ID started"
}

# Tor check
check_tor() {
    if systemctl is-active --quiet tor 2>/dev/null; then
        TOR_IP=$(timeout 10 curl --socks5 127.0.0.1:9050 -s https://httpbin.org/ip | grep -o '"origin":"[^"]*"' | cut -d'"' -f4)
        [[ "$TOR_IP" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] && success "TOR active → $TOR_IP" || warn "TOR running, IP unknown"
    else
        error "TOR not running"
    fi
}

# Rotate Tor identity
rotate_tor() {
    sudo systemctl restart tor
    sleep 5
    check_tor
    success "TOR identity rotated"
}

# VM detection
vm_detect() {
    PRODUCT=$(dmidecode -s system-product-name 2>/dev/null)
    if echo "$PRODUCT" | grep -Ei 'virtual|vmware|kvm|qemu|vbox' >/dev/null; then
        echo "VM: $PRODUCT"
    else
        echo "VM: Physical/Unknown"
    fi
}

# Clear shell history
clear_history() {
    history -c
    history -w
    success "Shell history cleared"
}

# Dependency check
check_dependencies() {
    info "Checking dependencies..."
    for cmd in proxychains4 tor nmap curl nikto dirsearch msfconsole burpsuite openssl; do
        if ! command -v $cmd >/dev/null 2>&1; then
            warn "$cmd not installed"
        else
            success "$cmd detected"
        fi
    done
}

# Encrypt logs for current session
encrypt_session_logs() {
    tar czf - "$CURRENT_SESSION" | openssl enc -aes-256-cbc -salt -pass pass:$SESSION_KEY -out "$CURRENT_SESSION.enc"
    rm -rf "$CURRENT_SESSION"
    success "Session logs encrypted"
}
