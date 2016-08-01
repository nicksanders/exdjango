defmodule ExDjango.Mixfile do
  use Mix.Project

  def project do
    [app: :exdjango,
     version: "0.3.2",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     description: "An elixir library for working with django",
     package: package]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    case Mix.env do
      :test -> [applications: [:logger, :redix]]
      _ -> [applications: [:logger]]
    end
  end

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:plug, "~> 1.1"},
      {:poison, "~> 1.5 or ~> 2.0", optional: true},
      {:comeonin, "~> 2.1", optional: true},
      {:redix, "~> 0.3", optional: true},
      {:poolboy, "~> 1.5", optional: true},
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.11.4", only: :dev},
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Nick Sanders"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/nicksanders/exdjango"
      }
    ]
  end
end
