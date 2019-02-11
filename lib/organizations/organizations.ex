defmodule Pipedrive.Organizations do
  @moduledoc """
  API endpoint wrappers for working with `Organizations`.
  """

  alias Pipedrive.API
  import Pipedrive.Helpers.Serialization
  import Pipedrive, only: [api_docs_base_url: 0]

  @doc """
  Get all organizations.

  [Pipedrive API docs](#{api_docs_base_url()}/Organizations/get_organizations)
  """
  @spec list(%{}) :: API.response()
  def list(url_params \\ %{}) do
    API.get("/organizations", "", url_params: url_params)
  end

  @doc """
  Create an organization. Accepts a map of params (`body`) of which `name` is required.

  [Pipedrive API docs](#{api_docs_base_url()}/Organizations/post_organizations)
  """
  @spec create(%{name: String.t()}) :: API.response()
  def create(body_params) do
    API.post("/organizations", body_params)
  end

  @doc """
  Delete multiple organizations.

  [Pipedrive API docs](#{api_docs_base_url()}/Organizations/delete_organizations)
  """
  @spec delete_bulk(nonempty_list(String.t())) :: API.response()
  def delete_bulk(ids) do
    API.delete("/organizations", %{ids: serialize_ids(ids)})
  end

  @doc """
  Delete an organizations.

  [Pipedrive API docs](#{api_docs_base_url()}/Organizations/delete_organizations_id)
  """
  @spec delete(String.t()) :: API.response()
  def delete(id) do
    API.delete("/organizations/#{id}")
  end
end
