package main

import (
	"log"
	"net/http"
	"time"
)

const (
	port = 8080
	host = "server"
)

func main() {
	log.Println("start client")

	for {
		uri := fmt.Sprintf("http://%s:%s", host, port)
		resp, err := http.Get(uri)
		if err != nil {
			log.Println("request error:", err)
		}
		resp.Body.Close()

		log.Println("response status:", resp.Status)
		time.Sleep(1 * time.Second)
	}
}
