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

    testNullPaddedString := method(
        assertEquals(list("a"), Pack unpack("a", "a"))
        assertEquals(list("a"), Pack unpack("a3", "a\0\0"))
        assertEquals(list("a", "b", "c"), Pack unpack("a3a3a3", "a\0\0b\0\0c\0\0"))
    )

    testUnsignedByte := method(
        assertEquals(list(65, 66, 67), Pack unpack("CCC", "ABC"))
        assertEquals(list(255), Pack unpack("C", 255 asCharacter))
    )

    testSignedByte := method(
        assertEquals(list(65, 66, 67), Pack unpack("ccc", "ABC"))
        assertEquals(list(-1), Pack unpack("c", 255 asCharacter))
        assertEquals(list(127), Pack unpack("c", 127 asCharacter))
        assertEquals(list(-128), Pack unpack("c", 128 asCharacter))
    )

    testDecendingBits := method(
        assertEquals(list("0110"), Pack unpack("B4", "`"))
        assertEquals(list("01100001"), Pack unpack("B8", "a"))
        assertEquals(list("001100110"), Pack unpack("B9", "3\0"))
        assertEquals(list("0110000101100010"), Pack unpack("B16", "ab"))
    )
)
