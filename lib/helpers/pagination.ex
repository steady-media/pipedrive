defmodule Pipedrive.Helpers.Pagination do
  @moduledoc false

  @max_items_per_page 500
  @default_timeout :timer.seconds(20)

  # TODO: investigate if pagination cursor is opaque
  # if it's not, this could be done concurrently, albeit rate limiting
  # will complicate things
  @spec fetch_all((() -> Pipedrive.API.response()), map()) :: Pipedrive.API.response()
  def fetch_all(api_call, body, opts \\ []) do
    timeout = Keyword.get(opts, :timeout, @default_timeout)
    task = Task.async(fn -> do_fetch_all(api_call, body) end)
    Task.await(task, timeout)
  end

  defp do_fetch_all(api_call, body, state \\ %{data: []}) do
    case api_call.(body, params: %{limit: @max_items_per_page}) do
      {:ok, response} ->
        state = merge_response(state, response)

        if more_items?(response) do
          body = Map.merge(body, %{start: next_start(response)})
          do_fetch_all(api_call, body, state)
        else
          state
        end

      # This is rather naive, as other processes might exhaust the rate
      # limit, leaving us starved. We therefore wrap `do_fetch_all` in
      # a `Task`.
      {:error, %HTTPoison.Response{status_code: 429, headers: headers}} ->
        headers
        |> parse_retry_after()
        |> :timer.sleep()

      {:error, %HTTPoison.Error{} = error} -> {:error, error}
    end
  end

  defp more_items?(response) do
    get_pagination_param(response, "more_items_in_collection")
  end

  defp next_start(response) do
    get_pagination_param(response, "next_start")
  end

  defp get_pagination_param(response, param) do
    get_in(response, ~w(additional_data pagination #{param}))
  end

  defp merge_response(state, response) do
    update_in(state, ["data"], &(&1 ++ response["data"]))
  end

  defp parse_retry_after(headers) do
    retry_after =
      headers
      |> Map.new()
      |> Map.get("Retry-After")

    {retry_after, ""} = Float.parse(retry_after)

    trunc(retry_after * 1_000)
  end
end
