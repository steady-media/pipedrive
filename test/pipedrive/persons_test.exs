defmodule Pipedrive.Test.Persons do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  require Logger

  alias Pipedrive.Persons

  test "creates a person" do
    name = "John Doe"
    email = "john@example.com"

    use_cassette "persons_create" do
      {:ok, response} = Persons.create(%{name: name, email: email})
      assert match?(%{"data" => %{"name" => ^name, "email" => [%{"value" => ^email}]}}, response)
    end
  end

  test "lists persons" do
    use_cassette "persons_list", match_requests_on: [:request_body] do
      {:ok, %{"data" => %{"id" => id1}}} = Persons.create(%{name: "Alice Doe"})
      {:ok, %{"data" => %{"id" => id2}}} = Persons.create(%{name: "Bob Doe"})
      {:ok, %{"data" => data}} = Persons.list()

      assert Enum.find(data, &(&1["id"] == id1))
      assert Enum.find(data, &(&1["id"] == id2))
    end
  end

  test "updates a person" do
    use_cassette "persons_update", match_requests_on: [:request_body] do
      get_email = fn p -> p |> Map.get("email", [%{}]) |> hd() |> Map.get("value") end
      old_email = "gary@example.com"
      new_email = "g.doe1985@example.com"
      {:ok, %{"data" => %{"id" => id}}} = Persons.create(%{name: "Gary Doe", email: old_email})
      {:ok, %{"data" => %{"id" => ^id}}} = Persons.update(%{id: id, email: new_email})

      {:ok, %{"data" => data}} = Persons.list()
      assert Enum.find(data, &(get_email.(&1) == new_email))
      refute Enum.find(data, &(get_email.(&1) == old_email))
    end
  end

  test "deletes a person" do
    use_cassette "persons_delete", match_requests_on: [:request_body] do
      {:ok, %{"data" => %{"id" => id}}} = Persons.create(%{name: "Charlie Doe"})
      {:ok, _} = Persons.delete(id)
      {:ok, %{"data" => data}} = Persons.list()

      refute Enum.find(data, &(&1["id"] == id))
    end
  end

  test "deletes multiple persons" do
    use_cassette "persons_delete_bulk", match_requests_on: [:request_body] do
      {:ok, %{"data" => %{"id" => id1}}} = Persons.create(%{name: "Daniel Doe"})
      {:ok, %{"data" => %{"id" => id2}}} = Persons.create(%{name: "Elizabeth Doe"})
      {:ok, %{"data" => %{"id" => id3}}} = Persons.create(%{name: "Frank Doe"})
      {:ok, _} = Persons.delete_bulk([id1, id3])
      {:ok, %{"data" => data}} = Persons.list()

      refute Enum.find(data, &(&1["id"] == id1))
      assert Enum.find(data, &(&1["id"] == id2))
      refute Enum.find(data, &(&1["id"] == id3))
    end
  end
end
