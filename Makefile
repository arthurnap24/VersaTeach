image = versateach
container = $(image)
bash = /bin/bash
dir_host = .
dir_container = /versateach
tomcat_server = /usr/libexec/tomcat/server

# Remove intermediate containers after successful build.
build:
	docker build --rm --tag $(image) .

# Run the Docker container and set /versateach/ dir as urrent working directory.
run:
	docker run -it --privileged -p 8080:8080 -v $(shell pwd):$(dir_container) $(container) $(bash)

tomcat_start:
	$(tomcat_server) start &