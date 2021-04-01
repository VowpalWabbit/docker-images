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

1. Navigate to [workflow](https://github.com/VowpalWabbit/docker-images/actions/workflows/build_deploy_release.yml)
2. Click `Run workflow`
3. Enter the tag to build and submit
