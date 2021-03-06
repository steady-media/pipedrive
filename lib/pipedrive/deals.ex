defmodule Pipedrive.Deals do
  @moduledoc """
  API endpoint wrappers for working with `Deals`.
  """
  @behaviour Pipedrive.RESTEntity

  alias Pipedrive.API
  import Pipedrive.Helpers.Serialization
  import Pipedrive, only: [api_docs_base_url: 0]

  @doc """
  Get all deals.

  [Pipedrive API docs](#{api_docs_base_url()}/Deals/get_deals)
  """
  @impl Pipedrive.RESTEntity
  @spec list(Keyword.t()) :: API.response()
  def list(opts \\ []) do
    API.get("/deals", "", opts)
  end

  @doc """
  Get a deal by ID.

  [Pipedrive API docs](#{api_docs_base_url()}/Deals/get_deals_id)
  """
  @impl Pipedrive.RESTEntity
  @spec get(String.t(), Keyword.t()) :: API.response()
  def get(id, opts \\ []) do
    API.get("/deals/#{id}", "", opts)
  end

  @doc """
  Create a deal. Accepts a map of params (`body`), of which `title` is required.

  [Pipedrive API docs](#{api_docs_base_url()}/Deals/post_deals)
  """
  @impl Pipedrive.RESTEntity
  @spec create(map(), Keyword.t()) :: API.response()
  def create(body_params, opts \\ [])
  def create(%{title: _} = body_params, opts), do: do_create(body_params, opts)
  def create(%{"title" => _} = body_params, opts), do: do_create(body_params, opts)

  defp do_create(body_params, opts) do
    API.post("/deals", body_params, opts)
  end

  @doc """
  Update a deal. Accepts an id and a map of params (`body`) to be updated.

  [Pipedrive API docs](#{api_docs_base_url()}/Deals/put_deals_id)
  """
  @impl Pipedrive.RESTEntity
  @spec update(String.t(), map(), Keyword.t()) :: API.response()
  def update(id, body_params, opts \\ []) do
    API.put("/deals/#{id}", body_params, opts)
  end

  @doc """
  Delete a deal.

  [Pipedrive API docs](#{api_docs_base_url()}/Deals/delete_deals_id)
  """
  @impl Pipedrive.RESTEntity
  @spec delete(String.t(), Keyword.t()) :: API.response()
  def delete(id, opts \\ []) do
    API.delete("/deals/#{id}", "", opts)
  end

  @doc """
  Delete multiple deals.

  [Pipedrive API docs](#{api_docs_base_url()}/Deals/delete_deals)
  """
  @impl Pipedrive.RESTEntity
  @spec delete_bulk(nonempty_list(String.t()), Keyword.t()) :: API.response()
  def delete_bulk(ids, opts \\ []) do
    API.delete("/deals", %{ids: serialize_ids(ids)}, opts)
  end

  @doc """
  Search an deal

  [Pipedrive API docs](#{api_docs_base_url()}/Deals/get_deals_search)
  """
  @impl Pipedrive.RESTEntity
  @spec search(Keyword.t()) :: API.response()
  def search(opts \\ []) do
    API.get("/deals/search", "", opts)
  end
end
