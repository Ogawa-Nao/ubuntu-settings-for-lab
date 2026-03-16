#!/usr/bin/env bash
set -euo pipefail

#========================
# You can install
# - vim git curl ssh
# - Japanese-input (IME)
#========================


# 1) update/upgrade
sudo apt update && sudo apt upgrade -y

# 1-1) vim, git, curl, ssh, Japanese-input
sudo apt install -y \
  vim-gtk3 git curl \
  openssh-client openssh-server \
  fcitx5 fcitx5-mozc fcitx5-config-qt\
  gnome-tweaks mozc-utils-gui

# 2) vim + NeoBundle
mkdir -p "$HOME/.vim/bundle"
if [ ! -d "$HOME/.vim/bundle/neobundle.vim/.git" ]; then
  git clone --depth 1 https://github.com/Shougo/neobundle.vim.git "$HOME/.vim/bundle/neobundle.vim"
else
  git -C "$HOME/.vim/bundle/neobundle.vim" pull --ff-only
fi

# .vimrc がない場合の最小テンプレート
if [ ! -f "$HOME/.vimrc" ]; then
  cat > "$HOME/.vimrc" <<'EOF'
" #####表示設定#####
set number "行番号を表示
set title "編集中のファイル名を表示
set showmatch "括弧入力時の対応する括弧を表示
syntax on "コードの色分け
set tabstop=2 "インデントを半角スペース2つ分に設定
set nosmartindent "スマートインデントOFF
set autoindent "オートインデントON
set expandtab "Tabインデント時に設定個数分の半角スペース挿入
set shiftwidth=2 "オートインデント時のズレ幅を半角スペース4つ分に設定
set hlsearch "検索語をハイライト表示
" ESC連打でハイライト解除
nmap <Esc><Esc> :nohlsearch<CR><Esc> 
"set virtualedit=onemore "行の1文字先までカーソル移動ができる．
" 一括インデント
vnoremap > >gv
vnoremap < <gv
" 括弧＋Enterで括弧閉じ
inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap [<Enter> []<Left><CR><ESC><S-o>
inoremap (<Enter> ()<Left><CR><ESC><S-o>
set clipboard=unnamedpuls
" LaTeX用の＄
inoremap $<Tab> $$<Left>


"#####コマンドライン設定#####
set ignorecase "大文字/小文字の区別なく検索
set smartcase "検索文字列に大文字/小文字が混在した場合のみ区別して検索
set wrapscan "末尾まで検索したら先頭に戻る
set wildmode=list:longest


"#####カーソル設定#####
" Ctrl+e, Ctrl+aで文末，文頭でインサートモード
inoremap <C-e> <Esc>$a
inoremap <C-a> <Esc>0i
noremap <C-e> <Esc>$a
noremap <C-a> <Esc>0i
"g+{j,k}で表示行で改行
nmap gj gj<SID>g
nmap gk gk<SID>g
nnoremap <script> <SID>gj gj<SID>g
nnoremap <script> <SID>gk gk<SID>g
nmap <SID>g <Nop>
"インサートモードのときにCtrl+lで右に移動
inoremap <C-l> <Right>
"インサートモードでjj連打でノーマルモードへ
inoremap <silent> jj <ESC>l
"ノーマルモードでShft+{h,l}で文頭，文末へ移動
noremap <S-l> $l
noremap <S-h> 0
"ノーマルモードでCtrl+{h,l}で1単語前後の頭へ移動
noremap <C-l> w
noremap <C-h> b
" x,Xでカーソル文字を削除する際にクリップボードを汚さない
nnoremap x "_x
xnoremap x "_x
nnoremap X "_X
xnoremap X "_X



" Neobundle設定
if has('vim_starting')
  set nocompatible               " Be iMproved
  " Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
  call neobundle#begin(expand('~/.vim/bundle/'))
endif
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'flazz/vim-colorschemes'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'kana/vim-altercmd'
NeoBundle 'surround.vim'


" You can specify revision/branch/tag.
NeoBundle 'Shougo/vimshell', { 'rev' : '3787e5' }
call neobundle#end()
filetype plugin indent on
" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
"ここまでがNeobundle

" NERDTreeをtreeで表示
command! Tree NERDTreeToggle
" kana/vim-altercmdプラグインの設定 capital small
if has('vim_starting')
    autocmd VimEnter * call altercmd#load()
    autocmd VimEnter * AlterCommand tree Tree
endif
EOF
fi

vim -u "$HOME/.vimrc" +NeoBundleInstall +qall
vim -u "$HOME/.vimrc" -c 'q'

# 3) Japanese-input (fcitx5)
im-config -n fcitx5

# 重複追記を防ぐ
if ! grep -q '## fcitx5 env ##' "$HOME/.profile" 2>/dev/null; then
  cat >> "$HOME/.profile" <<'EOF'

## fcitx5 env ##
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export INPUT_METHOD=fcitx
EOF
fi

gsettings set org.gnome.settings-daemon.plugins.xsettings overrides "{'Gtk/IMModule':<'fcitx'>}" || true
mkdir -p "$HOME/.config/autostart"
cp /usr/share/applications/org.fcitx.Fcitx5.desktop "$HOME/.config/autostart/" || true

echo 
echo "Done. Please logout/login to apply IME settings."
echo "Procedure in the new terminal"
echo "Euter fcitx5-configtool"
echo "Click input method tab"
echo "Search Mozc in search box for available input method"
echo "Add Mozc"
echo "That's it."
