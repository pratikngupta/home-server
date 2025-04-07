FROM node:14

# Set environment variable for qBittorrent host
ENV QBIT_HOST=http://qbittorrent:8080

# Set the working directory
WORKDIR /usr/src/node-app

# Install Git to clone the repo
RUN apt-get update && apt-get install -y git

# Clone the repository
RUN git clone https://github.com/ntoporcov/iQbit.git . 

# Install dependencies
RUN npm install --only=production && npm install --save-dev @types/react-virtualized

# Build and setup server
RUN npm run build && npm run server-setup

# Expose the application port
EXPOSE 8081

# Start the application
CMD ["npm", "run", "server-docker-start"]
