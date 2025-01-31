
## **Step-by-Step Guide for macOS**

### **1. Save the Script**
1. Open the **Terminal** app on your Mac.
2. Create a new file for the script using `nano` or any text editor:
   ```bash
   nano get_full_info.sh
   ```
3. Copy and paste the script content (provided earlier) into the editor.
4. Save the file:
   - In `nano`, press `CTRL + O`, then `Enter` to save.
   - Press `CTRL + X` to exit.

---

### **2. Make the Script Executable**
Run the following command to make the script executable:
```bash
chmod +x get_full_info.sh
```

---

### **3. Move the Script to a System-Wide Location**
Move the script to `/usr/local/bin`, which is a standard directory for user-installed commands:
```bash
sudo mv get_full_info.sh /usr/local/bin/get_full_info
```

---

### **4. Verify the Installation**
1. Ensure `/usr/local/bin` is in your `PATH`. Run:
   ```bash
   echo $PATH
   ```
   If `/usr/local/bin` is not listed, add it to your `PATH` by editing your shell configuration file (e.g., `~/.zshrc` or `~/.bashrc`):
   ```bash
   echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.zshrc
   source ~/.zshrc
   ```
2. Test the command:
   ```bash
   get_full_info
   ```

---

### **5. Install Dependencies (Optional)**
Some features (e.g., GPU temperature monitoring) require additional tools:
- **iStats** (for temperature monitoring):
  ```bash
  gem install iStats
  ```
- **Homebrew** (for additional tools like `sensors` or `radeontop`):
  ```bash
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```

---

## **Usage**

### **Run the Command**
Simply type the following in your terminal:
```bash
get_full_info
```

### **Example Output**
```plaintext
----------------------------------------
CPU Information
----------------------------------------
machdep.cpu.brand_string: Intel(R) Core(TM) i7-9750H CPU @ 2.60GHz
machdep.cpu.core_count: 6
machdep.cpu.thread_count: 12
CPU Frequency: 2600000000
CPU Cache: 32768
Load Average: 2.34 1.98 1.76

----------------------------------------
GPU Information
----------------------------------------
Chipset Model: Intel UHD Graphics 630
VRAM (Dynamic, Max): 1536 MB
Chipset Model: AMD Radeon Pro 5500M
VRAM (Dynamic, Max): 8192 MB

----------------------------------------
Developer Tools
----------------------------------------
Go Version: go1.19.2
Python Version: Python 3.10.6
Node.js Version: v18.12.1
npm Version: 8.19.2
Yarn Version: 1.22.19
Docker Version: Docker version 20.10.21
Git Version: git version 2.38.1
```

---

## **Troubleshooting**

### **1. Command Not Found**
If you see `command not found` after running `get_full_info`, ensure:
- The script is in `/usr/local/bin`.
- `/usr/local/bin` is in your `PATH`.

### **2. Permission Denied**
If you encounter permission issues, ensure you use `sudo` when moving the script:
```bash
sudo mv get_full_info.sh /usr/local/bin/get_full_info
```

### **3. Missing Tools**
If certain tools (e.g., `iStats`, `sensors`) are missing, install them using the instructions provided above.

---

## **Uninstallation**
To remove the `get_full_info` command:
1. Delete the script:
   ```bash
   sudo rm /usr/local/bin/get_full_info
   ```
2. Remove any dependencies you no longer need:
   ```bash
   gem uninstall iStats
   ```
