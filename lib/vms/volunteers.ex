defmodule Vms.Volunteers do
  @moduledoc """
  The Volunteers context.
  """

  import Ecto.Query, warn: false
  require Logger
  alias Vms.Repo
  alias Vms.Access
  alias Vms.Twilio
  alias Vms.Requests
  alias Vms.Genserver.Access, as: State

  alias Vms.Volunteers.Volunteer

  @doc """
  Returns the list of volunteers.

  ## Examples

      iex> list_volunteers()
      [%Volunteer{}, ...]

  """
  def list_volunteers do
    Repo.all(Volunteer)
  end

  @doc """
  Gets a single volunteer.

  Raises `Ecto.NoResultsError` if the Volunteer does not exist.

  ## Examples

      iex> get_volunteer!(123)
      %Volunteer{}

      iex> get_volunteer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_volunteer!(id), do: Repo.get!(Volunteer, id)

  @doc """
  Creates a volunteer.

  ## Examples

      iex> create_volunteer(%{field: value})
      {:ok, %Volunteer{}}

      iex> create_volunteer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_volunteer(attrs \\ %{}) do
    %Volunteer{}
    |> Volunteer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a volunteer.

  ## Examples

      iex> update_volunteer(volunteer, %{field: new_value})
      {:ok, %Volunteer{}}

      iex> update_volunteer(volunteer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_volunteer(%Volunteer{} = volunteer, attrs) do
    volunteer
    |> Volunteer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a volunteer.

  ## Examples

      iex> delete_volunteer(volunteer)
      {:ok, %Volunteer{}}

      iex> delete_volunteer(volunteer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_volunteer(%Volunteer{} = volunteer) do
    Repo.delete(volunteer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking volunteer changes.

  ## Examples

      iex> change_volunteer(volunteer)
      %Ecto.Changeset{data: %Volunteer{}}

  """
  def change_volunteer(%Volunteer{} = volunteer, attrs \\ %{}) do
    Volunteer.changeset(volunteer, attrs)
  end

  @doc """
  Volunteers ordered by :datetime_last_contact.

  Retrieves first number of volunteers.
  """
  @spec retrieve_volunteers(integer) :: [%Volunteer{}]
  def retrieve_volunteers(number) do
    query =
      from v in Volunteer,
        order_by: [asc_nulls_first: v.datetime_last_contact],
        limit: ^number

    Repo.all(query)
  end

  def request_link(%{"first_name" => first_name, "last_name" => last_name, "phone" => phone}) do
    {:ok, phone_number} = ExPhoneNumber.parse(phone, "US")
    phone_number_string = "#{phone_number.national_number}"

    first_name =
      first_name
      |> String.downcase()
      |> String.capitalize()

    last_name =
      last_name
      |> String.downcase()
      |> String.capitalize()

    query =
      from v in Volunteer,
        where:
          v.first_name == ^first_name and v.last_name == ^last_name and
            v.phone == ^phone_number_string

    case Repo.one(query) do
      nil ->
        Requests.create_request(%{
          first_name: first_name,
          last_name: last_name,
          phone: phone_number_string
        })

      volunteer ->
        access_struct = Access.generate_struct(volunteer)

        State.put(access_struct.uuid, access_struct)

        case State.valid?(access_struct.uuid) do
          true -> Twilio.send_message(:request, volunteer, access_struct.uuid)
          _ -> Logger.info("invalid uuid in state")
        end
    end
  end
end
