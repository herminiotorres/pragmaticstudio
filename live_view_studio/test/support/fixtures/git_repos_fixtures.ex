defmodule LiveViewStudio.GitReposFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveViewStudio.GitRepos` context.
  """

  @doc """
  Generate a git_repo.
  """
  def git_repo_fixture(attrs \\ %{}) do
    {:ok, git_repo} =
      attrs
      |> Enum.into(%{
        fork: true,
        language: "some language",
        license: "some license",
        name: "some name",
        owner_login: "some owner_login",
        owner_url: "some owner_url",
        stars: 42,
        url: "some url"
      })
      |> LiveViewStudio.GitRepos.create_git_repo()

    git_repo
  end
end
