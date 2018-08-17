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
