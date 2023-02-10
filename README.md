## gRPC hello world

### Server side

```
$ ./server
2023/02/10 15:25:42 server listening at [::]:8080
2023/02/10 15:25:48 call install: Hostname:"localhost"  Port:12345
2023/02/10 15:25:49 send alive response
2023/02/10 15:25:50 send alive response
2023/02/10 15:25:51 send alive response
2023/02/10 15:25:52 send alive response
2023/02/10 15:25:53 send alive response
2023/02/10 15:25:54 send alive response
2023/02/10 15:25:55 send alive response
2023/02/10 15:25:56 send alive response
2023/02/10 15:25:57 send alive response
2023/02/10 15:25:58 send alive response

```

### Client side

```
$ ./client
2023/02/10 15:25:49 installation is incomplete
2023/02/10 15:25:50 installation is incomplete
2023/02/10 15:25:51 installation is incomplete
2023/02/10 15:25:52 installation is incomplete
2023/02/10 15:25:53 installation is incomplete
2023/02/10 15:25:54 installation is incomplete
2023/02/10 15:25:55 installation is incomplete
2023/02/10 15:25:56 installation is incomplete
2023/02/10 15:25:57 installation is incomplete
2023/02/10 15:25:58 installation is incomplete
2023/02/10 15:25:58 installation is incomplete
2023/02/10 15:25:58 installation is finished!
```
