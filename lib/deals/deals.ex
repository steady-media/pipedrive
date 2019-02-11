defmodule Pipedrive.API.Deals do
  @moduledoc """
  API endpoint wrappers for working with `Deals`.
  """

  import Pipedrive

  @doc """
  Create an deal. Accepts a map of params, of which `title` is required.

  [Pipedrive API docs](#{api_docs_base_url()}/Deals/post_deals
  """
  @spec create(%{title: String.t()}) :: Pipedrive.API.response()
  def create(params) do
    Pipedrive.API.post("deals", params)
  end

  @doc """
  Update a deal. Accepts a map of params, of which `id` is required.

  [Pipedrive API docs](#{api_docs_base_url()}/Deals/put_deals_id
  """
  @spec update(%{id: String.t()}) :: Pipedrive.API.response()
  def update(params) do
    Pipedrive.API.put("deals", params)
  end
end
