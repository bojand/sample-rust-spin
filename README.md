# sample-rust-spin
Sample DigitalOcean App Platform app in Rust using Spin WebAssembly framework

Sample DigitalOcean [App Platform](https://www.digitalocean.com/products/app-platform/) application in Rust using [Spin](https://github.com/fermyon/spin) framework.

[![Deploy to DO](https://www.deploytodo.com/do-btn-blue.svg)](https://cloud.digitalocean.com/apps/new?repo=https://github.com/bojand/sample-rust-spin/tree/main)

Uses [cargo-build-deps](https://crates.io/crates/cargo-build-deps) crate to help speed up builds by building the dependences in a separate layer that's cached and reused on subsequent builds when only the application source code changes. 

Happy hacking!