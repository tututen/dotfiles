# users generic .zshrc file for zsh(1)
## Environment variable configuration
#
# LANG
#
export LANG=ja_JP.UTF-8
case ${UID} in
0)
LANG=C
;;
esac

## Default shell configuration
#
# set prompt
#
autoload colors
colors
case ${UID} in
0)
PROMPT="%{${fg[cyan]}%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') %B%{${fg[red]}%}%/#%{${reset_color}%}%b "
PROMPT2="%B%{${fg[red]}%}%_#%{${reset_color}%}%b "
SPROMPT="%B%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
;;
*)
PROMPT="%{${fg[red]}%}%/%%%{${reset_color}%} "
PROMPT2="%{${fg[red]}%}%_%%%{${reset_color}%} "
SPROMPT="%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%} "
[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
PROMPT="%{${fg[cyan]}%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') ${PROMPT}"
;;
esac
# auto change directory
#
setopt auto_cd
# auto directory pushd that you can get dirs list by cd -[tab]
#
setopt auto_pushd
# command correct edition before each completion attempt
#
setopt correct
# compacked complete list display
#
setopt list_packed
# no remove postfix slash of command line
#
setopt noautoremoveslash
# no beep sound when complete list displayed
#
setopt nolistbeep

# 
setopt interactivecomments

## Keybind configuration
#
# emacs like keybind (e.x. Ctrl-a gets to line head and Ctrl-e gets
# to end) and something additions
#
bindkey -v
#bindkey "^[[1~" beginning-of-line # Home gets to line head
#bindkey "^[[4~" end-of-line # End gets to line end
#bindkey "^[[3~" delete-char # Del
# historical backward/forward search with linehead string binded to ^P/^N
#
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end
# reverse menu completion binded to Shift-Tab
#
bindkey "\e[Z" reverse-menu-complete

## Command history configuration
#
HISTFILE=${HOME}/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt hist_ignore_dups # ignore duplication command history list
setopt share_history # share command history data
# 複数の zsh を同時に使う時など history ファイルに上書きせず追加する
setopt append_history
# zsh の開始・終了時刻をヒストリファイルに書き込む
setopt extended_history

## Completion configuration
#
fpath=(${HOME}/.zsh/functions/Completion ${fpath})
autoload -U compinit
compinit -u

## zsh editor
#
autoload zed

## Prediction configuration
#
#autoload predict-on
#predict-off

## Alias configuration
#
# expand aliases before completing
#
setopt complete_aliases # aliased ls needs if file/dir completions work

alias where="command -v"
alias j="jobs -l"
alias screen="screen -R"
#alias screen="byobu -R"
#export GREP_OPTIONS='--color=always'
case "${OSTYPE}" in
freebsd*|darwin*)
alias ls="ls -G -w"
;;
linux*)
alias ls="ls --color"
;;
esac
alias la="ls -a"
alias lf="ls -F"
alias ll="ls -l"
alias du="du -h"
alias df="df -h"
alias su="su -l"
## TAB で順に補完候補を切り替える
setopt auto_menu
## 補完候補のカーソル選択を有効に
zstyle ':completion:*:default' menu select=1
## terminal configuration
#
case "${TERM}" in
screen)
TERM=xterm-256color
;;
esac
case "${TERM}" in
xterm|xterm-color|xterm-256color)
export LSCOLORS=gxfxcxdxbxegedabagacad
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
;;
kterm-color)
stty erase '^H'
export LSCOLORS=gxfxcxdxbxegedabagacad
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
;;
kterm)
stty erase '^H'
;;
cons25)
unset LANG
export LSCOLORS=ExFxCxdxBxegedabagacad
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors 'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
;;
jfbterm-color)
export LSCOLORS=gxFxCxdxBxegedabagacad
export LS_COLORS='di=01;36:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors 'di=;36;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
;;
esac
# set terminal title including current directory
#
case "${TERM}" in
xterm|xterm-color|kterm|kterm-color)
precmd() {
echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
}
;;
esac

zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
# プロンプトにモード（Ins、Norを表示（Viバインド））
case ${UID} in
0)
	PROMPT="[%{$fg_bold[cyan]%}INS%{$reset_color%}] %{$fg_bold[white]%}%#%{$reset_color%} "
;;
*)
	PROMPT="[%{$fg_bold[cyan]%}INS%{$reset_color%}] %{$fg_bold[white]%}%%%{$reset_color%} "
;;
esac

function zle-line-init zle-keymap-select {
case $KEYMAP in
vicmd)
	case ${UID} in
	0)
	PROMPT="[%{$fg_bold[red]%}NOR%{$reset_color%}] %{$fg_bold[white]%}%#%{$reset_color%} "
	;;
	*)
	PROMPT="[%{$fg_bold[red]%}NOR%{$reset_color%}] %{$fg_bold[white]%}%%%{$reset_color%} "
	;;
	esac
;;
main|viins)
	case ${UID} in
	0)
	PROMPT="[%{$fg_bold[cyan]%}INS%{$reset_color%}] %{$fg_bold[white]%}%#%{$reset_color%} "
	;;
	*)
	PROMPT="[%{$fg_bold[cyan]%}INS%{$reset_color%}] %{$fg_bold[white]%}%%%{$reset_color%} "
	;;
	esac
;;
esac
zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select
# ディレクトリの色をシアンに
export LSCOLORS=gxfxcxdxbxegedabagacad
export LS_COLORS="${LS_COLORS}:di=00;36"

zstyle ':completion:*' list-colors $LSCOLORS

# 過剰補完
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*:messages' format $fg_bold[yellow]'%d'$reset_color
zstyle ':completion:*:warnings' format $fg_bold[red]'No matches for:'$fg_bold[yellow]' %d'$reset_color
zstyle ':completion:*:descriptions' format $fg_bold[yellow]'completing %B%d%b'$reset_color
zstyle ':completion:*:corrections' format $fg_bold[yellow]'%B%d '$fg_bold[red]'(errors: %e)%b'$reset_color
zstyle ':completion:*:options' description 'yes'
# グループ名に空文字列を指定すると，マッチ対象のタグ名がグループ名に使われる。
# したがって，すべての マッチ種別を別々に表示させたいなら以下のようにする
zstyle ':completion:*' group-name

function peco-history-selection() {
    BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection

## load user .zshrc configuration file
#
[ -f ${HOME}/.zshrc.mine ] && source ${HOME}/.zshrc.mine



test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
