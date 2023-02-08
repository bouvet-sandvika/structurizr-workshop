.PHONY: default
default: diagram

.PHONY: diagram
diagram:
	docker run -it --rm -p 8080:8080 -v $(shell pwd)/oda:/usr/local/structurizr structurizr/lite