FROM node:18

# create the app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package*.json ./
RUN npm install

# copy application code
COPY . .

# expose the application port
EXPOSE 3000

# start up the application
CMD ["npm", "start"]




