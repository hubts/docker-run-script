<h1>
    <p align="center">🐳 Run Node on Docker Container</p>
</h1>

## 🛫 Outline

**You can easily build images and deploy it into docker container through a script. The script automatically
reads the name and version of your application, and creates an image.**

Why? You created a new version of the output in your project. The following steps should be performed to place the output into docker container:

1. Shutdown the previously running container.
2. If it has the same container name, delete the container.
3. Clean up the previously used image.
4. Set the image name and tag to build a new image.
5. Fill in the command to build and deploy the image.

This script is simple, but it is taking your place. If you need to start a project quickly, this simple script will make your container deployment easier.

## 🥲 Prerequisites

1. You should be able to use `git` command from [here](https://git-scm.com).
2. You should be able to use `node` command from [here](https://nodejs.org/en).
3. You should be able to use `docker` command from [here](https://docs.docker.com/get-docker/).

## 🔥 Usage & Description

Firstly, copy the run script _run.sh_ and generate _Dockerfile_ in your project to deploy (or you can use the existing _Dockerfile_ example we provide).

If both files are ready, add the script below to your _package.json_:

```bash
"scripts": {
    "...": "...",
    "deploy": "./script/run.sh"
}
```

Now you can use this command to run the script:

```bash
$ yarn deploy
```

When `run.sh` script is executed, the following processes are executed sequentially:

1. Print your current branch
2. Extract the name and version of your application
3. Build a new image
4. Terminate the previous container with the same name
5. Export environment variables
6. Run a new container
7. Cleanup the legacy images (the images with older version)
8. Cleanup the dangling images (including other images)

The most important part is to customize the run command that is appropriate for your project framework or configuration. Other processes can be used universally, but the run command must be modified to suit your project.

**Therefore, you must re-write the run command, and can modify the _run.sh_ script to omit some non-essential processes.**

## 🌈 Examples

-   Run NestJS in [here](./nestjs/).
