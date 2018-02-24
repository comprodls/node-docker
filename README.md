# comproDLS Docker for Nodejs
This project serves as a baseline or seed project for creating Nodejs DOCKER containers.


## 1. Test the Docker image / IN Development:

```
$ docker build -t comprodls-nodejs-baseline .
$ docker run -it --rm -p 8080:5000 --name comprodls-running-service comprodls-nodejs-baseline
```
The ``-it `` argument is used to run in interactive mode. After runnning this you should have a prompt running inside the container

Normally, a Docker container persists after it has exited. This allows you to run the container again, inspect its filesystem, and so on. However, for testing we want to run the container and delete it immediately after it exits. The ```--rm``` command line option serves this purpose.

The ```--name``` command is used to give the container a name so you can refer to it later

**Additional commands / options for working with docker**

(1) For no cache option when building:
```
$ docker build --no-cache -t comprodls-nodejs-baseline .
```

(2) To check & stop a running container:
```
$ docker ps
$ docker stop comprodls-nodejs-baseline
```

(3) To test the container application (Express) first find your VM host IP using ```docker-machine ip``` and then open ```http://<Host IP>:8080```


## 2. Running IN Production 

### Environment Variables
Run with NODE_ENV set to production. This is the way you would pass in secrets and other runtime configurations to your application as well.

``` 
-e "NODE_ENV=production"
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
  --name "comprodls-running-service" \
  comprodls-nodejs-baseline
```

## 3. Running vis ECS 
TODO
