defmodule Pipedrive.Test.Deals do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  require Logger

  alias Pipedrive.Deals

  test "search a deal" do
    use_cassette "deals_search", match_requests_on: [:query] do
      {:ok, %{"data" => data}} =
        Deals.search(
          url_params: %{
            term: "b1ec4305-d3c0-4b6a-a76b-c7ade987de8d",
            exact_match: true,
            fields: :custom_fields
          }
        )

      assert match?(%{"items" => [%{"item" => %{"id" => 188, "title" => "pdtest2 deal"}}]}, data)
    end
  end

  test "get a deal" do
    use_cassette "deals_get", match_requests_on: [:query] do
      assert match?({:ok, %{"data" => %{"id" => 188, "title" => "pdtest2 deal"}}}, Deals.get(188))
    end
  end
end
