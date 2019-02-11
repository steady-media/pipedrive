defmodule Pipedrive.Deals do
  @moduledoc """
  API endpoint wrappers for working with `Deals`.
  """

  alias Pipedrive.API
  import Pipedrive, only: [api_docs_base_url: 0]

  @doc """
  Create an deal. Accepts a map of params (`body`), of which `title` is required.

  [Pipedrive API docs](#{api_docs_base_url()}/Deals/post_deals
  """
  @spec create(%{title: String.t()}) :: Pipedrive.API.response()
  def create(body) do
    API.post("/deals", body)
  end

  @doc """
  Update a deal. Accepts a map of params (`body`), of which `id` is required.

  [Pipedrive API docs](#{api_docs_base_url()}/Deals/put_deals_id
  """
  @spec update(%{id: String.t()}) :: Pipedrive.API.response()
  def update(body) do
    API.put("/deals", body)
  end
end
