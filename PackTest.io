PackTest := UnitTest clone do(
    testEmptyFormat := method(
        assertEquals("", Pack pack(""))
    )

    testMultipleStrings := method(
        assertEquals("a\0", Pack pack("p", "a"))
        assertEquals("a\0b\0", Pack pack("pp", "a", "b"))
        assertEquals("a\0b\0c\0", Pack pack("ppp", "a", "b", "c"))
        assertEquals("a\0b\0c\0", Pack pack("p3", "a", "b", "c"))
    )

    testNullByte := method(
        assertEquals("\0\0\0", Pack pack("xxx"))
        assertEquals("\0\0\0", Pack pack("x3"))
        assertEquals("\0\0a\0", Pack pack("x2p", "a"))
    )

    testSpacePaddedString := method(
        assertEquals("a", Pack pack("A", "a"))
        assertEquals("a", Pack pack("A1", "a"))
        assertEquals("a ", Pack pack("A2", "a"))
        assertEquals("a  ", Pack pack("A3", "a"))
    )

    testNullPaddedString := method(
        assertEquals("a", Pack pack("a", "a"))
        assertEquals("a", Pack pack("a1", "a"))
        assertEquals("a\0", Pack pack("a2", "a"))
        assertEquals("a\0\0", Pack pack("a3", "a"))
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
)
