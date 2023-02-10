package main

import (
	"context"
	"log"
    //"time"

	"google.golang.org/grpc"

	pbHello "pmapp/api/hello"
)

const (
	address = "localhost:8080"
)

func Install() error {
	var err error

	conn, err := grpc.Dial(address, grpc.WithInsecure(), grpc.WithBlock())
	if err != nil {
		return err
	}
	defer conn.Close()

    req := pbHello.InstallRequest{
        Hostname: "localhost",
        Port:   12345,
    }

	pbClient := pbHello.NewHelloClient(conn)
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()
    //ctx, _ := context.WithTimeout(context.Background(), 5 * time.Second)
	stream, err := pbClient.Install(ctx, &req)
    if err != nil {
        return err
    }

	for {
		res, err := stream.Recv()
        if err != nil {
            return err
        }
    	log.Println("installation is incomplete")
        if res.Done {
            log.Println("installation is finished!")
            break
        }
	}
    return err
}

func main() {
	Install()
}
