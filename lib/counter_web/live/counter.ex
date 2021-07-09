defmodule CounterWeb.Counter do
  use Phoenix.LiveView

  @topic "live"

  def mount(_params, _session, socket) do
    # subscribe to channel
    CounterWeb.Endpoint.subscribe(@topic)
    {:ok, assign(socket, :val, 0)}
  end

  def handle_event("inc", _, socket) do
    new_state = update(socket, :val, fn count -> count + 1 end)
    CounterWeb.Endpoint.broadcast_from(self(), @topic, "inc", new_state.assigns)
    {:noreply, new_state}
  end

  def handle_event("dec", _, socket) do
    new_state = update(socket, :val, fn count -> count - 1 end)
    CounterWeb.Endpoint.broadcast_from(self(), @topic, "dec", new_state.assigns)
    {:noreply, new_state}
  end

  def handle_info(msg, socket) do
    {:noreply, assign(socket, val: msg.payload.val)}
  end

  def render(assigns) do
    ~L"""
    <div>
      <h1>The count is: <%= @val %></h1>
      <button phx-click="dec">-</button>
      <button phx-click="inc">+</button>
    </div>

    <div>
          Made by Owais Qayyum, referenced from <a href="https://github.com/dwyl/phoenix-liveview-counter-tutorial">here</a>
    </div>
    """
  end
end
