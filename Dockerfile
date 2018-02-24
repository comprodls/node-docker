# Specify the official docker image for the latest long term support (LTS) release. 
# Use a specific version, rather than node:latest, so avoid risking an accidental upgrades
FROM node:6.11.1

# Create an unprivileged user,called dls, to run the app inside the container. If you don’t do this, then the container will run as root, security principles. 
# Install a more recent version of NPM, get npm has improvement a lot recently. Again, specify an exact version to avoid accidental upgrades.
RUN useradd --user-group --create-home --shell /bin/false dls &&\
  npm install --global npm@3.10.10

# Setup $HOME
ENV HOME=/home/dls

# Copy application folder/files on the host into $HOME/auth.
COPY package.json index.js $HOME/auth/

#Files copied into the container with the COPY command will be owned by root. So, we chown them to dls after copying.
RUN chown -R dls:dls $HOME/*

# Change user and working directory
USER dls
WORKDIR $HOME/dls

# Finally, at the end to run npm install. This will run as the dls user and install the dependencies in $HOME/chat/node_modules 
RUN npm install

# Bypass the package.json's start command and bake it directly into the image itself. This reduces the number of processes running inside of your container
# Secondly it causes exit signals such as SIGTERM and SIGINT to be received by the Node.js process instead of npm swallowing them.
CMD ["node","index.js"]
  
