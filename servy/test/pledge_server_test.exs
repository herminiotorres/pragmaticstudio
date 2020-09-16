defmodule PledgeServerTest do
  use ExUnit.Case, async: true

  alias Servy.PledgeServer

  test "caches the 3 most recent pledges and totals their amounts" do
    PledgeServer.start_link([])

    pid = GenServer.whereis(:pledge_server)

    send(pid, {:stop, "hammertime"})

    PledgeServer.create_pledge("larry", 10)
    PledgeServer.create_pledge("moe", 20)
    PledgeServer.create_pledge("curly", 30)
    PledgeServer.create_pledge("daisy", 40)
    PledgeServer.create_pledge("grace", 50)

    most_recent_pledges = [{"grace", 50}, {"daisy", 40}, {"curly", 30}]

    assert PledgeServer.recent_pledges() == most_recent_pledges

    assert PledgeServer.total_pledged() == 120

    assert Process.info(pid, :messages) == {:messages, []}

    Process.exit(pid, :kill)
  end
end
