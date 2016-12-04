# AOC.validTriangles("./3-input.txt")

defmodule AOC do

    def validTriangles(inputFilename) do
        inputFileStr = File.read!(inputFilename)
        inputArray = String.split(inputFileStr,"\n", trim: true)

        inputAsStrArrays = Enum.map(inputArray, fn(x) -> String.split(x, Regex.compile!("\s"), trim: true) end)

        inputAsIntArrays = Enum.map(inputAsStrArrays,
            fn(x) -> Enum.map(x,
                fn(y) -> String.to_integer(y)
                end)
            end)

        Enum.reduce(inputAsIntArrays, 0, fn(x, acc) -> if isValidTriangle?(x) do acc = acc + 1 else acc end end)
    end

    def isValidTriangle?(sidesArray) do
        valid = false
        sortedSidesArray = Enum.sort(sidesArray)
        if Enum.at(sortedSidesArray,0) + Enum.at(sortedSidesArray,1) > Enum.at(sortedSidesArray, 2) do
            valid = true
        end

        valid
    end
end
