# ASCII mode works on another Mac without requiring a particular font.
typeset -g POWERLEVEL9K_MODE=ascii
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs newline prompt_char)
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs time)
typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
typeset -g POWERLEVEL9K_VCS_SHOW_CHANGESET=true
typeset -g POWERLEVEL9K_VCS_CHANGESET_HASH_LENGTH=8
typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M}'
typeset -g POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
(( $+functions[p10k] )) && p10k reload
return 0
