package main

import (
	"log"
	"net"
    "sync"
    "time"

	pbHello "pmapp/api/hello"

	"google.golang.org/grpc"
)

const (
	port = ":8080"
)


type HelloServer struct {
	pbHello.UnimplementedHelloServer
}

func NewHelloServer() *HelloServer {
	return &HelloServer{}
}

func (helloServ *HelloServer) Install(req *pbHello.InstallRequest, stream pbHello.Hello_InstallServer) error {
	var err error
	log.Println("call install:", req)

    var wg sync.WaitGroup
    doneChan := make(chan bool)

    aliveFunc := func() {
        defer wg.Done()
        for {
            select {
            case <- doneChan:
                return
            default:
                time.Sleep(1 * time.Second)
            }
            log.Println("send alive response")
            intermRes := pbHello.InstallResult{
                Done: false,
            }
            err = stream.Send(&intermRes)
            if err != nil {
                return
            }
        }
    }
    wg.Add(1)
    go aliveFunc()

    time.Sleep(10 * time.Second)

    doneChan <- true
    wg.Wait()

    doneRes := pbHello.InstallResult{
        Done: true,
    }
    err = stream.Send(&doneRes)
    if err != nil {
        return err
    }

	return err
}


func main() {
	var err error
	listener, err := net.Listen("tcp", port)
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	grpcServ := grpc.NewServer()
	pbHello.RegisterHelloServer(grpcServ, NewHelloServer())

	log.Printf("server listening at %v", listener.Addr())
	err = grpcServ.Serve(listener)
	if err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
