# AOC.npObjects("./4-test.txt")
# AOC.npObjects("./4-input.txt")

defmodule AOC do

    def npObjects(inputFilename) do
        inputFileStr = File.read!(inputFilename)
        inputArray = String.split(inputFileStr,"\n", trim: true)

        realRooms = Enum.reduce(inputArray, [],
            fn(x, realRooms)
            -> if isRealRoom?(x) do
                    realRooms = realRooms ++ [x]
                else
                    realRooms
                end
            end)

        decryptedList = decryptNames(realRooms, [])

        "done"
    end

    def decryptNames(encryptedNames, decryptedNames) do
        if length(encryptedNames) > 0 do
            rotate = getSector(List.first(encryptedNames))

            encryptedName = Regex.compile!("([a-z]+\-)+")
                |> Regex.run(List.first(encryptedNames), capture: :first)
                |> Enum.at(0)
                |> String.replace("-", " ")
                |> String.to_charlist()

            codepointOffset = 97

            decryptedName = Enum.reduce(encryptedName, "",
                fn(letter, decrypted)
                -> if letter != ' ' do
                    newLetter = rem(letter - codepointOffset + rotate, 26) + codepointOffset
                    newLetter = << newLetter :: utf8 >>
                    decrypted = decrypted <> newLetter
                else
                    decrypted = decrypted <> " "
                end

                end)

            if(String.contains?(decryptedName, "north")) do
                IO.inspect({decryptedName, rotate})
            end

            decryptNames(List.delete_at(encryptedNames, 0),decryptedNames ++ [{decryptedName,rotate}])
        else
            decryptedNames
        end
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
