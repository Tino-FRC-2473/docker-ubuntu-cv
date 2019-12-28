# Fancy Prompt
source ~/.git-prompt.sh
source ~/.git-completion.bash
# With git info
export GIT_PS1_SHOWDIRTYSTATE=1
export PS1='\[\e[32;1m\]\u:\[\e[33;1m\]\w>\[\e[0m\]\[\e[31;1m\]$(__git_ps1)\[\e[0m\]$ '
# Without git info
#export PS1='\[\e[32;1m\]\u:\[\e[33;1m\]\w\[\e[0m\]$ '
