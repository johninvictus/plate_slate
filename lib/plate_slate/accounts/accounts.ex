defmodule PlateSlate.Accounts do
  import Ecto.Query, warn: false
  alias PlateSlate.Repo
  alias PlateSlate.Accounts.User

  def authenticate(role, email, password) do
    user = Repo.get_by(User, role: to_string(role), email: email)

    with %{password: digest} <- user,
         true <- Argon2.verify_pass(password, digest) do

      {:ok, user}
    else
      _ ->
        :error
    end
  end
end
