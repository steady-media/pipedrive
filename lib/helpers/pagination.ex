defmodule Pipedrive.Helpers.Pagination do
  @moduledoc false

  # This is the max page size allowed by Pipedrive
  @max_limit 500
  @default_timeout :timer.seconds(20)

  @doc """
  Given an API call and its params, this function will
  recursively repeat the call while modifying the pagination
  parameter `next_start` until `more_items_in_collection` is falsey,
  returning the merged responses. Note that other fields, such as
  `additional_data` and `related_objects` are discarded.
  """
  @spec fetch_all((map -> Pipedrive.API.response()), %{}, []) :: Pipedrive.API.response()
  def fetch_all(api_call, url_params \\ %{}, opts \\ []) do
    timeout = Keyword.get(opts, :timeout, @default_timeout)

    task =
      Task.async(fn ->
        do_fetch_all(api_call, url_params)
      end)

    try do
      {:ok, Task.await(task, timeout)}
    catch
      :exit, _ -> {:error, :timeout}
    end
  end

  defp do_fetch_all(api_call, url_params, state \\ %{"data" => []}) do
    url_params = Map.put_new(url_params, :limit, @max_limit)

    case apply(api_call, [url_params]) do
      {:ok, response} ->
        state = merge_response(state, response)

        if more_items?(response) do
          url_params = Map.merge(url_params, %{start: next_start(response)})
          do_fetch_all(api_call, url_params, state)
        else
          state
        end

      # This is rather naive, as other processes might exhaust the rate
      # limit, leaving us starved. We therefore wrap `do_fetch_all` in
      # a `Task`.
      {:error, %HTTPoison.Response{status_code: 429, headers: headers}} ->

        retry_after = parse_retry_after(headers)
        IO.puts("Rate limit exhausted, retry_after: #{inspect(retry_after)}")
        :timer.sleep(retry_after)

      {:error, %HTTPoison.Error{} = error} ->
        {:error, error}
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
