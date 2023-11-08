defmodule WikiSpider do
  use Crawly.Spider

  def base_url(), do: "https://en.wikipedia.org/"

  # Basic engine for generating item from Wiki Url
  def run(url) do

    response = Crawly.fetch(url)
    {:ok, document} = Floki.parse_document(response.body)

    %{
      title: document |> Floki.find("title") |> Floki.text(),
      url: response.request_url,
      links: grabWikiLinks(document)
    }

  end

  # Basic engine for generating item from Random Wiki Url
  def runRand() do

    {_loc, url} = List.keyfind(Crawly.fetch("https://en.wikipedia.org/wiki/Special:Random").headers, "location", 0)
    response = Crawly.fetch(url)
    {:ok, document} = Floki.parse_document(response.body)

    %{
      title: document |> Floki.find("title") |> Floki.text(),
      url: response.request_url,
      links: grabWikiLinks(document)
    }

  end

  # Helper, that combine links from all known tags and generate list of unique urls
  defp grabWikiLinks(doc) do
    listFrom(doc, "li a")
    |> Enum.concat(listFrom(doc, "div a"))
    |> Enum.concat(listFrom(doc, "td a"))
    |> Enum.concat(listFrom(doc, "p a"))
    |> Enum.uniq()
  end

  # Helper, that find all links by tag, filter only internal wiki links and add to them full url address.
  defp listFrom(doc, tag) do
    doc
    |> Floki.find(tag)
    |> Floki.attribute("href")
    |> Enum.filter(fn x -> String.starts_with?(x, ["/wiki/"]) end)
    |> Enum.map(fn x -> "https://en.wikipedia.org"<>x end)
  end
end
