# Metropolis
This is a pet project for tracking software data structures and their interactions within a project.

Describe your models, entities, etc., and see how they relate to one another in a diagram (drawn using [mermaid](https://mermaid.js.org/)).

## Tech stack of the app
Metropolis is composed of three main modules:

* Gymnasium - data storage module written in [Phoenix](https://www.phoenixframework.org/).
* Temple - core logic module written in [Rust](https://www.rust-lang.org/).
* Theater - client web application written in [Rails](https://rubyonrails.org/).

See more details in the `.docs` folder or serve it with the [mdbook](https://github.com/rust-lang/mdBook):

```
// Install mdbook
cargo install mdbook

// Install mermaid plugin
cargo install mdbook-mermaid

// Serve documentation folder
mdbook serve ./docs -p 8000 -n 127.0.0.1
```

## Roadmap
* [x] - Diagram data structures
* [ ] - Generate [Postgresql](https://www.postgresql.org/) table migration(s) for Model(s).
* [ ] - Generate programming language code (Rust, Ruby, Elixir) for created Model(s).
* [ ] - Implement the ability to add use cases.
