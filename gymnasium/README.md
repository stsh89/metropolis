# Gymnasium
Data storage module written in [Phoenix](https://www.phoenixframework.org/).

## Historical details
Project was generated using following command:
```
mix phx.new gymnasium
```

## Install
```
cargo install rtx-cli
mix escript.install hex protobuf
sudo apt install unzip libncurses5-dev inotify-tools
rtx install erlang@26.0.2
rtx install elixir@1.15.4
```

## Build gRPC libs
```
mix protobuf.compile
```

## Database setup
```
export PG_PASS=your_database_password
mix ecto.create
mix ecto.migrate
mix run priv/repo/seeds.exs
```

## Serve
```
mix phx.server
```

## Run tests
```
mix test
```

## Documentation
Generate:
```
mix docs
```

And serve:
```
python3 -m http.server 8001 --directory doc
```

## Phoenix framework overview
To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

### Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
