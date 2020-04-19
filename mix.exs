defmodule Pipedrive.MixProject do
  use Mix.Project

  def project do
    [
      app: :pipedrive,
      version: "0.1.0",
      elixir: "~> 1.8",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      preferred_cli_env: [
        vcr: :test,
        "vcr.delete": :test,
        "vcr.check": :test,
        "vcr.show": :test,
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      test_coverage: [tool: ExCoveralls],
      dialyzer: [
        plt_add_deps: true,
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.1"},
      {:httpoison, "~> 1.4"},

      # dev tools
      {:exvcr, "~> 0.10", only: :test},
      {:bypass, "~> 1.0", only: :test},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:excoveralls, "~> 0.10", only: :test},
      {:credo, "~> 1.4.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.4", only: [:dev], runtime: false}
    ]
  end

  defp description do
    """
    An Elixir API client for the Pipedrive REST API.
    """
  end

  defp package do
    [
      licenses: ["MIT"],
      keywords: ["Elixir", "Pipedrive", "REST", "API", "CRM"],
      maintainers: ["Steady Media"],
      links: %{
        "GitHub" => "https://github.com/steady-media/pipedrive",
        "Docs" => "https://hexdocs.pm/pipedrive"
      }
    ]
  end
end
