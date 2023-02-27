defmodule Vms.Repo.Migrations.CreatePositions do
  use Ecto.Migration

  def up do
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

    execute "CREATE EXTENSION IF NOT EXISTS btree_gist;"

    execute """
      ALTER TABLE positions
      ADD CONSTRAINT overlapping_schedules
      EXCLUDE USING GIST (
        volunteer_id WITH =,
        tsrange("shift_starttime", "shift_endtime", '[)') WITH &&
      )
    """
  end

  def down do
    drop table(:positions)
  end
end
