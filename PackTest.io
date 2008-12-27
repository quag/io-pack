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
    )

    testSpacePaddedString := method(
        assertEquals("a", Pack pack("A", "a"))
        assertEquals("a", Pack pack("A1", "a"))
        assertEquals("a ", Pack pack("A2", "a"))
        assertEquals("a  ", Pack pack("A3", "a"))
    )
)
