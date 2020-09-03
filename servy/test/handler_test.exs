defmodule HandlerTest do
  use ExUnit.Case

  alias Servy.Handler

  test "send a GET request to /wildthings and receive a response with status 200" do
    request = build_request(%{ method: "GET", path: "/wildthings" })

    expected_response = build_response(%{status: 200, body: emojify("Bears, Lions, Tigers")})

    assert Handler.handle(request) == expected_response
  end

  test "send a GET request to /wildlife and redirect to /wildthings and receive a response with status 200" do
    request = build_request(%{ method: "GET", path: "/wildlife" })

    expected_response = build_response(%{status: 200, body: emojify("Bears, Lions, Tigers")})

    assert Handler.handle(request) == expected_response
  end

  test "send a GET request to /bears and receive a response with status 200" do
    request = build_request(%{method: "GET", path: "/bears"})

    expected_response = build_response(%{status: 200, body: emojify("Teddy, Smokey, Paddington")})

    assert Handler.handle(request) == expected_response
  end

  test "send a GET request to /bears/1 and receive a response with status 200" do
    request = build_request(%{method: "GET", path: "/bears/1"})

    expected_response = build_response(%{status: 200, body: emojify("Bear 1")})

    assert Handler.handle(request) == expected_response
  end

  test "send a GET request to /bears?id=1 and receive a response with status 200" do
    request = build_request(%{method: "GET", path: "/bears?id=1"})

    expected_response = build_response(%{status: 200, body: emojify("Bear 1")})

    assert Handler.handle(request) == expected_response
  end

  test "send a DELETE request to /bears/1 and receive a response with status 403" do
    request = build_request(%{method: "DELETE", path: "/bears/1"})

    expected_response = build_response(%{status: 403, body: "Deleting a bear is forbidden!"})

    assert Handler.handle(request) == expected_response
  end

  test "send a GET request to /bigfoot and receive a response with status 404" do
    request = build_request(%{method: "GET", path: "/bigfoot"})

    expected_response = build_response(%{status: 404, body: "No /bigfoot here!"})

    assert Handler.handle(request) == expected_response
  end

  defp build_request(data) do
    """
    #{data.method} #{data.path} HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """
  end

  defp build_response(data) do
    """
    HTTP/1.1 #{data.status} #{status_reason(data.status)}
    Content-Type: text/html
    Content-Length: #{String.length(data.body)}

    #{data.body}
    """
  end

  def emojify(body) do
    emojies = String.duplicate("🎉", 5)
    emojies <> "\n" <> body <> "\n" <> emojies
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Create",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error",
    }[code]
  end
end
