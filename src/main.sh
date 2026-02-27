#!/bin/bash
# KALI-GHOST PRO v1.1 - Ultimate OPSEC Dashboard

VERSION="1.1"
DRY_RUN=false

source src/utils.sh
source src/modules/tools.sh

for arg in "$@"; do
    case $arg in
        --version) echo "KALI-GHOST PRO v$VERSION"; exit 0 ;;
        --dry-run) DRY_RUN=true ;;
    esac
done

init_config
init_session

banner() {
    clear
    echo -e "${PURPLE}
 _  __     _ _     ____ _               _   
 | |/ /__ _| (_)___/ ___| |__   ___  ___| |_ 
 | ' // _\` | | / __| |  _| '_ \ / _ \/ __| __|
 | . \ (_| | | \__ \ |_| | | | |  __/\__ \ |_ 
 |_|\_\__,_|_|_|___/\____|_| |_|\___||___/\__|
${NC}"
    echo -e "${GREEN}v$VERSION | OPSEC & Pentest Dashboard${NC}\n"
}

legal_targets() {
    echo -e "${GREEN}Legal Targets:${NC}"
    echo "• scanme.nmap.org"
    echo "• testphp.vulnweb.com"
    echo "• httpbin.org"
}

fingerprint() {
    echo -e "${BLUE}System Info:${NC}"
    echo "User: $(whoami)@$(hostname)"
    echo "OS: $(grep PRETTY_NAME /etc/os-release 2>/dev/null | cut -d'"' -f2)"
    echo "Kernel: $(uname -r)"
    echo "Arch: $(uname -m)"
    vm_detect
}

safety_check() {
    check_dependencies
    check_tor
}

main_menu() {
    while true; do
        banner
        fingerprint
        legal_targets

        echo -e "\n${BLUE}Dashboard Options:${NC}"
        echo "1) Launch Tool"
        echo "2) Safety Check"
        echo "3) Rotate TOR"
        echo "4) Clear History"
        echo "5) View Logs"
        echo "6) Encrypt & Close Session"
        echo "7) System Update"
        echo "q) Quit"

        read -p "Choose: " choice
        case $choice in
            1) run_tool ;;
            2) safety_check ;;
            3) rotate_tor ;;
            4) clear_history ;;
            5) cat "$CURRENT_SESSION/activity.log" 2>/dev/null || warn "No logs yet" ;;
            6) encrypt_session_logs ;;
            7) run_cmd "sudo apt update && sudo apt upgrade -y" ;;
            [qQ]) encrypt_session_logs; success "Exiting"; exit 0 ;;
            *) error "Invalid option" ;;
        esac

        read -p "Press Enter to continue..."
    done
}

main_menu
