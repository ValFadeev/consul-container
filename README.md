# Consul

[![Docker Stars](https://img.shields.io/docker/stars/beyondrepair/consul-container.svg)](https://hub.docker.com/r/beyondrepair/consul-container)
[![Docker Pulls](https://img.shields.io/docker/pulls/beyondrepair/consul-container.svg)](https://hub.docker.com/r/beyondrepair/consul-container)

## Contents

 * runs Consul process under [dumb-init](https://github.com/Yelp/dumb-init) as a non-root user with the possibity of mapping to an existing user id on host via `CONSUL_UID` environment variable (inspired by [this article](https://denibertovic.com/posts/handling-permissions-with-docker-volumes/));
 * ships with `curl` and [monitoring-plugins](https://www.monitoring-plugins.org/) to use in health checks, as well as [jq](https://stedolan.github.io/jq/) and [consul-cli](https://github.com/mantl/consul-cli) to use in handlers;

## Usage

### Development

```
docker run -it --rm \
           --name consul \
           -p 8500:8500 \
           beyondrepair/consul-container
```

### Custom configuration

```
docker run -it --rm \
           --name consul \
           -v /path/to/config/:/config \
           -p 8500:8500 \
           beyondrepair/consul
```

### Custom user

Assuming `/path/to/config` is readable by host user with id `9001`

```
docker run -it --rm \
           --name consul \
           -v /path/to/config/:/config \
           -e CONSUL_UID=9001 \
           -p 8500:8500 \
           beyondrepair/consul
```
