VERSION=	0.22.0
IMAGE_BASENAME=	step-ca

all: debian

debian:
	docker build \
		-f Dockerfile \
		--build-arg SMALLSTEP_CLI_VERSION=${VERSION} \
		--build-arg SMALLSTEP_CA_VERSION=${VERSION} \
		-t ${IMAGE_BASENAME}:${VERSION}-hsm-debian .
