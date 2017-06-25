defmodule LcsStats.Mixfile do
  use Mix.Project

  def project do
    [app: :lcs_stats,
     version: "0.2.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [
        :logger,
        :websockex,
        :elastix,
        :edeliver
      ],
    mod: {LcsStats, []}
  ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      # Core behavior
      {:websockex, "~> 0.2"},
      {:elastix, "~> 0.4"},
      {:poison, "~> 3.1"},
      
      # build and deploy
      {:edeliver, ">= 1.4.2"},
      {:distillery, "~> 1.4"}
    ]
  end
end
