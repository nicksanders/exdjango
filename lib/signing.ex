defmodule Signing do

  @default_salt "django.contrib.sessions.backends.signed_cookiessigner"

  def b64_encode(s) do
    Base.url_encode64(s)
  end

  def b64_decode(s) do
    Base.url_decode64(s)
  end

  def salted_hmac(salt, secret, value) do
    input = salt <> secret
    sha1_hash = :crypto.hash(:sha, input)
    :crypto.hmac(:sha, value, sha1_hash) |> Base.encode16
  end

  def base64_hmac(salt, secret, value) do
    b64_encode(salted_hmac(salt, secret, value))
  end

end
