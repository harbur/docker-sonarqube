# Table of Contents

# Introduction

Dockerfile to build a SonarQube container image.

## Version

Current Version: **5.6**

# Dependencies

Before you start, you need to make sure you have the following dependencies installed:

* [Install Docker](http://docs.docker.com/installation/)
* [Install Docker Compose](http://docs.docker.com/compose/install/)

Now you can verify that the installation is ok with the following commands:

<pre>
docker version
docker-compose --version
</pre>

# Reporting Issues

If you have any issues you can report them on the [issues](https://github.com/harbur/docker-sonarqube/issues) page.

In your report please make sure to add:

- Output of the `docker version` command
- The exact `docker run` or `docker-compose` command you used (mask any sensitive info)

# Installation

Pull the image from the docker index. This is the recommended method of installation as it is easier to update image in the future. These builds are performed by the Trusted Build service.

```bash
docker pull harbur/sonarqube:latest
```

The image builds are being tagged. You can pull a particular version of SonarQube by specifying the version number. For example,

```bash
docker pull harbur/sonarqube:5.6
```

Alternately you can build the image yourself if you run 5.6.

```bash
git clone https://github.com/harbur/docker-sonarqube.git
cd docker-sonarqube
docker build --tag="$USER/sonarqube" .
```

# Quick Start

Run the SonarQube with Docker Compose. Docker Compose uses a `docker-compose.yml` file that describes the environment.

```bash
git clone https://github.com/harbur/docker-sonarqube.git
cd docker-sonarqube
docker-compose up
```

**NOTE**: It will build Sonar 5.6 container. If you want to run pre build 5.1, please edit the docker-compose.yml accordingly.

**NOTE**: Please allow a minute or two for the SonarQube application to start.

On another console run:

```bash
make port
```

Point your browser to the given URL and login using the default username and password:

* username: **admin**
* password: **admin**

You should now have the SonarQube application up and ready for testing. If you want to use this image in production the please read on.

# Configuration

## Database

SonarQube uses PostgreSQL database backend to store its data. Database is launched as separate container and the linking is handled by Docker Compose.

The DB container is configured to create automatically the user and the database. The user credentials, database name and the database hostname are all injected to the SonarQube container by docker-compose using environment variables and container links.

The SonarQube container does **not** contain database by itself, there is no simple-container scenario. It needs to run with `docker-compose` commands (or you can craft manually the `docker` commands). This makes it a lot more portable, and follows the [Single Responsibility Principle](http://en.wikipedia.org/wiki/Single_responsibility_principle) and aligns well with the [Service-oriented Architecture](http://en.wikipedia.org/wiki/Service-oriented_architecture) design pattern.
This works seamlessly in the simple-host / multi-container scenario.
The multi-host / multi-container scenario is explained later on.

The database used is `orchardup/postgresql` and uses a Volume to store the database (`/var/lib/postgresql`) separately from the container instance.

## Data Store

The Postgresql database container is configured to persist data inside a Volume: `/var/lib/postgresql`.

If you want to mount the volume locally, you can append the following lines at the `docker-compose.yml` inside the `postgres` section:

**NOTE**: If you mount the volume locally, you'll singularize your setup, making all instances point to the same directory, safe if you want only one SonarQube instance.

```
  volumes:
    - /opt/db/sonarqube/:/var/lib/postgresql
```

# Connect with a PostgreSQL client

In order to connect to the database you can do the following:

```bash
docker-compose up -d postgresql
docker-compose run postgresql bash -c 'PGPASSWORD=$POSTGRESQL_PASS psql -h $POSTGRESQL_1_PORT_5432_TCP_ADDR $POSTGRESQL_DB $POSTGRESQL_USER'
```

This will launch the database of PostgreSQL (first command) and then connect to the database with a client (second command). The containers are linked together automatically by `docker-compose` and the variables are used to pass the connection info.

# Shell Access

For debugging and maintenance purposes you may want access the container shell. Since the container does not include a SSH server, you can use the [nsenter](http://man7.org/linux/man-pages/man1/nsenter.1.html) linux tool (part of the util-linux package) to access the container shell.

Some linux distros (e.g. ubuntu) use older versions of the util-linux which do not include the `nsenter` tool. To get around this @jpetazzo has created a nice docker image that allows you to install the `nsenter` utility and a helper script named `docker-enter` on these distros.

To install the nsenter tool on your host execute the following command.

```bash
docker run --rm -v /usr/local/bin:/target jpetazzo/nsenter
```

Now you can access the container shells using the following commands

```bash
sudo docker-enter dockersonarqube_sonarqube_1
sudo docker-enter dockersonarqube_postgresql_1
```

For more information refer https://github.com/jpetazzo/nsenter

Another tool named `nsinit` can also be used for the same purpose. Please refer https://jpetazzo.github.io/2014/03/23/lxc-attach-nsinit-nsenter-docker-0-9/ for more information.

## References

  * http://www.sonarqube.org/
  * http://docs.codehaus.org/display/SONAR/Browsing+SonarQube
  * http://docs.codehaus.org/display/SONAR/Setup+and+Upgrade

## Credits

Inspired by [docker-gitlab](https://github.com/sameersbn/docker-gitlab) and [docker-redmine](https://github.com/sameersbn/docker-redmine)

## License

docker-sonarqube is available under the MIT license.

Copyright © 2014-2015 [Harbur.io](https://harbur.io)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
