defmodule Vms.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string
      add :event_starttime, :utc_datetime
      add :event_endtime, :utc_datetime

      timestamps()
    end
  end
end
