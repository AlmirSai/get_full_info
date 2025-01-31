#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ASCII Art for Welcome Message
print_welcome() {
    echo -e "${BLUE}"
    echo "  ____  _   _ ____  _____ ____  "
    echo " / ___|| | | |  _ \| ____|  _ \ "
    echo " \___ \| | | | |_) |  _| | | | |"
    echo "  ___) | |_| |  __/| |___| |_| |"
    echo " |____/ \___/|_|   |_____|____/ "
    echo -e "${NC}"
    echo -e "${GREEN}Welcome to the System Information Tool!${NC}"
    echo -e "${BLUE}----------------------------------------${NC}"
}

# Function to display a header for each section
print_header() {
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║ $1${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
}

# Function to display a subheader for each section
print_subheader() {
    echo -e "${CYAN}╟────────────────────────────────────────╢${NC}"
    echo -e "${CYAN}║ $1${NC}"
    echo -e "${CYAN}╟────────────────────────────────────────╢${NC}"
}

# Function to display key-value pairs
print_info() {
    echo -e "${YELLOW}║ $1: ${NC}$2"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to display a spinner
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Function to display CPU information
cpu_info() {
    print_header "💻 CPU Information"
    if [ "$OS" = "Linux" ]; then
        lscpu
        print_info "CPU Frequency" "$(lscpu | grep 'MHz' | awk '{print $3 " MHz"}')"
        print_info "CPU Cache" "$(lscpu | grep 'cache' | awk -F ': ' '{print $2}')"
        print_info "CPU Flags" "$(lscpu | grep 'Flags' | awk -F ': ' '{print $2}')"
    elif [ "$OS" = "Darwin" ]; then
        sysctl -a | grep machdep.cpu
        print_info "CPU Frequency" "$(sysctl -n hw.cpufrequency)"
        print_info "CPU Cache" "$(sysctl -n hw.l1icachesize)"
    fi
    print_info "Load Average" "$(uptime | awk -F 'load average: ' '{print $2}')"
}

# Function to display GPU information
gpu_info() {
    print_header "🎮 GPU Information"
    if [ "$OS" = "Linux" ]; then
        lspci | grep -i vga
        if command_exists nvidia-smi; then
            echo -e "${CYAN}║ NVIDIA GPU Details:${NC}"
            nvidia-smi --query-gpu=name,driver_version,memory.total,memory.used,temperature.gpu --format=csv
        else
            echo -e "${RED}║ NVIDIA GPU not detected or driver not installed.${NC}"
        fi
        if command_exists radeontop; then
            echo -e "${CYAN}║ AMD GPU Details:${NC}"
            radeontop -l 1 -d - | grep 'GPU'
        else
            echo -e "${RED}║ AMD GPU not detected or radeontop not installed.${NC}"
        fi
    elif [ "$OS" = "Darwin" ]; then
        system_profiler SPDisplaysDataType
        if command_exists istats; then
            echo -e "${CYAN}║ GPU Temperature:${NC}"
            istats gpu
        else
            echo -e "${RED}║ Temperature sensors not available. Install 'istats' with 'gem install iStats'.${NC}"
        fi
    fi
}

# Function to display memory information
memory_info() {
    print_header "🧠 Memory Information"
    if [ "$OS" = "Linux" ]; then
        free -h
        print_info "RAM Type" "$(sudo dmidecode --type memory | grep 'Type:' | uniq | awk '{print $2}')"
        print_info "Swap Usage" "$(swapon --show | awk '{print $1 ": " $4}')"
    elif [ "$OS" = "Darwin" ]; then
        system_profiler SPHardwareDataType | grep "Memory"
        print_info "RAM Type" "$(system_profiler SPMemoryDataType | grep 'Type:' | awk '{print $2}')"
        print_info "Swap Usage" "$(sysctl vm.swapusage | awk '{print $4}')"
    fi
}

# Function to display disk information
disk_info() {
    print_header "💾 Disk Information"
    if [ "$OS" = "Linux" ]; then
        lsblk
        df -h
    elif [ "$OS" = "Darwin" ]; then
        diskutil list
        df -h
    fi
}

# Function to display network information
network_info() {
    print_header "🌐 Network Information"
    if [ "$OS" = "Linux" ]; then
        ip a
        print_info "Public IP" "$(curl -s ifconfig.me)"
        print_info "DNS Servers" "$(grep nameserver /etc/resolv.conf | awk '{print $2}')"
        print_info "Latency to Google DNS" "$(ping -c 4 8.8.8.8 | tail -1 | awk '{print $4}' | cut -d '/' -f 2) ms"
    elif [ "$OS" = "Darwin" ]; then
        ifconfig
        print_info "Public IP" "$(curl -s ifconfig.me)"
        print_info "DNS Servers" "$(scutil --dns | grep nameserver | awk '{print $3}')"
        print_info "Latency to Google DNS" "$(ping -c 4 8.8.8.8 | tail -1 | awk '{print $4}' | cut -d '/' -f 2) ms"
    fi
}

# Function to display developer tools information
dev_tools_info() {
    print_header "🛠️ Developer Tools"

    print_subheader "Programming Languages"
    print_info "Go Version" "$(go version 2>/dev/null || echo 'Go not installed')"
    print_info "Python Version" "$(python3 --version 2>/dev/null || echo 'Python not installed')"
    print_info "Node.js Version" "$(node --version 2>/dev/null || echo 'Node.js not installed')"
    print_info "Ruby Version" "$(ruby --version 2>/dev/null || echo 'Ruby not installed')"
    print_info "Java Version" "$(java --version 2>/dev/null || echo 'Java not installed')"
    print_info "GCC Version" "$(gcc --version 2>/dev/null | head -n 1 || echo 'GCC not installed')"

    print_subheader "Package Managers"
    print_info "npm Version" "$(npm --version 2>/dev/null || echo 'npm not installed')"
    print_info "Yarn Version" "$(yarn --version 2>/dev/null || echo 'Yarn not installed')"
    print_info "pip Version" "$(pip3 --version 2>/dev/null || echo 'pip not installed')"
    print_info "Homebrew Version" "$(brew --version 2>/dev/null || echo 'Homebrew not installed')"

    print_subheader "DevOps Tools"
    print_info "Jenkins Version" "$(jenkins --version 2>/dev/null || echo 'Jenkins not installed')"
    print_info "GitLab Runner Version" "$(gitlab-runner --version 2>/dev/null || echo 'GitLab Runner not installed')"
    print_info "Terraform Version" "$(terraform version 2>/dev/null || echo 'Terraform not installed')"
    print_info "Ansible Version" "$(ansible --version 2>/dev/null || echo 'Ansible not installed')"
    print_info "CircleCI CLI Version" "$(circleci version 2>/dev/null || echo 'CircleCI CLI not installed')"

    print_subheader "Security Tools"
    print_info "SonarQube Scanner Version" "$(sonar-scanner --version 2>/dev/null || echo 'SonarQube Scanner not installed')"
    print_info "OWASP ZAP Version" "$(zap.sh -version 2>/dev/null || echo 'OWASP ZAP not installed')"
    print_info "Snyk Version" "$(snyk --version 2>/dev/null || echo 'Snyk not installed')"
    print_info "Trivy Version" "$(trivy --version 2>/dev/null || echo 'Trivy not installed')"

    print_subheader "Backend Frameworks & Tools"
    print_info "Express Version" "$(npm list express 2>/dev/null | grep express || echo 'Express not installed')"
    print_info "Django Version" "$(python3 -m django --version 2>/dev/null || echo 'Django not installed')"
    print_info "Spring Boot Version" "$(spring --version 2>/dev/null || echo 'Spring Boot not installed')"
    print_info "FastAPI Version" "$(pip show fastapi 2>/dev/null | grep Version || echo 'FastAPI not installed')"
    print_info "NestJS Version" "$(nest --version 2>/dev/null || echo 'NestJS not installed')"

    print_subheader "Frontend Frameworks & Tools"
    print_info "React Version" "$(npm list react 2>/dev/null | grep react || echo 'React not installed')"
    print_info "Vue Version" "$(vue --version 2>/dev/null || echo 'Vue not installed')"
    print_info "Angular Version" "$(ng version 2>/dev/null | grep Angular || echo 'Angular not installed')"
    print_info "Next.js Version" "$(next --version 2>/dev/null || echo 'Next.js not installed')"
    print_info "Nuxt.js Version" "$(nuxt --version 2>/dev/null || echo 'Nuxt.js not installed')"
    print_info "Webpack Version" "$(webpack --version 2>/dev/null || echo 'Webpack not installed')"
    print_info "Vite Version" "$(vite --version 2>/dev/null || echo 'Vite not installed')"

    print_subheader "Databases"
    print_info "PostgreSQL Version" "$(psql --version 2>/dev/null || echo 'PostgreSQL not installed')"
    print_info "MySQL Version" "$(mysql --version 2>/dev/null || echo 'MySQL not installed')"
    print_info "MongoDB Version" "$(mongod --version 2>/dev/null || echo 'MongoDB not installed')"
    print_info "Redis Version" "$(redis-cli --version 2>/dev/null || echo 'Redis not installed')"
    print_info "SQLite Version" "$(sqlite3 --version 2>/dev/null || echo 'SQLite not installed')"

    print_subheader "Containerization & Orchestration"
    print_info "Docker Version" "$(docker --version 2>/dev/null || echo 'Docker not installed')"
    print_info "Docker Compose Version" "$(docker-compose --version 2>/dev/null || echo 'Docker Compose not installed')"
    print_info "Kubernetes Version" "$(kubectl version --client --short 2>/dev/null || echo 'Kubernetes not installed')"
    print_info "Helm Version" "$(helm version --short 2>/dev/null || echo 'Helm not installed')"
    print_info "Podman Version" "$(podman --version 2>/dev/null || echo 'Podman not installed')"

    print_subheader "Version Control"
    print_info "Git Version" "$(git --version 2>/dev/null || echo 'Git not installed')"
    print_info "Git LFS Version" "$(git-lfs --version 2>/dev/null || echo 'Git LFS not installed')"

    print_subheader "Cloud Tools"
    print_info "AWS CLI Version" "$(aws --version 2>/dev/null || echo 'AWS CLI not installed')"
    print_info "Azure CLI Version" "$(az --version 2>/dev/null || echo 'Azure CLI not installed')"
    print_info "Google Cloud SDK Version" "$(gcloud --version 2>/dev/null | head -n 1 || echo 'Google Cloud SDK not installed')"
    print_info "Heroku CLI Version" "$(heroku --version 2>/dev/null || echo 'Heroku CLI not installed')"
    print_info "Digital Ocean CLI Version" "$(doctl version 2>/dev/null || echo 'Digital Ocean CLI not installed')"
}

# Function to display security information
security_info() {
    print_header "🔒 Security Information"
    print_subheader "System Integrity"
    print_info "Last Login" "$(last -1 | head -1)"
    print_info "Failed Login Attempts" "$(grep -i "failed" /var/log/system.log 2>/dev/null | wc -l || echo 'Log not accessible')"
    print_info "Firewall Status" "$(if [ "$OS" = "Darwin" ]; then defaults read /Library/Preferences/com.apple.alf globalstate 2>/dev/null || echo 'Unknown'; else echo 'Not implemented for this OS'; fi)"
    
    print_subheader "Open Ports"
    if [ "$OS" = "Darwin" ]; then
        netstat -an | grep LISTEN
    else
        ss -tulpn
    fi
}

# Function to display process statistics
process_stats() {
    print_header "📊 Process Statistics"
    print_subheader "Top CPU Consumers"
    if [ "$OS" = "Darwin" ]; then
        ps -arcwwwxo command=,pid=,%cpu=,rss= | head -10
    else
        ps -eo cmd,pid,%cpu,%mem --sort=-%cpu | head -11
    fi

    print_subheader "Memory Usage by Process"
    if [ "$OS" = "Darwin" ]; then
        ps -amcwwwxo command=,pid=,%mem=,rss= | head -10
    else
        ps -eo cmd,pid,%cpu,%mem --sort=-%mem | head -11
    fi
}

# Function to display system performance metrics
performance_metrics() {
    print_header "📈 System Performance Metrics"
    print_subheader "System Load"
    print_info "CPU Load" "$(uptime | awk -F 'load average: ' '{print $2}')"
    if [ "$OS" = "Darwin" ]; then
        print_info "CPU Usage" "$(ps -A -o %cpu | awk '{s+=$1} END {print s"%"}')"
        print_info "Memory Pressure" "$(memory_pressure | head -1)"
    else
        print_info "CPU Usage" "$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4"%"}')"
        print_info "Memory Usage" "$(free | grep Mem | awk '{print $3/$2 * 100.0"%"}')"
    fi

    print_subheader "Disk I/O"
    if [ "$OS" = "Darwin" ]; then
        iostat
    else
        iostat -x 1 1
    fi
}

# Function to display all information
all_info() {
    print_welcome
    cpu_info
    gpu_info
    memory_info
    disk_info
    network_info
    security_info
    process_stats
    performance_metrics
    print_header "🐧 Kernel Information"
    uname -r

    print_header "⏱️ System Uptime"
    uptime

    print_header "📊 Running Processes"
    ps aux

    print_header "🌍 Environment Variables"
    printenv

    dev_tools_info
}

# Detect the operating system
OS="$(uname -s)"

# Function to save output to file
save_to_file() {
    local output_file=$1
    local timestamp=$(date +"%Y%m%d_%H%M%S")
    local final_output_file="${output_file:-system_info_$timestamp.txt}"
    
    # Redirect all output to both file and terminal
    exec > >(tee -a "$final_output_file") 2>&1
    
    echo "System Information Report - Generated on $(date)"
    echo "================================================"
    echo
}

# Parse command-line arguments
OUTPUT_FILE=""
COMMAND=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -c|--command)
            COMMAND="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        -h|--help)
            echo -e "${GREEN}Usage: $0 [-c|--command <command>] [-o|--output <file>]${NC}"
            echo -e "\nAvailable commands:"
            echo -e "${YELLOW}cpu${NC} - Display CPU information"
            echo -e "${YELLOW}gpu${NC} - Display GPU information"
            echo -e "${YELLOW}memory${NC} - Display memory information"
            echo -e "${YELLOW}disk${NC} - Display disk information"
            echo -e "${YELLOW}network${NC} - Display network information"
            echo -e "${YELLOW}dev_tools${NC} - Display developer tools information"
            echo -e "${YELLOW}security${NC} - Display security information"
            echo -e "${YELLOW}process${NC} - Display process statistics"
            echo -e "${YELLOW}performance${NC} - Display system performance metrics"
            echo -e "\nOptions:"
            echo -e "${YELLOW}-o, --output${NC} - Save output to specified file"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option. Use -h or --help to see available commands.${NC}"
            exit 1
            ;;
    esac
done

# Initialize file output if specified
if [ -n "$OUTPUT_FILE" ]; then
    save_to_file "$OUTPUT_FILE"
fi

# Execute requested command or all info
if [ -n "$COMMAND" ]; then
    case "$COMMAND" in
        cpu)
            cpu_info
            ;;
        gpu)
            gpu_info
            ;;
        memory)
            memory_info
            ;;
        disk)
            disk_info
            ;;
        network)
            network_info
            ;;
        dev_tools)
            dev_tools_info
            ;;
        security)
            security_info
            ;;
        process)
            process_stats
            ;;
        performance)
            performance_metrics
            ;;
        *)
            echo -e "${RED}Invalid command. Use -h or --help to see available commands.${NC}"
            exit 1
            ;;
    esac
else
    all_info
fi

echo -e "${GREEN}✅ Hardware and developer information collection complete.${NC}"
