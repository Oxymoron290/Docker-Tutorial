## A `Dockerfile` is used to create a docker image.
## Not all of these commands are ran each time a container is started
## Only the CMD statement is executed when the container is started

# base image for the container running our build
FROM node:12.2.0-alpine as bobTheBuilder

# set working directory
WORKDIR /app

# Copy all the files from our context into the containers WORKDIR
COPY . .

# install application dependencies from node package manager (npm)
RUN npm install

# create a build of the application (saved to ./build)
RUN npm run build

# base image for the container running our app
FROM nginx:1.16.0-alpine

# set working directory - nginx public content serve directory
WORKDIR /usr/share/nginx/html

# Copy contents of /app/build in our `bobTheBuilder` container to our current working directory
COPY --from=bobTheBuilder /app/build/. .

# NGINX runs on network port 80 for http
EXPOSE 80

# Command the container runs when it starts
CMD ["nginx", "-g", "daemon off;"]
