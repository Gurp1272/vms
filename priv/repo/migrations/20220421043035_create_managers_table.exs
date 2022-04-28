defmodule Vms.Repo.Migrations.CreateManagersTable do
  use Ecto.Migration

  def change do
    create table("managers") do
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :phone, :string, null: false
      timestamps()
    end
  end
end
