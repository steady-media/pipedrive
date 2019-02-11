defmodule Pipedrive.API.Organizations do
  @moduledoc """
  API endpoint wrappers for working with `Organizations`.
  """

  import Pipedrive
  import Pipedrive.Helpers.Serialization

  @doc """
  Get all organizations.

  [Pipedrive API docs](#{api_docs_base_url()}/Organizations/get_organizations)
  """
  @spec list :: Pipedrive.API.response()
  def list do
    Pipedrive.API.get("organizations")
  end

  @doc """
  Create an organization. Accepts a map of params (`body`) of which `name` is required.

  [Pipedrive API docs](#{api_docs_base_url()}/Organizations/post_organizations)
  """
  @spec create(%{name: String.t()}) :: Pipedrive.API.response()
  def create(body) do
    Pipedrive.API.post("organizations", body)
  end

  @doc """
  Delete multiple organizations.

  [Pipedrive API docs](#{api_docs_base_url()}/Organizations/delete_organizations)
  """
  @spec delete_bulk(nonempty_list(String.t())) :: Pipedrive.API.response()
  def delete_bulk(ids) do
    Pipedrive.API.delete("organizations", %{ids: serialize_ids(ids)})
  end

  @doc """
  Delete an organizations.

  [Pipedrive API docs](#{api_docs_base_url()}/Organizations/delete_organizations_id)
  """
  # TODO: clarify if Pipedrive extracts params from both URL and body, see doc link
  @spec delete(String.t()) :: Pipedrive.API.response()
  def delete(id) do
    Pipedrive.API.delete("organizations", nil, url_params: %{id: id})
  end
end
