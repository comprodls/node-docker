# comproDLS Docker for Nodejs

## Test the Docker image (build & run):

```
$ docker build -t comprodls-nodejs-baseline .
$ docker run -it --rm --name comprodls-running-service comprodls-nodejs-baseline
```

## Running IN Production 

### Environment Variables
Run with NODE_ENV set to production. This is the way you would pass in secrets and other runtime configurations to your application as well.

``` 
-e "NODE_ENV=production"
```

### Handling Kernel Signals
Node.js was not designed to run as PID 1 which leads to unexpected behaviour when running inside of Docker. For example, a Node.js process running as PID 1 will not respond to SIGTERM (CTRL-C) and similar signals. As of Docker 1.13, you can use the --init flag to wrap your Node.js process with a lightweight init system that properly handles running as PID 1.

```
docker run -it --init node
```

### Memory
By default, any Docker Container may consume as much of the hardware such as CPU and RAM. Limit the memory to how much you need.

-m "512M" --memory-swap "1G"

### Bringing it all together 
Here is an example of how you would run Nodejs Docker in production:

```
$ docker run \
  -e "NODE_ENV=production" \
  -m "512M" --memory-swap "1G" \
  --name "comprodls-running-service comprodls-nodejs-baseline" \
```
