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
  Get an organization by ID.

  [Pipedrive API docs](#{api_docs_base_url()}/Organizations/get_organizations_id)
  """
  @impl Pipedrive.RESTEntity
  @spec get(String.t(), Keyword.t()) :: API.response()
  def get(id, opts \\ []) do
    API.get("/organizations/#{id}", "", opts)
  end

  @doc """
  Create an organization. Accepts a map of params (`body`) of which `name` is required.

  [Pipedrive API docs](#{api_docs_base_url()}/Organizations/post_organizations)
  """
  @impl Pipedrive.RESTEntity
  @spec create(map(), Keyword.t()) :: API.response()
  def create(body_params, opts \\ [])
  def create(%{name: _} = body_params, opts), do: do_create(body_params, opts)
  def create(%{"name" => _} = body_params, opts), do: do_create(body_params, opts)

  defp do_create(body_params, opts) do
    API.post("/organizations", body_params, opts)
  end

  @doc """
  Updates an organization. Accepts an id and a map of params (`body`) to be updated.

  [Pipedrive API docs](#{api_docs_base_url()}Organizations/put_organizations_id)
  """
  @impl Pipedrive.RESTEntity
  @spec update(String.t(), map(), Keyword.t()) :: API.response()
  def update(id, body_params, opts \\ []) do
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

  @doc """
  Search an organization

  [Pipedrive API docs](#{api_docs_base_url()}/Organizations/get_organizations_search)
  """
  @impl Pipedrive.RESTEntity
  @spec search(Keyword.t()) :: API.response()
  def search(opts \\ []) do
    API.get("/organizations/search", "", opts)
  end
end
