# AOC.doit("./8-test.txt")
# AOC.doit("./8-input.txt")

defmodule AOC do

    def doit(inputFilename) do
        inputFileStr = File.read!(inputFilename)
        inputArray = String.split(inputFileStr,"\n", trim: true)

        #initialize board
        display = Enum.map 1..300, fn _ -> false end
        rowLength = 50
        columnLength = 6
        # display = Enum.map 1..9, fn _ -> false end
        # rowLength = 3
        # columnLength = 3

        display = followInstructions(inputArray, display, rowLength, columnLength)

        printDisplay(display, rowLength)

        Enum.reduce(display,0,
                fn(on,sum) ->
                    if on==true do
                        sum = sum+1
                    else
                        sum
                    end
                end)
    end

    def followInstructions([current|instructions], display, rowLength, columnLength) do
        # case current do
        #     String.starts_with?(current, "rect") ->
        #         parseRect(current, display, rowLength)
        #     # String.starts_with?(current, "rotate column x") ->
        #     #     #
        #     # String.starts_with?(current, "rotate row y") ->
        #     #     #
        #     _ ->
        #         # Nothing
        # end

        if String.starts_with?(current, "rect") do
            display = parseRect(String.split(current)|>Enum.at(1), display, rowLength)
        end

        if String.starts_with?(current, "rotate column x") do
            display = parseRotateColumn(String.split(current, "=")|>Enum.at(1), display, rowLength, columnLength)
        end

        if String.starts_with?(current, "rotate row y") do
            display = parseRotateRow(String.split(current, "=")|>Enum.at(1), display, rowLength, columnLength)
        end

        # printDisplay(display, rowLength)

        followInstructions(instructions, display, rowLength, columnLength)
    end

    def followInstructions([], display, rowLength, columnLength) do
        display
    end

    def printDisplay(display, rowLength) do
        output = Enum.reduce(display, "\n",
                fn(px, acc)->
                    if rem(String.length(acc),rowLength+1) == 0 do
                        acc = acc <> "\n"
                    end
                    if px == true do
                        acc = acc <> "1"
                    else
                        acc = acc <> " "
                    end
                end)
        IO.puts(output)
    end

    def parseRotateRow(str, display, rowLength, columnLength) do
        dirStrArray = String.split(str," by ")

        # Lame hack for fixing rotateNumber
        rotateRow(String.to_integer(Enum.at(dirStrArray,0)), 0, false, String.to_integer(Enum.at(dirStrArray,1))-1, display, rowLength, columnLength)
    end

    def rotateRow(y, xCur, newValue, rotateNumber, display, rowLength, columnLength) do
        cond do
            xCur == rowLength ->
                display = List.replace_at(display,y*rowLength,newValue)
                case rotateNumber do
                    0 ->
                        display
                    _ ->
                        rotateRow(y, 0, false, rotateNumber-1, display, rowLength, columnLength)
                end
            xCur == 0 ->
                nextValue = Enum.at(display, y*rowLength)
                rotateRow(y, xCur+1, nextValue, rotateNumber, display, rowLength, columnLength)
            true ->
                nextValue = Enum.at(display, y*rowLength+xCur)
                display = List.replace_at(display,y*rowLength+xCur,newValue)
                rotateRow(y, xCur+1, nextValue, rotateNumber, display, rowLength, columnLength)
        end
    end

    def parseRotateColumn(str, display, rowLength, columnLength) do
        dirStrArray = String.split(str," by ")

        # Lame hack for fixing rotateNumber
        rotateColumn(String.to_integer(Enum.at(dirStrArray,0)), 0, false, String.to_integer(Enum.at(dirStrArray,1))-1, display, rowLength, columnLength)
    end

    def rotateColumn(x, yCur, newValue, rotateNumber, display, rowLength, columnLength) do
        cond do
            yCur == columnLength ->
                display = List.replace_at(display,x,newValue)
                case rotateNumber do
                    0 ->
                        display
                    _ ->
                        rotateColumn(x, 0, false, rotateNumber-1, display, rowLength, columnLength)
                end
            yCur == 0 ->
                nextValue = Enum.at(display, x)
                rotateColumn(x, yCur+1, nextValue, rotateNumber, display, rowLength, columnLength)
            true ->
                nextValue = Enum.at(display, yCur*rowLength+x)
                display = List.replace_at(display,yCur*rowLength+x,newValue)
                rotateColumn(x, yCur+1, nextValue, rotateNumber, display, rowLength, columnLength)
        end
    end

    def parseRect(sizeStr, display, rowLength) do
        size = String.split(sizeStr, "x")

        rect(0, 0, String.to_integer(Enum.at(size,0)), String.to_integer(Enum.at(size,1)), display, rowLength)
    end

    def rect(xCur, yCur, xMax, yMax, display, rowLength) do
        case yMax-yCur do
            0 ->
                display
            _ ->
                case xMax-xCur do
                    0 ->
                        rect(0,yCur+1,xMax,yMax,display,rowLength)
                    _ ->
                        display = List.replace_at(display,yCur*rowLength+xCur,!Enum.at(display,yCur*rowLength+xCur))
                        rect(xCur+1,yCur,xMax,yMax,display,rowLength)
                end
        end
    end

end
