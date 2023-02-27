defmodule Vms.Presence do
  use Phoenix.Presence, otp_app: :vms, pubsub_server: Vms.PubSub
end
