# Specify the official docker image for the latest long term support (LTS) release. 
# Use a specific version, rather than node:latest, so avoid risking an accidental upgrades
FROM node:6.11.1

# Replace this with your application's default port
EXPOSE 5000

# Create an unprivileged user,called dls, to run the app inside the container. If you don’t do this, then the container will run as
# root, security principles. 
# Install a more recent version of NPM, get npm has improvement a lot recently. Again, specify an exact version to avoid 
#accidental upgrades.
RUN useradd --user-group --create-home --shell /bin/false dls &&\
  npm install --global npm@3.10.10

# Setup $HOME
ENV HOME=/home/dls

# Copy application packaging files on the host into $HOME/auth.
# We could COPY the whole application folder, but save some time on our docker builds by only copying in what we need
# at this point, and copying in the rest after we run npm install. This takes better advantage of docker build’s layer caching.
COPY package.json $HOME/auth/

#Files copied into the container with the COPY command will be owned by root. So, we chown them to dls after copying.
RUN chown -R dls:dls $HOME/*

# Change user and working directory
USER dls
WORKDIR $HOME/dls

# Run npm install. This will run as the dls user and install the dependencies in $HOME/chat/node_modules 
RUN npm install

# Finally install the app, by copying in the remaining source files, 
USER root
COPY . $HOME/dls
RUN chown -R dls:dls $HOME/*
USER dls

# Bypass the package.json's start command and bake it directly into the image itself. This reduces the number of processes
# running inside of your container
# Secondly it causes exit signals such as SIGTERM and SIGINT to be received by the Node.js process instead of npm swallowing them.
CMD ["node","index.js"]
  
