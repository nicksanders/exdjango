defmodule ExDjango.RedixPool do
  use Supervisor

  @redis_connection_params host: "127.0.0.1"

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    pool_opts = [
      name: {:local, :redix_poolboy},
      worker_module: Redix,
      size: 10,
      max_overflow: 5,
    ]

    children = [
      :poolboy.child_spec(:redix_poolboy, pool_opts, @redis_connection_params)
    ]

    supervise(children, strategy: :one_for_one, name: __MODULE__)
  end

  def command(command) do
    :poolboy.transaction(:redix_poolboy, &Redix.command(&1, command))
  end

  def command!(command) do
    :poolboy.transaction(:redix_poolboy, &Redix.command!(&1, command))
  end

  def pipeline(commands) do
    :poolboy.transaction(:redix_poolboy, &Redix.pipeline(&1, commands))
  end

  def pipeline!(commands) do
    :poolboy.transaction(:redix_poolboy, &Redix.pipeline!(&1, commands))
  end
end
