defmodule Servy.HttpClient do
  @host 'localhost'
  @port 4001

  def send_request(request) do
    options = [:binary, packet: :raw, active: false]
    {:ok, socket} = :gen_tcp.connect(@host, @port, options)

    :ok = :gen_tcp.send(socket, request)
    {:ok, response} = :gen_tcp.recv(socket, 0)
    :ok = :gen_tcp.close(socket)

    response
  end
end
