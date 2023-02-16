defmodule Vms.Scheduler do
  use Quantum, otp_app: :vms
  require Logger

  alias Vms.Genserver.Access, as: State
  alias Vms.Twilio
  alias Vms.Access
  alias Vms.Events
  alias Vms.Volunteers

  @moduledoc """
  Checks for open positions belonging to events starting within 30 days

  Grabs volunteers from db, and generates access structs for them stored in State

  Maybe triggers an sms message if access struct was successfully stored in State
  """

  def initialize do
    Events.open_positions()
    |> run()
  end

  defp run(count) when count == 0, do: nil

  # send link out to 10 people
  defp run(count) when count >= 10 do
    volunteers = Volunteers.retrieve_volunteers(10)

    access_structs =
      volunteers
      |> Access.generate_structs()

    access_structs
    |> Enum.each(fn access_struct ->
      access_struct
      |> add_to_state()
    end)

    access_structs
    |> Enum.each(fn struct ->
      maybe_trigger_message(struct)
    end)
  end

  # send link out to 5 people
  defp run(_count) do
    volunteers = Volunteers.retrieve_volunteers(5)

    access_structs =
      volunteers
      |> Access.generate_structs()

    access_structs
    |> Enum.each(fn access_struct ->
      access_struct
      |> add_to_state()
    end)

    access_structs
    |> Enum.each(fn struct ->
      maybe_trigger_message(struct)
    end)
  end

  defp add_to_state(%Access{uuid: uuid} = access_struct) do
    State.put(uuid, access_struct)
  end

  defp maybe_trigger_message(%Access{volunteer: volunteer, uuid: uuid}) do
    case State.valid?(uuid) do
      true -> Twilio.send_message(volunteer, uuid)
      _ -> Logger.error("#{volunteer} does not have a valid access key")
    end
  end
end
