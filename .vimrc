" release autogroup in MyAutoCmd
augroup MyAutoCmd
  autocmd!
augroup END

let s:noplugin = 0
let s:bundle_root = expand('~/.vim/bundle')
let s:neobundle_root = s:bundle_root . '/neobundle.vim'
if !isdirectory(s:neobundle_root) || v:version < 702
  " NeoBundleが存在しない、もしくはVimのバージョンが古い場合はプラグインを一切
  " 読み込まない
  let s:noplugin = 1
else
  " NeoBundleを'runtimepath'に追加し初期化を行う
  if has('vim_starting')
    execute "set runtimepath+=" . s:neobundle_root
  endif
  call neobundle#begin(s:bundle_root)

  " NeoBundle自身をNeoBundleで管理させる
  NeoBundleFetch 'Shougo/neobundle.vim'

  " 非同期通信を可能にする
  " 'build'が指定されているのでインストール時に自動的に
  " 指定されたコマンドが実行され vimproc がコンパイルされる
  NeoBundle "Shougo/vimproc", {
    \ "build": {
    \   "windows"   : "make -f make_mingw32.mak",
    \   "cygwin"    : "make -f make_cygwin.mak",
    \   "mac"       : "make -f make_mac.mak",
    \   "unix"      : "make -f make_unix.mak",
    \ }}

  NeoBundle 'Shougo/vimshell.vim'

  "NeoBundle 'alpaca-tc/alpaca_powertabline'
  "NeoBundle 'Lokaltog/powerline', { 'rtp' : 'powerline/bindings/vim'}
  "NeoBundle 'Lokaltog/powerline-fontpatcher'


  if has('lua') && ( v:version >= 703 && has('patch885') || v:version >= 704 )
    NeoBundleLazy "Shougo/neocomplete.vim", {
      \ "autoload": {
      \   "insert": 1,
      \ }}
    " 2013-07-03 14:30 NeoComplCacheに合わせた
    let g:neocomplete#enable_at_startup = 1
    let s:hooks = neobundle#get_hooks("neocomplete.vim")
    function! s:hooks.on_source(bundle)
      let g:acp_enableAtStartup = 0
      let g:neocomplete#enable_smart_case = 1
      let g:neocomplete#TagsAutoUpdate = 1
      let g:neocomplete#EnableInfo = 1
      let g:neocomplete#EnableCamelCaseCompletion = 1
      let g:neocomplete#MinSyntaxLength = 3
      let g:neocomplete#EnableSkipCompletion = 1
      let g:neocomplete#SkipInputTime = '0.5'

      "--------------------------------
      " 関数定義に飛ぶ（C/C++）　参考：http://d.hatena.ne.jp/osyo-manga/20110530/1306715525
      " <C-]>：カーソル位置の定義に飛ぶ
      " ,tu: 現在のバッファのタグファイルの生成、tagsの更新
      "--------------------------------
      "
      " 現在のバッファのタグファイルを生成する
      " neocomplcache からタグファイルのパスを取得して、tags に追加する
      nnoremap <expr>,tu g:TagsUpdate()
      function! g:TagsUpdate()
        " execute "setlocal tags=./tags,tags"
        set tags += ./tags,tags
        let bufname = expand("%:p")
        if bufname!=""
          call system(
              \ "ctags ".
              \ "-R --tag-relative=yes --sort=yes ".
              \ "--c++-kinds=+p --fields=+iaS --extra=+q "
              \ .bufname." `pwd`")
        endif
        "for filename in neocomplete#sources#include_complete#get_include_files(bufnr('%'))
        "  execute "set tags+=".neocomplete#cache#encode_name('include_tags', filename)
        "endfor
        return ""
      endfunction
    endfunction
  else
    NeoBundleLazy "Shougo/neocomplcache.vim", {
      \ "autoload": {
      \   "insert": 1,
      \ }}
    " 2013-07-03 14:30 原因不明だがNeoComplCacheEnableコマンドが見つからないので変更
    let g:neocomplcache_enable_at_startup = 1
    let s:hooks = neobundle#get_hooks("neocomplcache.vim")
    function! s:hooks.on_source(bundle)
      let g:acp_enableAtStartup = 0
      let g:neocomplcache_enable_smart_case = 1
      let g:NeoComplCache_TagsAutoUpdate = 1
      let g:NeoComplCache_EnableInfo = 1
      let g:NeoComplCache_EnableCamelCaseCompletion = 1
      let g:NeoComplCache_MinSyntaxLength = 3
      let g:NeoComplCache_EnableSkipCompletion = 1
      let g:NeoComplCache_SkipInputTime = '0.5'

      "--------------------------------
      " 関数定義に飛ぶ（C/C++）　参考：http://d.hatena.ne.jp/osyo-manga/20110530/1306715525
      " <C-]>：カーソル位置の定義に飛ぶ
      " ,tu: 現在のバッファのタグファイルの生成、tagsの更新
      "--------------------------------
      "
      " 現在のバッファのタグファイルを生成する
      " neocomplcache からタグファイルのパスを取得して、tags に追加する
      nnoremap <expr>,tu g:TagsUpdate()
      function! g:TagsUpdate()
        " execute "setlocal tags=./tags,tags"
        set tags += ./tags,tags
        let bufname = expand("%:p")
        if bufname!=""
          call system(
              \ "ctags ".
              \ "-R --tag-relative=yes --sort=yes ".
              \ "--c++-kinds=+p --fields=+iaS --extra=+q "
              \ .bufname." `pwd`")
        endif
        for filename in neocomplcache#sources#include_complete#get_include_files(bufnr('%'))
          execute "set tags+=".neocomplcache#cache#encode_name('include_tags', filename)
        endfor
        return ""
      endfunction
    endfunction
  endif

  NeoBundleLazy "Shougo/unite.vim", {
        \ "autoload": {
        \   "commands": ["Unite", "UniteWithBufferDir"]
        \ }}
  NeoBundleLazy 'h1mesuke/unite-outline', {
        \ "autoload": {
        \   "unite_sources": ["outline"],
        \ }}
  nnoremap [unite] <Nop>
  nmap U [unite]
  nnoremap <silent> [unite]f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
  nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
  nnoremap <silent> [unite]r :<C-u>Unite register<CR>
  nnoremap <silent> [unite]m :<C-u>Unite file_mru<CR>
  nnoremap <silent> [unite]c :<C-u>Unite bookmark<CR>
  nnoremap <silent> [unite]o :<C-u>Unite outline<CR>
  nnoremap <silent> [unite]t :<C-u>Unite tab<CR>
  nnoremap <silent> [unite]w :<C-u>Unite window<CR>
  nnoremap <silent> [unite]u :<C-u>Unite buffer file_mru<CR>
  nnoremap <silent> [unite]a :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru register bookmark outline tab window file<CR>

  " ウィンドウを分割して開く
  au FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
  au FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
  " ウィンドウを縦に分割して開く
  au FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
  au FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
  " ESCキーを2回押すと終了する
  au FileType unite nnoremap <silent> <buffer> <ESC><ESC> q
  au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>q

  let s:hooks = neobundle#get_hooks("unite.vim")
  function! s:hooks.on_source(bundle)
    " start unite in insert mode
    " let g:unite_enable_start_insert = 1
    " use vimfiler to open directory
    call unite#custom_default_action("source/bookmark/directory", "vimfiler")
    call unite#custom_default_action("directory", "vimfiler")
    call unite#custom_default_action("directory_mru", "vimfiler")
    autocmd MyAutoCmd FileType unite call s:unite_settings()
    function! s:unite_settings()
      imap <buffer> <Esc><Esc> <Plug>(unite_exit)
      nmap <buffer> <Esc> <Plug>(unite_exit)
      nmap <buffer> <C-n> <Plug>(unite_select_next_line)
      nmap <buffer> <C-p> <Plug>(unite_select_previous_line)
    endfunction
  endfunction


  NeoBundle 'mattn/emmet-vim.git'
  NeoBundle 'tpope/vim-surround'

  " インストールされていないプラグインのチェックおよびダウンロード
  NeoBundleCheck

  call neobundle#end()
endif

" ファイルタイププラグインおよびインデントを有効化
" これはNeoBundleによる処理が終了したあとに呼ばなければならない
filetype plugin indent on

" 配色関連
syntax on
set t_Co=256
colorscheme desert

set ignorecase          " 大文字小文字を区別しない
set smartcase           " 検索文字に大文字がある場合は大文字小文字を区別
set incsearch           " インクリメンタルサーチ
set hlsearch            " 検索マッチテキストをハイライト (2013-07-03 14:30 修正）

" バックスラッシュやクエスチョンを状況に合わせ自動的にエスケープ
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

set shiftround          " '<'や'>'でインデントする際に'shiftwidth'の倍数に丸める
set infercase           " 補完時に大文字小文字を区別しない
set virtualedit=all     " カーソルを文字が存在しない部分でも動けるようにする
set hidden              " バッファを閉じる代わりに隠す（Undo履歴を残すため）
set switchbuf=useopen   " 新しく開く代わりにすでに開いてあるバッファを開く
set showmatch           " 対応する括弧などをハイライト表示する
set matchtime=3         " 対応括弧のハイライト表示を3秒にする
" 開くファイルエンコードの選択
set fileencodings=utf-8,iso-2022-jp,cp932,euc-jp,utf-16,ucs-2-internal,ucs-2 
set wildmenu
set showcmd
" 補完候補が絞りきれない時のタイムアウト時間
set timeout timeoutlen=1000 ttimeoutlen=100 

" 対応括弧に'<'と'>'のペアを追加
set matchpairs& matchpairs+=<:>

" バックスペースでなんでも消せるようにする
set backspace=indent,eol,start

" Swapファイル？Backupファイル？前時代的すぎ
" なので全て無効化する
set nowritebackup
set nobackup
set noswapfile

set number              " 行番号の表示
set nowrap              " 長いテキストの折り返さない
set textwidth=0         " 自動的に改行が入るのを無効化
set colorcolumn=80      " その代わり80文字目にラインを入れる
set ambiwidth=double    " 全角の記号を正しく表示する
set autoindent          " オートインデント
set smarttab
set tabstop=2           " インデント幅
set shiftwidth=2        " 空白挿入幅
set expandtab           " インデントを空白文字に置き換え
set clipboard+=unnamed  " ヤンク時にclipboardに貼り付け

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
" Pythonのみの設定
autocmd FileType python setl autoindent
autocmd FileType python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType python setl expandtab tabstop=4 shiftwidth=4 softtabstop=4
"set foldmethod=syntax
autocmd FileType c setl foldmethod=syntax
autocmd FileType cpp setl foldmethod=syntax

" 画面のステータスバー表示
set statusline='%F%m%r%h%w\%=[%Y]\[%{&ff}]\[%{&fileencoding}]\[\%03.3b]\[HEX=\%02.2B]\[%04l行,%04v桁][%p%%]\ [LEN=%L]'
set laststatus=2

" 補完候補の色づけ for vim7
hi Pmenu     ctermbg=darkgray ctermfg=white
hi PmenuSel  ctermbg=blue     ctermfg=white
hi PmenuSbar ctermbg=0        ctermfg=9

" 前時代的スクリーンベルを無効化
set t_vb=
set novisualbell

"--------------------------------
" vimdiff用map
"--------------------------------
map dl :diffg 2<CR>:diffupdate<CR>]czz
map do :diffg 3<CR>:diffupdate<CR>]czz
map dp :diffp 1<CR>:diffupdate<CR>]czz

" デフォルト不可視文字は美しくないのでUnicodeで綺麗に
set list                " 不可視文字の可視化
if has('mac')
  set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%,eol:↲
else 
  set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%
endif

" 入力モード中に素早くjjと入力した場合はESCとみなす
inoremap jk <Esc>

" ESCを二回押すことでハイライトを消す
nmap <silent> <Esc><Esc> :nohlsearch<CR>

" カーソル下の単語を * で検索
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v, '\/'), "\n", '\\n', 'g')<CR><CR>

" 検索後にジャンプした際に検索単語を画面中央に持ってくる
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" j, k による移動を折り返されたテキストでも自然に振る舞うように変更
nnoremap j gj
nnoremap k gk

" vを二回で行末まで選択
vnoremap v $h

" T + ? で各種設定をトグル
nnoremap [toggle] <Nop>
nmap + [toggle]
nnoremap <silent> [toggle]s :setl spell!<CR>:setl spell?<CR>
nnoremap <silent> [toggle]l :setl list!<CR>:setl list?<CR>
nnoremap <silent> [toggle]t :setl expandtab!<CR>:setl expandtab?<CR>
nnoremap <silent> [toggle]w :setl wrap!<CR>:setl wrap?<CR>

"--------------------------------
" ZenCoding
"--------------------------------

let g:user_zen_settings = {
            \'indentation' : '  ',
            \}

"--------------------------------
" 挿入モード時、ステータスラインの色を変更
"--------------------------------
highlight StatusLine ctermfg=white ctermbg=darkblue cterm=none
let g:hi_insert = 'highlight StatusLine ctermfg=white ctermbg=darkgreen cterm=none'
let g:hi_normal = 'highlight StatusLine ctermfg=white ctermbg=darkblue cterm=none'
if has('syntax')
  augroup InsertHook
    autocmd!
    autocmd InsertEnter * call s:StatusLine('Enter')
    autocmd InsertLeave * call s:StatusLine('Leave')
  augroup END
endif

let s:slhlcmd = ''
function! s:StatusLine(mode)
  if a:mode == 'Enter'
    silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
    silent exec g:hi_insert
  else
    "highlight clear StatusLine
    "silent exec s:slhlcmd
    silent exec g:hi_normal
  endif
endfunction

function! s:GetHighlight(hi)
  redir => hl
  exec 'highlight '.a:hi
  redir END
  let hl = substitute(hl, '[\r\n]', '', 'g')
  let hl = substitute(hl, 'xxx', '', '')
  return hl
endfunction


"--------------------------------
" 補完補助
"--------------------------------
" <ESC>: close popup and save indent.
"inoremap <expr><ESC>  pumvisible() ? neocomplcache#smart_close_popup() : "\<ESC>"
" <TAB>: completion
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><CR>  pumvisible() ? "\<C-n>" : "\<CR>"

" make, grep などのコマンド後に自動的にQuickFixを開く
autocmd MyAutoCmd QuickfixCmdPost make,grep,grepadd,vimgrep copen

" QuickFixおよびHelpでは q でバッファを閉じる
autocmd MyAutoCmd FileType help,qf nnoremap <buffer> q <C-w>c

" w!! でスーパーユーザーとして保存（sudoが使える環境限定）
cmap w!! w !sudo tee > /dev/null %

" :e などでファイルを開く際にフォルダが存在しない場合は自動作成
function! s:mkdir(dir, force)
  if !isdirectory(a:dir) && (a:force ||
        \ input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
  endif
endfunction
autocmd MyAutoCmd BufWritePre * call s:mkdir(expand('<afile>:p:h'), v:cmdbang)


" ~/.vimrc.localが存在する場合のみ設定を読み込む
let s:local_vimrc = expand('~/.vimrc.local')
if filereadable(s:local_vimrc)
    execute 'source ' . s:local_vimrc
endif

set laststatus=2
"set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim 
"let g:Powerline_symbols='fancy'
set noshowmode

