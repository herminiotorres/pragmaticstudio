defmodule Servy.FourOhFourCounterHandRolled do
  @name :four_oh_four_counter_hand_rolled

  alias Servy.GenericServer

  # Client Interface

  def start do
    IO.puts "Starting the 404 counter..."
    GenericServer.start(__MODULE__, %{}, @name)
  end

  def bump_count(path) do
    GenericServer.call(@name, {:bump_count, path})
  end

  def get_counts do
    GenericServer.call(@name, :get_counts)
  end

  def get_count(path) do
    GenericServer.call(@name, {:get_count, path})
  end

  # Server Interface

  def init(state) do
    {:ok, state}
  end

  def handle_call({:bump_count, path}, state) do
    new_state = state |> Map.update(path, 1, &(&1 + 1))
    {:ok, new_state}
  end

  def handle_call(:get_counts, state) do
    {state, state}
  end

  def handle_call({:get_count, path}, state) do
    count = state |> Map.get(path, 0)
    {count, state}
  end

  def handle_cast(:clear, _state) do
    %{}
  end
end
