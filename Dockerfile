FROM node:0.10.38
MAINTAINER Stefan Dimitrov <stefan@dimitrov.li>

ADD . /app
WORKDIR /app
RUN npm install
RUN apt-get update

# install vim, git & heroku cli
RUN apt-get install -y software-properties-common apt-transport-https
RUN add-apt-repository "deb https://cli-assets.heroku.com/branches/stable/apt ./"
RUN curl -L https://cli-assets.heroku.com/apt/release.key | apt-key add -
RUN apt-get update
RUN apt-get install -y vim git heroku

# install docker-cli
RUN wget https://get.docker.com/builds/Linux/x86_64/docker-1.12.5.tgz
RUN tar xzvf docker-1.12.5.tgz
RUN rm -f docker-1.12.5.tgz
RUN cp docker/docker /usr/local/bin/
RUM rm -rf docker/

EXPOSE 3000

ENTRYPOINT ["node"]
CMD ["app.js", "-p", "3000"]
