describe(pack, "Pack function",
    pack("should handle empty format strings",
        Pack pack("") verify(== "")
    )
)

describe(packNullStrings, "Packing null terminated strings",
    packNullStrings("should handle a single string",
        Pack pack("Z", "abc") verify(== "abc\0")
    )

    packNullStrings("should handle multiple strings",
        Pack pack("ZZZ", "a", "b", "c") verify(== "a\0b\0c\0")
    )

    packNullStrings("should handle multiple when using counts",
        Pack pack("Z3", "a", "b", "c") verify(== "a\0b\0c\0")
    )
)

describe(packNull, "Packing nulls",
    packNull("should append null bytes for 'x' instruction",
        Pack pack("xxx") verify(== "\0\0\0")
    )

    packNull("should append multiple null bytes when count >1",
        Pack pack("x3") verify(== "\0\0\0")
    )

    packNull("should not use argument for null byte instructions",
        Pack pack("xZ", "a") verify(== "\0a\0")
    )
)

describe(packSpacePadded, "Packing space padded strings",
    packSpacePadded("should pad string",
        Pack pack("A4", "ab") verify(== "ab  ")
    )

    packSpacePadded("should handle single width strings",
        Pack pack("A", "a") verify(== "a")
        Pack pack("A1", "a") verify(== "a")
    )

    packSpacePadded("should omit string when width is zero",
        Pack pack("A0Z", "a", "b") verify(== "b\0")
    )

    packSpacePadded("should pad empty strings out to the width",
        Pack pack("A4", "") verify(== "    ")
    )

    packSpacePadded("should use * to mean as wide as is needed",
        Pack pack("A*", "abcd") verify(== "abcd")
    )
)

describe(packNullPadded, "Packing null padded strings",
    packNullPadded("should pad string",
        Pack pack("a4", "ab") verify(== "ab\0\0")
    )

    packNullPadded("should handle single width strings",
        Pack pack("a", "a") verify(== "a")
        Pack pack("a1", "a") verify(== "a")
    )

    packNullPadded("should omit string when width is zero",
        Pack pack("a0Z", "a", "b") verify(== "b\0")
    )

    packNullPadded("should pad empty strings out to the width",
        Pack pack("a4", "") verify(== "\0\0\0\0")
    )

    packNullPadded("should use * to mean as wide as is needed",
        Pack pack("a*", "abcd") verify(== "abcd")
    )
)

describe(packUnsignedByte, "Packing unsigned bytes",
    packUnsignedByte("should handle unsigned bytes",
        Pack pack("CCC", 65, 66, 67) verify(== "ABC")
    )

    packUnsignedByte("should pack 255 as 0xFF",
        Pack pack("C", 255) verify(== 0xFF asCharacter)
    )

    packUnsignedByte("should pack -1 as 0xFF",
        Pack pack("C", -1) verify(== 0xFF asCharacter)
    )

    packUnsignedByte("should pack 256 as 0x00",
        Pack pack("C", 256) verify(== 0x00 asCharacter)
    )
)

describe(packSignedByte, "Packing signed bytes",
    packSignedByte("should handle signed bytes",
        Pack pack("ccc", 65, 66, 67) verify(== "ABC")
    )

    packSignedByte("should pack 255 as 0xFF",
        Pack pack("c", 255) verify(== 0xFF asCharacter)
    )

    packSignedByte("should pack -1 as 0xFF",
        Pack pack("c", -1) verify(== 0xFF asCharacter)
    )

    packSignedByte("should pack 256 as 0x00",
        Pack pack("c", 256) verify(== 0x00 asCharacter)
    )
)

describe(packBitString, "Packing decending bit strings",
    packBitString("should handle less than a byte's worth of bits",
        Pack pack("B4", "0110") verify(== "`")
    )

    packBitString("should ignore extra bits in the bit string",
        Pack pack("B2", "0110") verify(== "@")
    )

    packBitString("should only append bits from the bit string",
        Pack pack("B16", "0110") verify(== "`")
    )

    packBitString("should pack 8 bits into a single byte",
        Pack pack("B8", "01100001") verify(== "a")
    )

    packBitString("should pack 9 bits into two bytes",
        Pack pack("B9", "001100110") verify("3\0")
    )

    packBitString("should pack 16 bits into two bytes",
        Pack pack("B16", "0110000101100010") verify(== "ab")
    )
)

describe(packBitString, "Packing ascending bit string",
    packBitString("should handle less than a byte's worth of bits",
        Pack pack("b4", "0101") verify(== "\n")
    )

    packBitString("should pack 8 bits into a single byte",
        Pack pack("b8", "10000110") verify(== "a")
    )

    packBitString("should pack 9 bits into two bytes",
        packed := Pack pack("b9", "111111001")
        verify(Pack unpack("B8B8", packed) == list("00111111", "00000001"))
    )

    packBitString("should pack 16 bits into two bytes",
        Pack pack("b16", "1000011001000110")
    )
)

