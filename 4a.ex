# AOC.sectorSum("./4-test.txt")
# AOC.sectorSum("./4-input.txt")

defmodule AOC do

    def sectorSum(inputFilename) do
        inputFileStr = File.read!(inputFilename)
        inputArray = String.split(inputFileStr,"\n", trim: true)

        Enum.reduce(inputArray, 0,
            fn(x, acc)
            -> if isRealRoom?(x) do
                    acc = acc + getSector(x)
                else acc
                end
            end)
    end

    def isRealRoom?(roomStr) do
        roomNameArray = Enum.at(Regex.run(Regex.compile!("([a-z]+\-)+"), roomStr, capture: :first),0)
                |> String.replace("-","")
                |> String.codepoints()

        letterCount = Enum.reduce(roomNameArray, %{},
            fn(x, acc)
            -> if Map.has_key?(acc, x) do
                    Map.update!(acc, x, &(&1 + 1))
                else
                    Map.put(acc, x, 1)
                end
            end)

        orderedStr = getOrderedLetterStr(letterCount, "")

        checkSumArray = getCheckSum(roomStr)

        if checkSumArray == String.slice(orderedStr, 0, 5) do
            true
        else
            false
        end
    end

    def getOrderedLetterStr(letterCount, orderedStr) do
        #find max count
        maxCount = Enum.reduce(letterCount, 0, fn(letter, max) -> if elem(letter, 1) > max do max = elem(letter, 1) else max end end)

        #get all letters at max count
        maxLetters = Enum.reduce(letterCount, [],
                fn(letter, letterArray)
                -> if elem(letter, 1) == maxCount
                    do letterArray ++ [elem(letter, 0)]
                    else letterArray
                end end)
                |> Enum.sort()

        #get first letter and append to String
        orderedStr = orderedStr <> Enum.at(maxLetters, 0)

        #remove letter from letterCount
        letterCount = Map.delete(letterCount, Enum.at(maxLetters, 0))

        if length(Map.keys(letterCount)) > 0 do
            getOrderedLetterStr(letterCount, orderedStr)
        else
            orderedStr
        end
    end

    def getCheckSum(roomStr) do

        #this is gross
        checkSum = Enum.at(Regex.run(Regex.compile!("\[[a-z]{5}\]$"), roomStr, capture: :first),0) |> String.slice(0,5)
    end

    def getSector(roomStr) do
        #y u no "\d"!?!?
        Regex.compile!("[0-9]+")
            |> Regex.run(roomStr, capture: :first)
            |> List.first()
            |> String.to_integer()
    end
end
