defmodule LiveViewStudioWeb.AutocompleteLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.{Cities, Stores}

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        zip: "",
        city: "",
        stores: [],
        matches: [],
        loading: false
      )

    {:ok, socket, temporary_assigns: [stores: [], matches: []]}
  end

  def render(assigns) do
    ~H"""
    <h1>Find a Store</h1>
    <div id="search">

      <form phx-submit="zip-search">
        <input type="text" name="zip" value={@zip}
               placeholder="Zip Code"
               autofocus autocomplete="off"
               readonly={@loading} />

        <button type="submit">
          <img src="images/search.svg">
        </button>
      </form>

      <form phx-submit="city-search" phx-change="suggest-city">
        <input type="text" name="city" value={@city}
               placeholder="City"
               autocomplete="off"
               list="matches"
               phx-debounce="1000"
               readonly={@loading} />

        <button type="submit">
          <img src="images/search.svg">
        </button>
      </form>

      <datalist id="matches">
        <%= for match <- @matches do %>
          <option value={match}><%= match %></option>
        <% end %>
      </datalist>


      <%= if @loading do %>
        <div class="loader">
          Loading...
        </div>
      <% end %>

      <div class="stores">
        <ul>
          <%= for store <- @stores do %>
            <li>
              <div class="first-line">
                <div class="name">
                  <%= store.name %>
                </div>
                <div class="status">
                  <%= if store.open do %>
                    <span class="open">Open</span>
                  <% else %>
                    <span class="closed">Closed</span>
                  <% end %>
                </div>
              </div>
              <div class="second-line">
                <div class="street">
                  <img src="images/location.svg">
                  <%= store.street %>
                </div>
                <div class="phone_number">
                  <img src="images/phone.svg">
                  <%= store.phone_number %>
                </div>
              </div>
            </li>
          <% end %>
        </ul>
      </div>
    </div>
    """
  end

  def handle_event("zip-search", %{"zip" => zip}, socket) do
    Process.send_after(self(), {:zip_search, zip}, 500)

    socket =
      assign(socket,
        zip: zip,
        stores: [],
        loading: true
      )

    {:noreply, socket}
  end

  def handle_event("suggest-city", %{"city" => prefix}, socket) do
    socket = assign(socket, matches: Cities.suggest(prefix))
    {:noreply, socket}
  end

  def handle_event("city-search", %{"city" => city}, socket) do
    Process.send_after(self(), {:city_search, city}, 500)

    socket =
      assign(socket,
        city: city,
        stores: [],
        loading: true
      )

    {:noreply, socket}
  end

  def handle_info({:zip_search, zip}, socket) do
    socket =
      case Stores.search_by_zip(zip) do
        [] ->
          socket
          |> put_flash(:info, ~s(No stores matching "#{zip}"))
          |> assign(stores: [], loading: false)

        stores ->
          socket
          |> assign(stores: stores, loading: false)
      end

    {:noreply, socket}
  end

  def handle_info({:city_search, city}, socket) do
    socket =
      case Stores.search_by_city(city) do
        [] ->
          socket
          |> put_flash(:info, ~s(No stores matching "#{city}"))
          |> assign(stores: [], loading: false)

        stores ->
          socket
          |> assign(stores: stores, loading: false)
      end

    {:noreply, socket}
  end
end
