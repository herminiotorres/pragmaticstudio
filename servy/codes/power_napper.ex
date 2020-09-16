parent = self()

power_nap = fn ->
  time = :rand.uniform(10_000)
  :timer.sleep(time)
  time
end

spawn(fn -> send(parent, {:slept, power_nap.()}) end)

receive do
  {:slept, time} -> IO.puts "Slept #{time} ms"
end
