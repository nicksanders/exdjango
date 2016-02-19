defmodule ExDjango.Utils.Zlib do
  @moduledoc """
  Zlib compress and decompress functions
  """

  def compress(data) do
    z = :zlib.open()
    :zlib.deflateInit(z)
    :zlib.deflate(z, data)
    result = :zlib.deflate(z, << >>, :finish)
    :zlib.deflateEnd(z)
    :erlang.list_to_binary(result)
  end

  def decompress(data, wbits \\ 15) do
    z = :zlib.open()
    :zlib.inflateInit(z, wbits)
    [result|_] = :zlib.inflate(z, data)
    :zlib.inflateEnd(z)
    result
  end

end
