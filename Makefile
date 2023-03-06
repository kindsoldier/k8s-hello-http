


KUBECTL = k3s kubectl
CTR = k3s ctr
DOCKER = podman

GENDIR=.


all: build-server build-client


baseos: 
	$(DOCKER) image build -t localhost/baseos:v1 -f baseos.docker .


install-go:
	mkdir -p /usr/local/bin
	cd /usr/local && \
	  wget -O go.tar.gz https://go.dev/dl/go1.20.1.linux-amd64.tar.gz && \
	  tar xzf go.tar.gz
	cd /usr/local/bin/ && ln -sf ../go/bin/* .

install-go-tools:
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
	mkdir -p  /usr/local/bin
	install ~/go/bin/protoc-gen-go-grpc /usr/local/bin

genrpc:
	protoc --proto_path=proto --go_out=$(GENDIR) --go-grpc_out=$(GENDIR) proto/*.proto

build-server:
	CGO_ENABLED=0 go build -o server server.go

build-client:
	CGO_ENABLED=0 go build -o client client.go

install: install-server install-client local-clean

install-server: build-server
	$(DOCKER) image build -t localhost/server:v2 -f server.docker .
	rm -f server.tar
	$(DOCKER) image save localhost/server:v2 -o server.tar
	$(CTR) images import server.tar
	rm -f server.tar
#	$(KUBECTL) delete -f server.yaml; true
#	$(KUBECTL) apply -f server.yaml
#	$(KUBECTL) get pod
#	$(KUBECTL) get svc
	helm install server charts/server


show:
	$(KUBECTL) get pod
	$(KUBECTL) get svc

install-client: build-client
	$(DOCKER) image build -t localhost/client:v2 -f client.docker .
	rm -f client.tar
	$(DOCKER) image save localhost/client:v2 -o client.tar
	$(CTR) images import client.tar
	rm -f client.tar
#	$(KUBECTL) delete -f client.yaml; true
#	$(KUBECTL) apply -f client.yaml
	helm install client charts/client


deinstall: deinstall-client deinstall-server

deinstall-client:
#	$(KUBECTL) delete -f client.yaml; true
	helm uninstall client


deinstall-server:
#	$(KUBECTL) delete -f server.yaml; true
	helm uninstall server

list-pods:
	kubectl get pod -o json -o custom-columns=:metadata.name,:status.hostIP,:status.podIP

show-logs:
	for pod in $$(kubectl get pods -l app=server -o custom-columns=:metadata.name);do \
	  echo "---$$pod :::"; \
	  kubectl logs $$pod; \
	done

make-descr:
	helm template client charts/client/ > client.yaml
	helm template server charts/server/ > server.yaml

install-k3s:
	curl -sfL https://get.k3s.io | sh

install-k3s-wo:
	curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--no-deploy traefik" sh

uninstall-k3s:
	k3s-uninstall.sh

install-k0s:
	curl -sSLf https://get.k0s.sh | sh
	wget -O k0s https://github.com/k0sproject/k0s/releases/download/v1.26.2+k0s.0/k0s-v1.26.2+k0s.0-amd64
	install k0s /usr/local/bin
#	k0s config create > k0s.yaml
#	k0s install controller -c k0s.yaml
	k0s install controller --single
	k0s start

config-k0s:
	mkdir -p ~/.kube
	k0s kubeconfig admin > kubeconf.yaml
	cp kubeconf.yaml ~/.kube/config

deinstall-k0s:
	k0s stop; true
	k0s reset
	rm -f /usr/local/bin/k0s

install-utils:
	sudo apt-get update
	sudo apt-get -y upgrade
	sudo apt-get install -y containerd.io docker-ce docker-ce-cli
	sudo apt-get install -y podman
	sudo apt-get install -y protoc-gen-go
	sudo apt-get install -y helm
	sudo apt-get install -y kubectl

clean: local-clean 

local-clean:
	rm -f server client *~
	rm -f *.tar


clean-images:
	podman system prune --all --force
	podman rmi --all --force
