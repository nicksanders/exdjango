defmodule ExDjango.Signing do

  def default_salt() do
    "django.contrib.sessions.backends.signed_cookiessigner"
  end

  def b64_encode(s) do
    String.rstrip(Base.url_encode64(s), ?=)
  end

  def b64_decode(s) do
    padding = String.duplicate("=", 4 - rem(String.length(s), 4))
    Base.url_decode64!(s <> padding)
  end

  def salted_hmac(salt, secret, value) do
    sha1_hash = :crypto.hash(:sha, salt <> secret)
    :crypto.hmac(:sha, sha1_hash, value)
  end

  def base64_hmac(salt, secret, value) do
    b64_encode(salted_hmac(salt, secret, value))
  end

end
