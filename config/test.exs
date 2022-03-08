import Mix.Config

config :exvcr,
  vcr_cassette_library_dir: "fixture/vcr_cassettes",
  filter_sensitive_data: [
    [pattern: ~s(email":".+?"), placeholder: ~s(email":"[EMAIL_REMOVED]")],
    [pattern: System.fetch_env!("PIPEDRIVE_API_TOKEN"), placeholder: "[API_TOKEN_REMOVED]"],
    [pattern: System.fetch_env!("PIPEDRIVE_COMPANY_SUBDOMAIN"), placeholder: "company-subdomain"]
  ],
  filter_url_params: false,
  filter_request_headers: [],
  response_headers_blacklist: []
