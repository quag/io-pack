Pack := Object clone do(
    
    pack := method(format,
        packer := Packer clone
        argIndex := 1
        format foreach(c,
            if (c == "p" at(0),
                packer appendNullTerminatedString(call evalArgAt(argIndex))
                argIndex = argIndex + 1
            )
        )

        packer bytes asString
    )

    unpack := method(format, bytes,
        result := list()

        unpacker := Unpacker clone setBytes(bytes)

        format foreach(c,
            if (c == "p" at(0),
                result append(unpacker unpackNullTerimatedString)
            )
        )

        result
    )
)

Pack Packer := Object clone do(
    bytes := nil

    init := method(
        bytes = Sequence clone
    )

    appendNullTerminatedString := method(string,
        bytes appendSeq(string)
        bytes append(0)
    )
)

Pack Unpacker := Object clone do(
    bytes ::= nil
    byteIndex := 0

    unpackNullTerimatedString := method(
        endIndex := bytes findSeq("\0", byteIndex)
        string := bytes exSlice(byteIndex, endIndex)
        byteIndex = endIndex + 1
        string
    )
)
