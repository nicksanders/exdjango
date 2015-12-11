defmodule ExDjango.Session.CookieTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @default_opts [
    store: ExDjango.Session.Cookie,
    key: "sessionid"
  ]

  @session_opts Plug.Session.init(@default_opts)

  defp sign_conn(conn) do
    conn
    |> Plug.Session.call(@session_opts)
    |> fetch_session
  end

  test "gets and sets signed session cookie" do
    conn = conn(:get, "/")
     |> sign_conn()
     |> put_session("foo", "bar")
     |> put_session("lam", "da")
     |> send_resp(200, "")

    conn2 = conn(:get, "/")
     |> recycle_cookies(conn)
     |> sign_conn()

    assert conn2
     |> get_session("foo") == "bar"

    assert conn2
     |> get_session("lam") == "da"
  end

  test "gets and sets user in session cookie" do
    conn = conn(:get, "/")
     |> sign_conn()
     |> ExDjango.Session.put_user(%{id: 99, password: "pa$$word"})
     |> send_resp(200, "")

    assert conn(:get, "/")
     |> recycle_cookies(conn)
     |> sign_conn()
     |> ExDjango.Session.get_user_id() == 99
  end

end
