# KaspaControl v2.1.0 — alerts + logs viewer + NVIDIA preflight
import os, re, sys, json, time, psutil, ctypes, threading, subprocess, tkinter as tk
from tkinter import messagebox, filedialog
from PIL import Image, ImageDraw
import pystray, webbrowser
import winsound, datetime

# ===================== PORTABLE BASE DIR =====================
if getattr(sys, 'frozen', False):
    BASE_DIR = os.path.dirname(sys.executable)
else:
    BASE_DIR = os.path.dirname(os.path.abspath(__file__))

CONFIG_PATH = os.path.join(BASE_DIR, "config.json")
ICON_PATH   = os.path.join(BASE_DIR, "kaspa.ico")  # tray + window icon

DEFAULT_CONFIG = {
    "algo": "kaspa",
    "wallet_worker": "kaspa:your_wallet.worker",
    "pool": "stratum+tcp://us2.kaspa.herominers.com:1209",
    "web_port": 4014,
    "miner_dir": os.path.join(BASE_DIR, "bzminer_v23.0.2_windows"),
    "miner_exe": "bzminer.exe",
    "miner_oc_args": [],
    "tuning_mode": "none",                # "none" | "odnt"
    "odnt_path": os.path.join(BASE_DIR, "OverdriveNTool.exe"),
    "odnt_profile_kaspa": "Kaspa",
    "odnt_profile_default": "Default",
    "gpu_index": 0,
    # v2.1.0 additions:
    "alert_block_sound": True,
    "alert_block_popup": True
}

def save_config(cfg):
    with open(CONFIG_PATH, "w", encoding="utf-8") as f:
        json.dump(cfg, f, indent=2)

def load_config():
    if not os.path.isfile(CONFIG_PATH):
        save_config(DEFAULT_CONFIG)
        return DEFAULT_CONFIG.copy()
    with open(CONFIG_PATH, "r", encoding="utf-8") as f:
        data = json.load(f)
    changed = False
    for k, v in DEFAULT_CONFIG.items():
        if k not in data:
            data[k] = v
            changed = True
    if changed:
        save_config(data)
    return data

cfg = load_config()

# ===================== RESOLVED PATHS =====================
def _abs_from_base(path_like: str) -> str:
    if not path_like:
        return ""
    return path_like if os.path.isabs(path_like) else os.path.abspath(os.path.join(BASE_DIR, path_like))

MINER_PATH = os.path.join(cfg["miner_dir"], cfg["miner_exe"]) if os.path.isabs(cfg["miner_dir"]) else os.path.abspath(os.path.join(BASE_DIR, cfg["miner_dir"], cfg["miner_exe"]))
WORK_DIR   = cfg["miner_dir"] if os.path.isabs(cfg["miner_dir"]) else os.path.abspath(os.path.join(BASE_DIR, cfg["miner_dir"]))
ARGS = ["-a", cfg["algo"], "-w", cfg["wallet_worker"], "-p", cfg["pool"]] + list(cfg.get("miner_oc_args", []))

TUNING_MODE = str(cfg.get("tuning_mode", "none")).lower()
ODNT_EXE    = _abs_from_base(cfg.get("odnt_path", os.path.join(BASE_DIR, "OverdriveNTool.exe")))
ODNT_PROFILE_KASPA   = cfg.get("odnt_profile_kaspa", "Kaspa")
ODNT_PROFILE_DEFAULT = cfg.get("odnt_profile_default", "Default")
GPU_INDEX  = int(cfg.get("gpu_index", 0))

REFRESH_SECS = 2
LOG_PATH = os.path.join(WORK_DIR, "bzminer_controller.log")

# ===================== STATE =====================
miner_proc = None
running = False
shutdown_evt = threading.Event()
current = {"mh": 0.0, "a": 0, "r": 0, "i": 0, "pw": 0.0, "tc": 0.0}

# UI globals
_root = None
_win = None
_text_var = None
_stats_label = None

# ===================== HELPERS =====================
_letter_chunk = re.compile(r'((?:[A-Za-z]\s+)+[A-Za-z])')
def _despace_letters(s: str) -> str:
    return _letter_chunk.sub(lambda m: re.sub(r'\s+', '', m.group(0)), s)

def _normalize_line(s: str) -> str:
    s = _despace_letters(s)
    s = re.sub(r'(?<=\d)\s+(?=[\d.])', '', s)
    s = re.sub(r'\s*/\s*', '/', s)
    return s

def kill_process_tree(p: subprocess.Popen):
    if not p: return
    try:
        parent = psutil.Process(p.pid)
    except psutil.NoSuchProcess:
        return
    for c in parent.children(recursive=True):
        try: c.terminate()
        except: pass
    try: parent.terminate()
    except: pass

def _is_admin():
    try:
        return ctypes.windll.shell32.IsUserAnAdmin() != 0
    except Exception:
        return False

def _relaunch_elevated_and_exit():
    params = " ".join([f'"{a}"' for a in os.sys.argv])
    ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, params, None, 1)
    os._exit(0)

def _ensure_log_file():
    try:
        os.makedirs(os.path.dirname(LOG_PATH), exist_ok=True)
    except Exception:
        pass
    if not os.path.isfile(LOG_PATH):
        try:
            with open(LOG_PATH, "w", encoding="utf-8") as _:
                _.write("")
        except Exception:
            pass

def _detect_gpus():
    """Returns (has_amd, has_nvidia, names list) using wmic (no extra deps)."""
    try:
        out = subprocess.run(
            ["wmic", "path", "win32_VideoController", "get", "Name"],
            capture_output=True, text=True, timeout=5
        )
        names = [n.strip() for n in out.stdout.splitlines() if n.strip() and "Name" not in n]
        low = " ".join(n.lower() for n in names)
        return ("amd" in low or "radeon" in low, "nvidia" in low or "geforce" in low, names)
    except Exception:
        return (False, False, [])

# ===================== NOTIFICATIONS =====================
def _notify_block_found(extra_msg: str = ""):
    # Sound (3 short beeps)
    if cfg.get("alert_block_sound", True):
        try:
            for f in (880, 1175, 1568):  # A5, D6, G6
                winsound.Beep(f, 120)
        except Exception:
            try: winsound.MessageBeep(-1)
            except Exception: pass
    # Popup on the Tk thread
    if cfg.get("alert_block_popup", True):
        ts = datetime.datetime.now().strftime("%H:%M:%S")
        msg = f"🎉 Block found at {ts}!\n\n{extra_msg}".strip()
        try:
            _root.after(0, lambda: messagebox.showinfo("KaspaControl — Block Found", msg))
        except Exception:
            pass

# ===================== PARSER/READER =====================
def parse_line(line: str):
    line = _normalize_line(line)

    # Hashrate
    m = re.search(r"\bminer\s*hr\b[^0-9]*([\d.]+)\s*mh\b", line, re.I)
    if m:
        try: current['mh'] = float(m.group(1))
        except: pass
    else:
        mh_vals = re.findall(r'([\d.]+)\s*mh(?!w)\b', line, re.I)
        if mh_vals:
            try: current['mh'] = float(mh_vals[-1])
            except: pass

    # A/R/I
    m = re.search(r"\bA/R/I[:\s]+([0-9-]+)/([0-9-]+)/([0-9-]+)", line, re.I)
    if not m:
        m = re.search(r"\|\s*\d+:\d+\s*\|\s*([0-9-]+)/([0-9-]+)/([0-9-]+)\s*\|", line)
    if m:
        def _to_int(v):
            try: return int(v.replace('-', '0'))
            except: return 0
        current['a'], current['r'], current['i'] = map(_to_int, m.groups())

    # Power
    m = re.search(r"\bpwr\b[^\d]*([\d.]+)\s*w\b", line, re.I)
    if not m:
        m = re.search(r"\|\s*(?:\d+\s*%|\s*)\s*\|\s*([\d.]+)\s*w\s*\|", line, re.I)
    if not m and "C/" in line:
        m = re.search(r"([\d.]+)\s*w\b", line, re.I)
    if m:
        try: current['pw'] = float(m.group(1))
        except: pass

    # Temp
    m = re.search(r"(\d+)C/(\d+)C", line)
    if m:
        try: current['tc'] = float(m.group(1))
        except: pass

def reader_loop():
    _ensure_log_file()
    with open(LOG_PATH, "a", encoding="utf-8", errors="ignore") as lf:
        while not shutdown_evt.is_set():
            if miner_proc and miner_proc.poll() is None:
                raw = miner_proc.stdout.readline()
                if not raw:
                    time.sleep(0.05); continue
                try:
                    line = raw.decode("utf-8", errors="ignore").rstrip("\r\n")
                except AttributeError:
                    line = str(raw).rstrip("\r\n")

                # write to log
                lf.write(line + "\n"); lf.flush()

                # detect block win (solo)
                low = line.lower()
                if ("block found" in low) or ("worker found a block" in low) or ("accepted solo block" in low):
                    _notify_block_found(line)

                parse_line(line)
            else:
                time.sleep(0.2)

# ===================== ODNT-ONLY TUNING =====================
def _odnt_ini_profiles(odnt_exe: str):
    try:
        ini_path = os.path.join(os.path.dirname(odnt_exe), "OverdriveNTool.ini")
        if not os.path.isfile(ini_path):
            return []
        names = []
        for enc in ("utf-16", "utf-8"):
            try:
                with open(ini_path, "r", encoding=enc, errors="ignore") as f:
                    for line in f:
                        line = line.strip()
                        if line.lower().startswith("name="):
                            names.append(line.split("=",1)[1].strip())
                if names: break
            except Exception:
                continue
        return names
    except Exception:
        return []

def _apply_with_odnt(profile_name: str, gpu_idx: int):
    exe = ODNT_EXE
    if not os.path.isfile(exe):
        return False, f"ODNT not found: {exe}"
    profs = _odnt_ini_profiles(exe)
    if profs and profile_name not in profs:
        return False, f"Profile '{profile_name}' not found in OverdriveNTool.ini next to ODNT."
    try:
        cmd = [exe, f"-r{gpu_idx}", f"-p{gpu_idx}{profile_name}"]
        cwd = os.path.dirname(exe) or None
        res = subprocess.run(cmd, cwd=cwd, capture_output=True, text=True)
        ok = (res.returncode == 0)
        msg = (res.stdout or "") + (res.stderr or "")
        return ok, msg.strip()
    except Exception as e:
        return False, str(e)

def apply_tune(phase: str):
    if TUNING_MODE != "odnt":
        return
    if not _is_admin():
        try:
            if messagebox.askyesno("Kaspa Control", "Tuning requires Administrator rights.\nRelaunch as admin now?"):
                _relaunch_elevated_and_exit()
        except Exception:
            _relaunch_elevated_and_exit()
        return
    prof = ODNT_PROFILE_KASPA if phase == "kaspa" else ODNT_PROFILE_DEFAULT
    ok, msg = _apply_with_odnt(prof, GPU_INDEX)
    if not ok and msg:
        try:
            messagebox.showwarning("Kaspa Control (ODNT)", f"Failed to apply '{prof}' on GPU {GPU_INDEX}:\n{msg}")
        except Exception:
            pass

# ===================== CORE CONTROLS =====================
def start_miner():
    global miner_proc, running
    if miner_proc and miner_proc.poll() is None:
        messagebox.showinfo("Kaspa Control", "Miner already running!")
        return

    # Pre-flight: basic GPU sanity + warn on NVIDIA CUDA missing last run
    has_amd, has_nv, gpu_names = _detect_gpus()
    if not (has_amd or has_nv):
        if not messagebox.askyesno("Kaspa Control",
            "No AMD/NVIDIA GPUs detected by Windows.\n\n"
            "Continue anyway? (Driver issue or headless system)"):
            return
    try:
        if os.path.isfile(LOG_PATH):
            with open(LOG_PATH, "rb") as _lf:
                _lf.seek(0, os.SEEK_END)
                size = _lf.tell()
                _lf.seek(max(size - 64*1024, 0))
                tail = _lf.read().decode("utf-8", "ignore").lower()
            if has_nv and ("cuda not found" in tail):
                messagebox.showwarning(
                    "Kaspa Control — NVIDIA driver",
                    "NVIDIA GPU(s) detected but BzMiner reported 'CUDA not found' last run.\n"
                    "Install/repair NVIDIA drivers and reboot."
                )
    except Exception:
        pass

    apply_tune("kaspa")
    time.sleep(1.0)

    try:
        miner_proc = subprocess.Popen(
            [MINER_PATH] + ARGS,
            cwd=WORK_DIR,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            bufsize=1
        )
    except FileNotFoundError:
        messagebox.showerror("Kaspa Control", f"Miner not found:\n{MINER_PATH}")
        return

    running = True
    threading.Thread(target=reader_loop, daemon=True).start()

    def delayed_reapply():
        time.sleep(5)
        apply_tune("kaspa")
    threading.Thread(target=delayed_reapply, daemon=True).start()

    messagebox.showinfo("Kaspa Control", "Started mining.")

def stop_miner():
    global miner_proc, running
    running = False
    if miner_proc:
        kill_process_tree(miner_proc)
        miner_proc = None
    apply_tune("default")
    time.sleep(0.5)
    messagebox.showinfo("Kaspa Control", "Stopped mining.")

# ===================== WEB GUI =====================
def open_web_gui():
    port = int(cfg.get("web_port", 4014))
    webbrowser.open(f"http://127.0.0.1:{port}", new=2)

# ===================== LOG VIEWER =====================
def open_logs_cmd():
    # Ensure the log file exists so tail doesn't error
    _ensure_log_file()

    # Open a NEW console window that tails the log in real time
    # Uses PowerShell's Get-Content -Wait for a proper tail
    subprocess.Popen(
        [
            "cmd", "/c", "start", "", "powershell",
            "-NoLogo", "-NoProfile", "-ExecutionPolicy", "Bypass",
            "-Command", f'Get-Content -Path "{LOG_PATH}" -Wait -Tail 200'
        ],
        cwd=WORK_DIR
    )

# ===================== SETTINGS UI =====================
def open_settings():
    s = tk.Toplevel(_root)
    s.title("Settings")
    try:
        if os.path.isfile(ICON_PATH):
            s.iconbitmap(ICON_PATH)
    except Exception:
        pass
    s.geometry("760x720")
    s.resizable(True, True)              # allow resizing
    s.grid_columnconfigure(1, weight=1)  # make input column stretch

    entries = {}
    def add_row(row, label, key):
        tk.Label(s, text=label, anchor="w").grid(row=row, column=0, sticky="w", padx=8, pady=4)
        var = tk.StringVar(value=str(cfg.get(key, "")))
        e = tk.Entry(s, textvariable=var)
        e.grid(row=row, column=1, sticky="ew", padx=8, pady=4)  # stretch horizontally
        entries[key] = var

    add_row(0,  "Algorithm",     "algo")
    add_row(1,  "Wallet.Worker", "wallet_worker")
    add_row(2,  "Pool URL",      "pool")

    tk.Label(s, text="Web GUI Port").grid(row=3, column=0, sticky="w", padx=8, pady=4)
    wp_var = tk.StringVar(value=str(cfg.get("web_port", 4014)))
    tk.Entry(s, textvariable=wp_var).grid(row=3, column=1, sticky="ew", padx=8, pady=4)

    add_row(4,  "Miner Folder",  "miner_dir")
    add_row(5,  "Miner EXE",     "miner_exe")

    tk.Label(s, text="Miner OC Args (JSON array, optional)").grid(row=6, column=0, sticky="w", padx=8, pady=4)
    mo_var = tk.StringVar(value=json.dumps(cfg.get("miner_oc_args", [])))
    tk.Entry(s, textvariable=mo_var).grid(row=6, column=1, sticky="ew", padx=8, pady=4)

    tk.Label(s, text="Tuning Mode (none/odnt)").grid(row=8, column=0, sticky="w", padx=8, pady=6)
    tm_var = tk.StringVar(value=str(cfg.get("tuning_mode","none")))
    tk.Entry(s, textvariable=tm_var, width=20).grid(row=8, column=1, sticky="w", padx=8, pady=6)

    add_row(9,  "ODNT Path",            "odnt_path")
    add_row(10, "ODNT Kaspa Profile",   "odnt_profile_kaspa")
    add_row(11, "ODNT Default Profile", "odnt_profile_default")

    tk.Label(s, text="GPU Index").grid(row=12, column=0, sticky="w", padx=8, pady=4)
    gi_var = tk.StringVar(value=str(cfg.get("gpu_index", 0)))
    tk.Entry(s, textvariable=gi_var, width=10).grid(row=12, column=1, sticky="w", padx=8, pady=4)

    # Alerts
    tk.Label(s, text="Alerts").grid(row=13, column=0, sticky="w", padx=8, pady=(16,6))
    alert_sound_var = tk.BooleanVar(value=bool(cfg.get("alert_block_sound", True)))
    alert_popup_var = tk.BooleanVar(value=bool(cfg.get("alert_block_popup", True)))
    tk.Checkbutton(s, text="Play sound on block found", variable=alert_sound_var)\
        .grid(row=14, column=0, columnspan=2, sticky="w", padx=16)
    tk.Checkbutton(s, text="Show popup on block found", variable=alert_popup_var)\
        .grid(row=15, column=0, columnspan=2, sticky="w", padx=16)

    def test_alerts():
        _notify_block_found("This is a test alert (manual).")
    tk.Button(s, text="🔔 Test Alerts", command=test_alerts).grid(row=14, column=2, padx=6)

    # Save
    def save_and_apply():
        try:
            cfg["algo"] = entries["algo"].get().strip()
            cfg["wallet_worker"] = entries["wallet_worker"].get().strip()
            cfg["pool"] = entries["pool"].get().strip()
            try: cfg["web_port"] = int(wp_var.get().strip())
            except: cfg["web_port"] = 4014

            cfg["miner_dir"] = entries["miner_dir"].get().strip()
            cfg["miner_exe"] = entries["miner_exe"].get().strip()

            try:
                cfg["miner_oc_args"] = json.loads(mo_var.get().strip() or "[]")
                if not isinstance(cfg["miner_oc_args"], list):
                    raise ValueError
            except Exception:
                messagebox.showerror("Settings", "Miner OC Args must be a JSON array (e.g., [\"--cclk\",\"1350\"]).")
                return

            cfg["tuning_mode"] = tm_var.get().strip().lower()
            cfg["odnt_path"] = entries["odnt_path"].get().strip()
            cfg["odnt_profile_kaspa"] = entries["odnt_profile_kaspa"].get().strip()
            cfg["odnt_profile_default"] = entries["odnt_profile_default"].get().strip()
            try: cfg["gpu_index"] = int(gi_var.get().strip())
            except: cfg["gpu_index"] = 0

            cfg["alert_block_sound"] = bool(alert_sound_var.get())
            cfg["alert_block_popup"] = bool(alert_popup_var.get())

            save_config(cfg)
            messagebox.showinfo("Settings", "Saved. Some changes apply next start.")
            s.destroy()
        except Exception as e:
            messagebox.showerror("Settings", f"Failed to save: {e}")

    tk.Button(s, text="Save", bg="#4CAF50", fg="white", command=save_and_apply)\
        .grid(row=20, column=1, pady=14, sticky="e")


    # Browse buttons
    def pick_miner_dir():
        path = filedialog.askdirectory(initialdir=cfg.get("miner_dir", BASE_DIR), title="Select miner folder")
        if path: entries["miner_dir"].set(path)
    def pick_odnt():
        path = filedialog.askopenfilename(initialdir=BASE_DIR, title="Select OverdriveNTool.exe",
                                          filetypes=[("EXE", "*.exe"), ("All Files", "*.*")])
        if path: entries["odnt_path"].set(path)

    tk.Button(s, text="Browse Miner Folder", command=pick_miner_dir).grid(row=4, column=2, padx=6)
    tk.Button(s, text="Browse ODNT", command=pick_odnt).grid(row=9, column=2, padx=6)

    # Alerts
    tk.Label(s, text="Alerts").grid(row=13, column=0, sticky="w", padx=8, pady=(16,6))
    alert_sound_var = tk.BooleanVar(value=bool(cfg.get("alert_block_sound", True)))
    alert_popup_var = tk.BooleanVar(value=bool(cfg.get("alert_block_popup", True)))
    tk.Checkbutton(s, text="Play sound on block found", variable=alert_sound_var).grid(row=14, column=0, columnspan=2, sticky="w", padx=16)
    tk.Checkbutton(s, text="Show popup on block found", variable=alert_popup_var).grid(row=15, column=0, columnspan=2, sticky="w", padx=16)
    def test_alerts():
        _notify_block_found("This is a test alert (manual).")
    tk.Button(s, text="🔔 Test Alerts", command=test_alerts).grid(row=14, column=2, padx=6)

    # Save
    def save_and_apply():
        try:
            cfg["algo"] = entries["algo"].get().strip()
            cfg["wallet_worker"] = entries["wallet_worker"].get().strip()
            cfg["pool"] = entries["pool"].get().strip()
            try: cfg["web_port"] = int(entries["web_port"].get().strip())
            except: cfg["web_port"] = 4014

            cfg["miner_dir"] = entries["miner_dir"].get().strip()
            cfg["miner_exe"] = entries["miner_exe"].get().strip()

            try:
                cfg["miner_oc_args"] = json.loads(mo_var.get().strip() or "[]")
                if not isinstance(cfg["miner_oc_args"], list):
                    raise ValueError
            except Exception:
                messagebox.showerror("Settings", "Miner OC Args must be a JSON array (e.g., [\"--cclk\",\"1350\"]).")
                return

            cfg["tuning_mode"] = tm_var.get().strip().lower()
            cfg["odnt_path"] = entries["odnt_path"].get().strip()
            cfg["odnt_profile_kaspa"] = entries["odnt_profile_kaspa"].get().strip()
            cfg["odnt_profile_default"] = entries["odnt_profile_default"].get().strip()
            try: cfg["gpu_index"] = int(entries["gpu_index"].get().strip())
            except: cfg["gpu_index"] = 0

            cfg["alert_block_sound"] = bool(alert_sound_var.get())
            cfg["alert_block_popup"] = bool(alert_popup_var.get())

            save_config(cfg)
            messagebox.showinfo("Settings", "Saved. Some changes apply next start.")
            s.destroy()
        except Exception as e:
            messagebox.showerror("Settings", f"Failed to save: {e}")

    tk.Button(s, text="Save", bg="#4CAF50", fg="white", command=save_and_apply).grid(row=20, column=1, pady=14)

# ===================== GUI (Toplevel) =====================
def _ensure_root():
    global _root
    if _root is None:
        _root = tk.Tk()
        _root.withdraw()
        try:
            if os.path.isfile(ICON_PATH):
                _root.iconbitmap(ICON_PATH)
        except Exception:
            pass

def _open_gui_on_main_thread():
    global _win, _text_var, _stats_label

    if _win and _win.winfo_exists():
        try:
            _win.deiconify(); _win.lift(); _win.focus_force()
        except Exception:
            pass
        return

    _win = tk.Toplevel(_root)
    _win.title("Kaspa Control")
    try:
        if os.path.isfile(ICON_PATH):
            _win.iconbitmap(ICON_PATH)
    except Exception:
        pass
    _win.geometry("360x420")
    _win.resizable(False, False)

    def _hide():
        try: _win.withdraw()
        except Exception: pass
    _win.protocol("WM_DELETE_WINDOW", _hide)

    tk.Button(_win, text="🟢 Start Mining", font=("Segoe UI", 12, "bold"),
              bg="#4CAF50", fg="white", command=start_miner).pack(pady=6)
    tk.Button(_win, text="🔴 Stop Mining", font=("Segoe UI", 12, "bold"),
              bg="#f44336", fg="white", command=stop_miner).pack(pady=4)
    tk.Button(_win, text="🌐 Open Miner Web GUI", font=("Segoe UI", 11, "bold"),
              bg="#2196F3", fg="white", command=open_web_gui).pack(pady=6)
    tk.Button(_win, text="⚙️ Settings…", font=("Segoe UI", 10, "bold"),
              bg="#666666", fg="white", command=open_settings).pack(pady=2)
    tk.Button(_win, text="🧪 Test ODNT", font=("Segoe UI", 9, "bold"),
              bg="#9C27B0", fg="white", command=test_odnt_profiles).pack(pady=2)
    tk.Button(_win, text="📄 View Logs…", font=("Segoe UI", 10, "bold"),
              bg="#444444", fg="white", command=open_logs_cmd).pack(pady=4)


    _text_var = tk.StringVar(value="Miner stopped.")
    _stats_label = tk.Label(_win, textvariable=_text_var, font=("Consolas", 10),
                            justify="left", fg="#FF4040")
    _stats_label.pack(pady=10)

    def update_stats_loop():
        while _win and _win.winfo_exists():
            try:
                if running:
                    display = (f"Hashrate: {current['mh']:.2f} MH/s\n"
                               f"A/R/I: {current['a']}/{current['r']}/{current['i']}\n"
                               f"Power: {current['pw']:.0f} W\n"
                               f"Temp: {current['tc']:.0f}°C")
                    _root.after(0, _text_var.set, display)
                    _root.after(0, _stats_label.config, {"fg": "#00CC66"})
                else:
                    _root.after(0, _text_var.set, "Miner stopped.")
                    _root.after(0, _stats_label.config, {"fg": "#FF4040"})
            except Exception:
                _root.after(0, _text_var.set, "⚠️ Parser waiting for data...")
                _root.after(0, _stats_label.config, {"fg": "#FF4040"})
            time.sleep(REFRESH_SECS)

    threading.Thread(target=reader_loop, daemon=True).start()  # safe if already running
    threading.Thread(target=update_stats_loop, daemon=True).start()

def open_gui(icon=None, item=None):
    _ensure_root()
    _root.after(0, _open_gui_on_main_thread)

# ===================== TRAY APP =====================
def _load_tray_icon():
    try:
        if os.path.isfile(ICON_PATH):
            im = Image.open(ICON_PATH).convert("RGBA")
            if hasattr(im, "n_frames"):
                best_sz, best_im = 0, im
                try:
                    for i in range(im.n_frames):
                        im.seek(i)
                        if im.size[0] > best_sz:
                            best_sz, best_im = im.size[0], im.copy()
                    im = best_im
                except Exception:
                    pass
            return im
    except Exception:
        pass
    img = Image.new('RGB', (64, 64), color=(255, 140, 0))
    d = ImageDraw.Draw(img)
    d.ellipse((8, 8, 56, 56), fill=(255, 255, 255))
    return img

def on_quit(icon, item):
    shutdown_evt.set()
    try:
        stop_miner()
    except Exception:
        pass
    try:
        icon.visible = False
        icon.stop()
    except Exception:
        pass
    if _root:
        _root.after(0, _root.quit)

def run_as_admin_if_needed():
    if TUNING_MODE == "odnt" and not _is_admin():
        _relaunch_elevated_and_exit()

def _start_tray():
    menu = pystray.Menu(
        pystray.MenuItem("Open Control", open_gui),
        pystray.MenuItem("Quit", on_quit)
    )
    tray_img = _load_tray_icon()
    icon = pystray.Icon("KaspaControl", tray_img, "Kaspa Control", menu)
    icon.run_detached()

# ===================== ODNT TEST DIALOG =====================
def test_odnt_profiles():
    exe = ODNT_EXE
    if not os.path.isfile(exe):
        messagebox.showerror("ODNT Test", f"ODNT not found:\n{exe}")
        return
    names = _odnt_ini_profiles(exe)
    lines = [f"ODNT: {exe}"]
    ini = os.path.join(os.path.dirname(exe), "OverdriveNTool.ini")
    lines.append(f"INI:  {ini} ({'found' if os.path.isfile(ini) else 'missing'})")
    if names:
        lines.append("Profiles:")
        lines += [f"  - {n}" for n in names]
    else:
        lines.append("Profiles: (none found)")

    cmd = [exe, f'-r{GPU_INDEX}', f'-p{GPU_INDEX}{ODNT_PROFILE_KASPA}']
    res = subprocess.run(cmd, cwd=os.path.dirname(exe) or None, capture_output=True, text=True)
    lines.append("")
    lines.append("Test apply:")
    lines.append(f"  {' '.join(cmd)}")
    lines.append(f"  rc={res.returncode}")
    if res.stdout: lines.append("  stdout:\n" + res.stdout.strip())
    if res.stderr: lines.append("  stderr:\n" + res.stderr.strip())
    messagebox.showinfo("ODNT Test", "\n".join(lines[:2000]))

# ===================== MAIN =====================
def main():
    run_as_admin_if_needed()
    _ensure_root()
    open_gui()       # comment out to start minimized to tray
    _start_tray()
    _root.mainloop()

if __name__ == "__main__":
    main()
