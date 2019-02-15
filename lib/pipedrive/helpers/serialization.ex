defmodule Pipedrive.Helpers.Serialization do
  @moduledoc false
  @id_separator ","

  @doc false
  def serialize_ids(list_of_ids) do
    Enum.join(list_of_ids, @id_separator)
  end
end
