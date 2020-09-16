defmodule Servy.Supervisor do
  use Supervisor

  def start_link do
    IO.puts("Starting THE Supervisor...")
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      Servy.KickStarter,
      Servy.ServicesSupervisor
    ]

    options = [strategy: :one_for_one]

    Supervisor.init(children, options)
  end
end
