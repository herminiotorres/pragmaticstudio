defmodule HandlerTest do
  use ExUnit.Case

  alias Servy.Handler

  test "send a GET request to /wildthings and receive a response with status 200" do
    request = build_request(%{method: "GET", path: "/wildthings"})

    expected_response = build_response(%{status: 200, body: emojify("Bears, Lions, Tigers")})

    assert Handler.handle(request) == expected_response
  end

  test "send a GET request to /wildlife and redirect to /wildthings and receive a response with status 200" do
    request = build_request(%{method: "GET", path: "/wildlife"})

    expected_response = build_response(%{status: 200, body: emojify("Bears, Lions, Tigers")})

    assert Handler.handle(request) == expected_response
  end

  test "send a GET request to /bears and receive a response with status 200" do
    request = build_request(%{method: "GET", path: "/bears"})

    content = "<h1>All The Bears!</h1>\n<ul>\n  \n    <li>Brutus - Grizzly</li>\n  \n    <li>Iceman - Polar</li>\n  \n    <li>Kenai - Grizzly</li>\n  \n    <li>Paddington - Brown</li>\n  \n    <li>Roscoe - Panda</li>\n  \n    <li>Rosie - Black</li>\n  \n    <li>Scarface - Grizzly</li>\n  \n    <li>Smokey - Black</li>\n  \n    <li>Snow - Polar</li>\n  \n    <li>Teddy - Brown</li>\n  \n</ul>\n"

    expected_response = build_response(%{status: 200, body: emojify(content)})

    assert Handler.handle(request) == expected_response
  end

  test "send a GET request to /bears/1 and receive a response with status 200" do
    request = build_request(%{method: "GET", path: "/bears/1"})

    content = "<h1>Show Bear</h1>\n<p>\n  Is Teddy hibernating? <strong>true</strong>\n</p>\n"

    expected_response = build_response(%{status: 200, body: emojify(content)})
    
    assert Handler.handle(request) == expected_response
  end

  test "send a GET request to /bears?id=1 and receive a response with status 200" do
    request = build_request(%{method: "GET", path: "/bears?id=1"})

    content = "<h1>Show Bear</h1>\n<p>\n  Is Teddy hibernating? <strong>true</strong>\n</p>\n"

    expected_response = build_response(%{status: 200, body: emojify(content)})

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

  test "send a GET request to /bears/new and receive a response with form page" do
    request = build_request(%{method: "GET", path: "/bears/new"})

    expected_response = build_response(handle_file(%{status: 200, body: "", file: "form"}))

    assert Handler.handle(request) == expected_response
  end

  test "send a GET request to /pages/about and receive a response with about page" do
    request = build_request(%{method: "GET", path: "/pages/about"})

    expected_response = build_response(handle_file(%{status: 200, body: "", file: "about"}))

    assert Handler.handle(request) == expected_response
  end

  test "send a POST request to /bears and receive a response with status 201" do
    request = build_request(%{method: "POST", path: "/bears", params: "name=Baloo&type=Brown"})

    expected_response = build_response(%{status: 201, body: "Created a Brown, bear named Baloo!"})

    assert Handler.handle(request) == expected_response
  end

  defp build_request(%{method: "POST"} = data) do
    """
    #{data.method} #{data.path} HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*
    Content-Type: application/x-www-form-urlencoded
    Content-Length: #{String.length(data.params)}

    #{data.params}
    """
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

  def handle_file(conv) do
    Path.expand("../pages", __DIR__)
    |> Path.join(conv.file <> ".html")
    |> File.read
    |> handle_file(conv)
  end

  defp handle_file({:ok, content}, conv) do
    %{conv | status: 200, body: emojify(content)}
  end
  defp handle_file({:error, :enoent}, conv) do
    %{conv | status: 404, body: "File not found!"}
  end
  defp handle_file({:error, reason}, conv) do
    %{conv | status: 500, body: "File error: #{reason}"}
  end

  defp emojify(body) do
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
