UnpackTest := UnitTest clone do(
    testEmptyFormat := method(
        assertEquals(list(), Pack unpack("", ""))
    )

    testMultipleStrings := method(
        assertEquals(list("test"), Pack unpack("Z", "test\0"))
        assertEquals(list("a", "b"), Pack unpack("ZZ", "a\0b\0"))
        assertEquals(list("a", "b", "c"), Pack unpack("ZZZ", "a\0b\0c\0"))
        assertEquals(list("a", "b", "c"), Pack unpack("Z3", "a\0b\0c\0"))
    )

    testSkipByte := method(
        assertEquals(list("a", "b", "c"), Pack unpack("ZxZxZx", "a\0\0b\0\0c\0\0"))
        assertEquals(list("test"), Pack unpack("x3Z", "\0\0\0test\0"))
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

    testAscendingBits := method(
        assertEquals(list("0101"), Pack unpack("b4", "\n"))
        assertEquals(list("10000110"), Pack unpack("b8", "a"))
        assertEquals(list("111111001"), Pack unpack("b9", Pack pack("B8B8", "00111111", "00000001")))
        assertEquals(list("1000011001000110"), Pack unpack("b16", "ab"))
    )
)
