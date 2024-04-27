<div align="center">
<img src="https://raw.githubusercontent.com/PowerShell/PowerShell/master/assets/ps_black_64.svg?sanitize=true" alt="Powershell Script Logo" width="200" height="200">
</div>

<p>This is a script I made to run after installing the branch system for the first time. For Windows only. </p>


<h1>Program Requirements</h1>
<ul>
    <li>Winget v1.7.1061+</li>
    <li>git (<code>winget install --interactive --id Git.Git</code>)</li>
    <li>Windows Powershell or Powershell Core 7.x.x+ (<code>winget install --id Microsoft.PowerShell</code>)
</ul>

<h1>Download</h1>

<h4>Powershell:</h4>

```powershell
Set-Location ~ ; git clone https://github.com/herrwinfried/myconfig/ -b windows ; Set-Location ~/myconfig/scripts
```

<h4>CMD:</h4>

```cmd
cd %userprofile% && git clone https://github.com/herrwinfried/myconfig/ -b windows && cd myconfig/scripts
```

<h1>Install</h1>
<p> After coming to the myconfig/Run path, you can run it via CLI or by selecting it by category and then double-clicking the BAT file. </p>
<h2> CLI </h2>

```powershell
./install.ps1 -u -c
```

<small>for details "-?" Use the argument.</small>