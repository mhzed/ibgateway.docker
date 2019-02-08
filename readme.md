## Interactive broker gateway

Builds a docker image that runs interactive broker gateway.  Currently at version 974.4

Dockerfile captures all the specifics.

```
docker build -t mhzed/ibgateway .
```

## Customization

First launch container running bash:
```
docker run -it --name ibg --entrypoint bash mhzed/ibgateway
```

Perform your customization in container, then save container to image:
```
docker commit --change='ENTRYPOINT ["/root/entry.sh"]' <container> mhzed/ibgateway
```

## Running

The container listens on two ports internally: 5900 for vnc server, 4004 for gateway api server.  

Run a live account:
```
docker run -d  --name ibg -p 15900:5900 -p 14004:4004 -e IBUSER=user -e IBPASS=pass mhzed/ibgateway
```

Run a paper account:
```
docker run -d  --name ibg -p 15900:5900 -p 14004:4004 -e IBUSER=user -e IBPASS=pass -e IBMODE=paper mhzed/ibgateway
```

Run a live account using FIX connection:
```
docker run -d  --name ibg -p 15900:5900 -p 14004:4004 -e IBFIXUSER=user -e IBFIXPASS=pass -e IBFIX=yes mhzed/ibgateway
```

To see gateway, vnc to localhost:15900 (no passwords).

To connect to api server, tcp connect to localhost:14004.


## More details

Details are in entry.sh.  The gateway accepts connection from localhost only for security reason.  The option could be overridden in the gateway configuration GUI, but doesn't work due to bug in version 974.4.  So we simply use socat to create a port forward to trick the gateway IP checks, and this also pins down the gateway api port to 4004.

Application level securities are stripped out intentionally, i.e. both vnc and api servers can be accessed directly.  Instead use SSH tunnel to the docker host to access these ports, this is much more secure and convenient.