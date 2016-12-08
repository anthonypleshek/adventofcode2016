# AOC.doit("./7-testb.txt")
# AOC.doit("./7-input.txt")

defmodule AOC do

    def doit(inputFilename) do
        inputFileStr = File.read!(inputFilename)
        inputArray = String.split(inputFileStr,"\n", trim: true)

        supportsArray = Enum.map(inputArray, fn(x) -> supportsSSL(x) end)

        IO.inspect(supportsArray)
        Enum.reduce(supportsArray, 0, fn(x, acc) -> if x do acc + 1 else acc end end)

    end

    def supportsSSL(str) do
        seqs = splitString(String.codepoints(str), [], [], [])

        abaArray = Enum.at(seqs, 0) |> Enum.reduce([],
                fn(str, abaArray) ->
                    abaArray ++ findAbas(str)
                end)

        babArray = Enum.at(seqs, 1) |> Enum.reduce([],
                fn(str, babArray) ->
                    babArray ++ findAbas(str)
                end)

        Enum.reduce(babArray, false,
                fn(x, hasBab) ->

                    if Enum.member?(abaArray,Enum.join([String.at(x,1),String.at(x,0),String.at(x,1)])) do
                        hasBab = true
                    else
                        hasBab
                    end
                end)
    end

    # def supportsTLS(str) do
    #     # hNetSeqs = Regex.compile!("[a-z]+") |> Regex.scan(str, capture: :first)
    #     seqs = splitString(String.codepoints(str), [], [], [])
    #     IO.inspect(seqs)
    #     hNetHasAbba = Enum.reduce(Enum.at(seqs, 1), false,
    #             fn(str, hasAbba) ->
    #                 if containsAbba?(str) do
    #                     hasAbba = true
    #                 else
    #                     hasAbba
    #                 end
    #             end)
    #     supported = false
    #     if hNetHasAbba == false do
    #         supported = Enum.at(seqs, 0) |> Enum.reduce(false,
    #                 fn(str, hasAbba) ->
    #                     if containsAbba?(str) do
    #                         hasAbba = true
    #                     else
    #                         hasAbba
    #                     end
    #                 end)
    #     end
    #
    #     supported
    # end

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

    def findAbas(str) do
        codepoints = String.codepoints(str)
        # IO.inspect(codepoints)
        foundAbas = []
        if length(codepoints) >= 3 do
            endIndex = length(codepoints) - 3
            range = [0]
            if endIndex > 0 do
                range = Enum.to_list(0..endIndex)
            end
            foundAbas = Enum.reduce(range,[],
                fn(i, foundAbas) ->
                    if String.equivalent?(Enum.at(codepoints, i), Enum.at(codepoints, i+1)) == false
                            && String.equivalent?(Enum.at(codepoints, i), Enum.at(codepoints, i+2)) do
                        aba = Enum.join([Enum.at(codepoints, i), Enum.at(codepoints, i+1), Enum.at(codepoints, i+2)])
                        foundAbas ++ [aba]
                    else
                        foundAbas
                    end

                end)
        end
        IO.inspect(foundAbas)
        foundAbas
    end

end
