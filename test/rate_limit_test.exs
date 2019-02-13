defmodule Pipedrive.Test.RateLimit do
  use ExUnit.Case
  require Logger
  alias Pipedrive.{Helpers.RateLimit, Organizations}

  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass, bypass_url: "http://localhost:#{bypass.port}/v1"}
  end

  test "rate limiting times out", %{bypass: bypass, bypass_url: bypass_url} do
    Bypass.expect_once(bypass, fn conn ->
      assert "/v1/organizations" == conn.request_path
      conn = Plug.Conn.put_resp_header(conn, "Retry-After", "2")
      Plug.Conn.resp(conn, 429, "")
    end)

    {:error, :timeout} =
      RateLimit.sleep_and_retry(&Organizations.list/1, [base_url: bypass_url],
        timeout: :timer.seconds(1)
      )
  end
end
