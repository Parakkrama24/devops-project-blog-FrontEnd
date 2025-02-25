FROM node:22-alpine

WORKDIR /app

copy package.json .

RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "run", "dev", "--", "--host"]
