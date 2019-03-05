defmodule Pipedrive.Helpers.RateLimit do
  @moduledoc """
  Helpers around rate limiting.
  """
  @behaviour Pipedrive.Helpers.SleepAndRetryBehaviour
  @default_timeout :timer.seconds(5)
  require Logger

  alias Pipedrive.API

  @doc """
  Given an api call and its params, this function will execute it
  and if the rate limit is reached, extract `retry_after` from
  the response headers and sleep before retrying.

  This is rather naive, as other processes might exhaust the rate
  limit, leaving us starved. We therefore wrap the API call (or
  calls if we retry), in a `Task` and allow it to timeout. The
  timeout can be passed as opts.
  """
  @impl true
  @spec sleep_and_retry((... -> API.response())) :: API.response()
  def sleep_and_retry(api_call, api_call_args \\ [], opts \\ []) do
    timeout = Keyword.get(opts, :timeout, @default_timeout)

    task =
      Task.async(fn ->
        execute_request(api_call, api_call_args)
      end)

    try do
      Task.await(task, timeout)
    catch
      :exit, _ -> {:error, :timeout}
    end
  end

  defp execute_request(api_call, api_call_args) do
    case apply(api_call, [api_call_args]) do
      {:ok, response} ->
        {:ok, response}

      {:error, %HTTPoison.Response{status_code: 429, headers: headers}} ->
        retry_after = parse_retry_after(headers)

        Logger.warn("""
        #{__MODULE__} Rate limit exhausted while executing #{inspect(Macro.escape(api_call))},
        Request will be retried after: #{inspect(retry_after)}
        """)

        :timer.sleep(retry_after)
        execute_request(api_call, api_call_args)

      {:error, error} ->
        {:error, error}
    end
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
