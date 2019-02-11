use Mix.Config

config :exvcr, [
  vcr_cassette_library_dir: "fixture/vcr_cassettes",
  filter_sensitive_data: [
    [pattern: ~s(email":".+?"), placeholder: ~s(email":"<EMAIL_REMOVED>")]
  ],
  filter_url_params: true,
  filter_request_headers: [],
  response_headers_blacklist: []
]
