defmodule Vms.GenServers.Message do
  use GenServer

  # Maintains state of map that contains last relevant message from recipient

  # Callbacks

  def init(init_arg) do
    {:ok, init_arg}
  end

  # If a post is accepted, a check is made to see if the post is still open
  # if it is, the post is considered filled
  # If this genserver fills a post, a message is sent to GenServers.Post
  # to notify of the filled post and this genserver is killed

  # if the inquired post is alrady filled, a response is sent to
  # recipient to display currently open posts, and recipient
  # can accept, decline, or ignore

  # If a post is declined, the state for this genserver is reset
  # and a new person is contacted

  # If a response is not received within <time>, post is considered declined
  # state is reset and a new person is contacted

end
