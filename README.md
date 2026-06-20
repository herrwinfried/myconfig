<div align="center">
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/08/Antu_bash.svg/2048px-Antu_bash.svg.png" alt="Bash Script Logo" width="200" height="200">
</div>

# MyConfig – Linux Environment Setup

A collection of Bash scripts to automate the installation and configuration of a personal Linux environment.  
Supports **openSUSE Tumbleweed**, **Fedora**, and **Debian** (and can be extended to other distributions).  
The scripts handle package installation, system configuration, desktop setup, and more.

## 📦 Package Requirements

| Package Name | openSUSE Tumbleweed | Fedora | Debian |
|--------------|--------------------|--------|--------|
| git | git | git | git |
| xdg-user-dirs | xdg-user-dirs | xdg-user-dirs | xdg-user-dirs |
| dos2unix | dos2unix | dos2unix | dos2unix |
| wget | wget | wget | wget |
| curl | curl | curl | curl |
| gettext | gettext-tools | gettext | gettext |
| rsync | rsync | rsync | rsync |
| which | which | which | which |
| tar | tar | tar | tar |
| ruby | ruby | ruby | ruby |
| inxi | inxi | inxi | inxi |

Install the above packages with your distro’s package manager before running the setup.

## 📥 Download

```bash
git clone https://github.com/herrwinfried/myconfig.git -b linux
cd myconfig
```

## ⚙️ Installation / Usage

The main entry point is `setup.sh`. It requires a **single flag** to specify what stage to run:

| Flag | Description |
|------|-------------|
| `--presetup`   | Run *Repository* + *Presetup* scripts (initial system preparation). |
| `--install`    | Run *Repository* + *Process* scripts (install packages and configure the system). |
| `--config`     | Run only the *Configure* scripts (desktop, services, etc.). |
| `--onlyconfig`| Run *Configure* scripts without any preceding stages. |

Example:

```bash
./setup.sh --install
```

You can combine flags as needed, but at least one flag must be provided.

### Helper scripts

- `compile_translations.sh` – Compiles `.po` files in `locale/` to `.mo`.
- `config.sh` – Detects the distribution and platform (WSL, Distrobox, native Linux) and exports useful variables.
- Library scripts in `lib/` provide colourised output, utility functions, and package‑manager abstraction.

## 📁 Repository Layout

```
myconfig/
├─ compile_translations.sh   # Compile i18n files
├─ config.sh                 # Detect distro / platform
├─ setup.sh                  # Orchestrator
├─ lib/                      # Shared Bash libraries
│   ├─ colors.sh
│   ├─ i18n.sh
│   ├─ package_manager.sh
│   └─ utils.sh
├─ distros/                  # Distribution‑specific scripts
│   └─ opensuse-tumbleweed/
│       ├─ Configure/        # Desktop, firewall, etc.
│       ├─ Presetup/         # Early‑stage setup
│       ├─ Process/          # Package installation
│       └─ Repository/       # Repository configuration
├─ locale/                   # Translation files
└─ data/                     # Additional data files
```

## 🛠️ Extending to Other Distributions

Add a new directory under `distros/` named after the target distribution and copy the four sub‑folders (`Configure`, `Presetup`, `Process`, `Repository`). Populate them with the appropriate Bash scripts. The orchestrator will automatically pick the correct directory based on the detected distro.

---

*For more information, run `./setup.sh -h` to see the full help message.*