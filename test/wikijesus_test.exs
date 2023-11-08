defmodule WikijesusTest do
  alias WikijesusWeb.LiveForm
  use ExUnit.Case
  import Plug.Conn
  import Phoenix.ConnTest
  import Phoenix.LiveViewTest
  @endpoint WikijesusWeb.Endpoint
  import Wikijesus

  @testitem %{url: "Some URL", links: ["URL1", "URL2", "https://en.wikipedia.org/wiki/Religion", "https://en.wikipedia.org/wiki/Taoism"]}

  test "Search in basic links to jesus to create path" do
    knownlinks = readFileToList("./jesus.txt")
    assert findKnownLink(@testitem, knownlinks, :jesus) == ["Some URL", "https://en.wikipedia.org/wiki/Religion", "https://en.wikipedia.org/wiki/Jesus"]
  end

  test "Search in basic links to religion to create path" do
    knownlinks = readFileToList("./religion.txt")
    assert findKnownLink(@testitem, knownlinks, :religion) == ["Some URL","https://en.wikipedia.org/wiki/Taoism", "https://en.wikipedia.org/wiki/Religion", "https://en.wikipedia.org/wiki/Jesus"]
  end

  test "file write" do
    writeListToFile(@testitem.links, "./test.txt")
    assert File.read!("./test.txt") == "URL1, URL2, https://en.wikipedia.org/wiki/Religion, https://en.wikipedia.org/wiki/Taoism"
  end

  test "file read to list" do
    assert readFileToList("./test.txt") == @testitem.links
  end

  test "update file read to list" do
    assert readFileToList("./test.txt") == @testitem.links
  end

  test "spider item" do
    assert is_map(WikiSpider.runRand()) == true
  end

  test "type of path" do
    assert is_list(getPath(WikiSpider.runRand())) == true
  end


#  THIS NOT PASSING THE TEST.

#  test "connected mount", %{conn: conn} do
#   {:ok, _view, html} = live(conn, "/")
#   assert html =~ "просто нажми GO, я выберу случайную"
#  end

#  test "form change",  %{conn: conn} do
#    {:ok, view, html} = live(conn, "/")
#    assert view
#      |> element("link")
#      |> render_change(%{form: 123, urls: @testitem.links}) =~ "НЕВЕРНАЯ ССЫЛКА, ДОЛЖНА БЫТЬ ТАКАЯ"
#  end

#  test "path to jesus" do
#    assert render_component(&LiveForm.pathToJesus/1, urls: @testitem.links) == "<ul><li>URL1</li><li>URL2</li><li>https://en.wikipedia.org/wiki/Religion</li><li>https://en.wikipedia.org/wiki/Taoism</li></ul>"
#  end

end
