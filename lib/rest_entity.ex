defmodule Pipedrive.RESTEntity do
  @moduledoc false
  alias Pipedrive.API
  @callback list(Keyword.t()) :: API.response()
  @callback create(map(), Keyword.t()) :: API.response()
  @callback update(map(), Keyword.t()) :: API.response()
  @callback delete(String.t(), Keyword.t()) :: API.response()
  @callback delete_bulk(nonempty_list(String.t()), Keyword.t()) :: API.response()
end
