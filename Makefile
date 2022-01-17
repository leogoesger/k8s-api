build-go:
	go build -o ./tmp/api ./app/api/main.go

tidy:
	go mod tidy
	go mod vendor

build: 
	docker-compose build

run: build
	docker-compose up -d; \
	docker-compose logs -f go_api