describe(unpack, "Unpack function",
    unpack("should handle empty format strings",
        Pack unpack("") verify(== list())
    )
)

describe(unpackNullStrings, "Unpacking null terminated strings",
    unpackNullStrings("should unpack a single string",
        Pack unpack("Z", "test\0") verify(== list("test"))
    )

    unpackNullStrings("should unpack multiple strings",
        Pack unpack("ZZZ", "a\0b\0c\0") verify(== list("a", "b", "c"))
    )

    unpackNullStrings("should unpack multiple strings with count",
        Pack unpack("Z3", "a\0b\0c\0") verify(== list("a", "b", "c"))
    )
)

describe(unpackSkip, "Unpack skipping bytes",
    unpackSkip("should skip bytes",
        Pack unpack("ZxZxZx", "a\02b\0\0c\0 ") verify(== list("a", "b", "c"))
    )
)

describe(unpackSpacePadded, "Unpacking space padded strings",
    unpackSpacePadded("should unpack padded strings",
        Pack unpack("A4", "a   ") verify(== list("a"))
    )

    unpackSpacePadded("should unpack zero width string",
        Pack unpack("A0", "") verify(== list(""))
    )

    unpackSpacePadded("should unpack one character strings",
        Pack unpack("A", "a") verify(== list("a"))
        Pack unpack("A1", "a") verify(== list("a"))
    )
)

describe(unpackNullPadded, "Unpacking null padded strings",
    unpackNullPadded("should unpack padded strings",
        Pack unpack("a4", "a\0\0\0") verify(== list("a"))
    )

    unpackNullPadded("should unpack zero width string",
        Pack unpack("a0", "") verify(== list(""))
    )

    unpackNullPadded("should unpack one character strings",
        Pack unpack("a", "a") verify(== list("a"))
        Pack unpack("a1", "a") verify(== list("a"))
    )
)

describe(unpackUnsignedByte, "Unpacking unsigned bytes",
    unpackUnsignedByte("should unpack bytes",
        Pack unpack("CCC", "ABC") verify(== list(65, 66, 67))
    )

    unpackUnsignedByte("should unpack 0xFF as 255 not -1",
        Pack unpack("C", 255 asCharacter) verify(== list(255))
    )
)

describe(unpackSignedByte, "Unpacking signed bytes",
    unpackSignedByte("should unpack bytes",
        Pack unpack("ccc", "ABC") verify(== list(65, 66, 67))
    )

    unpackSignedByte("should unpack 0xFF as -1 not 255",
        Pack unpack("c", 0xFF asCharacter) verify(== list(-1))
    )

    unpackSignedByte("should unpack 0x7F as 127",
        Pack unpack("c", 0x7F asCharacter) verify(== list(127))
    )

    unpackSignedByte("should unpack 0x80 as -128",
        Pack unpack("c", 0x80 asCharacter) verify(== list(-128))
    )
)

describe(unpackBitString, "Unpacking decending bit strings",
    unpackBitString("should handle unpacking a few bits from a bits",
        Pack unpack("B4", "`") verify(== list("0110"))
    )

    unpackBitString("should unpack 8 bits from a byte",
        Pack unpack("B8", "a") verify(== list("01100001"))
    )

    unpackBitString("should unpack 9 bits from two bytes",
        Pack unpack("B9", "3\0") verify(== list("001100110"))
    )

    unpackBitString("should unpack 16 bits from two bytes",
        Pack unpack("B16", "ab") verify(== list("0110000101100010"))
    )
)

describe(unpackBitString, "Unpacking ascending bit string",
    unpackBitString("should handle unpacking a few bits from a bits",
        Pack unpack("b4", "\n") verify(== list("0101"))
    )

    unpackBitString("should unpack 8 bits from a byte",
        Pack unpack("b8", "a") verify(== list("10000110"))
    )

    unpackBitString("should unpack 9 bits from two bytes",
        packed := Pack pack("B8B8", "00111111", "00000001")
        Pack unpack("b9", packed) verify(== list("111111001"))
    )

    unpackBitString("should unpack 16 bits from two bytes",
        Pack unpack("b16", "ab") verify(== list("1000011001000110"))
    )
)

