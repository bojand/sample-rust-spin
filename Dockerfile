FROM rust:1.61.0-buster as base
WORKDIR /app
RUN rustup target add wasm32-wasi
RUN wget https://github.com/fermyon/spin/releases/download/v0.1.0/spin-v0.1.0-linux-amd64.tar.gz
RUN tar -zxf spin-v0.1.0-linux-amd64.tar.gz

FROM base as builder
WORKDIR /app
COPY Cargo.toml Cargo.lock spin.toml /app/
COPY src /app/src
RUN cargo build --target wasm32-wasi --release

FROM debian:buster-slim as runtime
WORKDIR /app
COPY --from=base /app/spin /usr/local/spin
COPY --from=builder /app/target/wasm32-wasi/release/sample_rust_spin.wasm /app/sample_rust_spin.wasm
COPY --from=builder /app/spin.toml /app/spin.toml
ENTRYPOINT ["spin", "up", "--listen", "0.0.0.0:8080"]