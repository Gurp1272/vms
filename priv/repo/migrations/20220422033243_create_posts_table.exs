defmodule Vms.Repo.Migrations.CreatePostsTable do
  use Ecto.Migration

  def change do
    create table("posts") do
      add :title, :string, null: false
      add :date_start_scheduling, :utc_datetime, null: false
      add :date_start, :utc_datetime, null: false
      add :date_end, :utc_datetime, null: false
      add :manager_id, references("managers"), null: false
      timestamps()
    end
  end
end
