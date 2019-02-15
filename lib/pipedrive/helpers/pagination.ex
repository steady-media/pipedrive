defmodule Pipedrive.Helpers.Pagination do
  @moduledoc """
  Helpers around pagination.
  """
  alias Pipedrive.API
  alias Pipedrive.Helpers.RateLimit

  # This is the max page size allowed by Pipedrive
  @max_limit 500
  # This is the default timeout *per request*
  @default_timeout :timer.seconds(10)

  @doc """
  Given an API call and its params, this function will
  recursively repeat the call while modifying the pagination
  parameter `next_start` until `more_items_in_collection` is falsey,
  returning the merged responses. Note that other fields, such as
  `additional_data` and `related_objects` are discarded.
  """
  @spec fetch_all((... -> API.response()), Keyword.t()) :: {:ok, any} | {:error, term()}
  def fetch_all(api_call, opts \\ []) do
    do_fetch_all(api_call, opts)
  end

  defp do_fetch_all(api_call, opts, state \\ %{"data" => []}) do
    timeout = Keyword.get(opts, :timeout, @default_timeout)
    opts = put_new_url_param(opts, :limit, @max_limit)

    case RateLimit.sleep_and_retry(api_call, opts, timeout: timeout) do
      {:ok, response} ->
        state = merge_response(state, response)

        if more_items?(response) do
          opts = put_url_param(opts, :start, next_start(response))
          do_fetch_all(api_call, opts, state)
        else
          {:ok, state}
        end

      {:error, :timeout} ->
        {:error, :timeout}

      {:error, error} ->
        {:error, error}
    end
  end

  defp put_new_url_param(opts, param, value) do
    if get_in(opts, [:url_params, param]) do
      opts
    else
      put_url_param(opts, [:url_params, param], value)
    end
  end

  def put_url_param(opts, param, value) do
    put_in(opts, [:url_params, param], value)
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
end
