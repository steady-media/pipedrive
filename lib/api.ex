defmodule Pipedrive.API do
  @moduledoc """
  This module handles interaction with the Pipedrive REST API at HTTP level.
  """

  # Pipedrive URLs look like this: https://my-company.pipedrive.com/...
  @base_url "https://pipedrive.com/v1"
  @default_headers %{"Content-Type" => "application/json"}

  @type error :: {:error, HTTPoison.Response.t() | HTTPoison.Error.t()}
  @type response ::
          {:ok, map()} | error

  defguardp ok?(code) when is_integer(code) and code in 200..299
  defguardp client_error?(code) when is_integer(code) and code in 400..499
  defguardp server_error?(code) when is_integer(code) and code in 500..599

  ~w(get head delete post put patch)a
  |> Enum.each(fn method ->
    @spec unquote(method)(String.t(), any, Keyword.t()) :: response
    def unquote(method)(url, body_params \\ "", opts \\ []) do
      url_params = Keyword.get(opts, :url_params, %{})
      headers = Keyword.get(opts, :headers, %{})
      base_url = Keyword.get(opts, :base_url, false)

      response =
        HTTPoison.request(
          unquote(method),
          base_url(base_url) <> url,
          json_encode(body_params),
          headers(headers),
          params: url_params(url_params),
          follow_redirect: true
        )

      handle_response(response)
    end
  end)

  defp handle_response(response) do
    case response do
      {:ok, %HTTPoison.Response{status_code: status_code} = response}
      when client_error?(status_code) or server_error?(status_code) ->
        {:error, response}

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}}
      when ok?(status_code) ->
        {:ok, json_decode(body)}

      {:error, %HTTPoison.Error{} = error} ->
        {:error, error}
    end
  end

  defp headers(headers), do: Map.merge(@default_headers, headers)

  defp url_params(url_params) do
    api_token = app_env_or_log(:api_token)
    Map.merge(%{api_token: api_token}, url_params)
  end

  defp base_url(false) do
    company_subdomain = app_env_or_log(:company_subdomain)
    base_url_for_company(company_subdomain)
  end

  defp base_url(base_url), do: base_url

  defp base_url_for_company(company_subdomain) do
    @base_url
    |> URI.parse()
    |> Map.update!(:host, &Enum.join([company_subdomain, &1], "."))
    |> URI.to_string()
  end

  defp app_env_or_log(key) do
    value = Application.get_env(:pipedrive, key)

    if is_nil(value) || String.length(to_string(value)) == 0 do
      require Logger

      Logger.error(
        "#{__MODULE__} Required key `#{inspect(key)}` not found in app env, check your configuration."
      )
    end

    value
  end

  defp json_encode(""), do: ""
  defp json_encode(body_params) when is_nil(body_params), do: ""
  defp json_encode(body_params) when is_map(body_params), do: Jason.encode!(body_params)

  defp json_decode(string) when is_bitstring(string) do
    Jason.decode!(string)
  end
end
