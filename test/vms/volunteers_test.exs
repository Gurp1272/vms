defmodule Vms.VolunteersTest do
  use Vms.DataCase

  alias Vms.Volunteers

  describe "volunteers" do
    alias Vms.Volunteers.Volunteer

    import Vms.VolunteersFixtures

    @invalid_attrs %{datetime_last_contact: nil, datetime_last_served: nil, first_name: nil, last_name: nil, note: nil, phone: nil, times_contacted: nil, times_filled: nil, total_time_served: nil}

    test "list_volunteers/0 returns all volunteers" do
      volunteer = volunteer_fixture()
      assert Volunteers.list_volunteers() == [volunteer]
    end

    test "get_volunteer!/1 returns the volunteer with given id" do
      volunteer = volunteer_fixture()
      assert Volunteers.get_volunteer!(volunteer.id) == volunteer
    end

    test "create_volunteer/1 with valid data creates a volunteer" do
      valid_attrs = %{datetime_last_contact: ~U[2023-02-13 04:38:00Z], datetime_last_served: ~U[2023-02-13 04:38:00Z], first_name: "some first_name", last_name: "some last_name", note: "some note", phone: "some phone", times_contacted: 42, times_filled: 42, total_time_served: "some total_time_served"}

      assert {:ok, %Volunteer{} = volunteer} = Volunteers.create_volunteer(valid_attrs)
      assert volunteer.datetime_last_contact == ~U[2023-02-13 04:38:00Z]
      assert volunteer.datetime_last_served == ~U[2023-02-13 04:38:00Z]
      assert volunteer.first_name == "some first_name"
      assert volunteer.last_name == "some last_name"
      assert volunteer.note == "some note"
      assert volunteer.phone == "some phone"
      assert volunteer.times_contacted == 42
      assert volunteer.times_filled == 42
      assert volunteer.total_time_served == "some total_time_served"
    end

    test "create_volunteer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Volunteers.create_volunteer(@invalid_attrs)
    end

    test "update_volunteer/2 with valid data updates the volunteer" do
      volunteer = volunteer_fixture()
      update_attrs = %{datetime_last_contact: ~U[2023-02-14 04:38:00Z], datetime_last_served: ~U[2023-02-14 04:38:00Z], first_name: "some updated first_name", last_name: "some updated last_name", note: "some updated note", phone: "some updated phone", times_contacted: 43, times_filled: 43, total_time_served: "some updated total_time_served"}

      assert {:ok, %Volunteer{} = volunteer} = Volunteers.update_volunteer(volunteer, update_attrs)
      assert volunteer.datetime_last_contact == ~U[2023-02-14 04:38:00Z]
      assert volunteer.datetime_last_served == ~U[2023-02-14 04:38:00Z]
      assert volunteer.first_name == "some updated first_name"
      assert volunteer.last_name == "some updated last_name"
      assert volunteer.note == "some updated note"
      assert volunteer.phone == "some updated phone"
      assert volunteer.times_contacted == 43
      assert volunteer.times_filled == 43
      assert volunteer.total_time_served == "some updated total_time_served"
    end

    test "update_volunteer/2 with invalid data returns error changeset" do
      volunteer = volunteer_fixture()
      assert {:error, %Ecto.Changeset{}} = Volunteers.update_volunteer(volunteer, @invalid_attrs)
      assert volunteer == Volunteers.get_volunteer!(volunteer.id)
    end

    test "delete_volunteer/1 deletes the volunteer" do
      volunteer = volunteer_fixture()
      assert {:ok, %Volunteer{}} = Volunteers.delete_volunteer(volunteer)
      assert_raise Ecto.NoResultsError, fn -> Volunteers.get_volunteer!(volunteer.id) end
    end

    test "change_volunteer/1 returns a volunteer changeset" do
      volunteer = volunteer_fixture()
      assert %Ecto.Changeset{} = Volunteers.change_volunteer(volunteer)
    end
  end
end
