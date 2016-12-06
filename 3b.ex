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

        vertTrianglesArray = getVertTriangles(inputAsIntArrays, 0, [])

        validTriangleCount = Enum.reduce(vertTrianglesArray, 0, fn(x, acc) -> if isValidTriangle?(x) do acc = acc + 1 else acc end end)
    end

    def getVertTriangles([nextInput|inputArrayTail], row, triArray) do
        cond do
            rem(row, 3) == 0 ->
                triArray = triArray ++ [[Enum.at(nextInput,0)]]
                triArray = triArray ++ [[Enum.at(nextInput,1)]]
                triArray = triArray ++ [[Enum.at(nextInput,2)]]
            rem(row, 3) > 0 ->
                triArray = List.update_at(triArray, length(triArray) - 3, &(&1 ++ [Enum.at(nextInput,0)]))
                triArray = List.update_at(triArray, length(triArray) - 2, &(&1 ++ [Enum.at(nextInput,1)]))
                triArray = List.update_at(triArray, length(triArray) - 1, &(&1 ++ [Enum.at(nextInput,2)]))
        end

        getVertTriangles(inputArrayTail, row + 1, triArray)
    end

    def getVertTriangles([], row, triArray) do
        triArray
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
