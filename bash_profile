# Difference between bash profile and rc files
# http://www.joshstaiger.org/archives/2005/07/bash_profile_vs.html
# OR
# https://stackoverflow.com/a/415444/2069749
#
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/pkrypto/projects/bin/google-cloud-sdk/path.bash.inc' ]; then source '/Users/pkrypto/projects/bin/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/pkrypto/projects/bin/google-cloud-sdk/completion.bash.inc' ]; then source '/Users/pkrypto/projects/bin/google-cloud-sdk/completion.bash.inc'; fi
export PATH="/usr/local/opt/sqlite/bin:$PATH"
export PATH="/usr/local/opt/python@3.8/bin:$PATH"

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

export PATH="/usr/local/opt/mongodb-community@5.0/bin:$PATH"
