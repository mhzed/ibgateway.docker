FROM debian:jessie-slim
RUN apt update && apt -y install unzip xvfb x11vnc wget socat && rm -rf /var/lib/apt/lists/*
WORKDIR /root
RUN wget -q https://download2.interactivebrokers.com/installers/ibgateway/latest-standalone/ibgateway-latest-standalone-linux-x64.sh \
  && chmod a+x ibgateway-latest-standalone-linux-x64.sh && yes n | sh ibgateway-latest-standalone-linux-x64.sh -c \
  && rm ibgateway-latest-standalone-linux-x64.sh
RUN wget -q https://github.com/IbcAlpha/IBC/releases/download/3.7.4/IBCLinux-3.7.4.zip && unzip IBCLinux-3.7.4.zip -d ibc \
  && chmod a+x ./ibc/*.sh ./ibc/*/*.sh && mkdir -p /opt/ibc && cp -R ./ibc/* /opt/ibc \
  && rm IBCLinux-3.7.4.zip && cp ~/ibc/config.ini ~/ibc/config.ini.original \
  && sed -i 's/TWS_MAJOR_VRSN=963/TWS_MAJOR_VRSN=974/g' ~/ibc/gatewaystart.sh \
  && sed -i 's/TWS_MAJOR_VRSN=963/TWS_MAJOR_VRSN=974/g' ~/ibc/twsstart.sh
ADD ./entry.sh /root/entry.sh
EXPOSE 5900 4004
ENTRYPOINT [ "/root/entry.sh" ] 
