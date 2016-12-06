# AOC.doit("./6-test.txt")
# AOC.doit("./6-input.txt")

defmodule AOC do

    def doit(inputFilename) do
        inputFileStr = File.read!(inputFilename)
        inputArray = String.split(inputFileStr,"\n", trim: true)

        mostCommonArray = getMostCommon(inputArray, [%{}, %{}, %{}, %{}, %{}, %{}, %{}, %{}])

        Enum.map(mostCommonArray,
        fn(x) ->
            maxVal = Enum.reduce(x, {"0",0},
                fn({k,v}, max) ->
                    if(v > elem(max,1)) do
                        max = put_elem(max,0,k)
                        max = put_elem(max,1,v)
                    else
                        max
                    end
                end)

            IO.inspect maxVal
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
