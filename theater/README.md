# Theater
Client web application written in [Rails](https://rubyonrails.org/)

## Historical details
Project was generated using following command:
```
rails new . --skip-active-record --skip-jbuilder --skip-test
```

## Install
```
cargo install rtx-cli
sudo apt install zlib1g-dev libyaml-dev libssl-dev
rtx install ruby@3.2.2
```

## Build gRPC libs
```
rake protobuf:compile
```

## Database setup
```
export PG_PASS=your_database_password
mix ecto.create
mix ecto.migrate
mix run priv/repo/seeds.exs
```

## Serve
Start Temple and Gymnasium:
```
foreman start --procfile=./theater/Procfile.deps
```

Serve rails app:
```
rails s
```

## Run tests
```
rake spec
```

## Documentation
Generate:
```
bundle exec yard -o docs
```

And serve:
```
python3 -m http.server 8003 --directory docs
```
