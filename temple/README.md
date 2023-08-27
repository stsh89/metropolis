# Temple
Core logic module written in [Rust](https://www.rust-lang.org/).

## Temple structure

* Foundation - the main module that defines all of the available functionality of the application.
* Portal - GRPC gateway.
* Mermaid - module related to generating [mermaid](https://mermaid.js.org/) diagrams.

## Install
Install rust using official instructions [Install Rust](https://www.rust-lang.org/tools/install).

Install needed dependencies:
```
sudo apt install protobuf-compiler libprotobuf-dev
```

## Serve
```
cargo run -- ./portal/config.json.sample
```

## Run tests
```
cargo test
```

## Documentation
Generate:
```
cargo doc
```

And serve:
```
python3 -m http.server 8002 --directory target/doc/
```

## Useful links

* [Style guide](https://doc.rust-lang.org/beta/style-guide/index.html)
