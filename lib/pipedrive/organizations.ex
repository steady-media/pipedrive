defmodule Pipedrive.Organizations do
  @moduledoc """
  API endpoint wrappers for working with `Organizations`.
  """
  @behaviour Pipedrive.RESTEntity

  alias Pipedrive.API
  import Pipedrive.Helpers.Serialization
  import Pipedrive, only: [api_docs_base_url: 0]

  @doc """
  Get all organizations.

  [Pipedrive API docs](#{api_docs_base_url()}/Organizations/get_organizations)
  """
  @impl Pipedrive.RESTEntity
  @spec list(Keyword.t()) :: API.response()
  def list(opts \\ []) do
    API.get("/organizations", "", opts)
  end

  @doc """
  Create an organization. Accepts a map of params (`body`) of which `name` is required.

  [Pipedrive API docs](#{api_docs_base_url()}/Organizations/post_organizations)
  """
  @impl Pipedrive.RESTEntity
  @spec create(map(), Keyword.t()) :: API.response()
  def create(%{name: _} = body_params, opts \\ []) do
    API.post("/organizations", body_params, opts)
  end

  @doc """
  Updates an organization. Accepts a map of params (`body`) of which `id` is required.

  [Pipedrive API docs](#{api_docs_base_url()}Organizations/put_organizations_id)
  """
  @impl Pipedrive.RESTEntity
  @spec update(map(), Keyword.t()) :: API.response()
  def update(%{id: _id} = body_params, opts \\ []) do
    {id, body_params} = Map.pop(body_params, :id)
    API.put("/organizations/#{id}", body_params, opts)
  end

  @doc """
  Delete an organizations.

  [Pipedrive API docs](#{api_docs_base_url()}/Organizations/delete_organizations_id)
  """
  @impl Pipedrive.RESTEntity
  @spec delete(String.t(), Keyword.t()) :: API.response()
  def delete(id, opts \\ []) do
    API.delete("/organizations/#{id}", "", opts)
  end

  @doc """
  Delete multiple organizations.

  [Pipedrive API docs](#{api_docs_base_url()}/Organizations/delete_organizations)
  """
  @impl Pipedrive.RESTEntity
  @spec delete_bulk(nonempty_list(String.t()), Keyword.t()) :: API.response()
  def delete_bulk(ids, opts \\ []) do
    API.delete("/organizations", %{ids: serialize_ids(ids)}, opts)
  end
end
