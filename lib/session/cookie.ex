defmodule ExDjango.Session.Cookie do
  @moduledoc """
  Stores the session in a cookie compatible with django's signed_cookies.
  """
  @behaviour Plug.Session.Store

  alias ExDjango.Session
  alias ExDjango.Utils.Cookie
  alias ExDjango.Utils.Signing

  def init(opts) do
    salt = opts[:encryption_salt] || Signing.default_salt()
    # Default max age to 7 days
    max_age = opts[:max_age] || 7 * 24 * 60 * 60

    %{salt: salt, max_age: max_age}
  end

  def get(_conn, sid, opts) do
    secret_key = Session.secret_key()
    session = Cookie.get_session(sid, secret_key, opts.max_age, opts.salt)
    {sid, session}
  end

  def put(_conn, _sid, data, _opts) do
    secret_key = Session.secret_key()
    data |> Session.encode() |> Cookie.create(secret_key)
  end

  def delete(_conn, _sid, _opts) do
    :ok
  end

end
