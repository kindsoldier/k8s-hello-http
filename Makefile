
GENDIR=.

build:
	CGO_ENABLED=0 go build server.go 
	CGO_ENABLED=0 go build client.go 

server: server.go
client: client.go

images: build image-server image-client

image-server: server 
	podman image build -t localhost/server:v2 -f server.docker .
	rm -f  server.tar
	podman image save localhost/server:v2 -o server.tar
	k3s ctr images import server.tar
	k3s kubectl delete -f server.yaml; true
	k3s kubectl apply -f server.yaml


image-client: client
	podman image build -t localhost/client:v2 -f client.docker .
	rm -f  client.tar
	podman image save localhost/client:v2 -o client.tar
	k3s ctr images import client.tar
	k3s kubectl delete -f client.yaml; true
	k3s kubectl apply -f client.yaml

clean:
	rm -f server client *~
	k3s kubectl delete -f client.yaml; true
	k3s kubectl delete -f server.yaml; true
	rm -f *.tar
