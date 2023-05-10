.PHONY: build test shell clean

build:
	docker build --platform="amd64" -t postal_expand .

test:
	docker run --rm -v "${PWD}/test":/tmp postal_expand address.csv
	docker run --rm -v "${PWD}/test":/tmp postal_expand address_stub.csv

shell:
	docker run --rm -it --entrypoint=/bin/bash -v "${PWD}/test":/tmp postal_expand

clean:
	docker system prune -f
