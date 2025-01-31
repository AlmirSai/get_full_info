#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to display a header for each section
print_header() {
    echo -e "${BLUE}----------------------------------------${NC}"
    echo -e "${GREEN}$1${NC}"
    echo -e "${BLUE}----------------------------------------${NC}"
}

# Function to display key-value pairs
print_info() {
    echo -e "${YELLOW}$1: ${NC}$2"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Detect the operating system
OS="$(uname -s)"

# Gather hardware information based on the OS
if [ "$OS" = "Linux" ]; then
    print_header "CPU Information"
    lscpu
    print_info "CPU Frequency" "$(lscpu | grep 'MHz' | awk '{print $3 " MHz"}')"
    print_info "CPU Cache" "$(lscpu | grep 'cache' | awk -F ': ' '{print $2}')"
    print_info "CPU Flags" "$(lscpu | grep 'Flags' | awk -F ': ' '{print $2}')"
    print_info "Load Average" "$(uptime | awk -F 'load average: ' '{print $2}')"

    print_header "GPU Information"
    lspci | grep -i vga
    if command_exists nvidia-smi; then
        echo -e "${CYAN}NVIDIA GPU Details:${NC}"
        nvidia-smi --query-gpu=name,driver_version,memory.total,memory.used,temperature.gpu --format=csv
    else
        echo -e "${RED}NVIDIA GPU not detected or driver not installed.${NC}"
    fi
    if command_exists radeontop; then
        echo -e "${CYAN}AMD GPU Details:${NC}"
        radeontop -l 1 -d - | grep 'GPU'
    else
        echo -e "${RED}AMD GPU not detected or radeontop not installed.${NC}"
    fi

elif [ "$OS" = "Darwin" ]; then
    print_header "CPU Information"
    sysctl -a | grep machdep.cpu
    print_info "CPU Frequency" "$(sysctl -n hw.cpufrequency)"
    print_info "CPU Cache" "$(sysctl -n hw.l1icachesize)"
    print_info "Load Average" "$(uptime | awk -F 'load averages: ' '{print $2}')"

    print_header "GPU Information"
    system_profiler SPDisplaysDataType
    if command_exists istats; then
        echo -e "${CYAN}GPU Temperature:${NC}"
        istats gpu
    else
        echo -e "${RED}Temperature sensors not available. Install 'istats' with 'gem install iStats'.${NC}"
    fi

else
    echo -e "${RED}Unsupported operating system: $OS${NC}"
    exit 1
fi

print_header "Kernel Information"
uname -r

print_header "System Uptime"
uptime

print_header "Running Processes"
ps aux

print_header "Environment Variables"
printenv

# Expanded Developer Tools Section
print_header "Developer Tools"

print_header "${CYAN}Programming Languages${NC}"
print_info "Go Version" "$(go version 2>/dev/null || echo 'Go not installed')"
print_info "Python Version" "$(python3 --version 2>/dev/null || echo 'Python not installed')"
print_info "Node.js Version" "$(node --version 2>/dev/null || echo 'Node.js not installed')"
print_info "Ruby Version" "$(ruby --version 2>/dev/null || echo 'Ruby not installed')"
print_info "Java Version" "$(java --version 2>/dev/null || echo 'Java not installed')"
print_info "GCC Version" "$(gcc --version 2>/dev/null | head -n 1 || echo 'GCC not installed')"

print_header "${CYAN}Package Managers${NC}"
print_info "npm Version" "$(npm --version 2>/dev/null || echo 'npm not installed')"
print_info "Yarn Version" "$(yarn --version 2>/dev/null || echo 'Yarn not installed')"
print_info "pip Version" "$(pip3 --version 2>/dev/null || echo 'pip not installed')"
print_info "Homebrew Version" "$(brew --version 2>/dev/null || echo 'Homebrew not installed')"

print_header "${CYAN}Databases${NC}"
print_info "PostgreSQL Version" "$(psql --version 2>/dev/null || echo 'PostgreSQL not installed')"
print_info "MySQL Version" "$(mysql --version 2>/dev/null || echo 'MySQL not installed')"
print_info "MongoDB Version" "$(mongod --version 2>/dev/null || echo 'MongoDB not installed')"
print_info "SQLite Version" "$(sqlite3 --version 2>/dev/null || echo 'SQLite not installed')"

print_header "${CYAN}Web Frameworks${NC}"
print_info "React Version" "$(npx react --version 2>/dev/null || echo 'React not installed')"
print_info "Vue Version" "$(npx vue --version 2>/dev/null || echo 'Vue not installed')"
print_info "Angular Version" "$(npx ng version 2>/dev/null || echo 'Angular not installed')"
print_info "Django Version" "$(python3 -m django --version 2>/dev/null || echo 'Django not installed')"
print_info "Flask Version" "$(python3 -m flask --version 2>/dev/null || echo 'Flask not installed')"

print_header "${CYAN}Containerization & Orchestration${NC}"
print_info "Docker Version" "$(docker --version 2>/dev/null || echo 'Docker not installed')"
print_info "Kubernetes Version" "$(kubectl version --client --short 2>/dev/null || echo 'Kubernetes not installed')"
print_info "Helm Version" "$(helm version --short 2>/dev/null || echo 'Helm not installed')"

print_header "${CYAN}Version Control${NC}"
print_info "Git Version" "$(git --version 2>/dev/null || echo 'Git not installed')"

print_header "${CYAN}Cloud Tools${NC}"
print_info "AWS CLI Version" "$(aws --version 2>/dev/null || echo 'AWS CLI not installed')"
print_info "Azure CLI Version" "$(az --version 2>/dev/null || echo 'Azure CLI not installed')"
print_info "Google Cloud SDK Version" "$(gcloud --version 2>/dev/null | head -n 1 || echo 'Google Cloud SDK not installed')"

echo -e "${GREEN}Hardware and developer information collection complete.${NC}"
