#!/bin/sh
rm /tmp/.X1-lock
Xvfb :1 -ac -screen 0 1024x768x16 >> /var/log/xvfb.log &
export DISPLAY=:1
x11vnc -ncache_cr -display :1 -forever -shared -logappend /var/log/x11vnc.log -bg -noipv6

cat <<EOT > ~/ibc/config.ini
FIX=${IBFIX:-no}
IbLoginId=$IBUSER
IbPassword=$IBPASS
FIXLoginId=$IBFIXUSER
FIXPassword=$IBFIXPASS
# 'paper'. For earlier versions of TWS this setting has no
TradingMode=${IBMODE:-live}
IbDir=$IBUSER
StoreSettingsOnServer=no
MinimizeMainWindow=no
# primary|secondary|manual
ExistingSessionDetectedAction=primary
AcceptIncomingConnectionAction=accept
ShowAllTrades=no
OverrideTwsApiPort=4010
ReadOnlyLogin=no
AcceptNonBrokerageAccountWarning=yes
IbAutoClosedown=yes
ClosedownAt=
DismissPasswordExpiryWarning=no
DismissNSEComplianceNotice=yes
#AutoConfirmOrders=no
SaveTwsSettingsAt=
#CommandServerPort=7462
ControlFrom=
BindAddress=
CommandPrompt=
SuppressInfoMessages=yes
LogComponents=never
EOT

DISPLAY=:1 ~/ibc/gatewaystart.sh
# ib gateway allows localhost only
socat TCP4-LISTEN:4004,fork TCP4:127.0.0.1:4010 &
while true; do sleep 10; done
