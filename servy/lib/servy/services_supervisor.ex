defmodule Servy.ServicesSupervisor do
  use Supervisor

  @doc """
    Restart Strategies and Other Supervisor Options

    In the video, we initialized both supervisors with the :one_for_one restart strategy, like so

        Supervisor.init(children, strategy: :one_for_one)

    Here's a quick summary of all the restart strategies:
      - :one_for_one means if a child process terminates, only that process is restarted. None of the other child processes being supervised are affected.

      - :one_for_all means if any child process terminates, the supervisor will terminate all the other children. All the child processes are then restarted. You'll typically use this strategy if all the child processes depend on each other and should therefore have their fates tied together.

      - :rest_for_one means if a child process terminates, the rest of the child processes that were started after it (those children listed after the terminated child) are terminated as well. The terminated child process and the rest of the child processes are then restarted.

      - :simple_one_for_one is intended for situations where you need to dynamically attach children. This strategy is restricted to cases when the supervisor only has one child specification. Using this specification as a recipe, the supervisor can dynamically spawn multiple child processes that are then attached to the supervisor. You would use this strategy if you needed to create a pool of similar worker processes, for example.

    In addition to the strategy option, you can also initialize a supervisor with the following other options:
      - :max_restarts indicates the maximum number of restarts allowed within a specific time frame. After this threshold is met, the supervisor gives up. This is used to prevent infinite restarts. The default is 3 restarts.

      - :max_seconds indicates the time frame in which :max_restarts applies. The default is 5 seconds.

    def child_spec(args) do
      %{
        id: Servy.ServicesSupervisor,
        start: {Servy.ServicesSupervisor, :start_link, [[]]},
        restart: :permanent,
        type: :supervisor
      }
    end
  """

  def start_link(_args) do
    IO.puts("Starting the services supervisor...")
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      Servy.PledgeServer,
      {Servy.SensorServer, 60},
      Servy.FourOhFourCounter
    ]

    # [strategy: :one_for_one, max_restarts: 5, max_seconds: 10]
    options = [strategy: :one_for_one]

    Supervisor.init(children, options)
  end
end
