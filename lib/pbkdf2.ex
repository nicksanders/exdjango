defmodule ExDjango.Pbkdf2 do
  @moduledoc """
  Comeonin didn't want to support pbkdf2_sha256 so copied to here

  Module to handle pbkdf2_sha256 authentication.

  To generate a password hash, use the `hashpwsalt` function:

    ExDjango.Pbkdf2.hashpwsalt("hard to guess")
    ExDjango.Pbkdf2.hashpwsalt("hard to guess", 20_000, :sha256)

  To check the password against a password hash, use the `checkpw` function:

    ExDjango.Pbkdf2.checkpw("hard to guess", stored_hash)

  There is also a `dummy_checkpw`, which can be used to stop an attacker guessing
  a username by timing the responses.

  See the documentation for each function for more details.

  Most users will not need to use any of the other functions in this module.

  ## Pbkdf2

  Pbkdf2 is a password-based key derivation function
  that uses a password, a variable-length salt and an iteration
  count and applies a pseudorandom function to these to
  produce a key.

  The original implementation used SHA-1 as the pseudorandom function,
  but this version uses HMAC-SHA-256.
  """

  use Bitwise

  @max_length bsl(1, 32) - 1
  @salt_length 12
  @pbkdf2_rounds 20_000

  @doc """
  Generate a salt for use with the `hashpass` function.

  The minimum length of the salt is 16 and the maximum length
  is 1024. The default is 16.
  """
  def gen_salt(salt_length \\ @salt_length)
  def gen_salt(salt_length) when salt_length in 12..1024 do
    :crypto.strong_rand_bytes(salt_length * 2)
    |> Base.url_encode64
    |> String.replace(~r/[-|_|=]/, "")
    |> String.slice(0, salt_length)
  end
  def gen_salt(_) do
    raise ArgumentError, message: "The salt is the wrong length."
  end

  @doc """
  Hash the password using pbkdf2_sha256.
  """
  def hashpass(password, salt, rounds \\ @pbkdf2_rounds, algorithm \\ :sha256) do
    if is_binary(salt) do
      pbkdf2(algorithm, password, salt, rounds) |> format(salt, rounds, algorithm)
    else
      raise ArgumentError, message: "Wrong type. The salt needs to be a string."
    end
  end

  @doc """
  Hash the password with a salt which is randomly generated.

  To change the complexity (and the time taken) of the  password hash
  calculation, you need to change the value for `pbkdf2_rounds`
  in the config file.
  """
  def hashpwsalt(password, rounds \\ @pbkdf2_rounds, algorithm \\ :sha256) do
    hashpass(password, gen_salt, rounds, algorithm)
  end

  defp format(hash, salt, rounds, algorithm) do
    "pbkdf2_#{algorithm}$#{rounds}$#{salt}$#{Base.encode64(hash)}"
  end

  @doc """
  Check the password.

  The check is performed in constant time to avoid timing attacks.
  """
  def checkpw(password, hash) when is_binary(password) and is_binary(hash) do
    case String.starts_with?(hash, "$") do
      # If hash starts with $ use Comeonin to check it
      true ->
        Comeonin.Pbkdf2.checkpw(password, hash)
      false ->
        [algorithm, rounds, salt, hash] = String.split(hash, "$")
        pbkdf2(parse_algorithm(algorithm), password, salt, String.to_integer(rounds))
        |> Base.encode64
        |> Comeonin.Tools.secure_check(hash)
    end

  end
  def checkpw(_password, _hash) do
    raise ArgumentError, message: "Wrong type. The password and hash need to be strings."
  end

  @doc """
  Perform a dummy check for a user that does not exist.
  This always returns false. The reason for implementing this check is
  in order to make user enumeration by timing responses more difficult.
  """
  def dummy_checkpw do
    hashpwsalt("password")
    false
  end

  def pbkdf2(:sha256, password, salt, rounds), do: pbkdf2(:sha256, password, salt, rounds, 32)
  def pbkdf2(:sha512, password, salt, rounds), do: pbkdf2(:sha512, password, salt, rounds, 64)

  defp pbkdf2(_algorithm, _password, _salt, _rounds, length) when length > @max_length do
    raise ArgumentError, "length must be less than or equal to #{@max_length}"
  end
  defp pbkdf2(algorithm, password, salt, rounds, length) when byte_size(salt) in 12..1024 do
    pbkdf2(algorithm, password, salt, rounds, length, 1, [], 0)
  end
  defp pbkdf2(_algorithm, _password, _salt, _rounds, _length) do
    raise ArgumentError, message: "The salt is the wrong length."
  end

  defp pbkdf2(_algorithm, _password, _salt, _rounds, max_length, _block_index, acc, length)
  when length >= max_length do
    key = acc |> Enum.reverse |> IO.iodata_to_binary
    <<bin::binary-size(max_length), _::binary>> = key
    bin
  end
  defp pbkdf2(algorithm, password, salt, rounds, max_length, block_index, acc, length) do
    initial = :crypto.hmac(algorithm, password, <<salt::binary, block_index::integer-size(32)>>)
    block = iterate(algorithm, password, rounds - 1, initial, initial)
    pbkdf2(algorithm, password, salt, rounds, max_length, block_index + 1,
    [block | acc], byte_size(block) + length)
  end

  defp iterate(_algorithm, _password, 0, _prev, acc), do: acc
  defp iterate(algorithm, password, round, prev, acc) do
    next = :crypto.hmac(algorithm, password, prev)
    iterate(algorithm, password, round - 1, next, :crypto.exor(next, acc))
  end

  defp parse_algorithm(algorithm) do
    case String.split(algorithm, ["_", "-"]) do
      [_, "sha256"] -> :sha256
      [_, "sha512"] -> :sha512
      _ -> raise ArgumentError, message: "Unknown password algorithm."
    end
  end

end
