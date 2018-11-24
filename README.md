VersaTeach test docker environment:

It is important to maintain the versateach folder with the
Dockerfile to make sure that the folder is mounted to the
Docker container. Failure to do so will result to the folder
not being shared between the host machine and the Docker
container. This container will also download Maven and Spring
so that it is easy to create REST services.

Prerequisites:
    You need to download Docker for your operating system.

    Windows:
        https://docs.docker.com/docker-for-windows/install/

    Mac:
        https://docs.docker.com/docker-for-mac/install/

    Linux:
        Depending on your distro, might have to run different
        commands.

Instructions to build:
    There is a Makefile located in the top directory of this
    project. It contains a target called `build`. To create
    the `versateach` Docker image, run:
        make build

Instructions to run:
    After a successful build, run:
        make run

    Inside the Docker container terminal, run:
        cd versateach/

    * To run the example app from Spring's introduction guide:
      run:
        mvn spring-boot:run

    * Go to localhost:8080 on your browser or use the curl command.
      You should see a json text.