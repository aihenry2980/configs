WIN11 DEV SETUP
===============

WHAT IT INSTALLS
----------------
Latest available versions through WinGet:

Utilities:
- Everything
- TreeSize Free
- 7-Zip

Git:
- Git for Windows
- TortoiseGit
- Fork

Cloud:
- Dropbox

Editors:
- Visual Studio Code
- Notepad++
- Zed
- Sublime Text
- VSCodium

Browsers:
- Google Chrome
- Mozilla Firefox
- Vivaldi

Development:
- CMake
- Android Studio
- Python Install Manager
- Latest stable Python runtime

NOT INCLUDED:
- Visual Studio


EASIEST WAY TO USE
------------------
1. Extract this ZIP to any folder.
2. Double-click:
      Run-Setup.bat
3. Click Yes on the Windows UAC administrator prompt.
4. Leave the window open while apps install.
5. When it finishes, reboot Windows once.


ALTERNATIVE: RUN POWERSHELL DIRECTLY
------------------------------------
Right-click Start > Terminal (Admin), then:

  powershell -ExecutionPolicy Bypass -File ".\Install-All.ps1"


ANDROID STUDIO
--------------
The script installs Android Studio itself.

On first launch:
- Install Android SDK
- Install Android SDK Platform Tools
- Install the current Android SDK Platform / Build Tools you need

If you use a real Galaxy phone through ADB, you can skip Android Emulator
system images to save a lot of disk space.


PYTHON
------
The script installs Python Install Manager and then attempts:

  pymanager install default

This selects the current latest stable Python runtime rather than hard-coding
a specific Python version.

If the runtime install does not run in the same terminal session, reboot or
open a new terminal and run:

  py install default


DISK SPACE
----------
The script shows free space on C: before installation.

With Visual Studio removed, 120 GB free space is comfortable for this setup
as long as you avoid accumulating many Android Emulator images / SDK versions
and do not fully sync a very large Dropbox.


LOGS
----
Each run creates a log file beside the script:

  Install-Log-YYYYMMDD-HHMMSS.txt

If one app fails, the script continues installing the rest.
