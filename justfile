set shell := ["zsh", "-cu"]

default:
    @just --list


# Contracts

contracts: contracts-install contracts-lint contracts-solhint contracts-fmt-check contracts-build contracts-test contracts-generate-bindings

contracts-install:
    cd contracts && forge soldeer install

contracts-generate-bindings:
    cd contracts && forge bind \
        --select "^(IProtocolAdapter|ProtocolAdapter|VersioningLibExternal)$" \
        --bindings-path ../bindings/src/generated/ \
        --module \
        --overwrite

contracts-lint:
    cd contracts && forge lint --deny warnings

contracts-solhint-install:
    cd contracts && bun install solhint

contracts-solhint: contracts-solhint-src contracts-solhint-test contracts-solhint-script

contracts-solhint-src:
    cd contracts && bunx --bun solhint --config .solhint.json 'src/**/*.sol'

contracts-solhint-test:
    cd contracts && bunx --bun solhint --config .solhint.other.json 'test/**/*.sol'

contracts-solhint-script:
    cd contracts && bunx --bun solhint --config .solhint.other.json 'script/**/*.sol'

contracts-slither:
    cd contracts && slither .

contracts-fmt-check:
    cd contracts && forge fmt --check

contracts-fmt:
    cd contracts && forge fmt

contracts-build:
    cd contracts && forge build

contracts-test:
    cd contracts && forge test -vvv

contracts-clean:
    cd contracts && forge clean

contracts-update:
    cd contracts && forge  update


# Bindings

bindings: bindings-fmt-check bindings-clippy bindings-test

bindings-fmt-check:
    cargo fmt -- --check

bindings-fmt:
    cargo fmt --

bindings-build:
    cargo build

bindings-build-release:
    cargo build --release

bindings-clippy:
    cargo clippy -- -Dwarnings

bindings-clippy-test:
    cargo clippy --tests -- -Dwarnings

bindings-test:
    cargo test

bindings-clean:
    cargo clean


# Workspace

fmt: contracts-fmt bindings-fmt

check: contracts-fmt-check contracts-lint bindings-fmt-check

build: contracts-build bindings-build

test: contracts-test bindings-test

clean: contracts-clean bindings-clean

install: contracts-solhint-install
    cargo fetch

version-foundry:
    @forge --version

version-rust:
    @rustc --version

version-bun:
    @bun --version

version-slither:
    @slither --version || echo "Slither not installed"

version: version-foundry version-rust version-bun version-slither

pre-commit: fmt check test

docs:
    cd contracts && forge doc

docs-serve:
    cd contracts && forge doc --serve --port 3000


