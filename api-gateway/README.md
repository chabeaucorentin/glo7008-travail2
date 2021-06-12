## Packaging the application
` $ mvn install`

## Running the application
` $ java -jar gateway-0.0.1-SNAPSHOT.jar --logic.api.url=http://localhost:5000 ` 

## Building the container
` $ docker build -f Dockerfile -t $DOCKER_USER_ID/api-gateway . `

## Running the container
``` 
$ docker run -d -p 8080:8080 -e LOGIC_API_URL='http://<container_ip or docker machine ip>:5000' $DOCKER_USER_ID/api-gateway  
```

#### Native docker support needs the Container IP
CONTAINER_IP: To forward messages to the logic-api container we need to get  its IP. To do so execute:

` $ docker container list`

Copy the id of logic-api container and execute:

` $ docker inspect <container_id> `

The Containers IP address is found under the property NetworkSettings.IPAddress, use it in the RUN command.

#### Docker Machine on a VM 
Get Docker Machine IP by executing:

` $ docker-machine ip `

Use this one in the command.


## Pushing the container
` $ docker push $DOCKER_USER_ID/api-gateway `


