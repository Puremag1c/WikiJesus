defmodule Wikijesus do
  @moduledoc """
  Wikijesus keeps the business logic functions.
  Find and construct path to Jesus wiki page.
  """

  # Main function, that search some known links on given item from crawly and if not,
  # uses random clicker for next url and txt files with known links for best path
  def getPath(item, path \\ []) do

    jesuslist = readFileToList("./jesus.txt")
    religionlist = readFileToList("./religion.txt")

    cond do
      item.url == "https://en.wikipedia.org/wiki/Jesus" -> path ++ [item.url]
      item.url == "https://en.wikipedia.org/wiki/Jesus_Christ" -> path ++ [item.url]
      Enum.member?(jesuslist, item.url) -> path ++ [item.url, "https://en.wikipedia.org/wiki/Jesus"]
      Enum.member?(religionlist, item.url) -> path ++ [item.url, "https://en.wikipedia.org/wiki/Religion", "https://en.wikipedia.org/wiki/Jesus"]
      Enum.any?(item.links, fn x -> Enum.member?(jesuslist, x) end) -> path ++ findKnownLink(item, jesuslist, :jesus)
      Enum.any?(item.links, fn x -> Enum.member?(religionlist, x) end) -> path ++ findKnownLink(item, religionlist, :religion)
      true -> crazyRandomMachine(item, path)
    end
  end

  # Function, that click on random links from item and search for adequate link for next iteration
  defp crazyRandomMachine(item, path) do
    newitem =  WikiSpider.run(Enum.random(item.links))
    cond do
      length(newitem.links) == 0 -> crazyRandomMachine(item, path)
      String.trim(newitem.url, "https://en.wikipedia.org") == newitem.url -> crazyRandomMachine(item, path)
      true -> getPath(newitem, path ++ [item.url])
    end
  end

  # Helper that find concrete url, that send us to jesus page
  def findKnownLink(item, knownlinks, :jesus) do
    {result, _other} =
      Enum.split(Enum.reduce(item.links, [item.url], fn x, acc ->
        if Enum.member?(knownlinks, x), do: acc ++ [x], else: acc
      end), 2)
    result ++ ["https://en.wikipedia.org/wiki/Jesus"]
  end

  # Helper that find concrete url, that send us to religion page
  def findKnownLink(item, knownlinks, :religion) do
    {result, _other} =
      Enum.split(Enum.reduce(item.links, [item.url], fn x, acc ->
        if Enum.member?(knownlinks, x), do: acc ++ [x], else: acc
      end), 2)
    result ++ ["https://en.wikipedia.org/wiki/Religion", "https://en.wikipedia.org/wiki/Jesus"]
  end

  # OTHER HELPERS FOR MANAGE LIST OF STRINGS(URLs) IN TXT FILES

  def writeListToFile(list, filepath) do
    list
    |> Enum.reduce("", fn y, acc -> acc <> y <>", " end)
    |> String.trim_trailing(", ")
    |> then(fn x -> File.write(filepath, x) end)
  end

  def grabFromUrlToFile(url, filepath) do
    writeListToFile(WikiSpider.run(url).links, filepath)
  end

  def readFileToList(filepath) do
    String.split(File.read!(filepath), ", ")
  end

  def updateFileByList(list, filepath) do
    oldlist = if readFileToList(filepath) == [""], do: [], else: readFileToList(filepath)
    oldlist
    |> Enum.concat(list)
    |> Enum.uniq()
    |> then(fn x -> File.write(filepath, Enum.reduce(x, "", fn y, acc -> acc <> y <>", " end)) end)
  end

  def updateFileByString(string, filepath) do
    newstring = if File.read!(filepath) == "", do: string, else: File.read!(filepath)<>", "<>string
    File.write(filepath, newstring)
  end

  def removeElementFromFile(string, filepath) do
    list = readFileToList(filepath)
    list
    |> Enum.find_index(fn x -> x == string end)
    |> then( fn y -> List.delete_at(list, y) end)
    |> then(fn v -> File.write(filepath, Enum.reduce(v, "", fn z, acc -> acc <> z <>", " end)) end)
  end

  # Helper function, that i use to create base wiki links to optimize paths, with saving results.
  def checkFileLinksToUrl(basefilepath, targetfilepath, url) do
    Enum.map(readFileToList(basefilepath), fn x ->
      if Enum.member?(WikiSpider.run(x).links, url) do
        updateFileByString(x, targetfilepath)
        removeElementFromFile(x, basefilepath)
      else
        removeElementFromFile(x, basefilepath)
      end
    end)
  end

end
