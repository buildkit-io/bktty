FROM node:0.10.38
MAINTAINER Stefan Dimitrov <stefan@dimitrov.li>

ADD . /app
WORKDIR /app
RUN npm install
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository "deb https://cli-assets.heroku.com/branches/stable/apt ./"
RUN curl -L https://cli-assets.heroku.com/apt/release.key | apt-key add -
RUN apt-get update
RUN apt-get install -y vim git heroku

EXPOSE 3000

ENTRYPOINT ["node"]
CMD ["app.js", "-p", "3000"]
