# CI Docker Images

This repo contains the dockerfiles used to generate images used for CI. They are automatically built through DockerHub.

## Status

| Image | Docker Repository | Status | Build Instructions |
|---|---|---|---|
| Ubuntu 16.04 | vowpalwabbit/ubuntu1604-build | <a href="https://hub.docker.com/r/vowpalwabbit/ubuntu1604-build"><img alt="Docker Cloud Build Status" src="https://img.shields.io/docker/cloud/build/vowpalwabbit/ubuntu1604-build"></a> | Automated |
| Ubuntu 14.04 | vowpalwabbit/ubuntu1404-build |<a href="https://hub.docker.com/r/vowpalwabbit/ubuntu1404-build"><img alt="Docker Cloud Build Status" src="https://img.shields.io/docker/cloud/build/vowpalwabbit/ubuntu1404-build"></a>| Automated |
| CentOS 7.6.1810 | vowpalwabbit/centos7_6_1860-build | Manual | [See here](#CentOS-build-instructions) |
| RL Ubuntu 16.04 | vowpalwabbit/rl-ubuntu-1604 | <a href="https://hub.docker.com/r/vowpalwabbit/rl-ubuntu-1604"><img alt="Docker Cloud Build Status" src="https://img.shields.io/docker/cloud/build/vowpalwabbit/rl-ubuntu-1604"></a> | Automated |

### CentOS build instructions
```sh
git clone https://github.com/VowpalWabbit/docker-images.git
cd docker-images/vowpal_wabbit
docker build -t vowpalwabbit/centos7_6_1860-build:<tag> -f centos7_6_1860-build.Dockerfile .
docker login
docker push vowpalwabbit/centos7_6_1860-build:<tag>
```

- To push latest replace `<tag>` with `latest`
- To push a tagged version replace `<tag>` with a tag such as `0.4.0`
