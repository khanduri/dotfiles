alias fanmgmt="cd /Users/pkhanduri/projects/HearsayLabs/fanmgmt; source ../virtualenv/bin/activate; ./manage.py runserver 8001"
export FB_USER_ID=517521816
export DEVLOCAL=True
# Difference between bash profile and rc files
# http://www.joshstaiger.org/archives/2005/07/bash_profile_vs.html

if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/heroku/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
