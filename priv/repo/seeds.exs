# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Vms.Repo.insert!(%Vms.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Vms.Repo
alias Vms.Events.Event
alias Vms.Positions.Position
alias Vms.Volunteers.Volunteer
alias Vms.Requests.Request

Repo.delete_all(Position)
Repo.delete_all(Volunteer)
Repo.delete_all(Event)
Repo.delete_all(Request)


start_time = DateTime.utc_now() |> DateTime.add(48, :hour) |> DateTime.truncate(:second)
end_time = DateTime.utc_now() |> DateTime.add(50, :hour) |> DateTime.truncate(:second)

past_start_time = DateTime.utc_now() |> DateTime.add(-48, :hour) |> DateTime.truncate(:second)
past_end_time = DateTime.utc_now() |> DateTime.add(-46, :hour) |> DateTime.truncate(:second)

{:ok, primary_volunteer} = Repo.insert(
  %Volunteer{
    first_name: "Isaac",
    last_name: "Finley",
    phone: "3856454006"
  }
)

Repo.insert! %Event{
  name: "Church",
  event_starttime: start_time,
  event_endtime: end_time,
  positions: [
    %Position{
      title: "East Gate",
      shift_starttime: start_time,
      shift_endtime: end_time,
    },
    %Position{
      title: "Center Gate",
      shift_starttime: start_time,
      shift_endtime: end_time,
    },
    %Position{
      title: "West Gate",
      shift_starttime: start_time,
      shift_endtime: end_time,
      volunteer_id: primary_volunteer.id
    }
  ]
}

Repo.insert! %Event{
  name: "Church",
  event_starttime: past_start_time,
  event_endtime: past_end_time,
  positions: [
    %Position{
      title: "East Gate",
      shift_starttime: past_start_time,
      shift_endtime: past_end_time,
    },
    %Position{
      title: "Center Gate",
      shift_starttime: past_start_time,
      shift_endtime: past_end_time,
    },
    %Position{
      title: "West Gate",
      shift_starttime: past_start_time,
      shift_endtime: past_end_time,
      volunteer_id: primary_volunteer.id
    }
  ]
}

Repo.insert! %Volunteer{
  first_name: "John",
  last_name: "Finley",
  phone: "8018596433",
  datetime_last_contact: DateTime.utc_now() |> DateTime.add(2, :minute) |> DateTime.truncate(:second)
}

Repo.insert! %Volunteer{
  first_name: "Jacob",
  last_name: "Finley",
  phone: "8018596434",
  datetime_last_contact: DateTime.utc_now()|> DateTime.add(4, :minute) |> DateTime.truncate(:second)
}

Repo.insert! %Volunteer{
  first_name: "Jingle",
  last_name: "Finley",
  phone: "8018596435",
  datetime_last_contact: DateTime.utc_now()|> DateTime.add(6, :minute) |> DateTime.truncate(:second)
}

Repo.insert! %Volunteer{
  first_name: "Faith",
  last_name: "Finley",
  phone: "8018596436",
  datetime_last_contact: DateTime.utc_now()|> DateTime.add(6, :minute) |> DateTime.truncate(:second)
}

Repo.insert! %Volunteer{
  first_name: "Ortell",
  last_name: "Finley",
  phone: "8018596437",
  datetime_last_contact: DateTime.utc_now()|> DateTime.add(6, :minute) |> DateTime.truncate(:second)
}

Repo.insert! %Volunteer{
  first_name: "Zuri",
  last_name: "Finley",
  phone: "8018596438",
  datetime_last_contact: DateTime.utc_now()|> DateTime.add(6, :minute) |> DateTime.truncate(:second)
}
