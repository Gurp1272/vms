defmodule Vms.Twilio do
  alias ExTwilio.Message
  alias Vms.Volunteers.Volunteer

  @twilio_number "+18449822184"

  def send_message(%Volunteer{phone: to} = volunteer, uuid) do
    body =
      volunteer
      |> generate_body(uuid)

    {:ok, _response} = Message.create(to: to, from: @twilio_number, body: body)

    # Twilio only allows 1 message per second
    :timer.sleep(1000)
  end

  defp generate_body(%Volunteer{first_name: first_name, last_name: last_name}, uuid) do
    "
    Hello #{first_name} #{last_name},
    We need Gate Guards for upcoming events.
    #{VmsWeb.Endpoint.url()}/#{uuid}

    Visit this link to view upcoming events with open positions, and sign up for any positions you're able.

    This link is unique to you and expires in 24 hours, you can visit this link after expiry to request a new one. To request a link for someone else, fill out the request form with their phone number.

    This is a trial run of an automated event management system.
    If you have any problems or questions please send a text to: 385-645-4006.
    DONOTREPLY.
    "
  end
end
