defmodule Vms.Repo.Migrations.CreateRequests do
  use Ecto.Migration

  def change do
    create table(:requests) do
      add :first_name, :string
      add :last_name, :string
      add :phone, :string

      timestamps()
    end
  end
end
