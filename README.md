<div align="center">
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/08/Antu_bash.svg/2048px-Antu_bash.svg.png" alt="Bash Script Logo" width="200" height="200">
</div>

<p>This is a script I made to run after installing the branch system for the first time. For GNU/Linux only. </p>


<h1>Package Requirements</h1>

| Package Name | OpenSUSE Tumleweed | Fedora | Debian |
|--------------|--------------------|--------|--------|
| git          | git                | git    | git    |
| xdg-user-dirs| xdg-user-dirs      | xdg-user-dirs | xdg-user-dirs |
| dos2unix     | dos2unix           | dos2unix | dos2unix |
| wget         | wget               | wget   | wget   |
| curl         | curl               | curl   | curl   |
| gettext         | gettext-tools               | gettext   | gettext   |


<h1>Download</h1>

```bash
sh -c "cd ~ ; git clone https://github.com/herrwinfried/myconfig/ -b linux && cd ~/myconfig/scripts"
```

<h1>Install</h1>

```bash
./install.sh -u -c
```

<small>for details "-h" Use the argument.</small>