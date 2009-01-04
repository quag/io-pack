PackTest := UnitTest clone do(
    testEmptyFormat := method(
        assertEquals("", Pack pack(""))
    )

    testMultipleStrings := method(
        assertEquals("a\0", Pack pack("Z", "a"))
        assertEquals("a\0b\0", Pack pack("ZZ", "a", "b"))
        assertEquals("a\0b\0c\0", Pack pack("ZZZ", "a", "b", "c"))
        assertEquals("a\0b\0c\0", Pack pack("Z3", "a", "b", "c"))
    )

    testNullByte := method(
        assertEquals("\0\0\0", Pack pack("xxx"))
        assertEquals("\0\0\0", Pack pack("x3"))
        assertEquals("\0\0a\0", Pack pack("x2Z", "a"))
    )

    testSpacePaddedString := method(
        assertEquals("a", Pack pack("A", "a"))
        assertEquals("a", Pack pack("A1", "a"))
        assertEquals("a ", Pack pack("A2", "a"))
        assertEquals("a  ", Pack pack("A3", "a"))
        assertEquals("b\0", Pack pack("A0Z", "a", "b"))
        assertEquals("abcd", Pack pack("A*", "abcd"))
    )

    testNullPaddedString := method(
        assertEquals("a", Pack pack("a", "a"))
        assertEquals("a", Pack pack("a1", "a"))
        assertEquals("a\0", Pack pack("a2", "a"))
        assertEquals("a\0\0", Pack pack("a3", "a"))
        assertEquals("b\0", Pack pack("a0Z", "a", "b"))
        assertEquals("abcd", Pack pack("a*", "abcd"))
    )

    testUnsignedByte := method(
        assertEquals("ABC", Pack pack("CCC", 65, 66, 67))
        assertEquals(255 asCharacter, Pack pack("C", 255))
        assertEquals(255 asCharacter, Pack pack("C", -1))
    )

    testSignedByte := method(
        assertEquals("ABC", Pack pack("ccc", 65, 66, 67))
        assertEquals(255 asCharacter, Pack pack("c", 255))
        assertEquals(255 asCharacter, Pack pack("c", -1))
    )

    testDecendingBits := method(
        assertEquals("`", Pack pack("B4", "0110"))
        assertEquals("@", Pack pack("B2", "0110"))
        assertEquals("`", Pack pack("B16", "0110"))
        assertEquals("a", Pack pack("B8", "01100001"))
        assertEquals("3\0", Pack pack("B9", "001100110"))
        assertEquals("ab", Pack pack("B16", "0110000101100010"))
    )

    testAscendingBits := method(
        assertEquals("\n", Pack pack("b4", "0101"))
        assertEquals("a", Pack pack("b8", "10000110"))
        assertEquals(list("00111111", "00000001"), Pack unpack("B8B8", Pack pack("b9", "111111001")))
        assertEquals("ab", Pack pack("b16", "1000011001000110"))
    )
)
