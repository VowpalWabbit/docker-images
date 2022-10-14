# CI Docker Images

This repo contains the dockerfiles used to generate images used for CI, as well as a development image. They are automatically built through GitHub Actions.

Tags on DockerHub correspond to [tags](https://github.com/VowpalWabbit/docker-images/tags) in this repository.

## Status

| Image | Docker Repository | Type |
|---|---|---|
| [Rel Alpine](./vowpal_wabbit/vw-rel-alpine.Dockerfile) | [vowpalwabbit/vw-rel-alpine](https://hub.docker.com/r/vowpalwabbit/vw-rel-alpine) |  Packaged binary |
| [Ubuntu 20.04](./vowpal_wabbit/ubuntu2004-build.Dockerfile) | [vowpalwabbit/ubuntu2004-build](https://hub.docker.com/r/vowpalwabbit/ubuntu2004-build) |  CI |
| [Ubuntu 18.04](./vowpal_wabbit/ubuntu1804-build.Dockerfile) | [vowpalwabbit/ubuntu1804-build](https://hub.docker.com/r/vowpalwabbit/ubuntu1804-build) |  CI |
| [Python ManyLinux 2010](./vowpal_wabbit/manylinux-2010/manylinux2010-build.Dockerfile) | [vowpalwabbit/manylinux2010-build](https://hub.docker.com/r/vowpalwabbit/manylinux2010-build) |  CI/Python packaging |
| [CentOS 7.6.1810](./vowpal_wabbit/centos7_6_1810-build.Dockerfile) | [vowpalwabbit/centos7_6_1810-build](https://hub.docker.com/r/vowpalwabbit/centos7_6_1810-build)  |  CI |
| [RL Ubuntu 18.04](./reinforcement_learning/ubuntu1804-build.Dockerfile) | [vowpalwabbit/rl-ubuntu-1804](https://hub.docker.com/r/vowpalwabbit/rl-ubuntu-1804)  |  CI |
| [RL Python ManyLinux 2010](./reinforcement_learning/manylinux-2010/rlclientlib-manylinux2010-build.Dockerfile) | [vowpalwabbit/rlclientlib-manylinux2010-build](https://hub.docker.com/r/vowpalwabbit/rlclientlib-manylinux2010-build)  |  CI/Python packaging |


## Release steps

### Rel Alpine

These steps are for a VW release.

1. Navigate to [workflow](https://github.com/VowpalWabbit/docker-images/actions/workflows/build_deploy_release.yml)
2. Click `Run workflow`
3. Enter the tag to build and submit

### Other images

These steps are only necessary if a new tagged version of the various CI images are needed.

1. [Create a release](https://github.com/VowpalWabbit/docker-images/releases/new) to automatically create a tag
2. Monitor [build status](https://github.com/VowpalWabbit/docker-images/actions/workflows/build_deploy_latest.yml)
