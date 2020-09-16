defmodule Timer do
  def remind(reminder, seconds) do
    spawn(fn ->
      ms = seconds * 1000
      ms |> :timer.sleep
      IO.puts reminder
    end)
  end
end

Timer.remind("Stand Up", 5)
Timer.remind("Sit Down", 10)
Timer.remind("Fight, Fight, Fight", 15)

:timer.sleep(:infinity)
