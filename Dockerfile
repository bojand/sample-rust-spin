FROM rust:1.60 as base
WORKDIR /app
RUN cargo install cargo-build-deps
RUN wget https://github.com/fermyon/spin/releases/download/v0.1.0/spin-v0.1.0-linux-amd64.tar.gz
RUN tar -zxf spin-v0.1.0-linux-amd64.tar.gz

FROM base as builder
WORKDIR /app
COPY Cargo.toml Cargo.lock /app/
RUN cargo build-deps --release
COPY src /app/src
RUN cargo build --target wasm32-wasi --release

FROM debian:buster-slim as runtime
WORKDIR /app
COPY --from=base /app/spin /usr/local/spin
COPY --from=builder /app/target/wasm32-wasi/release/sample-rust-spin.wasm /app/sample-rust-spin.wasm
ENTRYPOINT ["spin", "up", "--listen", "0.0.0.0:80"]