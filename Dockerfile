ARG NODE_VERSION
FROM node:${NODE_VERSION}

WORKDIR /usr/src/app
RUN apk add --no-cache tini

COPY node/package*.json ./
RUN npm install

COPY node ./

USER node
ENTRYPOINT [ "/sbin/tini", "--" ]
CMD [ "node", "src/index.js" ]



ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Washing Machine Tweeter" \
      org.label-schema.description="Node app that collects stats on washes and tweets about them." \
      org.label-schema.version=$VERSION \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/alexswilliams/washing-machine-tweeter" \
      org.label-schema.schema-version="1.0" \
      node-version=$NODE_VERSION
