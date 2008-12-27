UnpackTest := UnitTest clone do(
    testEmptyFormat := method(
        assertEquals(list(), Pack unpack("", ""))
    )

    testMultipleStrings := method(
        assertEquals(list("test"), Pack unpack("p", "test\0"))
        assertEquals(list("a", "b"), Pack unpack("pp", "a\0b\0"))
        assertEquals(list("a", "b", "c"), Pack unpack("ppp", "a\0b\0c\0"))
        assertEquals(list("a", "b", "c"), Pack unpack("p3", "a\0b\0c\0"))
    )

    testSkipByte := method(
        assertEquals(list("a", "b", "c"), Pack unpack("pxpxpx", "a\0\0b\0\0c\0\0"))
        assertEquals(list("test"), Pack unpack("x3p", "\0\0\0test\0"))
    )

    testSpacePaddedString := method(
        assertEquals(list("a"), Pack unpack("A", "a"))
        assertEquals(list("a"), Pack unpack("A3", "a  "))
        assertEquals(list("a", "b", "c"), Pack unpack("A3A3A3", "a  b  c  "))
    )
)
