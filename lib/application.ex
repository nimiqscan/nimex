defmodule Nimex.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(Nimex.Reward, [])
    ]

    opts = [strategy: :one_for_one, name: Nimex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
