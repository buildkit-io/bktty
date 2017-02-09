bktty = BuildKit + tty (based on Wetty: https://github.com/krishnasrinivas/wetty)
-----------------

Terminal over HTTP and HTTPS. Bktty is a fork of Wetty which is an alternative 
to ajaxterm/anyterm but much better than them because wetty uses ChromeOS'
terminal emulator (hterm) which is a full fledged implementation of
terminal emulation written entirely in Javascript. Also it uses
websockets instead of Ajax and hence better response time.

Differences between bktty and wetty:
- bktty logs you as current user automatically, wetty allows you to login
- bktty lets you drop into a Docker container shell, wetty lets you ssh
- the bktty Docker image includes git, Docker-cli & Heroku cli 

hterm source - https://chromium.googlesource.com/apps/libapps/+/master/hterm/

![Wetty](/terminal.png?raw=true)

Dockerized Version
------------------

This repo includes a Dockerfile you can use to run a Dockerized version of bktty.
You can run node.js, git, vim or manage other Docker containers. You can even
push to Heroku.

Just do:

```
    docker run --name term -p 3000 -dt buildkit/bktty -v /var/run/docker.sock:/var/run/docker.sock
```

Visit the appropriate URL in your browser (`[localhost|$(boot2docker ip)]:PORT`).


Install
-------

*  `git clone https://github.com/buildkit-io/bktty`

*  `cd bktty`

*  `npm install`

Run on HTTP:
-----------

    node app.js -p 3000

By default it will launch `/bin/bash` as the user you run it with.

If instead you wish to get a shell in a docker container, specify the container
name in the address bar like this:

  `http://yourserver:3000/wetty/docker/<container_name>`
  
Make sure you have docker-cli installed, /var/run/docker.sock exists and the
user running app.js has permissions to access Docker.

Run on HTTPS:
------------

Always use HTTPS! If you don't have SSL certificates from a CA you can
create a self signed certificate using this command:

  `openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 30000 -nodes`

And then run:

    node app.js --sslkey key.pem --sslcert cert.pem -p 3000

Run bktty behind nginx:
----------------------

Put the following configuration in nginx's conf:

    location /wetty {
	    proxy_pass http://127.0.0.1:3000/wetty;
	    proxy_http_version 1.1;
	    proxy_set_header Upgrade $http_upgrade;
	    proxy_set_header Connection "upgrade";
	    proxy_read_timeout 43200000;

	    proxy_set_header X-Real-IP $remote_addr;
	    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
	    proxy_set_header Host $http_host;
	    proxy_set_header X-NginX-Proxy true;
    }

If you want to get a shell on the host running app.js use:

    http://yourserver.com/wetty

Else if you want to get a shell in a Docker container use:

    http://yourserver.com/wetty/docker/<username>

**Note that if your Nginx is configured for HTTPS you should run bktty without SSL.**
