# AOC.doit("./9-test.txt")
# AOC.doit("./9-input.txt")

defmodule AOC do

    def doit(inputFilename) do
        inputFileStr = File.read!(inputFilename) |> String.trim()

        full = decompress(String.codepoints(inputFileStr), "")

        IO.puts(full)

        String.length(full)
    end

    def decompress([current|codepoints], result) do
        IO.puts(result)
        case current do
            "(" ->
                expanded = expand(codepoints, "", "")
                codepoints = Enum.slice(codepoints, Enum.at(expanded, 0), length(codepoints))
                IO.inspect(expanded)
                result = result <> Enum.at(expanded, 1)
                decompress(codepoints,result)
            _ ->
                decompress(codepoints,result<>current)
        end
    end

    def decompress([], result) do
        result
    end

    def expand([current|codepoints], marker, expansionResult) do
        case current do
            ")" ->
                IO.puts(marker)
                markerData = String.split(marker, "x") |> Enum.map(fn str -> String.to_integer(str) end)
                # Append next markerData[1] chars from codepoints to result markerData[0] times
                repeatData = Enum.slice(codepoints, 0, Enum.at(markerData,0))
                expansionResult = for _ <- 1..Enum.at(markerData,1) do
                    expansionResult = expansionResult <> Enum.join(repeatData)
                end
                expansionResult = Enum.join(expansionResult)
                charCount = String.length(marker) + 1 + Enum.at(markerData,0)
                [charCount,expansionResult]
            _ ->
                marker = marker <> current
                expand(codepoints, marker, expansionResult)
        end
    end

end
