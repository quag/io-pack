UnpackTest := UnitTest clone do(
    testSNullStrings := method(
        result := Pack unpack("s", "test\0")
        assertEquals(1, result size)
        assertEquals("test", result at(0))
    )
)
