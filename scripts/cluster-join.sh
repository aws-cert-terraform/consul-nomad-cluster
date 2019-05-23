#!/bin/bash

if [ $CLUSTER_NU == 0 ]; then
    docker run -d --net=host -v /data/consul:/data \
        --name=dev-consul consul agent -server -ui -bootstrap-expect=2 -client 0.0.0.0 -advertise $NODE_IP -retry-join "provider=digitalocean region=nyc3 tag_name=consul api_token=$DO_TOKEN"
else
    docker run -d --net=host -v /data/consul:/data \
        --name=dev-consul consul agent -server -ui -bootstrap-expect=2 -client 0.0.0.0 -advertise $NODE_IP -retry-join "provider=digitalocean region=nyc3 tag_name=consul api_token=$DO_TOKEN"
fi

# Could also do this? I dunno I forget but I used this to learn something...
# docker run -d --net=host --name=dev-consul consul agent -server -bootstrap-expect=2 -advertise $NODE_IP


        # -p $NODE_IP:8300:8300 \
        # -p $NODE_IP:8301:8301 \
        # -p $NODE_IP:8301:8301/udp \
        # -p $NODE_IP:8302:8302 \
        # -p $NODE_IP:8302:8302/udp \
        # -p $NODE_IP:8400:8400 \
        # -p $NODE_IP:8500:8500 \
        # -p 53:53/udp \
