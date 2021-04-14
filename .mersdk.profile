function hadk() { source $HOME/.hadk.env; echo "Env setup for $DEVICE"; }
PS1="[PlatformSDK [\${DEVICE}] \u@\h] $ "
[ -d /etc/bash_completion.d ] && for i in /etc/bash_completion.d/*;do . $i;done
export PATH=$PATH:/sbin
hadk