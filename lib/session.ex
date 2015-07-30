defmodule ExDjango.Session do
  alias ExDjango.BaseConv
  alias ExDjango.Signing
  alias ExDjango.Zlib

  def validate(salt, secret, session_id, max_age \\ nil) do
    result = nil
    [signature|data] = String.split(session_id, ":", parts: 2)

    data_signature = Signing.base64_hmac(salt, secret, data)
    if data_signature != signature do
      {:error, "Invalid Signature"}
    else
      [timestamp|payload] = String.split(data, ":")

      if max_age != nil do
        min_secs = Timex.Time.now(:secs) - max_age
        if BaseConv.decode(:base62, timestamp) < min_secs do
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

  end

end
