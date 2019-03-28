defmodule Pipedrive.Test.Pagination do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  require Logger

  alias Pipedrive.{Helpers.Pagination, Organizations}

  test "pagination" do
    use_cassette "pagination", match_requests_on: [:query, :request_body] do
      for i <- 1..10 do
        {:ok, _} = Organizations.create(%{name: "My Org (pagination)" <> " #{i}"})
      end

      {:ok, %{"data" => data}} =
        Pagination.fetch_all(&Organizations.list/1, [[url_params: %{limit: 1}]])

      assert length(data) >= 10

      {:ok, %{"data" => data}} = Organizations.list(url_params: %{limit: 1})
      assert length(data) == 1
    end
  end
end
