defmodule ExDjango.Session.Cookie do
  alias ExDjango.Session
  alias ExDjango.Utils.Cookie
  alias ExDjango.Utils.Signing

  def init(opts) do
    salt = opts[:encryption_salt] || Signing.default_salt()
    secret_key = Session.secret_key()
    # Default max age to 7 days
    max_age = opts[:max_age] || 7 * 24 * 60 * 60

    %{salt: salt, secret_key: secret_key, max_age: max_age}
  end

  def get(_conn, cookie, opts) do
    session = case Cookie.verify(cookie, opts.secret_key, opts.max_age, opts.salt) do
      {:ok, data} -> data |> Session.decode()
      {:error, _} -> %{}
    end
    {cookie, session}
  end

  def put(_conn, _sid, data, opts) do
    data |> Session.encode() |> Cookie.create(opts.secret_key)
  end

  def delete(_conn, _sid, _opts) do
    :ok
  end

end
