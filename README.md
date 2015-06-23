atlassian-stash
===============

The atlassian-stash container can be used to spin up an instance of
[Atlassian Stash™](https://www.atlassian.com/software/stash).


Quick Start
-----------

To quickly spin up an instance of Atlassian Stash™, simply specify a port
forwarding rule and run the container:

    $ docker run \
        -p 7990:7990 \
        jleight/atlassian-stash

Atlassian Stash™ also exposes SSH access for git operations on port 7999. If you
want to allow git SSH operations, you'll also need to expose port 7999:

    $ docker run \
        -p 7990:7990 \
        -p 7999:7999 \
        jleight/atlassian-stash

Usage
-----

If you want to change the context root of the application (by default the
application listens on `/`) you can follow the instructions in the
[context root](#context-root) section of this document.

If you are not planning on running Atlassian Stash™ behind a reverse proxy, you
can follow the instructions in the [simple](#simple) section. If you plan to use
a reverse proxy, further instructions can be found in the
[reverse proxy](#reverse-proxy) section of this document.

### Simple

Atlassian Stash™ stores instance-specific data inside a folder it defines as the
`STASH_HOME` directory. This container defines the `STASH_HOME` directory as
`/var/opt/atlassian` and exposes it as a volume. As such, it is recommended to
either map this volume to a host directory, or to create a data container for
the volume.

A data container can be created by running the following command:

    $ docker create \
        --name stash-data \
        jleight/atlassian-stash

The application container can then be started by running:

    $ docker run \
        --name stash \
        --volumes-from stash-data \
        -p 7990:7990 \
        -p 7999:7999 \
        jleight/atlassian-stash

### Context Root

If you want to run Atlassian Stash™ under a context root other than `/`, you can
specify an extra environment variable when running the container:

- *TC_ROOTPATH*: the new context root for Atlassian Stash™.

It can be specified in the `docker run` command like this:

    $ docker run \
        --name stash \
        --volumes-from stash-data \
        -p 7990:7990 \
        -p 7999:7999 \
        -e TC_ROOTPATH=/stash \
        jleight/atlassian-stash

Atlassian Stash™ can then be accessed at http://${HOST_IP}:7990/stash.

### Reverse Proxy

If you are using a reverse proxy to proxy connections to Atlassian Stash™, you
will need to specify two extra environment variables when starting this
container.

The variables are as follows:

- *TC_PROXYNAME*: the domain name at which Atlassian Stash™ will be accessible.
- *TC_PROXYPORT*: the port on which Atlassian Stash™ will be accessible.

For example, if you are planning on running Atlassian Stash™ at
https://example.com/stash, you would use the following command:

    $ docker run \
        --name stash \
        --volumes-from stash-data \
        -p 7990:7990 \
        -p 7999:7999 \
        -e TC_PROXYNAME=example.com \
        -e TC_PROXYPORT=443 \
        -e TC_ROOTPATH=/stash \
        jleight/atlassian-stash

Once your proxy server is configured, Atlassian Stash™ should be accessible at
https://example.com/stash.
