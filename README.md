## gRPC hello world

### Server side

```
# ./server
2023/02/10 16:17:39 server listening at [::]:8080
2023/02/10 16:17:46 call install: Hostname:"localhost"  Port:12345
2023/02/10 16:17:47 send alive response
2023/02/10 16:17:48 send alive response
2023/02/10 16:17:49 send alive response
2023/02/10 16:17:50 send alive response
2023/02/10 16:17:51 send alive response
2023/02/10 16:17:52 send alive response
2023/02/10 16:17:53 send alive response
2023/02/10 16:17:54 send alive response
2023/02/10 16:17:55 send alive response
2023/02/10 16:17:56 installation is finished!
2023/02/10 16:17:56 send alive response
2023/02/10 16:17:56 cancel alive func
```

### Client side

```
# ./client
2023/02/10 16:17:47 installation is incomplete
2023/02/10 16:17:48 installation is incomplete
2023/02/10 16:17:49 installation is incomplete
2023/02/10 16:17:50 installation is incomplete
2023/02/10 16:17:51 installation is incomplete
2023/02/10 16:17:52 installation is incomplete
2023/02/10 16:17:53 installation is incomplete
2023/02/10 16:17:54 installation is incomplete
2023/02/10 16:17:55 installation is incomplete
2023/02/10 16:17:56 installation is incomplete
2023/02/10 16:17:56 installation is incomplete
2023/02/10 16:17:56 installation is finished!
```
