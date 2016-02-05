defmodule ExDjango.Utils.Cookie do
  alias ExDjango.Utils.Baseconv
  alias ExDjango.Utils.Signing
  alias ExDjango.Utils.Zlib
  alias ExDjango.Session


  def get_session(sid) do
    secret_key = Session.secret_key()
    max_age = 7 * 24 * 60 * 60
    salt = Signing.default_salt()
    get_session(sid, secret_key, max_age, salt)
  end

  def get_session(sid, secret_key, max_age, salt) do
    case verify(sid, secret_key, max_age, salt) do
      {:ok, data} -> data |> Session.decode()
      {:error, _} -> %{}
    end
  end

  def verify(sid, secret_key, max_age), do: verify(sid, secret_key, max_age, Signing.default_salt())
  def verify(sid, secret_key, max_age, salt) do
    case String.split(sid, ":") do
      [payload, timestamp, signature] ->
        case Signing.base64_hmac(salt, secret_key, payload <> ":" <> timestamp) do
           x when x == signature ->
             case verify_timestamp(timestamp, max_age) do
               :error -> {:error, "Session Expired"}
               :ok -> {:ok, decode_payload(payload)}
             end
           _ -> {:error, "Invalid Signature"}
        end
      _ -> {:error, "Invalid Cookie"}
    end
  end

  def create(payload, secret_key), do: create(payload, secret_key, Signing.default_salt())
  def create(payload, secret_key, salt) do
    first_part = create_data(payload) <> ":" <> create_timestamp()
    signature = Signing.base64_hmac(salt, secret_key, first_part)
    first_part <> ":" <> signature
  end

  def create_data(payload) do
    data = payload |> Zlib.compress() |> Signing.b64_encode()
    ".#{data}"
  end

  def create_timestamp() do
    secs = :erlang.system_time(:seconds)
    Baseconv.encode(:base62, secs)
  end

  def verify_timestamp(timestamp, max_age) do
    result = :ok
    if max_age != nil do
      min_secs = :erlang.system_time(:seconds) - max_age
      secs = Baseconv.decode(:base62, timestamp)
      if secs < min_secs, do: result = :error
    end
    result
  end

  def decode_payload(payload) do
    if String.starts_with?(payload, ".") do
      {_, payload} = String.split_at(payload, 1)
      Signing.b64_decode(payload) |> Zlib.decompress()
    else
      Signing.b64_decode(payload)
    end
  end

end
