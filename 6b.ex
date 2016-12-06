# AOC.doit("./6-test.txt")
# AOC.doit("./6-input.txt")

defmodule AOC do

    def doit(inputFilename) do
        inputFileStr = File.read!(inputFilename)
        inputArray = String.split(inputFileStr,"\n", trim: true)

        mostCommonArray = getMostCommon(inputArray, [%{}, %{}, %{}, %{}, %{}, %{}, %{}, %{}])

        Enum.map(mostCommonArray,
        fn(x) ->
            firstKey = Map.keys(x) |> List.first()
            minVal = Enum.reduce(x, {firstKey,Map.fetch!(x,firstKey)},
                fn({k,v}, min) ->
                    if(v < elem(min,1)) do
                        min = put_elem(min,0,k)
                        min = put_elem(min,1,v)
                    else
                        min
                    end
                end)

            IO.inspect minVal
        end)

        # IO.inspect(maxVals)

        # mostCommonArray
    end

    def getMostCommon([currentLine|inputArray], charCount) do
        currentCP = String.codepoints(currentLine)

        reduced = Enum.reduce(0..7, charCount,
            fn(i, charCount) -> indexMap = Enum.at(charCount, i)
            indexMap = Map.update(indexMap, Enum.at(currentCP,i), 1, &(&1+1))
            charCount = List.replace_at(charCount, i, indexMap)
            end)

        getMostCommon(inputArray, reduced)
    end

    def getMostCommon([], commonCount) do
        commonCount
    end
end
