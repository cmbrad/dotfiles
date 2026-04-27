# load bitwarden helper functions if present
if [[ -f ~/.bitwardencli ]]; then
    source ~/.bitwardencli
fi

export PATH=~/bin:~/.local/bin:~/go/bin:$PATH
export KUBECONFIG=~/.kube/k3s.yml
export PATH=$PATH:$HOME/.tfenv/bin
alias config='/usr/bin/git --git-dir=/home/cmbrad/.cfg/ --work-tree=/home/cmbrad'

if command -v direnv &> /dev/null; then
  eval "$(direnv hook bash)"
fi
