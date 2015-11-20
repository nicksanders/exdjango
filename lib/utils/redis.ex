defmodule ExDjango.Utils.Redis do
  alias ExDjango.Session

  def default_session_key_prefix(), do: ":1:django.contrib.sessions.cache"

  def init(key_prefix, sid) do
    {:ok, client} = Exredis.start_link
    {client, key_prefix <> sid}
  end

  def get_session(key_prefix, sid) do
    {client, key} = init(key_prefix, sid)
    case client |> Exredis.Api.get(key) do
      :undefined -> %{}
      session -> session |> Session.decode()
    end
  end

  def put_session(key_prefix, sid, data) do
    {client, key} = init(key_prefix, sid)
    client |> Exredis.Api.set(key, Session.encode(data))
    sid
  end

  def delete_session(key_prefix, sid) do
    {client, key} = init(key_prefix, sid)
    client |> Exredis.Api.del(key)
    :ok
  end

end
