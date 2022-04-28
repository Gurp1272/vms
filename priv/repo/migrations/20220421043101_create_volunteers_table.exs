defmodule Vms.Repo.Migrations.CreateVolunteersTable do
  use Ecto.Migration

  def change do
    create table("volunteers") do
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :age, :integer
      add :phone, :string, null: false
      add :manager_id, references("managers"), null: false
      timestamps()
    end
  end
end
