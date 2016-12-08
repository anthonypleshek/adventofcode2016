# AOC.doit("./7-test.txt")
# AOC.doit("./7-input.txt")

defmodule AOC do

    def doit(inputFilename) do
        inputFileStr = File.read!(inputFilename)
        inputArray = String.split(inputFileStr,"\n", trim: true)

        supportsArray = Enum.map(inputArray, fn(x) -> supportsTLS(x) end)

        IO.inspect(supportsArray)
        Enum.reduce(supportsArray, 0, fn(x, acc) -> if x do acc + 1 else acc end end)

    end

    def supportsTLS(str) do
        # hNetSeqs = Regex.compile!("[a-z]+") |> Regex.scan(str, capture: :first)
        seqs = splitString(String.codepoints(str), [], [], [])
        IO.inspect(seqs)
        hNetHasAbba = Enum.reduce(Enum.at(seqs, 1), false,
                fn(str, hasAbba) ->
                    if containsAbba?(str) do
                        hasAbba = true
                    else
                        hasAbba
                    end
                end)
        supported = false
        if hNetHasAbba == false do
            supported = Enum.at(seqs, 0) |> Enum.reduce(false,
                    fn(str, hasAbba) ->
                        if containsAbba?(str) do
                            hasAbba = true
                        else
                            hasAbba
                        end
                    end)
        end

        supported
    end

    # got fed up with regex :(
    def splitString([cp|codepoints], currentStrArr, seqs, hNetSeqs) do
        case cp do
            "[" ->
                if length(currentStrArr) > 0 do
                    seqs = seqs ++ [Enum.join(currentStrArr)]
                    currentStrArr = []
                end
            "]" ->
                hNetSeqs = hNetSeqs ++ [Enum.join(currentStrArr)]
                currentStrArr = []
            _ ->
                currentStrArr = currentStrArr ++ [cp]
        end

        splitString(codepoints, currentStrArr, seqs, hNetSeqs)
    end

    def splitString([], currentStrArr, seqs, hNetSeqs) do
        if length(currentStrArr) > 0 do
            seqs = seqs ++ [Enum.join(currentStrArr)]
        end
        [seqs, hNetSeqs]
    end

    def containsAbba?(str) do
        codepoints = String.codepoints(str)
        # IO.inspect(codepoints)
        found = false
        if length(codepoints) >= 4 do
            endIndex = length(codepoints) - 4
            range = [0]
            if endIndex > 0 do
                range = Enum.to_list(0..endIndex)
            end
            found = Enum.reduce(range,false,
                fn(i, found) ->
                    if String.equivalent?(Enum.at(codepoints, i), Enum.at(codepoints, i+1)) == false
                            && String.equivalent?(Enum.at(codepoints, i), Enum.at(codepoints, i+3))
                            && String.equivalent?(Enum.at(codepoints, i+1), Enum.at(codepoints, i+2)) do
                        found = true
                    else
                        found
                    end

                end)
        end
        found
    end

end
