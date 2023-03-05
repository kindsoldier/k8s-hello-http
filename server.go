package main

import (
	"fmt"
	"log"
	"net/http"
)

const (
	port = 9001
)

func main() {
	address := fmt.Sprintf(":%d", port)
	log.Println("start service on", address)
	http.HandleFunc("/", HelloServer)
	http.ListenAndServe(address, nil)
}

func HelloServer(w http.ResponseWriter, r *http.Request) {
	log.Println("Got hello request")
	fmt.Fprintf(w, "Hello!\n")
}
