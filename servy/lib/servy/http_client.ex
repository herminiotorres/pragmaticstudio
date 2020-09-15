defmodule Servy.HttpClient do
  def send_request(request) do
    host = 'localhost'
    port = 4000

    {:ok, socket} =
      :gen_tcp.connect(host, port, [:binary, packet: :raw, active: false])

    :ok = :gen_tcp.send(socket, request)
    {:ok, response} = :gen_tcp.recv(socket, 0)
    :ok = :gen_tcp.close(socket)

    response
  end
end
