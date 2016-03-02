# ExDjango

[![Travis](https://img.shields.io/travis/nicksanders/exdjango.svg?style=flat-square)](https://travis-ci.org/nicksanders/exdjango)
[![Hex.pm](https://img.shields.io/hexpm/v/exdjango.svg?style=flat-square)](https://hex.pm/packages/exdjango)
[![Hex.pm](https://img.shields.io/hexpm/dt/exdjango.svg?style=flat-square)](https://hex.pm/packages/exdjango)

An elixir library for working with django

Warning: This is Alpha software and subject to breaking changes.

## Features

* Django cookie-based sessions
* Django redis cache sessions
* Django pbkdf2_sha256 passwords

## Installation

Add ex_django to your `mix.exs` dependencies other dependencies are optional depending on what features you want to use.

```elixir
defp deps do
[ {:exdjango, "~> 0.3.1"} ]
end
```

If you need sessions you need to add poison

```elixir
{:poison, "~> 1.5.0"},
```

If you need to read/write django passwords you need to add comeonin

```elixir
{:comeonin, "~> 1.6"},
```

## Django sessions
Add secret_key to config.exs and add either Cookie or Redis to endpoint.ex Plug config

```elixir
# config.exs  
config :exdjango, :config,
  secret_key: "django-secret-key"

# endpoint.ex  
plug Plug.Session,
  store: ExDjango.Session.Cookie,
  key: "sessionid"
```

or

```elixir
# config.exs  
config :exdjango, :config,
  secret_key: "django-secret-key"
  redis_pool: MyApp.RedixPool

# endpoint.ex  
plug Plug.Session,
  store: ExDjango.Session.Redis,
  key: "sessionid"
```

To use Redis session you need a redis connection pool see https://github.com/whatyouhide/redix for more information.

Set user / get user_id ("_auth_user_id" from django session)

```elixir
conn
 |> ExDjango.Session.put_user(user)

conn
 |> ExDjango.Session.get_user_id()
```


## Django passwords

```elixir
ExDjango.Pbkdf2.checkpw(password, user.password)

changeset
|> put_change(:password, ExDjango.Pbkdf2.hashpwsalt(changeset.params["plaintext_password"]))
|> repo.insert()
```
