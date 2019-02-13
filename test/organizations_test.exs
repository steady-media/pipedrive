defmodule Pipedrive.Test.API do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  require Logger

  alias Pipedrive.Organizations

  test "creates an organization" do
    name = "My Organization (create)"

    use_cassette "organizations_create" do
      {:ok, response} = Organizations.create(%{name: name})
      assert match?(%{"data" => %{"name" => ^name}}, response)
    end
  end

  test "lists organizations" do
    use_cassette "organizations_list" do
      {:ok, %{"data" => %{"id" => id}}} = Organizations.create(%{name: "My Organization"})
      {:ok, %{"data" => data}} = Organizations.list()

      assert Enum.find(data, fn org ->
               org["id"] == id
             end)
    end
  end

  test "deletes an organization" do
    use_cassette "organizations_delete", match_requests_on: [:request_body] do
      {:ok, %{"data" => %{"id" => id}}} = Organizations.create(%{name: "My Organization"})
      {:ok, _} = Organizations.delete(id)
      {:ok, %{"data" => data}} = Organizations.list()

      refute Enum.find(data || %{}, fn org ->
               org["id"] == id
             end)
    end
  end

  test "deletes multiple organizations" do
    use_cassette "organizations_delete_bulk", match_requests_on: [:request_body] do
      {:ok, %{"data" => %{"id" => id1}}} = Organizations.create(%{name: "My Organization (1)"})
      {:ok, %{"data" => %{"id" => id2}}} = Organizations.create(%{name: "My Organization (2)"})
      {:ok, _} = Organizations.delete_bulk([id1, id2])
      {:ok, %{"data" => data}} = Organizations.list()

      refute Enum.find(data || %{}, fn org ->
               org["id"] in [id1, id2]
             end)
    end
  end
end
