## Step 1

```bash
sudo apt install -y wget
```
or
```bash
sudo zypper install -y wget
```
## Step 2

```bash
cd ~ && wget https://raw.githubusercontent.com/herrwinfried/myconfig/main/wsl/download.sh -O download.sh && chmod +x ./download.sh && ./download.sh
```

### Available Parameters

- `-ps` or `--powershell` -> Powershell Setup
- `--guidnf` -> Graphical packages are installs via dnf instead of zypper (OpenSUSE TW)
- `--gui` -> installs graphics packages (OpenSUSE TW)
- `--dnf` -> installs via dnf instead of zypper (OpenSUSE TW)

**NOTE**
`--guidnf` , `--gui` and `--dnf` parametres only openSUSE