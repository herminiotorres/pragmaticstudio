# Servy

**Servy - Rebuild Phoenix from Scratch**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `servy` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:servy, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/servy](https://hexdocs.pm/servy).

## Running the Server from the Command Line

In the video we started the server in an `iex` session. You can also start it from the command line using

```shell
& mix run -e "Servy.HttpServer.start(4000)"
```

This runs the given Elixir expression in the context of the application. It also recompiles any files that are out of date.

## Sending POST Requests from the Command Line

In the video we used the Unix `curl` command-line utility to send a request, just to demonstrate that any HTTP client can talk to our server:

```shell
$ curl http://localhost:4000/api/bears
```

In a previous exercise we challenged you to handle a `POST` request to the API endpoint `/api/bears` with a `Content-Type` of `application/json`. Here's how to use the `curl` utility to send a request to that endpoint:

```shell
$ curl -H 'Content-Type: application/json' -XPOST http://localhost:4000/api/bears -d '{"name": "Breezly", "type": "Polar"}'
```

The `-H` option is used to set the `Content-Type` header to `application/json`. The `-X` option sets the request method to `POST`. And the `-d` option sets the request body to the given JSON string representing the bear you want to create.
