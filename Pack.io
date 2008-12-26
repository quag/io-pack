Pack := Object clone do(
    
    pack := method(format,
        bytes := Sequence clone
        i := 1
        format foreach(c,
            if (c == "s" at(0),
                bytes appendSeq(call evalArgAt(i))
                bytes append(0)
                i = i + 1
            )
        )

        bytes asString
    )

    unpack := method(format,
        list("test")
    )
)
