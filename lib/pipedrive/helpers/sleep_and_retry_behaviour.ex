defmodule Pipedrive.Helpers.SleepAndRetryBehaviour do
  @moduledoc false
  alias Pipedrive.API
  @callback sleep_and_retry((... -> API.response())) :: API.response()
  @callback sleep_and_retry((... -> API.response()), []) :: API.response()
  @callback sleep_and_retry((... -> API.response()), [], []) :: API.response()
end
