VERSION := 1.0

build-go:
	go build -o ./tmp/api ./app/api/main.go

tidy:
	go mod tidy
	go mod vendor

build:
	docker build \
		-f zarf/docker/Dockerfile \
		-t k8s-api:$(VERSION) \
		--build-arg BUILD_REF=$(VERSION) \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		.

run:
	docker-compose -f ./zarf/docker/docker-compose.yml up -d; \
	docker-compose -f ./zarf/docker/docker-compose.yml logs -f go_api

clean:
	docker-compose -f ./zarf/docker/docker-compose.yml down -v --remove-orphans

# ==============================================================================
# Running from within k8s/kind

KIND_CLUSTER := k8s-cluster

kind-up:
	kind create cluster \
		--image kindest/node:v1.23.1 \
		--name $(KIND_CLUSTER) \
		--config zarf/k8s/kind/kind-config.yml

kind-down:
	kind delete cluster --name $(KIND_CLUSTER)

kind-load:
	kind load docker-image k8s-api:$(VERSION) --name $(KIND_CLUSTER)

kind-services:
	kustomize build zarf/k8s/kind | kubectl apply -f -

kind-logs:
	kubectl logs -lapp=k8s-api --all-containers=true -f

kind-status:
	kubectl get nodes
	kubectl get pods

kind-status-full:
	kubectl describe pod -lapp=k8s-api

kind-rebuild: build kind-load
	kubectl delete pods -lapp=k8s-api
