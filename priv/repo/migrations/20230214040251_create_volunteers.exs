defmodule Vms.Repo.Migrations.CreateVolunteers do
  use Ecto.Migration

  def change do
    create table(:volunteers) do
      add :first_name, :string
      add :last_name, :string
      add :phone, :string
      add :note, :text
      add :times_filled, :integer
      add :total_time_served, :string
      add :datetime_last_served, :utc_datetime
      add :times_contacted, :integer
      add :datetime_last_contact, :utc_datetime

      timestamps()
    end

    create unique_index(:volunteers, [:first_name, :last_name, :phone])
  end
end
