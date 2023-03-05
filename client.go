package main

import (
	"fmt"
	"log"
	"net/http"
	"time"
)

const (
	port = 9001
	host = "server"
)

func main() {
	log.Println("start client")

	for {
		uri := fmt.Sprintf("http://%s:%d", host, port)
		resp, err := http.Get(uri)
		if err != nil {
			log.Println("request error:", err)
		}
		resp.Body.Close()

		log.Println("response status:", resp.Status)
		time.Sleep(1 * time.Second)
	}
}
