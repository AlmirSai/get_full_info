
# System Information Tool

A comprehensive system information gathering tool for macOS and Linux systems.

## Features

- 💻 CPU Information
  - Processor details
  - Clock speeds
  - Cache information
  - Architecture details

- 🎮 GPU Information
  - Graphics card details
  - VRAM information
  - Driver versions
  - Temperature monitoring

- 🧠 Memory Information
  - Total RAM
  - Available memory
  - Swap usage
  - Memory pressure

- 💾 Disk Information
  - Storage capacity
  - Disk usage
  - I/O statistics
  - Mount points

- 🌐 Network Information
  - Interface details
  - IP addresses
  - Network throughput
  - Active connections

- 🔒 Security Information
  - System integrity status
  - Firewall configuration
  - Open ports
  - Security updates
  - Failed login attempts

- 📊 Process Statistics
  - CPU usage per process
  - Memory consumption
  - Running services
  - Process tree

- 📈 Performance Metrics
  - System load
  - CPU utilization
  - Memory pressure
  - I/O wait times

- 🛠️ Developer Tools Information
  - Programming Languages
    - Python, Node.js, Ruby, Java, Go
    - Version information
    - Installation paths
  - Package Managers
    - npm, pip, Homebrew
    - Global packages
  - DevOps Tools
    - Docker, Kubernetes
    - CI/CD tools
  - Databases
    - PostgreSQL, MySQL, MongoDB
    - Connection status
  - Web Frameworks
    - React, Vue, Django, Flask
    - Version compatibility

## Installation

### Prerequisites
- macOS or Linux operating system
- Terminal access
- Administrative privileges (for some features)

### Quick Install

1. Clone the repository:
```bash
git clone <repository-url>
cd system-info-tool
```

2. Make the script executable:
```bash
chmod +x get_full_info.sh
```

3. (Optional) Install system-wide:
```bash
sudo mv get_full_info.sh /usr/local/bin/get_full_info
```

### Dependencies

The script primarily uses built-in system commands, but some features require additional tools:

```bash
# For macOS
gem install iStats  # GPU temperature monitoring

# For enhanced monitoring
brew install iostat  # Disk I/O statistics
```

## Usage

### Basic Usage

Run the script without arguments to get complete system information:
```bash
./get_full_info.sh
```

### Command-Line Options

Use the `-c` flag to get specific information:
```bash
./get_full_info.sh -c [command]
```

Available commands:
- `cpu` - CPU information
- `gpu` - GPU information
- `memory` - Memory statistics
- `disk` - Storage information
- `network` - Network details
- `dev_tools` - Developer tools status
- `security` - Security information
- `process` - Process statistics
- `performance` - System metrics
- `help` - Show all commands

## Troubleshooting

### Common Issues

1. Permission Denied
   - Ensure script is executable
   - Run with sudo for privileged operations

2. Missing Tools
   - Install required dependencies
   - Check PATH configuration

3. Performance Issues
   - Adjust refresh intervals
   - Filter specific metrics

### Error Messages

- "Temperature sensors not found": Install iStats
- "Disk I/O monitoring unavailable": Install iostat
- "Permission denied": Use sudo for system-level operations

## Contributing

Contributions are welcome! Please feel free to:
- Report bugs
- Suggest features
- Submit pull requests
- Improve documentation

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

- Create an issue for bug reports
- Join discussions for feature requests
- Check documentation for common questions
