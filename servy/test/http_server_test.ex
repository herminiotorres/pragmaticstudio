defmodule HttpServerTest do
  use ExUnit.Case, async: true

  alias Servy.{HttpClient, HttpServer}

  test "accepts a request on a socket and sends back a response via HTTP" do
    spawn(HttpServer, :start, [4000])

    request = """
    GET /wildthings HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = HttpClient.send_request(request)

    assert response == """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 20\r
    \r
    Bears, Lions, Tigers
    """
  end

  test "accepts one request on a socket and sends back a response via JSON" do
    spawn(HttpServer, :start, [4000])

    {:ok, response} = HTTPoison.get("http://localhost:4000/wildthings")

    assert response.status_code == 200
    assert response.body == "Bears, Lions, Tigers"
  end

  test "accepts concurrency requests on a socket and sends back a response via JSON" do
    spawn(HttpServer, :start, [4000])

    parent = self()

    max_concurrent_request = 5

    # Spawn the client processes
    for _ <- 1..max_concurrent_request do
      spawn(fn ->
        # Send the request
        {:ok, response} = HTTPoison.get("http://localhost:4000/wildthings")

        # Send the response back to the parent
        send(parent, {:ok, response})
      end)
    end

    # Await all {:handled, response} messages from spawned processes.
    for _ <- 1..max_concurrent_request do
      receive do
        {:ok, response} ->
          assert response.status_code == 200
          assert response.body == "Bears, Lions, Tigers"
      end
    end
  end
end
