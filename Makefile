GOLANGCI_LINT_VERSION:=v2.2.1
MOCKGEN_VERSION:=v0.5.2

.PHONY: mockgen
mockgen:
	go install go.uber.org/mock/mockgen@${MOCKGEN_VERSION}
	mockgen -source=openfeature/provider.go -destination=openfeature/provider_mock.go -package=openfeature -build_constraint=testtools
	mockgen -source=openfeature/hooks.go -destination=openfeature/hooks_mock.go -package=openfeature -build_constraint=testtools
	mockgen -source=openfeature/interfaces.go -destination=openfeature/interfaces_mock.go -package=openfeature -build_constraint=testtools

.PHONY: test
test:
	go test --short -tags testtools -cover -timeout 1m ./...

.PHONY: e2e-test
e2e-test:
	git submodule update --init --recursive && go test -tags testtools -race -cover -timeout 1m ./e2e/...

.PHONY: lint
lint:
	go run github.com/golangci/golangci-lint/v2/cmd/golangci-lint@$(GOLANGCI_LINT_VERSION) run ./...

.PHONY: fix
fix:
	go run github.com/golangci/golangci-lint/v2/cmd/golangci-lint@$(GOLANGCI_LINT_VERSION) run ./... --fix

.PHONY: docs
docs:
	go run golang.org/x/pkgsite/cmd/pkgsite@latest -open .
