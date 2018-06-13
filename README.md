# Nimex

An Elixir library for communicating with
Nimiq JSON RPC nodes.


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `nimex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:nimex, "~> 0.1.0"}
  ]
end
```

## Usage

RPC_USERNAME=user RPC_PASSWORD=password RPC_HOST=node.somewhere.com:8648 iex -S mix
iex> Nimex.get_block_by_number(1)
