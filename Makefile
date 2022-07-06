.PHONY: build test shell clean

build:
	docker build -t postal .

test:
	docker run --rm -v "${PWD}/test":/tmp postal address.csv

shell:
	docker run --rm -it --entrypoint=/bin/bash -v "${PWD}/test":/tmp postal

clean:
	docker system prune -f