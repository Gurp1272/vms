defmodule Vms.Repo.Migrations.CreatePositions do
  use Ecto.Migration

  def change do
    create table(:positions) do
      add :title, :string
      add :shift_starttime, :utc_datetime
      add :shift_endtime, :utc_datetime
      add :lat, :real
      add :lng, :real

      add :event_id, references("events")
      add :volunteer_id, references("volunteers")
      timestamps()
    end
  end
end
