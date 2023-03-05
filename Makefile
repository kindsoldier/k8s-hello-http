

KUBECTL = k3s kubectl
CTR = k3s ctr
DOCKER = podman

all: build-server build-client

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

k3s-install:
	curl -sfL https://get.k3s.io | sh

k3s-install-wo:
	curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--no-deploy traefik" sh

k3s-uninstall:
	k3s-uninstall.sh

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
