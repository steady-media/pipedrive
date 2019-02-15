defmodule Pipedrive.RESTEntity do
  @moduledoc false
  alias Pipedrive.API
  
  # We declare both arities to avoid warnings during mocking
  @callback list() :: API.response()
  @callback list(Keyword.t()) :: API.response()

  @callback create(map()) :: API.response()
  @callback create(map(), Keyword.t()) :: API.response()

  @callback update(map()) :: API.response()
  @callback update(map(), Keyword.t()) :: API.response()

  @callback delete(String.t()) :: API.response()
  @callback delete(String.t(), Keyword.t()) :: API.response()

  @callback delete_bulk(nonempty_list(String.t())) :: API.response()
  @callback delete_bulk(nonempty_list(String.t()), Keyword.t()) :: API.response()
end
