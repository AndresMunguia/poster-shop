# Vue.js & Node.js Poster Shop App

Source code for the app:
(https://vuejsdevelopers.com/courses/first-vue-app?utm_source=gitlab-vjd)


### Description

This repository was create to dockerise a node.js app and automate the image building process as well as the publishing of it in DockerHub. There is a ci pipeline which merges any changes pushed to 'testing' branch in to the 'master' branch, also every time a change is pushed, a new image of the app its created and published to DockerHub. 


This image is being built using Docker multi-stages to make it really light. Builder downloads required dependencies on "node v18", then our actual image (runner) is built in a lite version of "node v10.15.2" with a "alpine" linux distro and its listening to "port 3000".

 ```
 
 # First Stage

FROM node:18 as builder
WORKDIR /app

COPY ["package.json", "package-lock.json", "./"]
RUN npm install
COPY . .


# Second Stage

FROM node:10.15.2-alpine as runner
WORKDIR /app

COPY --from=builder /app .
CMD ["node", "server.js"]
EXPOSE 3000

 ```
 
#### CI Pipeline

This is the "Yaml" script used to configure the Github Action that automates the CI process.

Here I set the events that will trigger this action, basically a new image will be created everytime there is a change pushed to the 'master' or 'testing' branches as well if there is a pull request on any of this two.

```

name: Docker Image CI

on:
  push:
    branches:
     - master
     - testing
  pull_request:
    branches:
     - master
     - testing
	 
```

Below is the workflow for this pipeline, first it will build the image from /root, tag it with "poster-shop:date" and proceed to the next step which is publishing the image on my Dockerhub repository.

```
jobs:

  build:

    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3
    - name: Build the Docker image
      run: docker build . --file Dockerfile --tag poster-shop:$(date +%s)
    - uses: mr-smithers-excellent/docker-build-push@v5
      name: Build & push Docker image
      with:
       image: andresmunguia/poster-shop
       tags: v1, latest
       registry: docker.io
       dockerfile: Dockerfile
       username: ${{ secrets.DOCKER_USERNAME }}
       password: ${{ secrets.DOCKER_PASSWORD }}

```
 
#### Intallation with Docker

This image is hosted on a DockerHub public repository so it can be easily downloaded and executed using the commands bellow:

 ```

 $  docker pull andresmunguia/poster-shop:latest
 
 ```
 
 Then:
 
 ```
 
 $  docker run -d -p 3000:3000 andresmunguia/poster-shop
 
 ```
 
 And you can access the app using the link below:
 
 ```
 
 http://localhost:3000
 
 ```

#### Pre-installation WITHOUT DOCKER

Ensure [Node.js  >=4](https://nodejs.org/en/download/), [NPM](https://docs.npmjs.com) and [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) are installed on your system
 
#### Installation WITHOUT DOCKER

1. Install this code on your local system
     
    1. Fork this repository (click 'Fork' button in top right corner)
    2. Clone the forked repository on your local file system
    
        ```
        cd /path/to/install/location
        
        git clone https://github.com/[your_username]/poster-shop.git
		
        ```

2. Change directory into the local clone of the repository

    ```
    cd poster-shop
	
    ```

3. Install dependencies

    ```
    npm install
	
    ```
    
4. Start project

    ```
    npm run serve
	
    ```

5. Your site will be available at *localhost:3000*.


## Troubleshooting

Here are some common mistakes people make, check these before filing an issue:

- `EADDRINUSE :::3000`. You already have another application using port 3000. Either end it, or change manually set the `PORT` environment variable to resolve the conflict e.g. `3001`
- Ensure you have a version of Node >= 18

```
node -v

```
