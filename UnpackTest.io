UnpackTest := UnitTest clone do(
    testMultipleStrings := method(
        assertEquals(list("test"), Pack unpack("p", "test\0"))
        assertEquals(list("a", "b"), Pack unpack("pp", "a\0b\0"))
        assertEquals(list("a", "b", "c"), Pack unpack("ppp", "a\0b\0c\0"))
    )
)
