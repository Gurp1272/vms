defmodule Vms.GenServers.MessageRouter do
  use GenServer

  # Maintains state of map that links GenServers.Message pids to phone numbers
  # %{phone_number => PID, phone_number => PID}

  # When twilio sends an http request, the phone number will be extracted
  # and sent to MessageRouter to determine which GenServers.Message PID
  # to send the message body to

  # Callbacks
  def init(%{}) do
    {:ok, %{}}
  end

  # 
end
