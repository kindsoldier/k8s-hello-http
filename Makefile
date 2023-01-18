
GENDIR=.

all:
	protoc --proto_path=proto --go_out=$(GENDIR) --go-grpc_out=$(GENDIR) proto/*.proto
	go build server.go 
	go build client.go 

clean:
	rm -f server client *~
