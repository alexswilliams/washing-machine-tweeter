ARG VERSION
FROM node:${VERSION}

WORKDIR /usr/src/app
RUN apk add --no-cache tini

COPY node/package*.json ./
RUN npm install

COPY node ./

USER node
ENTRYPOINT [ "/sbin/tini", "--" ]
CMD [ "node", "src/index.js" ]
