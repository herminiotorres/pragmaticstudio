defmodule LiveViewStudio.Licenses do
  def calculate(seats) do
    amount =
      if seats <= 5 do
        seats * 20.0
      else
        100 + (seats - 5) * 15.0
      end

    parse_to_integer(amount)
  end

  defp parse_to_integer(amount) do
    amount
    |> Kernel.*(100)
    |> round()
  end
end
