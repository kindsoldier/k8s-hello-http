package main

import (
    "fmt"
    "log"
    "net/http"
)

func main() {
    log.Println("start service")
    http.HandleFunc("/", HelloServer)
    http.ListenAndServe(":8080", nil)
}

func HelloServer(w http.ResponseWriter, r *http.Request) {
    log.Println("hello request")
    fmt.Fprintf(w, "Hello!\n")
}
