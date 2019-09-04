FROM node:10.9
ENV NODE_ROOT /usr/src/app/

RUN mkdir -p $NODE_ROOT
WORKDIR $NODE_ROOT
COPY . .

RUN npm install -g @angular/cli
RUN npm install

EXPOSE 4200 4915
