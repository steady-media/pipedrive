defmodule PipedriveAPITest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import ExUnit.CaptureLog
  require Logger

  setup_all do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")

    Application.put_env(:pipedrive, :company, "acme")
    Application.put_env(:pipedrive, :api_token, "pipedrive-dummy-api-token")
    :ok
  end

  test "API requests fail with bad credentials" do
    use_cassette "api_token_unauthorised" do
      resp = Pipedrive.API.get("/organizations")
      assert match? {:error, %HTTPoison.Response{status_code: 401}}, resp
    end
  end

  test "logs an error when a required key is missing from app env" do
    Application.delete_env(:pipedrive, :api_token)

    fun = fn ->
      use_cassette "api_token_unauthorised" do
        Pipedrive.API.get("/organizations")
      end
    end

    assert capture_log([level: :error], fun) =~ "Required key `api_token` not found"
  end
end
