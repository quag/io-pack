Pack := Object clone do(
    
    pack := method(format,
        packer := Packer clone
        argIndex := 1
        Format clone parse(format) instructions foreach(instruction,
            if(instruction name == "p",
                instruction count repeat(
                    packer appendNullTerminatedString(call evalArgAt(argIndex))
                    argIndex = argIndex + 1
                )
            )

            if(instruction name == "A",
                packer appendSpacePaddedString(call evalArgAt(argIndex), instruction count)
                argIndex = argIndex + 1
            )

            if(instruction name == "a",
                packer appendNullPaddedString(call evalArgAt(argIndex), instruction count)
                argIndex = argIndex + 1
            )

            if(instruction name == "B",
                packer appendDecendingBitString(call evalArgAt(argIndex), instruction count)
                argIndex = argIndex + 1
            )

            if(instruction name == "C",
                instruction count repeat(
                    packer appendUnsignedByte(call evalArgAt(argIndex))
                    argIndex = argIndex + 1
                )
            )

            if(instruction name == "c",
                instruction count repeat(
                    packer appendSignedByte(call evalArgAt(argIndex))
                    argIndex = argIndex + 1
                )
            )

            if(instruction name == "x",
                instruction count repeat(
                    packer appendNullByte
                )
            )
        )

        packer bytes asString
    )

    unpack := method(format, bytes,
        result := list()

        unpacker := Unpacker clone setBytes(bytes)

        Format clone parse(format) instructions foreach(instruction,
            if(instruction name == "p",
                instruction count repeat(
                    result append(unpacker unpackNullTerimatedString)
                )
            )

            if(instruction name == "A",
                result append(unpacker unpackSpacePaddedString(instruction count))
            )

            if(instruction name == "a",
                result append(unpacker unpackNullPaddedString(instruction count))
            )

            if(instruction name == "B",
                result append(unpacker unpackDecendingBitString(instruction count))
            )

            if(instruction name == "C",
                instruction count repeat(
                    result append(unpacker unpackUnsignedByte)
                )
            )

            if(instruction name == "c",
                instruction count repeat(
                    result append(unpacker unpackSignedByte)
                )
            )

            if(instruction name == "x",
                instruction count repeat(
                    unpacker skipByte
                )
            )
        )

        result
    )
)

Pack Packer := Object clone do(
    bytes := nil

    init := method(
        bytes = Sequence clone
    )

    appendNullTerminatedString := method(string,
        bytes appendSeq(string)
        appendNullByte
    )

    appendSpacePaddedString := method(string, width,
        bytes appendSeq(string alignLeft(width))
    )

    appendNullPaddedString := method(string, width,
        bytes appendSeq(string alignLeft(width, "\0"))
    )

    appendNullByte := method(
        bytes append(0)
    )

    appendUnsignedByte := method(byte,
        bytes append(byte)
    )

    appendSignedByte := method(byte,
        appendUnsignedByte(byte)
    )

    appendDecendingBitString := method(bitString, bitCount,
        offset := 7
        byte := 0

        bitString foreach(bitCharacter,
            if(bitCharacter == "1" at(0),
                byte = byte + (1 << offset)
            )

            if(bitCharacter == "1" at(0) or bitCharacter == "0" at(0),
                offset = offset - 1

                if(offset < 0,
                    appendUnsignedByte(byte)
                    offset = 7
                    byte = 0
                )
            )
        )

        if(offset != 7,
            appendUnsignedByte(byte)
        )
    )
)

Pack Unpacker := Object clone do(
    bytes ::= nil
    byteIndex := 0

    skipByte := method(
        byteIndex = byteIndex + 1
    )

    unpackNullTerimatedString := method(
        endIndex := bytes findSeq("\0", byteIndex)
        string := bytes exSlice(byteIndex, endIndex)
        byteIndex = endIndex + 1
        string
    )

    unpackSpacePaddedString := method(width,
        string := bytes exSlice(byteIndex, byteIndex + width)
        byteIndex = byteIndex + width
        string asMutable rstrip
    )

    unpackNullPaddedString := method(width,
        string := bytes exSlice(byteIndex, byteIndex + width)
        byteIndex = byteIndex + width

        string = string asMutable
        loop(
            size := string size
            string removeSuffix("\0")

            if(size == string size,
                break
            )
        )

        string
    )

    unpackUnsignedByte := method(
        number := bytes at(byteIndex)
        byteIndex = byteIndex + 1
        number
    )

    unpackSignedByte := method(
        number := unpackUnsignedByte
        if(number > 0x7F,
            number - 0x100
        ,
            number
        )
    )

    unpackDecendingBitString := method(bitCount,
        bitString := Sequence clone
        
        offset := -1
        byte := nil

        bitCount repeat(
            if(offset < 0,
                byte = unpackUnsignedByte
                offset = 7
            )

            bitString appendSeq(if((byte & (1 << offset)) != 0, "1", "0"))
            offset = offset - 1
        )

        bitString asString
    )
)

Pack Format := Object clone do(
    instructions := nil

    parse := method(format,
        instructions = list()
        instruction := nil
        numbers := Sequence clone
        format foreach(c,
            if(c isDigit,
                numbers append(c)
            ,
                if(numbers size != 0,
                    instruction setCount(numbers asNumber)
                    numbers empty
                )

                instruction = Instruction clone setName(c asCharacter)
                instructions append(instruction)
            )
        )

        if(numbers size != 0,
            instruction setCount(numbers asNumber)
            numbers empty
        )

        self
    )

    Instruction := Object clone do(
        name ::= nil
        count ::= 1

        asString := method(
            if(count != nil,
                name .. count
            ,
                name
            )
        )
    )
)
