#!/usr/bin/env bash
set -euo pipefail

#============================
# You can install 
# - Google chrome
# - Visual Stadio Code
# - gcc with lapack and blas
# - Anaconda
#============================


need_pkg () {
  dpkg -s "$1" >/dev/null 2>&1
}

apt_install_if_missing () {
  local pkg="$1"
  if need_pkg "$pkg"; then
    echo "[SKIP] $pkg already installed"
  else
    echo "[INSTALL] $pkg"
    sudo apt install -y "$pkg"
  fi
}

# ---- common deps
sudo apt update
apt_install_if_missing wget
apt_install_if_missing gpg
apt_install_if_missing curl
apt_install_if_missing ca-certificates

# =========================
# 1) Google Chrome
# =========================
CHROME_LIST="/etc/apt/sources.list.d/google-chrome.list"
CHROME_KEY="/etc/apt/trusted.gpg.d/google-chrome.gpg"

if need_pkg google-chrome-stable; then
  echo "[SKIP] google-chrome-stable already installed"
else
  if [ ! -f "$CHROME_KEY" ]; then
    wget -qO- https://dl.google.com/linux/linux_signing_key.pub \
      | sudo gpg --yes --dearmor -o "$CHROME_KEY"
  else
    echo "[SKIP] chrome apt key already exists"
  fi

  if [ ! -f "$CHROME_LIST" ]; then
    echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' \
      | sudo tee "$CHROME_LIST" >/dev/null
  else
    echo "[SKIP] chrome apt source already exists"
  fi

  sudo apt update
  sudo apt install -y google-chrome-stable
fi

# desktop entry if it needs
mkdir -p "$HOME/.local/share/applications"
if [ ! -f "$HOME/.local/share/applications/google-chrome.desktop" ]; then
  cat > "$HOME/.local/share/applications/google-chrome.desktop" <<'EOF'
[Desktop Entry]
Version=1.0
Name=Google Chrome
# Only KDE 4 seems to use GenericName, so we reuse the KDE strings.
# From Ubuntu's language-pack-kde-XX-base packages, version 9.04-20090413.
GenericName=Web Browser
GenericName[ar]=متصفح الشبكة
GenericName[bg]=Уеб браузър
GenericName[ca]=Navegador web
GenericName[cs]=WWW prohlížeč
GenericName[da]=Browser
GenericName[de]=Web-Browser
GenericName[el]=Περιηγητής ιστού
GenericName[en_GB]=Web Browser
GenericName[es]=Navegador web
GenericName[et]=Veebibrauser
GenericName[fi]=WWW-selain
GenericName[fr]=Navigateur Web
GenericName[gu]=વેબ બ્રાઉઝર
GenericName[he]=דפדפן אינטרנט
GenericName[hi]=वेब ब्राउज़र
GenericName[hu]=Webböngésző
GenericName[it]=Browser Web
GenericName[ja]=ウェブブラウザ
GenericName[kn]=ಜಾಲ ವೀಕ್ಷಕ
GenericName[ko]=웹 브라우저
GenericName[lt]=Žiniatinklio naršyklė
GenericName[lv]=Tīmekļa pārlūks
GenericName[ml]=വെബ് ബ്രൌസര്‍
GenericName[mr]=वेब ब्राऊजर
GenericName[nb]=Nettleser
GenericName[nl]=Webbrowser
GenericName[pl]=Przeglądarka WWW
GenericName[pt]=Navegador Web
GenericName[pt_BR]=Navegador da Internet
GenericName[ro]=Navigator de Internet
GenericName[ru]=Веб-браузер
GenericName[sl]=Spletni brskalnik
GenericName[sv]=Webbläsare
GenericName[ta]=இணைய உலாவி
GenericName[th]=เว็บเบราว์เซอร์
GenericName[tr]=Web Tarayıcı
GenericName[uk]=Навігатор Тенет
GenericName[zh_CN]=网页浏览器
GenericName[zh_HK]=網頁瀏覽器
GenericName[zh_TW]=網頁瀏覽器
# Not translated in KDE, from Epiphany 2.26.1-0ubuntu1.
GenericName[bn]=ওয়েব ব্রাউজার
GenericName[fil]=Web Browser
GenericName[hr]=Web preglednik
GenericName[id]=Browser Web
GenericName[or]=ଓ୍ବେବ ବ୍ରାଉଜର
GenericName[sk]=WWW prehliadač
GenericName[sr]=Интернет прегледник
GenericName[te]=మహాతల అన్వేషి
GenericName[vi]=Bộ duyệt Web
# Gnome and KDE 3 uses Comment.
Comment=Access the Internet
Comment[ar]=الدخول إلى الإنترنت
Comment[bg]=Достъп до интернет
Comment[bn]=ইন্টারনেটটি অ্যাক্সেস করুন
Comment[ca]=Accedeix a Internet
Comment[cs]=Přístup k internetu
Comment[da]=Få adgang til internettet
Comment[de]=Internetzugriff
Comment[el]=Πρόσβαση στο Διαδίκτυο
Comment[en_GB]=Access the Internet
Comment[es]=Accede a Internet.
Comment[et]=Pääs Internetti
Comment[fi]=Käytä internetiä
Comment[fil]=I-access ang Internet
Comment[fr]=Accéder à Internet
Comment[gu]=ઇંટરનેટ ઍક્સેસ કરો
Comment[he]=גישה אל האינטרנט
Comment[hi]=इंटरनेट तक पहुंच स्थापित करें
Comment[hr]=Pristup Internetu
Comment[hu]=Internetelérés
Comment[id]=Akses Internet
Comment[it]=Accesso a Internet
Comment[ja]=インターネットにアクセス
Comment[kn]=ಇಂಟರ್ನೆಟ್ ಅನ್ನು ಪ್ರವೇಶಿಸಿ
Comment[ko]=인터넷 연결
Comment[lt]=Interneto prieiga
Comment[lv]=Piekļūt internetam
Comment[ml]=ഇന്റര്‍‌നെറ്റ് ആക്‌സസ് ചെയ്യുക
Comment[mr]=इंटरनेटमध्ये प्रवेश करा
Comment[nb]=Gå til Internett
Comment[nl]=Verbinding maken met internet
Comment[or]=ଇଣ୍ଟର୍ନେଟ୍ ପ୍ରବେଶ କରନ୍ତୁ
Comment[pl]=Skorzystaj z internetu
Comment[pt]=Aceder à Internet
Comment[pt_BR]=Acessar a internet
Comment[ro]=Accesaţi Internetul
Comment[ru]=Доступ в Интернет
Comment[sk]=Prístup do siete Internet
Comment[sl]=Dostop do interneta
Comment[sr]=Приступите Интернету
Comment[sv]=Gå ut på Internet
Comment[ta]=இணையத்தை அணுகுதல்
Comment[te]=ఇంటర్నెట్‌ను ఆక్సెస్ చెయ్యండి
Comment[th]=เข้าถึงอินเทอร์เน็ต
Comment[tr]=İnternet'e erişin
Comment[uk]=Доступ до Інтернету
Comment[vi]=Truy cập Internet
Comment[zh_CN]=访问互联网
Comment[zh_HK]=連線到網際網路
Comment[zh_TW]=連線到網際網路
Exec=/usr/bin/google-chrome-stable %U --enable-features=TouchpadOverscrollHistoryNavigation
StartupNotify=true
Terminal=false
Icon=google-chrome
Type=Application
Categories=Network;WebBrowser;
MimeType=application/pdf;application/rdf+xml;application/rss+xml;application/xhtml+xml;application/xhtml_xml;application/xml;image/gif;image/jpeg;image/png;image/webp;text/html;text/xml;x-scheme-handler/http;x-scheme-handler/https;
Actions=new-window;new-private-window;

[Desktop Action new-window]
Name=New Window
Name[am]=አዲስ መስኮት
Name[ar]=نافذة جديدة
Name[bg]=Нов прозорец
Name[bn]=নতুন উইন্ডো
Name[ca]=Finestra nova
Name[cs]=Nové okno
Name[da]=Nyt vindue
Name[de]=Neues Fenster
Name[el]=Νέο Παράθυρο
Name[en_GB]=New Window
Name[es]=Nueva ventana
Name[et]=Uus aken
Name[fa]=پنجره جدید
Name[fi]=Uusi ikkuna
Name[fil]=New Window
Name[fr]=Nouvelle fenêtre
Name[gu]=નવી વિંડો
Name[hi]=नई विंडो
Name[hr]=Novi prozor
Name[hu]=Új ablak
Name[id]=Jendela Baru
Name[it]=Nuova finestra
Name[iw]=חלון חדש
Name[ja]=新規ウインドウ
Name[kn]=ಹೊಸ ವಿಂಡೊ
Name[ko]=새 창
Name[lt]=Naujas langas
Name[lv]=Jauns logs
Name[ml]=പുതിയ വിന്‍ഡോ
Name[mr]=नवीन विंडो
Name[nl]=Nieuw venster
Name[no]=Nytt vindu
Name[pl]=Nowe okno
Name[pt]=Nova janela
Name[pt_BR]=Nova janela
Name[ro]=Fereastră nouă
Name[ru]=Новое окно
Name[sk]=Nové okno
Name[sl]=Novo okno
Name[sr]=Нови прозор
Name[sv]=Nytt fönster
Name[sw]=Dirisha Jipya
Name[ta]=புதிய சாளரம்
Name[te]=క్రొత్త విండో
Name[th]=หน้าต่างใหม่
Name[tr]=Yeni Pencere
Name[uk]=Нове вікно
Name[vi]=Cửa sổ Mới
Name[zh_CN]=新建窗口
Name[zh_TW]=開新視窗
Exec=/usr/bin/google-chrome-stable

[Desktop Action new-private-window]
Name=New Incognito Window
Name[ar]=نافذة جديدة للتصفح المتخفي
Name[bg]=Нов прозорец „инкогнито“
Name[bn]=নতুন ছদ্মবেশী উইন্ডো
Name[ca]=Finestra d'incògnit nova
Name[cs]=Nové anonymní okno
Name[da]=Nyt inkognitovindue
Name[de]=Neues Inkognito-Fenster
Name[el]=Νέο παράθυρο για ανώνυμη περιήγηση
Name[en_GB]=New Incognito window
Name[es]=Nueva ventana de incógnito
Name[et]=Uus inkognito aken
Name[fa]=پنجره جدید حالت ناشناس
Name[fi]=Uusi incognito-ikkuna
Name[fil]=Bagong Incognito window
Name[fr]=Nouvelle fenêtre de navigation privée
Name[gu]=નવી છુપી વિંડો
Name[hi]=नई गुप्त विंडो
Name[hr]=Novi anoniman prozor
Name[hu]=Új Inkognitóablak
Name[id]=Jendela Penyamaran baru
Name[it]=Nuova finestra di navigazione in incognito
Name[iw]=חלון חדש לגלישה בסתר
Name[ja]=新しいシークレット ウィンドウ
Name[kn]=ಹೊಸ ಅಜ್ಞಾತ ವಿಂಡೋ
Name[ko]=새 시크릿 창
Name[lt]=Naujas inkognito langas
Name[lv]=Jauns inkognito režīma logs
Name[ml]=പുതിയ വേഷ പ്രച്ഛന്ന വിന്‍ഡോ
Name[mr]=नवीन गुप्त विंडो
Name[nl]=Nieuw incognitovenster
Name[no]=Nytt inkognitovindu
Name[pl]=Nowe okno incognito
Name[pt]=Nova janela de navegação anónima
Name[pt_BR]=Nova janela anônima
Name[ro]=Fereastră nouă incognito
Name[ru]=Новое окно в режиме инкогнито
Name[sk]=Nové okno inkognito
Name[sl]=Novo okno brez beleženja zgodovine
Name[sr]=Нови прозор за прегледање без архивирања
Name[sv]=Nytt inkognitofönster
Name[ta]=புதிய மறைநிலைச் சாளரம்
Name[te]=క్రొత్త అజ్ఞాత విండో
Name[th]=หน้าต่างใหม่ที่ไม่ระบุตัวตน
Name[tr]=Yeni Gizli pencere
Name[uk]=Нове вікно в режимі анонімного перегляду
Name[vi]=Cửa sổ ẩn danh mới
Name[zh_CN]=新建隐身窗口
Name[zh_TW]=新增無痕式視窗
Exec=/usr/bin/google-chrome-stable --incognito
EOF
fi

# =========================
# 2) VS Code
# =========================
VSCODE_LIST="/etc/apt/sources.list.d/vscode.list"
VSCODE_KEY="/etc/apt/keyrings/packages.microsoft.gpg"

if need_pkg code; then
  echo "[SKIP] code already installed"
else
  sudo install -d -m 0755 /etc/apt/keyrings

  if [ ! -f "$VSCODE_KEY" ]; then
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc \
      | gpg --dearmor \
      | sudo tee "$VSCODE_KEY" >/dev/null
    sudo chmod 0644 "$VSCODE_KEY"
  else
    echo "[SKIP] vscode keyring already exists"
  fi

  if [ ! -f "$VSCODE_LIST" ]; then
    echo "deb [arch=amd64,arm64,armhf signed-by=$VSCODE_KEY] https://packages.microsoft.com/repos/code stable main" \
      | sudo tee "$VSCODE_LIST" >/dev/null
  else
    echo "[SKIP] vscode apt source already exists"
  fi

  sudo apt update
  sudo apt install -y code
fi

# =========================
# 3) Programming packages
# =========================
apt_install_if_missing gcc
apt_install_if_missing liblapacke-dev
apt_install_if_missing libopenblas-dev

# ===========================
# 4) Anaconda (curl download)
# ===========================
ANACONDA_URL="https://repo.anaconda.com/archive/Anaconda3-2025.12-2-Linux-x86_64.sh"
ANACONDA_INSTALLER="$HOME/Downloads/Anaconda3-2025.12-2-Linux-x86_64.sh"
ANACONDA_PREFIX="$HOME/anaconda3"

mkdir -p "$HOME/Downloads"

if [ -x "$ANACONDA_PREFIX/bin/conda" ]; then
  echo "[SKIP] Anaconda already installed at $ANACONDA_PREFIX"
else
  if [ ! -f "$ANACONDA_INSTALLER" ]; then
    echo "[DOWNLOAD] $ANACONDA_URL"
    curl -L --fail --retry 3 --retry-delay 2 -o "$ANACONDA_INSTALLER" "$ANACONDA_URL"
  else
    echo "[SKIP] installer already exists: $ANACONDA_INSTALLER"
  fi

  chmod +x "$ANACONDA_INSTALLER"
  bash "$ANACONDA_INSTALLER" -b -p "$ANACONDA_PREFIX"
  $HOME/anaconda3/bin/conda init
fi

echo "Done. Open a new terminal (or run: source ~/.bashrc)"
