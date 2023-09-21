FROM --platform=linux/amd64 node:18

# create the app directory
WORKDIR /usr/src/app/ganga

# Install app dependencies
COPY hello-world-node-express/package*.json ./
RUN npm install

# copy application code
COPY hello-world-node-express .

# expose the application port
EXPOSE 3000

# start up the application
CMD ["npm", "start"]

