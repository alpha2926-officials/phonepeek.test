#!/bin/bash

# X Ghost PhoneInfoga - Phone Number Intelligence Tool

# Colors
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
BLINK='\033[5m'
REVERSE='\033[7m'
NC='\033[0m'

# Banner
echo -e "${RED}▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄"
echo -e "${CYAN} 
 ██▓███   ██▓ ██▀███   ██▓███   ▒█████    █████▒▓█████  ██▀███  
▓██░  ██▒▓██▒▓██ ▒ ██▒▓██░  ██▒▒██▒  ██▒▓██   ▒ ▓█   ▀ ▓██ ▒ ██▒
▓██░ ██▓▒▒██▒▓██ ░▄█ ▒▓██░ ██▓▒▒██░  ██▒▒████ ░ ▒███   ▓██ ░▄█ ▒
▒██▄█▓▒ ▒░██░▒██▀▀█▄  ▒██▄█▓▒ ▒▒██   ██░░▓█▒  ░ ▒▓█  ▄ ▒██▀▀█▄  
▒██▒ ░  ░░██░░██▓ ▒██▒▒██▒ ░  ░░ ████▓▒░░▒█░    ░▒████▒░██▓ ▒██▒
▒▓▒░ ░  ░░▓  ░ ▒▓ ░▒▓░▒▓▒░ ░  ░░ ▒░▒░▒░  ▒ ░    ░░ ▒░ ░░ ▒▓ ░▒▓░
░▒ ░      ▒ ░  ░▒ ░ ▒░░▒ ░       ░ ▒ ▒░  ░       ░ ░  ░  ░▒ ░ ▒░
░░        ▒ ░  ░░   ░ ░░       ░ ░ ░ ▒   ░ ░       ░     ░░   ░ 
          ░     ░                    ░ ░           ░  ░   ░     
${NC}"
echo -e "${RED}▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀${NC}"
echo -e "${YELLOW}[+] ${WHITE}Phone Number Intelligence Tool ${GREEN}Created by X Ghost ${NC}"
echo -e "${YELLOW}[+] ${WHITE}Gathering Phone Number Intelligence Like A Pek!${NC}\n"

# Check dependencies
check_deps() {
    command -v curl >/dev/null 2>&1 || { echo -e "${RED}[-] Error: curl not found!${NC}"; exit 1; }
    command -v jq >/dev/null 2>&1 || { echo -e "${RED}[-] Error: jq required!${NC}"; exit 1; }
}

# Validate phone number
validate_number() {
    local num="$1"
    if [[ ! $num =~ ^\+[1-9]{1}[0-9]{1,14}$ ]]; then
        echo -e "${RED}[-] Invalid phone number format! Use E.164 format (+CountryCodeNumber)${NC}"
        exit 1
    fi
}

# API function
get_info() {
    local number="$1"
    local api_key="YOUR_API_KEY_HERE"  # Get from numverify.com
    
    echo -e "${CYAN}[*] ${WHITE}Initializing scan for: ${GREEN}$number${NC}"
    echo -e "${CYAN}[*] ${WHITE}Connecting to intelligence sources...${NC}"
    
    response=$(curl -s "http://apilayer.net/api/validate?access_key=$api_key&number=$number")
    
    if [ -z "$response" ]; then
        echo -e "${RED}[-] API request failed! Check connection${NC}"
        exit 1
    fi
    
    echo -e "\n${GREEN}➖➖➖➖➖➖➖➖➖➖[ ${WHITE}RESULTS ${GREEN}]➖➖➖➖➖➖➖➖➖➖${NC}"
    
    valid=$(echo "$response" | jq -r '.valid')
    if [ "$valid" == "true" ]; then
        echo -e "${GREEN}[✓] ${WHITE}Number Validated: ${GREEN}Valid${NC}"
    else
        echo -e "${RED}[✗] ${WHITE}Number Validated: ${RED}Invalid${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}[•] ${WHITE}Country: ${YELLOW}$(echo "$response" | jq -r '.country_name')${NC}"
    echo -e "${BLUE}[•] ${WHITE}Location: ${YELLOW}$(echo "$response" | jq -r '.location')${NC}"
    echo -e "${BLUE}[•] ${WHITE}Carrier: ${YELLOW}$(echo "$response" | jq -r '.carrier')${NC}"
    echo -e "${BLUE}[•] ${WHITE}Line Type: ${YELLOW}$(echo "$response" | jq -r '.line_type')${NC}"
    echo -e "${BLUE}[•] ${WHITE}International Format: ${YELLOW}$(echo "$response" | jq -r '.international_format')${NC}"
    echo -e "${BLUE}[•] ${WHITE}Local Format: ${YELLOW}$(echo "$response" | jq -r '.local_format')${NC}"
    echo -e "${BLUE}[•] ${WHITE}Country Prefix: ${YELLOW}+$(echo "$response" | jq -r '.country_prefix')${NC}"
    
    echo -e "\n${MAGENTA}[!] ${WHITE}Additional OSINT Suggestions:"
    echo -e "${YELLOW}- Check social media platforms"
    echo -e "- Search on Truecaller"
    echo -e "- Google dork: intext:\"$number\""
    echo -e "- Check data breach databases${NC}"
}

# Main execution
main() {
    check_deps
    
    if [ $# -eq 0 ]; then
        echo -e "${GREEN}[?] ${WHITE}Enter phone number (E.164 format): ${NC}"
        read -p $'\e[1;36mPHONE\e[0m>\e[1;33m+\e[0m ' number
        number="+$number"
    else
        number="$1"
    fi

    validate_number "$number"
    get_info "$number"
    
    echo -e "\n${GREEN}➖➖➖➖➖➖➖➖➖➖[ ${WHITE}X GHOST ${GREEN}]➖➖➖➖➖➖➖➖➖➖${NC}"
}

main "$@"
