### Docker file without stages.

FROM node:18
WORKDIR /app

COPY . .
RUN npm install
CMD ["node", "server.js"]
EXPOSE 3000