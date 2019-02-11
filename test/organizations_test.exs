defmodule Pipedrive.Test.API do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  require Logger

  alias Pipedrive.Organizations

  test "creates an organization" do
    name = "My Organization"

    use_cassette "organizations_create" do
      response = Organizations.create(%{name: name})
      IO.inspect response
      assert match?({:ok, %{"data" => %{"name" => ^name}}}, response)
    end
  end
end
