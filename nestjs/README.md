<h1>
    <p align="center">Running NestJS in Docker container</p>
</h1>

## Setting Example

This NestJS project was created by a boilerplate provided by [Nest](https://nestjs.com) with the following command:

```bash
$ nest new nestjs # 'nestjs' can be replaced by the project name what you want
```

We generated a script file _script/run.sh_ and _Dockerfile_ in this project. Moreover, we set environment variables in _.env_ file to use in container execution. In this example, a variable `PORT` is used to an exported port number of server.

### Dockerfile

> You can pass this section by copying a script only if you want to write _Dockerfile_ by yourself.

This is an example _Dockerfile_ for your understanding.

```bash
# Builder
FROM node:16.18 AS builder
WORKDIR /build

COPY    package.json yarn.lock ./
COPY    nest-cli.json tsconfig.build.json tsconfig.json ./
COPY    src ./src

RUN     yarn install --pure-lockfile --production
RUN     yarn add --dev @nestjs/cli
RUN     yarn build

# Distribute
FROM node:16.18-alpine
LABEL maintainer "@hubts <gtsk623@gmail.com>"
WORKDIR /app

COPY    --from=builder /build/dist          ./dist
COPY    --from=builder /build/package.json  ./package.json
COPY    --from=builder /build/node_modules  ./node_modules

# Run
CMD ["yarn", "start:prod"]
```

Each command is executed sequentially by a script to build a new image.

### Script

See in [_script/run.sh_](./script/run.sh).

If you want to use your docker run command, change a command in the following section:

```bash
###############################################
# (Customize) Here is your docker run command #
###############################################

docker run -dit \
    --name=$APP_NAME \
    --env-file $ENV_FILE \
    -p 8000:$PORT \
    $IMAGE_FULLNAME

###############################################
```

In this example, _.env_ file was exported by the previous command `export_env`, and the environment variables are used to docker run. Furthermore, the exported port number is matched to run.
