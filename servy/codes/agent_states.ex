{:ok, agent} = Agent.start(fn -> [] end)
# {:ok, #PID<0.90.0>}

Agent.update(agent, fn(state) -> [ {"larry", 10} | state ] end)
Agent.update(agent, fn(state) -> [ {"moe", 20} | state ] end)

Agent.get(agent, fn(state) -> state end)
# [{"moe", 20}, {"larry", 10}]
