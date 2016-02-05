defmodule ExDjango.Utils.Redis do
  alias ExDjango.Session

  def default_session_key_prefix(), do: ":1:django.contrib.sessions.cache"

  def key(key_prefix, sid), do: key_prefix <> sid

  def get_session(sid), do: default_session_key_prefix() |> get_session(sid)
  def get_session(key_prefix, sid) do
    case Session.redis_pool().command(["GET", key(key_prefix, sid)]) do
      {:ok, session} when session != nil -> session |> Session.decode()
      _ -> %{}
    end
  end

  def put_session(key_prefix, sid, data) do
    {:ok, _} = Session.redis_pool().command(["SET", key(key_prefix, sid), Session.encode(data)])
    sid
  end

  def delete_session(key_prefix, sid) do
    {:ok, _} = Session.redis_pool().command(["DEL", key(key_prefix, sid)])
    :ok
  end

end
