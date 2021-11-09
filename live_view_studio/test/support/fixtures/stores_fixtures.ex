defmodule LiveViewStudio.StoresFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveViewStudio.Stores` context.
  """

  @doc """
  Generate a store.
  """
  def store_fixture(attrs \\ %{}) do
    {:ok, store} =
      attrs
      |> Enum.into(%{
        city: "some city",
        hours: "some hours",
        name: "some name",
        open: true,
        phone_number: "some phone_number",
        street: "some street",
        zip: "some zip"
      })
      |> LiveViewStudio.Stores.create_store()

    store
  end
end
