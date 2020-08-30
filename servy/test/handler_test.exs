defmodule HandlerTest do
  use ExUnit.Case

  alias Servy.Handler

  test "send request and receive the response" do
    request = """
    GET /wildthings HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    expected_response = """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 20

    Bears, Lions, Tigers
    """

    assert Handler.handle(request) == expected_response
  end
end
