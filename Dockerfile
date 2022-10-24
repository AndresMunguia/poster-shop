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