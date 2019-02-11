defmodule Pipedrive.API.Deals do
  @moduledoc """
  API endpoint wrappers for working with `Deals`.
  """

  import Pipedrive

  @doc """
  Create an deal. Accepts a map of params (`body`), of which `title` is required.

  [Pipedrive API docs](#{api_docs_base_url()}/Deals/post_deals
  """
  @spec create(%{title: String.t()}) :: Pipedrive.API.response()
  def create(body) do
    Pipedrive.API.post("deals", body)
  end

  @doc """
  Update a deal. Accepts a map of params (`body`), of which `id` is required.

  [Pipedrive API docs](#{api_docs_base_url()}/Deals/put_deals_id
  """
  @spec update(%{id: String.t()}) :: Pipedrive.API.response()
  def update(body) do
    Pipedrive.API.put("deals", body)
  end
end
