PackTest := UnitTest clone do(
    testMultipleStrings := method(
        assertEquals("a\0", Pack pack("s", "a"))
        assertEquals("a\0b\0", Pack pack("ss", "a", "b"))
        assertEquals("a\0b\0c\0", Pack pack("sss", "a", "b", "c"))
    )
)
