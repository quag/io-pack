Pack := Object clone do(
    
    pack := method(format,
        bytes := Sequence clone
        argIndex := 1
        format foreach(c,
            if (c == "s" at(0),
                bytes appendSeq(call evalArgAt(argIndex))
                bytes append(0)
                argIndex = argIndex + 1
            )
        )

        bytes asString
    )

    unpack := method(format,
        list("test")
    )
)
