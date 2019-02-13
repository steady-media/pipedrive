defmodule Pipedrive.Deals do
  @moduledoc """
  API endpoint wrappers for working with `Deals`.
  """

  alias Pipedrive.API
  import Pipedrive, only: [api_docs_base_url: 0]

  @doc """
  Create an deal. Accepts a map of params (`body`), of which `title` is required.

  [Pipedrive API docs](#{api_docs_base_url()}/Deals/post_deals)
  """
  @spec create(%{title: String.t()}, Keyword.t()) :: API.response()
  def create(%{title: _title} = body_params, opts \\ []) do
    API.post("/deals", body_params, opts)
  end

  @doc """
  Update a deal. Accepts a map of params (`body`), of which `id` is required.

  [Pipedrive API docs](#{api_docs_base_url()}/Deals/put_deals_id)
  """
  @spec update(%{id: String.t()}, Keyword.t()) :: API.response()
  def update(%{id: _id} = body_params, opts \\ []) do
    API.put("/deals", body_params, opts)
  end

  @doc """
  Delete a deal.

  [Pipedrive API docs](#{api_docs_base_url()}/Deals/delete_deals_id)
  """
  @spec delete(String.t(), Keyword.t()) :: API.response()
  def delete(id, opts \\ []) do
    API.delete("/deals/#{id}", "", opts)
  end
end
