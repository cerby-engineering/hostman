ifdef QUIET
  MAKE_FLAGS += --no-print-directory
  Q := @
else
  Q :=
endif

MODULE=$(shell grep ^module go.mod | awk '{print $$2}')
GOFILES=$(shell find . -type f -name "*.go")
MAJOR := 0
MINOR := 1
PATCH ?= 99999+local-$(shell git rev-parse --abbrev-ref HEAD 2>/dev/null)-$(shell git rev-list --count HEAD 2>/dev/null)-$(shell git rev-parse --short HEAD)
VERSION := $(MAJOR).$(MINOR).$(PATCH)
PATH := $(PATH):$(HOME)/go/bin
SHELL=/bin/bash -euo pipefail
EXECUTABLE=hostman
log = $(if $(QUIET),,$(info $(1)))

$(call log,Entering directory `$(shell pwd)') # '`
$(call log,VERSION: $(VERSION))

all: bin/$(EXECUTABLE)

bin/$(EXECUTABLE): $(GOFILES) go.mod Makefile
	$(Q)export GOOS=darwin && \
	go build -buildvcs=false -ldflags="-X '${MODULE}/consts.Version=$(VERSION)'" -o "$(abspath $@)"
	$(Q)test -f "$(abspath $@)"
	$(Q)chmod +x "$(abspath $@)"

.PHONY: link
link: bin/$(EXECUTABLE) unlink
	ln -s $(shell pwd)/bin/$(EXECUTABLE) ~/.bin/$(EXECUTABLE)

.PHONY: unlink
unlink:
	rm -f ~/.bin/$(EXECUTABLE)

.PHONY: test
test:
	go test ./...

.PHONY: clean
clean:
	rm -rf bin

run: bin/$(EXECUTABLE)
	./bin/$(EXECUTABLE)

.PHONY: version
version:
	@printf $(VERSION)
