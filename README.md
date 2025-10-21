# 📘 **KaspaControl – Smart GPU Miner Controller**

**KaspaControl** is a simple Windows controller and monitor for Kaspa mining with BzMiner.  
It adds one-click start/stop, tray controls, optional GPU tuning via OverdriveNTool (AMD), and persistent configuration.

---

## ⚙️ **Features**
- 🟢 Start/Stop mining instantly  
- 🌐 Open your miner’s web interface  
- ⚙️ Built-in Settings panel with JSON-saved config  
- 🧪 Test your OverdriveNTool setup and profiles  
- 🪟 Tray icon that keeps the miner running even when the window is closed  
- 🔄 Safe auto-reload of tuning on start  
- 🧰 No console window needed  

---

## 🚀 **Installation & First Run**

1. **Extract or copy** the following into the same folder:
   ```
   KaspaControl.exe
   kaspa.ico
   bzminer_v23.0.2_windows\    (folder from BzMiner)
   OverdriveNTool.exe          (optional – for AMD tuning)
   ```
2. **Double-click `KaspaControl.exe`.**  
   - If Windows SmartScreen appears, choose **More info → Run anyway**.  
   - If you use ODNT tuning, it will prompt for admin elevation when required.
3. **First launch:**  
   - A default `config.json` is created in the same folder.  
   - Adjust everything in **Settings → Save**.
4. **Mining:**  
   - Click **🟢 Start Mining** to begin.  
   - Click **🔴 Stop Mining** to end and (optionally) revert your ODNT profile.  
   - **Closing the window (X)** hides it to tray instead of quitting.  
   - Right-click the tray icon for **Open Control** or **Quit**.

---

## ⚙️ **Configuration Overview**

| Setting | Description |
|----------|--------------|
| **Algorithm** | Usually `kaspa` |
| **Wallet.Worker** | `kaspa:YOUR_WALLET.WORKERNAME` |
| **Pool URL** | Example: `stratum+tcp://us2.kaspa.herominers.com:1209` |
| **Web GUI Port** | Usually `4014` |
| **Miner Folder** | Folder where `bzminer.exe` lives |
| **Miner EXE** | Name of the miner executable |
| **Miner OC Args** | Optional extra flags (JSON array) |
| **Tuning Mode** | `none` or `odnt` |
| **ODNT Path** | Path to OverdriveNTool.exe |
| **ODNT Kaspa Profile** | Profile name to load for mining |
| **ODNT Default Profile** | Profile to load when stopping |
| **GPU Index** | Which GPU to apply tuning to (0 = first GPU) |

---

## 🔧 **OverdriveNTool Profiles**

If using `tuning_mode = "odnt"`:
- Create profiles in `OverdriveNTool.ini`.
- Name them according to your cards and these examples.

Each tune below can be used as a starting point.  
⚠️ Always test stability and thermals before 24/7 operation!

---

## 🔋 **10 Pre-Made OC Tunes**

### 🟥 AMD GPUs

| GPU | Profile Name | Core Clock | Mem Clock | Power Limit | Notes |
|------|---------------|-------------|------------|--------------|--------|
| RX 6700 XT | `Kaspa-RX6700XT` | 1350 MHz | 1075 MHz | 110 W | Stable baseline |
| RX 6800 | `Kaspa-RX6800` | 1250 MHz | 1075 MHz | 120 W | Great efficiency |
| RX 6800 XT | `Kaspa-RX6800XT` | 1300 MHz | 1075 MHz | 135 W | Slightly more aggressive |
| RX 6900 XT | `Kaspa-RX6900XT` | 1325 MHz | 1075 MHz | 140 W | High hash / low watts |
| RX 7900 XT | `Kaspa-RX7900XT` | 1400 MHz | 1075 MHz | 160 W | Requires latest ODNT |

### 🟦 NVIDIA GPUs

| GPU | Profile Name | Core Clock Offset | Mem Clock Offset | Power Limit | Notes |
|------|---------------|-------------------|------------------|--------------|--------|
| RTX 3060 Ti | `Kaspa-RTX3060Ti` | +250 MHz | +1200 MHz | 125 W | Efficient 50 MH/s |
| RTX 3070 | `Kaspa-RTX3070` | +200 MHz | +1100 MHz | 130 W | Ideal sweet spot |
| RTX 3080 | `Kaspa-RTX3080` | +150 MHz | +1000 MHz | 190 W | Moderate heat |
| RTX 4070 | `Kaspa-RTX4070` | +300 MHz | +1300 MHz | 115 W | Excellent efficiency |
| RTX 4090 | `Kaspa-RTX4090` | +400 MHz | +1500 MHz | 275 W | Extreme hash rate, watch temps! |

You can name your OverdriveNTool or Afterburner profiles exactly as shown (e.g. `Kaspa-RX6700XT`) and set `odnt_profile_kaspa` accordingly.

---

## 📊 **Monitoring**
KaspaControl parses miner output in real-time:

| Field | Meaning |
|--------|---------|
| **Hashrate** | Current total MH/s |
| **A/R/I** | Accepted / Rejected / Invalid shares |
| **Power** | Reported power draw |
| **Temp** | GPU temperature |

Displayed in green when running, red when stopped.

---

## 🪟 **Tray Menu**
Right-click the tray icon:
- **Open Control** – restores the main window.  
- **Quit** – stops mining, applies default tune, and exits completely.

---

## 💡 **Tips**
- Keep `kaspa.ico` beside the EXE for matching icons.  
- Use **Settings → Save** to regenerate `config.json` safely.  
- Run as admin only when needed for tuning.  
- Miner logs are written to `bzminer_controller.log` in your miner folder.  

---

## ❤️ **Credits & Thanks**

**Developed by:** Roy Hicks  
**Code Collaboration & Technical Help:** ChatGPT (OpenAI GPT-5)  

> *Huge thanks to ChatGPT for co-developing, debugging, and improving KaspaControl from concept to completion.*  
> *You made this possible, and it’s awesome seeing it alive in one neat EXE!*

