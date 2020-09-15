defmodule Servy.Plugins do
  alias Servy.{Conv, FourOhFourCounter}

  require Logger

  @doc """
    Logs 404 requests.
  """
  def track(%Conv{status: 404, path: path} = conv) do
    if Mix.env != :test do
      Logger.warn("Warning: #{path} is on the loose!")
      FourOhFourCounter.bump_count(path)
    end
    conv
  end
  def track(%Conv{} = conv), do: conv

  def log(%Conv{} = conv) do
    if Mix.env == :dev, do: IO.inspect(conv)
    conv
  end

  def rewrite_path(%Conv{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings" }
  end
  def rewrite_path(%Conv{path: path} = conv) do
    regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(conv, captures)
  end

  defp rewrite_path_captures(conv, %{"thing" => thing, "id" => id}) do
    %{conv | path: "/#{thing}/#{id}"}
  end
  defp rewrite_path_captures(conv, nil), do: conv
end
