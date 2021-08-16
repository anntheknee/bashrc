#   / /  ___ ____ / /  ________
#  / _ \/ _ `(_-</ _ \/ __/ __/
# /_.__/\_,_/___/_//_/_/  \__/ 

stty -ixon # disable ctrl-s/ctrl-q
shopt -s autocd # cd w/o cd
HISTSIZE=HISTFILESIZE=-1 # infinite history
shopt -s histappend # >> instead of >
HISTTIMEFORMAT='%F %T ' # format hist logs

alias p='sudo pacman'
alias h='history | grep'
alias pag='ps aux | grep'
alias ..='cd ..'
alias ...='cd ../..'
alias pls='sudo "$BASH" -c "$(history -p !!)"'
alias cat='bat'
alias ls='exa -la'
alias grep="grep --color=auto"
alias x='exit'
alias mv="mv -iv"
alias cp="cp -riv"
alias mkdir='mkdir -vp'

function getBranch () {
    branch=$(git branch --show-current 2>/dev/null)
    if [[ ! -z "$branch" ]]; then
        echo "[$branch] "
    fi
}

function moneyEarned() {
    # Work hours in 24hr format (00...23)
    start=09:00
    end=17:00
    currenttime=$(date +"%H:%M:%S")
    # Only print during work hours
    if [[ "$currenttime" > $start ]] && [[ "$currenttime" < $end ]]; then
        # Strip leading zero and convert to seconds
        start_sec=$(($(date -d $start +"%H" | sed 's/^0*//') * 60 * 60))
        IFS=':'
        read -a strarr <<< "$currenttime"
        total_min=$((${strarr[0]} * 60 + ${strarr[1]}))
        total_sec=$(($total_min * 60 + ${strarr[2]}))
        monthly_pay=6349
        hours_worked=173.2
        pay_per_sec=$(echo "scale=10 ; $monthly_pay / $hours_worked /60 /60" | bc)
        time_delta=$(($total_sec - $start_sec))
        earned_today=$(echo "scale=2 ; $pay_per_sec * $time_delta / 1" | bc)
        echo "{\$$earned_today} "
    fi
}

function shortOLDPWD() {
    echo $OLDPWD | sed 's/\(..\)[^/]*/\1/g' | sed 's/\/h\/a/~/'
}

PS1='[\T] \u@\h $(moneyEarned)|| $(shortOLDPWD) <<: $(getBranch)\w  \n'

echo "Hello! o/"
echo "Today is $(date +"%A %B %d, %Y")"