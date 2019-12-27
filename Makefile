build :
	docker build . --tag docker-ubuntu-cv:$(shell git rev-parse --short HEAD)
clean :
	docker system prune --filter label=docker-ubuntu-cv
run : build
	docker run -it -p 5901:5901 -p 6901:6901 docker-ubuntu-cv:$(shell git rev-parse --short HEAD)
