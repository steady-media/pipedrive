defmodule APITest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import ExUnit.CaptureLog
  import Test.Support.AppEnvHelper
  require Logger

  test "API requests fail with bad credentials" do
    with_app_env(:pipedrive, %{company_subdomain: "some-company", api_token: "invalid-token"}) do
      use_cassette "api_token_unauthorised" do
        resp = Pipedrive.API.get("/organizations")
        assert match?({:error, %HTTPoison.Response{status_code: 401}}, resp)
      end
    end
  end

  test "logs an error when a required key is missing from app env" do
    with_app_env(:pipedrive, %{company_subdomain: "some-company", api_token: nil}) do
      fun = fn ->
        use_cassette "api_token_unauthorised" do
          Pipedrive.API.get("/organizations")
        end
      end

      assert capture_log([level: :error], fun) =~ "Required key `:api_token` not found"
    end
  end
end
