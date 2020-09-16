defmodule Servy do
  use Application

  @doc """

    Changing the Port at Runtime

      In the video we ran the application with its default environment like so:

        mix run --no-halt

      But what if you wanted to override the default port value so that the web server runs on
      port 5000, for example. Here's how to do that:

        elixir --erl "-servy port 5000" -S mix run --no-halt

      The --erl option is the way you pass flags (switches) to the Erlang VM.
      Using -servy port 5000 tells the VM to set the port environment parameter to the value 5000
      for the servy application. Using this same form,
      you can set environment parameters for any application running in the VM.
  """

  def start(_type, _args) do
    IO.puts("Starting the application..")
    Servy.Supervisor.start_link()
  end
end
