Pack := Object clone do(
    
    pack := method(format,
        packer := Packer clone
        argIndex := 1

        Format parse(format) foreach(instruction,
            packer doMessage(
                instruction appendMessage(
                    value := call evalArgAt(argIndex)
                    argIndex = argIndex + 1
                    value
                )
            )
        )

        packer bytes asString
    )

    unpack := method(format, bytes,
        results := list()

        unpacker := Unpacker clone setBytes(bytes)

        Format parse(format) foreach(instruction,
            value := unpacker doMessage(instruction unpackMessage)

            if(instruction hasValue,
                results append(value)
            )
        )

        results
    )
)

Pack Format := Object clone do(
    instructionProtos := Map clone

    parse := method(format,
        instructions := list()
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

                instruction = instructionProtos at(c asCharacter) clone
                instructions append(instruction)
            )
        )

        if(numbers size != 0,
            instruction setCount(numbers asNumber)
            numbers empty
        )

        unrollRepeats(instructions)
    )

    unrollRepeats := method(instructions,
        unrolled := list()

        instructions foreach(instruction,
            instruction repeatCount repeat(
                unrolled append(instruction)
            )
        )

        unrolled
    )

    Instruction := Object clone do(
        character ::= nil
        count ::= 1
        appendName ::= nil
        unpackName ::= nil
        usesCount ::= false
        hasValue ::= true

        repeatCount := method(
            if(usesCount, 1, count)
        )

        appendMessage := method(
            m := Message clone setName(appendName)

            if(hasValue,
                m appendCachedArg(call evalArgAt(0))
            )

            if(usesCount,
                m appendCachedArg(count)
            )

            m
        )

        unpackMessage := method(
            m := Message clone setName(unpackName)

            if(usesCount,
                m appendCachedArg(count)
            )

            m
        )

        setNames := method(baseName,
            setAppendName("append" .. baseName)
            setUnpackName("unpack" .. baseName)
        )

        asString := method(
            if(count != nil,
                character .. count
            ,
                character
            )
        )
    )

    list(
        Instruction clone setCharacter("A") setNames("SpacePaddedString") setUsesCount(true),
        Instruction clone setCharacter("a") setNames("NullPaddedString") setUsesCount(true),
        Instruction clone setCharacter("B") setNames("DecendingBitString") setUsesCount(true),
        Instruction clone setCharacter("b") setNames("AscendingBitString") setUsesCount(true),
        Instruction clone setCharacter("C") setNames("UnsignedByte"),
        Instruction clone setCharacter("c") setNames("SignedByte"),
        Instruction clone setCharacter("x") setAppendName("appendNullByte") setUnpackName("skipByte") setHasValue(false),
        Instruction clone setCharacter("Z") setNames("NullTerminatedString")
    ) foreach(instruction,
        instructionProtos atPut(instruction character, instruction)
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

        bitString exSlice(0, bitCount) foreach(bitCharacter,
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

    appendAscendingBitString := method(bitString, bitCount,
        byte := 0
        offset := 0

        bitString exSlice(0, bitCount) foreach(bitCharacter,
            if(bitCharacter == "1" at(0),
                byte = byte + (1 << offset)
            )

            if(bitCharacter == "1" at(0) or bitCharacter == "0" at(0),
                offset = offset + 1

                if(offset == 8,
                    appendUnsignedByte(byte)
                    offset = 0
                    byte = 0
                )
            )
        )

        if(offset != 0,
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

    unpackNullTerminatedString := method(
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

    unpackAscendingBitString := method(bitCount,
        bitString := Sequence clone

        offset := 8
        byte := nil

        bitCount repeat(
            if(offset == 8,
                byte = unpackUnsignedByte
                offset = 0
            )

            bitString appendSeq(if((byte & (1 << offset)) != 0, "1", "0"))
            offset = offset + 1
        )

        bitString asString
    )
)

