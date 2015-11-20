defmodule ExDjango.Session do

  def get_user(conn) do
     Plug.Conn.get_session(conn, "_auth_user_id")
  end

  def put_user(conn, user) when is_map(user), do: put_user(conn, user.id)
  def put_user(conn, user_id) when is_integer(user_id) do
    Plug.Conn.put_session(conn, "_auth_user_id", user_id)
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

end
