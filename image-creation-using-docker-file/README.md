# Image creation using a Dockerfile

## Clone this repo or create the index.js and create Dockerfile as in current directory

Let’s build our first image out of this Dockerfile, we will name it hello:v0.1

```bash
#!/bin/bash
docker image build -t hello:v0.1 .
```

-t - target

hello:v0.1 - hello is the image name, and v0.1 is the tag or version of the image

You may miss the .(dot in the end), which means current path for image build

ERROR / HELP TEXT if you miss dot(.) :

"docker build" requires exactly 1 argument(s).
See 'docker build --help'
