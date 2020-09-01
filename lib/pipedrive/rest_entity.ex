defmodule Pipedrive.RESTEntity do
  @moduledoc false
  alias Pipedrive.API

  # We declare both arities to avoid warnings during mocking
  @callback list() :: API.response()
  @callback list(Keyword.t()) :: API.response()

  @callback get(String.t()) :: API.response()
  @callback get(String.t(), Keyword.t()) :: API.response()

  @callback create(map()) :: API.response()
  @callback create(map(), Keyword.t()) :: API.response()

  @callback update(String.t(), map()) :: API.response()
  @callback update(String.t(), map(), Keyword.t()) :: API.response()

  @callback delete(String.t()) :: API.response()
  @callback delete(String.t(), Keyword.t()) :: API.response()

  @callback delete_bulk(nonempty_list(String.t())) :: API.response()
  @callback delete_bulk(nonempty_list(String.t()), Keyword.t()) :: API.response()

  @callback search(map()) :: API.response()

  @optional_callbacks search: 1, get: 1, get: 2
end
