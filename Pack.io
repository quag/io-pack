Pack := Object clone do(
    
    pack := method(format,
        bytes := Sequence clone
        argIndex := 1
        format foreach(c,
            if (c == "p" at(0),
                bytes appendSeq(call evalArgAt(argIndex))
                bytes append(0)
                argIndex = argIndex + 1
            )
        )

        bytes asString
    )

    unpack := method(format, bytes,
        result := list()

        byteIndex := 0

        format foreach(c,
            if (c == "p" at(0),
                endIndex := bytes findSeq("\0", byteIndex)
                result append(bytes exSlice(byteIndex, endIndex))
                byteIndex = endIndex + 1
            )
        )

        result
    )
)
