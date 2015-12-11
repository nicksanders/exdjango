defmodule ExDjango.Session.Redis do
  alias ExDjango.Utils.Redis

  def init(opts) do
    %{key_prefix: Keyword.get(opts, :key_prefix, Redis.default_session_key_prefix())}
  end

  def get(_conn, sid, opts) do
    {sid, Redis.get_session(opts.key_prefix, sid)}
  end

  def put(conn, nil, data, opts) do
    sid = :crypto.strong_rand_bytes(96) |> Base.encode64
    put(conn, sid, data, opts)
  end

  def put(_conn, sid, data, opts) do
    Redis.put_session(opts.key_prefix, sid, data)
  end

  def delete(_conn, sid, opts) do
    Redis.delete_session(opts.key_prefix, sid)
  end

end
