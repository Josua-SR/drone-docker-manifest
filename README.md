# Simplified drone manifest plugin for docker images

This project is designed to replace `plugins/manifest` in drone.io pipelines.
It currently supports only the *from-args* variant of *manifest-tool* with platforms, template and target arguments.

## Pros:
- Easy to debug
- Minimal
- can substitute TAG in template

## Cons:
- does **not** support *from-spec* feature of manifest-tool

## Usage:

```
steps:
- name: manifest
  image: container.solid-build.xyz/kube/drone-docker-manifest:v0.1
  settings:
    target: registry.domain/project/image
    template: registry.domain/project/image:TAG-OS-ARCH
    tags:
    - "${DRONE_TAG:-ci}"
    platforms:
    - linux/amd64
    - linux/arm64
    username:
      from_secret: docker_username
    password:
      from_secret: docker_password
```
