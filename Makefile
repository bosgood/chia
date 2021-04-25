
# Rebuilds the Ignition config for the CoreOS instance
.PHONY: build-os-image
build-os-image:
	@farmer/build.sh

# Rebuilds the Chia farmer Docker image
.PHONY: build-docker-image
build-docker-image:
	@docker build -t bosgood/chia:dev .
