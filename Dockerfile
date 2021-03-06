FROM node:12-alpine as builder

# Create app directory
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

ARG ARG_GRAPHQL_ENDPOINT=http://localhost:4000/graphql
ARG ARG_AUTHENTICATION_ENABLE=true
ARG ARG_AUTH_CLIENT_ID=6f4fcdb2-5792-4e17-bbdc-14ac0cf78496
ARG ARG_AUTH_TENANT_ID=22e3aada-5a09-4e2b-9e0e-dc4f02328b29
ARG ARG_AUTH_API_SCOPE=api://869e0dc2-907e-45fe-841f-34cc93beee63/.default
ARG ARG_AUTH_REDIRECT_URI=http://localhost:3000

ENV REACT_APP_GRAPHQL_ENDPOINT=${GRAPHQL_ENDPOINT_ARG}
ENV REACT_APP_AUTHENTICATION_ENABLE=${ARG_AUTHENTICATION_ENABLE}
ENV REACT_APP_AUTH_CLIENT_ID=${ARG_AUTH_CLIENT_ID}
ENV REACT_APP_AUTH_TENANT_ID=${ARG_AUTH_TENANT_ID}
ENV REACT_APP_AUTH_API_SCOPE=${ARG_AUTH_API_SCOPE}
ENV REACT_APP_AUTH_REDIRECT_URI=${ARG_AUTH_REDIRECT_URI}
# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm install

# Everything for now
COPY . .

RUN npm run-script build

FROM nginx:alpine as production-build
COPY ./.nginx/nginx.conf /etc/nginx/nginx.conf

## Remove default nginx index page
RUN rm -rf /usr/share/nginx/html/*

# Copy from the stage 1
COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]
