UnpackTest := UnitTest clone do(
    testMultipleStrings := method(
        assertEquals(list("test"), Pack unpack("s", "test\0"))
        assertEquals(list("a", "b"), Pack unpack("ss", "a\0b\0"))
        assertEquals(list("a", "b", "c"), Pack unpack("sss", "a\0b\0c\0"))
    )
)
