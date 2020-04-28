defmodule UnirisCore.MixProject do
  use Mix.Project

  def project do
    [
      app: :uniris_core,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      compilers: [:elixir_make] ++ Mix.compilers(),
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {UnirisCore.Application, []}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:elixir_make, "~> 0.6.0", only: [:dev, :test]},
      {:ex_doc, "~> 0.21.2", only: [:dev]},
      {:mox, "~> 0.5.2", only: [:test]},
      {:stream_data, "~> 0.4.3", only: [:test]}
    ]
  end
end