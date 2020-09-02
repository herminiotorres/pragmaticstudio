defmodule HandlerTest do
  use ExUnit.Case

  alias Servy.Handler

  test "send a GET request to /wildthings without params and receive the response" do
    request = build_request(%{ method: "GET", path: "/wildthings" })

    assert Handler.handle(request) == expected_response("Bears, Lions, Tigers")
  end

  test "send a GET request to /bears without params and receive the response" do
    request = build_request(%{ method: "GET", path: "/bears" })

    assert Handler.handle(request) == expected_response("Teddy, Smokey, Paddington")
  end

  defp build_request(%{ method: method, path: path }) do
    """
    #{method} #{path} HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """
  end

  defp expected_response(body) do
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: #{String.length(body)}

    #{body}
    """
  end
end
