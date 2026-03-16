# Ubuntu initial setting files
There are two initial setup files for Ubuntu.
After installing Ubuntu on your computer, you can run these files which are written in shell script.

- setup1.sh

This file installs vim, git, curl, and ssh, and configures Japanese-input.
It also inclues my `.vimrc` that is very usefull in my opinion.
I guess almost all users are using VSCode for coding, so this might not be strictly necessary for everyone.
However, I've included it just in case I need to troubleshoot issues via the terminal.
Of course, feel free to overwrite it with your own settings.

Note that this Japanese-input configuration is designed only for the US-keyboards with using fcitx5 and mozc.
That's why I'm not sure how to adapt it for JIS-keyboards.
I recommend searching for relevant documents if needed.
If you get stuck, I'll do my best to help!:D

- setup2.sh

You can install Google Chrome, Visual Studio Code, gcc (with LAPACK and BLAS), and Anaconda from this installer.
This Anaconda installer was available at March 16, 2026.
If you prefer another one, you can simply delete or modify those lines.
