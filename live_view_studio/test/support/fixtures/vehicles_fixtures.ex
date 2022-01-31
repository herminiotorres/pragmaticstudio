defmodule LiveViewStudio.VehiclesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveViewStudio.Vehicles` context.
  """

  @doc """
  Generate a vehicle.
  """
  def vehicle_fixture(attrs \\ %{}) do
    {:ok, vehicle} =
      attrs
      |> Enum.into(%{
        color: "some color",
        make: "some make",
        model: "some model"
      })
      |> LiveViewStudio.Vehicles.create_vehicle()

    vehicle
  end
end
