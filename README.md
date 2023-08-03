# Metropolis
Highly specialized Architecture Design and Documentation Tool.

## Theater
Client application based on the Ruby on Rails framework.

Command that was used to generate the initial application:
```
rails new . --skip-active-record --skip-jbuilder --skip-test
```

### Install
```
cargo install rtx-cli
sudo apt install zlib1g-dev libyaml-dev libssl-dev
rtx install ruby@3.2.2
```

### Serve
```
./theater/bin/rails s
```

### Run tests
```
./theater/bin/rake -C ./theater spec
```

### Build gRPC libs
```
./theater/bin/rake -C ./theater grpc:build
```

## Gymnasium
Datastore based on the Phoenix framework.

Command that was used to generate the initial application:
```
rails new . --skip-active-record --skip-jbuilder --skip-test
```

### Install
```
cargo install rtx-cli
mix escript.install hex protobuf
sudo apt install unzip libncurses5-dev inotify-tools
rtx install erlang@26.0.2
rtx install elixir@1.15.4
```

### Database setup
```
export PG_PASS=your_database_password
mix ecto.create
```

### Serve
```
mix phx.server
```

### Run tests
```
./theater/bin/rake -C ./theater spec
```

### Build gRPC libs
```
protoc --elixir_out=plugins=grpc:./lib --proto_path=../proto/gymnasium/ ../proto/gymnasium/projects.proto
```

### Seed database
```
mix run priv/repo/seeds.exs
```

## Docs

### Install
```
cargo install mdbook
cargo install mdbook-mermaid
```

### Serve
```
mdbook serve ./docs -p 8000 -n 127.0.0.1
```

## Temple

### Install
```
sudo apt install protobuf-compiler libprotobuf-dev
```

### Serve
```
cargo run --manifest-path ./temple/Cargo.toml
```

## Config

### Generate Local Config
```
./config/bin/generate local
```
