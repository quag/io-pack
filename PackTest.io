PackTest := UnitTest clone do(
    testMultipleStrings := method(
        assertEquals("a\0", Pack pack("p", "a"))
        assertEquals("a\0b\0", Pack pack("pp", "a", "b"))
        assertEquals("a\0b\0c\0", Pack pack("ppp", "a", "b", "c"))
    )

    testNullByte := method(
        assertEquals("\0\0\0", Pack pack("xxx"))
    )
)
