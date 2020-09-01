defmodule Pipedrive.Persons do
  @moduledoc """
  API endpoint wrappers for working with `Persons`.
  """
  @behaviour Pipedrive.RESTEntity

  alias Pipedrive.API
  import Pipedrive.Helpers.Serialization
  import Pipedrive, only: [api_docs_base_url: 0]

  @doc """
  Get all persons.

  [Pipedrive API docs](#{api_docs_base_url()}/Persons/get_persons)
  """
  @impl Pipedrive.RESTEntity
  @spec list(Keyword.t()) :: API.response()
  def list(opts \\ []) do
    API.get("/persons", "", opts)
  end

  @doc """
  Get person by ID.

  [Pipedrive API docs](#{api_docs_base_url()}/Persons/get_persons_id)
  """
  @impl Pipedrive.RESTEntity
  @spec get(String.t(), Keyword.t()) :: API.response()
  def get(id, opts \\ []) do
    API.get("/persons/#{id}", "", opts)
  end

  @doc """
  Create a person. Accepts a map of params (`body`), of which `name` is required.

  [Pipedrive API docs](#{api_docs_base_url()}/Persons/post_persons)
  """
  @impl Pipedrive.RESTEntity
  @spec create(map(), Keyword.t()) :: API.response()
  def create(body_params, opts \\ [])
  def create(%{name: _} = body_params, opts), do: do_create(body_params, opts)
  def create(%{"name" => _} = body_params, opts), do: do_create(body_params, opts)

  defp do_create(body_params, opts) do
    API.post("/persons", body_params, opts)
  end

  @doc """
  Update a person. Accepts an id and a map of params to be updated.

  [Pipedrive API docs](#{api_docs_base_url()}/Persons/put_person_id)
  """
  @impl Pipedrive.RESTEntity
  @spec update(String.t(), map(), Keyword.t()) :: API.response()
  def update(id, body_params, opts \\ []) do
    API.put("/persons/#{id}", body_params, opts)
  end

  @doc """
  Delete a person.

  [Pipedrive API docs](#{api_docs_base_url()}/Persons/delete_persons_id)
  """
  @impl Pipedrive.RESTEntity
  @spec delete(String.t(), Keyword.t()) :: API.response()
  def delete(id, opts \\ []) do
    API.delete("/persons/#{id}", "", opts)
  end

  @doc """
  Delete multiple persons.

  [Pipedrive API docs](#{api_docs_base_url()}/Persons/delete_persons)
  """
  @impl Pipedrive.RESTEntity
  @spec delete_bulk(nonempty_list(String.t()), Keyword.t()) :: API.response()
  def delete_bulk(ids, opts \\ []) do
    API.delete("/persons", %{ids: serialize_ids(ids)}, opts)
  end

  @doc """
  Search a person

  [Pipedrive API docs](#{api_docs_base_url()}/Persons/get_persons_search)
  """
  @impl Pipedrive.RESTEntity
  @spec search(Keyword.t()) :: API.response()
  def search(opts \\ []) do
    API.get("/persons/search", "", opts)
  end
end
