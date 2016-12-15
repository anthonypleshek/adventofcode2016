# AOC.doit("./9-test.txt")
# AOC.doit("./9-input.txt")

defmodule AOC do

    def doit(inputFilename) do
        inputFileStr = File.read!(inputFilename) |> String.trim()

        full = decompress(String.codepoints(inputFileStr), 0)
    end

    def decompress([current|codepoints], lengthSum) do
        case current do
            "(" ->
                expandedSum = expand(codepoints, "")
                codepoints = Enum.slice(codepoints, Enum.at(expandedSum, 0), length(codepoints))
                lengthSum = lengthSum + Enum.at(expandedSum, 1)
                decompress(codepoints,lengthSum)
            _ ->
                decompress(codepoints,lengthSum+1)
        end
    end

    def decompress([], lengthSum) do
        lengthSum
    end

    def expand([current|codepoints], marker) do
        case current do
            ")" ->
                markerData = String.split(marker, "x") |> Enum.map(fn str -> String.to_integer(str) end)
                repeatData = Enum.slice(codepoints, 0, Enum.at(markerData,0))
                subSum = decompress(repeatData, 0)
                charCount = String.length(marker) + 1 + Enum.at(markerData,0)
                [charCount,subSum*Enum.at(markerData,1)]
            _ ->
                marker = marker <> current
                expand(codepoints, marker)
        end
    end

end
