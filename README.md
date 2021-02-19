# CI Docker Images

This repo contains the dockerfiles used to generate images used for CI, as well as a development image. They are automatically built through GitHub Actions.

## Status

| Image | Docker Repository | Status |
|---|---|---|
| Ubuntu 16.04 | [vowpalwabbit/ubuntu1604-build](https://hub.docker.com/r/vowpalwabbit/ubuntu1604-build) | [![Build and deploy to DockerHub](https://github.com/VowpalWabbit/docker-images/workflows/Build%20and%20deploy%20to%20DockerHub/badge.svg?branch=master&event=push)](https://github.com/VowpalWabbit/docker-images/actions?query=workflow%3A%22Build+and+deploy+to+DockerHub%22) |
| Ubuntu 14.04 | [vowpalwabbit/ubuntu1404-build](https://hub.docker.com/r/vowpalwabbit/ubuntu1404-build) | [![Build and deploy to DockerHub](https://github.com/VowpalWabbit/docker-images/workflows/Build%20and%20deploy%20to%20DockerHub/badge.svg?branch=master&event=push)](https://github.com/VowpalWabbit/docker-images/actions?query=workflow%3A%22Build+and+deploy+to+DockerHub%22) |
| CentOS 7.6.1810 | [vowpalwabbit/centos7_6_1810-build](https://hub.docker.com/r/vowpalwabbit/centos7_6_1810-build)  | [![Build and deploy to DockerHub](https://github.com/VowpalWabbit/docker-images/workflows/Build%20and%20deploy%20to%20DockerHub/badge.svg?branch=master&event=push)](https://github.com/VowpalWabbit/docker-images/actions?query=workflow%3A%22Build+and+deploy+to+DockerHub%22) |
| RL Ubuntu 16.04 | [vowpalwabbit/rl-ubuntu-1604](https://hub.docker.com/r/vowpalwabbit/rl-ubuntu-1604)  | [![Build and deploy to DockerHub](https://github.com/VowpalWabbit/docker-images/workflows/Build%20and%20deploy%20to%20DockerHub/badge.svg?branch=master&event=push)](https://github.com/VowpalWabbit/docker-images/actions?query=workflow%3A%22Build+and+deploy+to+DockerHub%22) |
| Dev Ubuntu 16.04 | [vowpalwabbit/all-dev-ubuntu1604](https://hub.docker.com/r/vowpalwabbit/all-dev-ubuntu1604) | [![Build and deploy to DockerHub](https://github.com/VowpalWabbit/docker-images/workflows/Build%20and%20deploy%20to%20DockerHub/badge.svg?branch=master&event=push)](https://github.com/VowpalWabbit/docker-images/actions?query=workflow%3A%22Build+and+deploy+to+DockerHub%22) |
| Rel Alpine | [vowpalwabbit/vw-rel-alpine](https://hub.docker.com/r/vowpalwabbit/vw-rel-alpine) | ![Build and deploy vw image to DockerHub](https://github.com/VowpalWabbit/docker-images/workflows/Build%20and%20deploy%20vw%20image%20to%20DockerHub/badge.svg) |

## Release steps

1. [Generate token](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) with `workflow` permissions.
2. Update tag to appropriate value.

```sh
SECRET_TOKEN=my_secret_token
TAG=0.8.8
curl -H "Accept: application/vnd.github.everest-preview+json" \
    -H "Authorization: token $SECRET_TOKEN" \
    --request POST \
    --data '{"event_type": "push-image", "client_payload": { "tag": "$TAG"}}' \
    https://api.github.com/repos/VowpalWabbit/docker-images/dispatches
```
