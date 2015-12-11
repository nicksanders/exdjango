defmodule ExDjango.Session do
  alias ExDjango.Utils.Signing

  @auth_hash_salt "django.contrib.auth.models.AbstractBaseUser.get_session_auth_hash"
  @auth_user_backend "django.contrib.auth.backends.ModelBackend"

  def get_user_id(%Plug.Conn{} = conn) do
    Plug.Conn.get_session(conn, "_auth_user_id")
  end
  def get_user_id(session) do
    session["_auth_user_id"]
  end

  def put_user(conn, user) when is_map(user) do
    conn
    |> Plug.Conn.put_session("_auth_user_id", user.id)
    |> Plug.Conn.put_session("_auth_user_backend", @auth_user_backend)
    |> Plug.Conn.put_session("_auth_user_hash", session_auth_hash(user.password))
  end

  def decode(json) do
    case Poison.Parser.parse(json) do
      {:ok, data} -> data
      {:error, _} -> %{}
    end
  end

  def encode(data) do
     data |> Poison.encode!
  end

  def session_auth_hash(password) do
    Signing.salted_hmac(@auth_hash_salt, secret_key(), password) |> Base.encode16
  end

  def secret_key() do
    case Application.get_env(:exdjango, :config)[:secret_key] do
      nil -> raise(ArgumentError, "ExDjango session needs a secret key")
      x -> x
    end
  end

end
