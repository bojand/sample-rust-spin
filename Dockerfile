FROM rust:1.61.0-buster as builder
WORKDIR /app
RUN rustup target add wasm32-wasi
COPY Cargo.toml Cargo.lock spin.toml /app/
COPY src /app/src/
RUN cargo build --target wasm32-wasi --release

FROM debian:bullseye-slim as runtime-base
RUN apt-get update && apt-get install -y \
    wget
WORKDIR /app
RUN wget https://github.com/fermyon/spin/releases/download/v0.2.0/spin-v0.2.0-linux-amd64.tar.gz
RUN tar -zxf spin-v0.2.0-linux-amd64.tar.gz

FROM runtime-base as runtime
COPY --from=runtime-base /app/spin /usr/local/bin/spin
COPY --from=builder /app/target/wasm32-wasi/release/sample_rust_spin.wasm /app/sample_rust_spin.wasm
COPY --from=builder /app/spin.toml /app/spin.toml
ENTRYPOINT ["spin", "up", "--listen", "0.0.0.0:8080"]