FROM node

EXPOSE 3000

COPY app /app
WORKDIR /app
RUN npm install

ENTRYPOINT ["node", "/app/index.js"]
