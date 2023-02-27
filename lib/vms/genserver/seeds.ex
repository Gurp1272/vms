defmodule Vms.Genserver.Seeds do
  alias Vms.Repo
  alias Vms.Volunteers.Volunteer
  alias Vms.Access
  alias Vms.Genserver.Access, as: State


  def run do
    volunteer = Repo.all(Volunteer)

    access_struct = %Access{
      volunteer: Enum.at(volunteer, 0),
      uuid: "d59ddba3-a1df-4e89-9765-9d3c0f90d133",
      expiry: DateTime.utc_now() |> DateTime.add(24, :hour)
    }

    access_struct2 = %Access{
      volunteer: Enum.at(volunteer, 1),
      uuid: "d59ddba3-a1df-4e89-9765-9d3c0f90d134",
      expiry: DateTime.utc_now() |> DateTime.add(24, :hour)
    }

    access_struct3 = %Access{
      volunteer: Enum.at(volunteer, 2),
      uuid: "d59ddba3-a1df-4e89-9765-9d3c0f90d135",
      expiry: DateTime.utc_now() |> DateTime.add(24, :hour)
    }

    access_struct4 = %Access{
      volunteer: Enum.at(volunteer, 3),
      uuid: "d59ddba3-a1df-4e89-9765-9d3c0f90d136",
      expiry: DateTime.utc_now() |> DateTime.add(24, :hour)
    }

    access_struct5 = %Access{
      volunteer: Enum.at(volunteer, 4),
      uuid: "d59ddba3-a1df-4e89-9765-9d3c0f90d137",
      expiry: DateTime.utc_now() |> DateTime.add(24, :hour)
    }

    access_struct6 = %Access{
      volunteer: Enum.at(volunteer, 5),
      uuid: "d59ddba3-a1df-4e89-9765-9d3c0f90d138",
      expiry: DateTime.utc_now() |> DateTime.add(24, :hour)
    }

    access_struct7 = %Access{
      volunteer: Enum.at(volunteer, 6),
      uuid: "d59ddba3-a1df-4e89-9765-9d3c0f90d139",
      expiry: DateTime.utc_now() |> DateTime.add(24, :hour)
    }



    State.put("d59ddba3-a1df-4e89-9765-9d3c0f90d133", access_struct)
    State.put("d59ddba3-a1df-4e89-9765-9d3c0f90d134", access_struct2)
    State.put("d59ddba3-a1df-4e89-9765-9d3c0f90d135", access_struct3)
    State.put("d59ddba3-a1df-4e89-9765-9d3c0f90d136", access_struct4)
    State.put("d59ddba3-a1df-4e89-9765-9d3c0f90d137", access_struct5)
    State.put("d59ddba3-a1df-4e89-9765-9d3c0f90d138", access_struct6)
    State.put("d59ddba3-a1df-4e89-9765-9d3c0f90d139", access_struct7)
  end
end
