defmodule LiveViewStudioWeb.FilterLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Boats

  def mount(_params, _session, socket) do
    socket = assign_defaults(socket)
    socket = {:ok, socket, temporary_assigns: [boats: []]}
  end

  def render(assigns) do
    ~H"""
      <h1>Daily Boat Rentals</h1>
      <div id="filter">
        <form phx-change="filter">
          <div class="filters">
            <select name="type">
              <%= options_for_select(type_options(), @type) %>
            </select>
          </div>
          <div class="prices">
            <input type="hidden" name="prices[]", value="" />
            <%= for price <- ["$", "$$", "$$$"] do %>
              <%= price_checkbox(price, price in @prices) %>
            <% end %>
          </div>
          <a href="#" phx-click="clear">Clear All</a>
        </form>

        <div class="boats">
          <%= for boat <- @boats do %>
            <div class="card">
              <img src={"#{boat.image}"}>
              <div class="content">
                <div class="model">
                  <%= boat.model %>
                </div>
                <div class="details">
                  <span class="price">
                    <%= boat.price %>
                  </span>
                  <span class="type">
                    <%= boat.type %>
                  </span>
                </div>
              </div>
            </div>
          <% end %>
        </div>
      </div>
    """
  end

  def handle_event("filter", %{"type" => type, "prices" => prices}, socket) do
    params = [type: type, prices: prices]
    boats = Boats.list_boats(params)
    socket = assign(socket, [boats: boats] ++ params)
    {:noreply, socket}
  end

  def handle_event("clear", _, socket) do
    socket = assign_defaults(socket)
    {:noreply, socket}
  end

  defp price_checkbox(price, true) do
    assigns = %{price: price}

    ~H"""
    <input type="checkbox" id={"#{@price}"}
          name="prices[]" value={"#{@price}"}
          checked />
    <label for={"#{@price}"}><%= @price %></label>
    """
  end

  defp price_checkbox(price, _checked) do
    assigns = %{price: price}

    ~H"""
    <input type="checkbox" id={"#{@price}"}
          name="prices[]" value={"#{@price}"} />
    <label for={"#{@price}"}><%= @price %></label>
    """
  end

  defp type_options do
    [
      "All Types": "",
      Fishing: "fishing",
      Sporting: "sporting",
      Sailing: "sailing"
    ]
  end

  defp assign_defaults(socket) do
    assign(socket, boats: Boats.list_boats(), type: "", prices: [])
  end
end
