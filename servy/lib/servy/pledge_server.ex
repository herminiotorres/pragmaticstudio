defmodule Servy.PledgeServer do
  @name :pledge_server

  use GenServer

  defmodule State do
    defstruct cache_size: 3, pledges: []
  end

  @doc """
    Child Specification Fields

    Here's a quick break-down of the fields in the child specification and what they control:
      - :id
        A name used internally by the supervisor to uniquely identify the child specification.
        This key is always required.
        Default: __MODULE__

      - :start
        A {module, function, args} tuple used to start a child process. This key is always required.
        Default: {__MODULE__, :start_link, [[]]}

      - :restart
        An atom that defines when a terminated child process should be restarted by its supervisor:
        :permanent indicates that the child process is always restarted
        :temporary indicates that the child process is never restarted
        :transient indicates that the child process is restarted only if it terminates abnormally.
        That is, the exit signal reason must be something other than :normal, :shutdown, or {:shutdown, term}.
        Default: :permanent

      - :shutdown
        An atom that defines how a child process should be terminated by its supervisor:
        :brutal_kill indicates that the child process is brutally terminated using
        Process.exit(child_pid, :kill)
        :infinity indicates that the supervisor should wait indefinitely for the child process to terminate
        any integer indicates the amount of time in milliseconds that the supervisor will wait for
        a child process to terminate gracefully after sending it a polite
        Process.exit(child, :shutdown) signal. If no exit signal is received from the child process
        within the specified time, the child process is brutally terminated using
        Process.exit(child_pid, :kill). So the supervisor asks nicely once, then it drops the hammer.
        Default: 5000 if the type is :worker or :infinity if the type is :supervisor.

      - :type
        An atom that indicates if the child process is a :worker or a :supervisor.
        Default: :worker

      def child_spec(args) do
        %{
          id: Servy.PledgeServer,
          start: {Servy.PledgeServer, :start_link, [[]]},
          restart: :permanent,
          shutdown: 5000,
          type: :worker
        }
      end
  """

  # Client Interface

  def start_link(_args) do
    IO.puts("Starting the pledge server...")
    GenServer.start_link(__MODULE__, %State{}, name: @name)
  end

  def create_pledge(name, amount) do
    GenServer.call(@name, {:create_pledge, name, amount})
  end

  def recent_pledges do
    GenServer.call(@name, :recent_pledges)
  end

  def total_pledged do
    GenServer.call(@name, :total_pledged)
  end

  def clear do
    GenServer.cast(@name, :clear)
  end

  def set_cache_size(size) do
    GenServer.cast(@name, {:set_cache_size, size})
  end

  # Server Callbacks

  def init(state) do
    pledges = fetch_recent_pledges_from_service()
    new_state = %{state | pledges: pledges}
    {:ok, new_state}
  end

  def handle_cast(:clear, state) do
    {:noreply, %{state | pledges: []}}
  end

  def handle_cast({:set_cache_size, size}, state) do
    resized_cache = Enum.take(state.pledges, size)
    new_state = %{state | cache_size: size, pledges: resized_cache}
    {:noreply, new_state}
  end

  def handle_call(:total_pledged, _from, state) do
    total = Enum.map(state.pledges, &elem(&1, 1)) |> Enum.sum
    {:reply, total, state}
  end

  def handle_call(:recent_pledges, _from, state) do
    {:reply, state.pledges, state}
  end

  def handle_call({:create_pledge, name, amount}, _from, state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    most_recent_pledges = Enum.take(state.pledges, state.cache_size - 1)
    cached_pledges = [{name, amount} | most_recent_pledges]
    new_state = %{state | pledges: cached_pledges}
    {:reply, id, new_state}
  end

  def handle_info({:stop, _text} = message, state) do
    IO.puts("Can't touch this! #{inspect(message)}")
    {:noreply, state}
  end

  def handle_info(other, state) do
    IO.puts "Unexpected message: #{inspect(other)}"
    {:noreply, state}
  end

  defp send_pledge_to_service(_name, _amount) do
    # CODE GOES HERE TO SEND PLEDGE TO EXTERNAL SERVICE
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end

  defp fetch_recent_pledges_from_service do
    # CODE GOES HERE TO FETCH RECENT PLEDGES FROM EXTERNAL SERVICE

    # Example return value:
    [{"wilma", 15}, {"fred", 25}]
  end
end

# alias Servy.PledgeServer
#
# {:ok, pid} = PledgeServer.start_link([])
#
# send pid, {:stop, "hammertime"}
#
# PledgeServer.set_cache_size(4)
#
# IO.inspect PledgeServer.create_pledge("larry", 10)
#
# PledgeServer.clear()
#
# IO.inspect PledgeServer.create_pledge("moe", 20)
# IO.inspect PledgeServer.create_pledge("curly", 30)
# IO.inspect PledgeServer.create_pledge("daisy", 40)
# IO.inspect PledgeServer.create_pledge("grace", 50)
#
# IO.inspect PledgeServer.recent_pledges()
# IO.inspect PledgeServer.total_pledged()
