defmodule Servy.Parser do
  alias Servy.Conv

  require Logger

  def parse(request) do
    splited_request = String.split(request, "\r\n\r\n")
    top = hd(splited_request)
    params_string = tl(splited_request)

    [request_line | header_lines] = String.split(top, "\r\n")

    [method, path, _] = String.split(request_line, " ")

    headers = parse_headers(header_lines)

    params = parse_params(headers["Content-Type"], params_string)

    %Conv{
      method: method,
      path: path,
      params: params,
      headers: headers
    }
  end

  def parse_headers(header_lines) do
    Enum.reduce(header_lines, %{}, fn(line, headers) ->
      [key, value] = String.split(line, ": ")
      Map.put(headers, key, value)
    end)
  end

  @doc """
  Parses the given param string of the form `key1=value1&key2=value2`
  into a map with corresponding keys and values.

  ## Examples

        iex> params_one = "name=Baloo&type=Brown"
        iex> params_two = ~s({"name": "Breezly", "type": "Polar"})
        iex> Servy.Parser.parse_params("application/x-www-form-urlencoded", params_one)
        %{"name" => "Baloo", "type" => "Brown"}
        iex> Servy.Parser.parse_params("multipart/form-data", params_one)
        %{}
        iex> Servy.Parser.parse_params("application/json", params_two)
        %{"name" => "Breezly", "type" => "Polar"}

  """
  def parse_params("application/x-www-form-urlencoded", params_string) when is_binary(params_string) do
    params_string |> String.trim |> URI.decode_query
  end
  def parse_params("application/x-www-form-urlencoded", params_string) when is_list(params_string) do
    parse_params("application/x-www-form-urlencoded", params_string |> List.first)
  end
  def parse_params("application/json", params_string) do
    Poison.Parser.parse!(params_string, %{})
  end
  def parse_params(_,_), do: %{}
end
