defmodule ExDjango.Session do
  alias ExDjango.BaseConv
  alias ExDjango.Signing
  alias ExDjango.Zlib

  def validate(salt, secret, session_id, max_age \\ nil) do
    result = nil
    [payload, timestamp, signature] = String.split(session_id, ":")

    data_signature = Signing.base64_hmac(salt, secret, payload <> ":" <> timestamp)
    if data_signature != signature do
      {:error, "Invalid Signature"}
    else

      if max_age != nil do
        min_secs = Timex.Time.now(:secs) - max_age
        secs = BaseConv.decode(:base62, timestamp)
        if secs < min_secs do
          result = {:error, "Session Expired"}
        end
      end

      if result == nil do
        if String.starts_with?(payload, ".") do
          {_, payload} = String.split_at(payload, 1)
          result = Signing.b64_decode(payload)
            |> Zlib.decompress()
        else
          result = Signing.b64_decode(payload)
        end
        {:ok, result}
      else
        result
      end
    end

  end

  def get_user_id(payload) do
    session = Poison.Parser.parse!(payload)
    session["_auth_user_id"]
  end

end
