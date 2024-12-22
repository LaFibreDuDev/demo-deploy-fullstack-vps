FROM node:20-alpine
RUN mkdir -p home/node-traefik
WORKDIR /home/node-traefik
RUN npm install --production
COPY . .
RUN npm run db:reset || echo "Skipping db:reset"
EXPOSE 3000
CMD [ "npm", "run", "start" ]