defmodule LiveViewStudioWeb.FlightsLiveLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Airports
  alias LiveViewStudio.Flights

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        number: "",
        airport: "",
        flights: [],
        matches: [],
        loading: false
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Find a Flight</h1>
    <div id="search">
      <form phx-submit="number-search">
        <input type="text" name="number" value={"#{@number}"}
               placeholder="Flight Number"
                readonly={@loading} />
        <button type="submit">
          <img src="images/search.svg">
        </button>
      </form>

      <form phx-submit="airport-search" phx-change="suggest-airport">
        <input type="text" name="airport" value={"#{@airport}"}
               list="matches"
               placeholder="Airport"
               readonly={@loading} />
        <button type="submit">
          <img src="images/search.svg">
        </button>
      </form>

      <datalist id="matches">
        <%= for match <- @matches do %>
          <option value={"#{match}"}><%= match %></option>
        <% end %>
      </datalist>

      <%= if @loading do %>
        <div class="loader">Loading...</div>
      <% end %>

      <div class="flights">
        <ul>
          <%= for flight <- @flights do %>
            <li>
              <div class="first-line">
                <div class="number">
                  Flight #<%= flight.number %>
                </div>
                <div class="origin-destination">
                  <img src="images/location.svg">
                  <%= flight.origin %> to
                  <%= flight.destination %>
                </div>
              </div>
              <div class="second-line">
                <div class="departs">
                  Departs: <%= format_time(flight.departure_time) %>
                </div>
                <div class="arrives">
                  Arrives: <%= format_time(flight.arrival_time) %>
                </div>
              </div>
            </li>
          <% end %>
        </ul>
      </div>
    </div>
    """
  end

  defp format_time(time) do
    Timex.format!(time, "%b %d at %H:%M", :strftime)
  end

  def handle_event("number-search", %{"number" => number}, socket) do
    Process.send_after(self(), {:run_number_search, number}, 500)

    socket =
      assign(socket,
        number: number,
        airport: "",
        flights: [],
        loading: true
      )

    {:noreply, socket}
  end

  def handle_info({:run_number_search, number}, socket) do
    socket =
      case Flights.search_by_number(number) do
        [] ->
          socket
          |> put_flash(:info, ~s(No flights matching "#{number}"))
          |> assign(flights: [], loading: false)

        flights ->
          socket
          |> clear_flash()
          |> assign(flights: flights, loading: false)
      end

    {:noreply, socket}
  end

  def handle_event("suggest-airport", %{"airport" => prefix}, socket) do
    socket = assign(socket, matches: Airports.suggest(prefix))
    {:noreply, socket}
  end

  def handle_event("airport-search", %{"airport" => airport}, socket) do
    Process.send_after(self(), {:run_airport_search, airport}, 500)

    socket =
      assign(socket,
        number: "",
        airport: airport,
        flights: [],
        loading: true
      )

    {:noreply, socket}
  end

  def handle_info({:run_airport_search, airport}, socket) do
    socket =
      case Flights.search_by_airport(airport) do
        [] ->
          socket
          |> put_flash(:info, ~s(No flights matching "#{airport}"))
          |> assign(flights: [], loading: false)

        flights ->
          socket
          |> clear_flash()
          |> assign(flights: flights, loading: false)
      end

    {:noreply, socket}
  end
end
