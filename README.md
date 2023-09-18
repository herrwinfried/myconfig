# ⚠️ WARN / DİKKAT

There are configurations that I made according to myself. Please try it yourself according to your own consciousness.

Kendime göre yaptığım konfigürasyonlar var. Lütfen kendi bilincinize göre kendiniz deneyiniz.

## OpenSUSE Tumbleweed

```bash
sudo sh -c 'zypper in -y wget curl git xdg-user-dirs' && git clone https://github.com/herrwinfried/myconfig.git -b linux && mkdir -p myconfig/files && xdg-user-dirs-update && chmod +x myconfig/scripts/*.sh
```
## fedora

```bash
sudo sh -c 'dnf install -y wget curl git xdg-user-dirs' && git clone https://github.com/herrwinfried/myconfig.git -b linux && mkdir -p myconfig/files && xdg-user-dirs-update && chmod +x myconfig/scripts/*.sh
```

## debian

```bash
sudo sh -c 'apt install -y wget curl git xdg-user-dirs' && git clone https://github.com/herrwinfried/myconfig.git -b linux && mkdir -p myconfig/files && xdg-user-dirs-update && chmod +x myconfig/scripts/*.sh
```
### The file extension that the `files` folder supports *
- .run
- .appimage
- .bundles
- .rpm
- .flatpakref

\* Only OpenSUSE Tumbleweed