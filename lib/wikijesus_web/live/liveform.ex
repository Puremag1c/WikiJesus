defmodule WikijesusWeb.LiveForm do
  use WikijesusWeb, :live_view
  use Phoenix.Component
  alias Wikijesus.Paths

  # URLS var can hold basic text, for inform and arrows
  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: "", status: "Введи любую ссылку на википедию <br> или <br> просто нажми GO, я выберу случайную", urls: ["ПУТЬ ДО СТАТЬИ ОБ <b>ИИСУСЕ</b> БУДЕТ ТУТ"])}
  end

  # Just render
  def render(assigns) do
    ~H"""
    <center>
      <div class="flex-shrink-0 border-transparent border-4 text-teal-500 text-lg py-1 px-2 rounded">
        <%= Phoenix.HTML.raw(@status) %>
      </div>
      <br>
      <form class="w-full max-w-sm" phx-submit="submit_form" phx-change="change_form">
        <div class="flex items-center border-b border-teal-500 py-2">
          <input class="appearance-none bg-transparent border-none w-full text-gray-700 mr-3 py-1 px-2 leading-tight focus:outline-none" type="text" placeholder="https://en.wikipedia.org/" name="link" phx-debounce="300" value={@form} phx-trigger-submit="key-up">
          <button class="flex-shrink-0 bg-teal-500 hover:bg-teal-700 border-teal-500 hover:border-teal-700 text-sm border-4 text-white py-1 px-2 rounded" type="submit">
            GO
          </button>
        </div>
      </form>
      <br>
      <br>
      <.pathToJesus :let={links} urls={@urls}>
        <%= links %>
      </.pathToJesus>
    </center>
    """
  end

  # Helper, that render path urls from assigned list
  def pathToJesus(assigns) do
    ~H"""
    <ul>
      <%= for url <- @urls do %>
        <%= if isWikiLink?(url) do %>
          <li><%= render_slot(@inner_block, Phoenix.HTML.raw("<a class='font-medium text-blue-600 dark:text-blue-500 hover:underline' href='"<>url<>"'>"<>url<>"</a>")) %></li>
        <% else %>
          <li><%= render_slot(@inner_block, Phoenix.HTML.raw(url)) %></li>
        <% end %>
      <% end %>
    </ul>
    """
  end

  # Submit Form Event Handler, that check given link, starts path finder and add result to DB and view
  def handle_event("submit_form", %{"link" => link}, socket) do
    {status, links} =
      if isWikiLink?(link) or link == "" do
        {"ГОТОВО, ДАВАЙ ЕЩЕ?)", runMachine(link)}
      else
        {"НЕВЕРНАЯ ССЫЛКА, ДОЛЖНА БЫТЬ ТАКАЯ <br> <b>https://en.wikipedia.org/wiki/WHATEVER</b> <br> ПОПРОБУЙ ЕЩЕ РАЗ", ["ПУТЬ ДО СТАТЬИ ОБ <b>ИИСУСЕ</b> БУДЕТ ТУТ"]}
      end
      Paths.create_path(%{link: List.first(links), path: links})
    {:noreply, assign(socket, status: status, urls: Enum.join(links, ",↓,") |> String.split(","), form: "")}
  end

  # Change From handler for interactive statuses
  def handle_event("change_form", %{"link" => link}, socket) do
    {:noreply, assign(socket, status: checkForm(link) )}
  end

  # Helper, that define what WikiSpider funtcion needed to run and got path from it to jesus
  defp runMachine(link) do
    if link == "", do: WikiSpider.runRand() |> Wikijesus.getPath(), else: WikiSpider.run(link) |> Wikijesus.getPath()
  end

  # Basic form checker for interactive statuses
  defp checkForm(link) do
    case String.trim(link, "https://en.wikipedia.org/wiki/") do
      ^link -> if link == "", do: "Введи любую ссылку на википедию <br> или <br> просто нажми GO, я выберу случайную", else: "НЕВЕРНАЯ ССЫЛКА, ДОЛЖНА БЫТЬ ТАКАЯ <br> <b>https://en.wikipedia.org/wiki/WHATEVER</b>"
      "" -> "ПОЧТИ - ССЫЛКА ДОЛЖНА БЫТЬ <br> <b>https://en.wikipedia.org/wiki/WHATEVER </b>"
      _ -> "КАЖЕТСЯ ВСЕ ХОРОШО, ЖМИ GO"
    end
  end

  # Basic helper to get boolean value about given link Wiki or Not
  def isWikiLink?(link) do
    case String.trim(link, "https://en.wikipedia.org/wiki/") do
      ^link -> false
      "" -> false
      _ -> true
    end
  end

end
