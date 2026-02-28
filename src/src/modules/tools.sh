#!/bin/bash
# KALI-GHOST PRO - Tool Launcher

run_tool() {
    echo -e "\n${CYAN}Available Tools:${NC}"
    echo "1) Nmap"
    echo "2) Nikto"
    echo "3) Dirsearch"
    echo "4) Metasploit"
    echo "5) Burp"
    read -p "Select: " t

    case $t in
        1) run_cmd "proxychains4 nmap -sC -sV scanme.nmap.org -oN $CURRENT_SESSION/nmap.txt" ;;
        2) run_cmd "proxychains4 nikto -h testphp.vulnweb.com" ;;
        3) run_cmd "proxychains4 dirsearch -u http://testphp.vulnweb.com -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt" ;;
        4) run_cmd "proxychains4 msfconsole" ;;
        5) run_cmd "burpsuite" ;;
        *) error "Invalid tool selection" ;;
    esac
}
