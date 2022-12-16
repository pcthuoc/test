%include 	'func.asm'
section .data
    adrr_setion         dd  0    
    isELF32             dd  0
    isLittle            dd  0
    ishnum              dd  0
    ishnum1             dd  0
    iphnum              dd  0
    isphoff             dd  0
    ishoff              dd  0
    ishstrndx           dd  0
    ishentsize          dd  0
    len                 dd  0
    iphentsize          db  0
    sError              db  "Error occured!", 0
    sRequestFilename    db  "Enter link to ELF file: ", 0
    ; ELF Header
    sElfHeader          db  0xa, "ELF Header: ", 0xa, 0
    sMagic              db  9, "Magic: ",9,9, 0
    sClass              db  9, "Class: ", 9,9,9,9,0
    sELF32              db  9, "ELF32", 0
    sELF64              db  9, "ELF64", 0
    sData               db  9, "Data: ", 9,9,9,9,0
    sLittleEndian       db  9, "2's complement,little endian", 0
    sBigEndian          db  9, "2's complement,big endian", 0
    sVersion            db  9, "Version: ", 9,9,9,9,0
    sOSABI              db  9, "OS/ABI: ", 9,9,9,9,0
        sELFOSABI_NONE              db       "UNIX System V ABI ",0
        sELFOSABI_HPUX              db       "HP-UX ",0     
        sELFOSABI_NETBSD            db       "NetBSD.  ",0
        sELFOSABI_GNU               db       "Object uses GNU ELF extensions.  ",0
        sELFOSABI_SOLARIS           db       "Sun Solaris.  ",0
        sELFOSABI_AIX               db       "IBM AIX.  ",0
        sELFOSABI_IRIX              db       "SGI Irix.  ",0
        sELFOSABI_FREEBSD           db       "FreeBSD.  ",0
        sELFOSABI_TRU64             db       "Compaq TRU64 UNIX.  ",0
        sELFOSABI_MODESTO           db       "Novell Modesto.  ",0
        sELFOSABI_OPENBSD           db       "OpenBSD.  ",0
        sELFOSABI_ARM_AEABI         db       "ARM EABI ",0
        sELFOSABI_ARM               db       "ARM ",0
        sELFOSABI_STANDALONE        db       "Standalone (embedded) application ",0
    sABIVersion         db  9, "ABI Version: ", 9,9,9,9,0
    sType               db  9, "Type: ", 9,9,9,9,9,0
        sET_REL                     db       "Relocatable file",0
        sET_EXEC                    db       "Executable file ",0     
        sET_DYN                     db       "Shared object file",0
        sET_CORE                    db       "Core file   ",0
    sMachine            db  9, "Machine: ", 9,9,9,9,0
        sEM_M32                     db      "AT&T WE 32100 ",0   
        sEM_SPARC                   db      "SUN SPARC ",0
        sEM_386                     db      "Intel 80386 ",0
        sEM_68K                     db      "Motorola m68k family ",0
        sEM_88K                     db      "Motorola m88k family ",0
        sEM_IAMCU                   db      "Intel MCU ",0
        sEM_860                     db      "Intel 80860 ",0
        sEM_MIPS                    db      "MIPS R3000 big-endian ",0
        sEM_S370                    db      "IBM System/370 ",0
        sEM_MIPS_RS3_LE             db      "MIPS R3000 little-endian ",0
    
    sEntryPointAddress  db  9, "Entry Point Address: ",9,9,9,0
    sStartProgram       db  9, "Start of Program Headers: ", 9,9,0
    sStartSection       db  9, "Start of Section Headers: ", 9,9,0
    sFlags              db  9, "Flags: ", 9,9,9,9,9,0
    sSizeHeader         db  9, "Size of this header: ", 9,9,9,0   
    sSizeProgram        db  9, "Size of Program Headers: ", 9,9,0
    sNumberProgram      db  9, "Number of Program Headers: ", 9,9,0
    sSizeSection        db  9, "Size of Section Headers: ", 9,9,0
    sNumberSection      db  9, "Number of Section Headers: ", 9,9,0
    sStringTableIndex   db  9, "Section Header String Table Index: ", 9,0
    ; Section Header
    sSectionHeader      db  "Section Header: ", 0ah, 0
    sSectionHeaderTable db  9,"Name", 9, 9, 9,"Type",9, 9,"Addr", 9,"Off", 9, "Size", 9, "ES", 9, "Flg", 9, "Lk", 9, "Inf", 9, "Al", 0ah, 0
    ; Program Header
    sProgramHeader      db  "Program Header: ", 0ah, 0
    sProgramHeaderTable db  9,"Type", 9,9, "Offset", 9, 9,"VirtAddr", 9, "PhysAddr", 9, "FileSiz", 9, "MemSiz", 9, "Flags", 9, "Align", 0ah, 0 

    ;filename            db   "Easy_ELF",0
    tab                  db   '1',9,0
    endl                 db   0ah


section .bss
    filename        resb    512
    filesize        resq    1
    filedata        resq    1      
    fd              resd    1    
    fd_stat         resb    144     ; sizeof struct stat = 144
    hexString       resb    17
   
section .text
global _start
_start:
    .get_filename:
    push    sRequestFilename
    call    print
    push    512
    push    filename    
    call    read
    ;open file 
    
    push    filename 
    call    str_len
    mov     byte [filename + eax], 0
    
    mov     edx,0           ; mode 
    mov     ecx,0           ; flags 
    mov     ebx,filename 
    mov     eax,5  
	int 	0x80            ; open( file , read )

    mov     [fd],eax 
    ; get file size     
    mov     ebx, [fd]
    mov     ecx, fd_stat
    mov     eax, 0x6c ;newfstat
    int 	0x80                 ; fstat(fd, (struct stat) fd_stat)
    mov     ecx,fd_stat
    mov     ecx,dword[ecx+48]
    mov     [filesize],ecx
    ; allocate mem
    xor     ebx,ebx
    mov     eax,0x2d
    int     0x80
    mov     ebx,eax
    mov     [filedata], ebx
    add     ebx,[filesize]
    mov     eax,0x2d
    int     0x80  
    ; read file to filedata string
    mov     ebx,[fd]
    mov     ecx,[filedata]
    mov     edx,[filesize]
    mov     eax,0x3
    int     0x80
    ; begin parsing file
    mov     ebx, [filedata]
    ;ELF_HEADER:
    mov     ecx,[ebx]    ; e->ident[0..3]
    cmp     ecx, 0x464c457f     ; \x7fELF
    jnz     .errorExit
    push    sElfHeader
    call    print
        call    print_endl
    ; magic 
    push    sMagic
    call    print
    xor     ecx,ecx
    .printMagicBytes:
        movzx   edx, byte [ebx+ecx]
        push    edx
        push    hexString
        call    ltoh   
        mov     byte [hexString+eax],20h
        push    hexString
        call    print
        inc     ecx
        cmp     ecx,10h
        jnz     .printMagicBytes
    call    print_endl

    ;class 
    push    sClass
    call    print
    mov     al,[ebx+4]
    cmp     al,1
    jz      .markELF32
    push    sELF64
    call    print
    jmp     .endClass
    .markELF32:
        mov     byte [isELF32], 1
        push    sELF32
        call    print
    .endClass:
        call    print_endl
    ; data 
    push    sData 
    call    print   
    mov     al,[ebx+4]
    cmp     al,1
    jz      .markLittleEndian
    push    sLittleEndian
    call    print 
    jmp     .endData 
    .markLittleEndian:
        mov     byte[isLittle],1 
        push    sLittleEndian
        call    print
    .endData:
        call    print_endl
    ; version
    push    sVersion
    call    print 
    xor     eax,eax
    mov     al, byte [ebx +5]
    push    eax
    push    hexString
    call    ltoh
    mov     byte [hexString+eax ],0ah
    push    hexString 
    call    print 
            call    print_endl
    ;OSA/ABI
    push    sOSABI
    call    print 
    ; switch(osabi= byte [ebx +7])             case 
        .ELFOSABI_NONE:
            cmp     byte[ebx+7],0
            jnz      .ELFOSABI_HPUX
            push    sELFOSABI_NONE
            call    print
            jmp     .endOSABI
        .ELFOSABI_HPUX:
            cmp     byte[ebx+8],1
            jnz      .ELFOSABI_NETBSD
            push    sELFOSABI_HPUX
            call    print
            jmp     .endOSABI
        .ELFOSABI_NETBSD:    
            cmp     byte[ebx+8],2
            jnz      .ELFOSABI_GNU
            push    sELFOSABI_NETBSD
            call    print
            jmp     .endOSABI
        .ELFOSABI_GNU:    
            cmp     byte[ebx+8],3
            jnz      .ELFOSABI_SOLARIS
            push    sELFOSABI_GNU
            call    print
            jmp     .endOSABI
        .ELFOSABI_SOLARIS:    
            cmp     byte[ebx+8],6
            jnz      .ELFOSABI_AIX
            push    sELFOSABI_SOLARIS
            call    print
            jmp     .endOSABI
        .ELFOSABI_AIX:    
            cmp     byte[ebx+8],7
            jnz      .ELFOSABI_IRIX
            push    sELFOSABI_AIX
            call    print
            jmp     .endOSABI
         .ELFOSABI_IRIX:    
            cmp     byte[ebx+8],8
            jnz      .ELFOSABI_FREEBSD
            push    sELFOSABI_IRIX
            call    print
            jmp     .endOSABI
        .ELFOSABI_FREEBSD:    
            cmp     byte[ebx+8],9
            jnz      .ELFOSABI_TRU64 
            push    sELFOSABI_FREEBSD
            call    print
            jmp     .endOSABI
        .ELFOSABI_TRU64:    
            cmp     byte[ebx+8],10
            jnz      .ELFOSABI_MODESTO
            push    sELFOSABI_TRU64 
            call    print
            jmp     .endOSABI
        .ELFOSABI_MODESTO:    
            cmp     byte[ebx+8],11
            jnz      .ELFOSABI_OPENBSD
            push    sELFOSABI_MODESTO
            call    print
            jmp     .endOSABI
        .ELFOSABI_OPENBSD:    
            cmp     byte[ebx+8],12
            jnz      .ELFOSABI_ARM_AEABI
            push    sELFOSABI_OPENBSD
            call    print
            jmp     .endOSABI
        .ELFOSABI_ARM_AEABI:    
            cmp     byte[ebx+8],64
            jnz      .ELFOSABI_ARM
            push    sELFOSABI_ARM_AEABI
            call    print
            jmp     .endOSABI
        .ELFOSABI_ARM:    
            cmp     byte[ebx+8],97
            jnz      .ELFOSABI_STANDALONE
            push    sELFOSABI_ARM
            call    print
            jmp     .endOSABI
        .ELFOSABI_STANDALONE:    
            push    sELFOSABI_STANDALONE
            call    print
            jmp     .endOSABI
    .endOSABI: 
        call print_endl
    ;OSA/ABI version 
    push    sABIVersion
    call    print
    xor     eax,eax 
    mov     al, byte [ebx +8]
    push    eax 
    push    hexString
    call    ltoh
    mov     byte [hexString+eax],0ah 
    push    hexString
    call    print  
    ; e_type 
    call    print_endl
    push    sType
    call    print
    xor     eax,eax 
    mov     al, byte  [ebx +10h ]
        push    eax 
    push    hexString
    call    ltoh
    ; switch( type = byte [ebx +10h])             case 
        .ET_REL:
            cmp     byte [ebx+10h], 1
            jnz      .ET_EXEC
            push    sET_REL
            call    print
            jmp     .end_type 
        .ET_EXEC:
            cmp      byte [ebx+10h],2
            jnz      .ET_DYN 
            push    sET_EXEC
            call    print 
            jmp     .end_type
        .ET_DYN:
            cmp      byte [ebx+10h],3
            jnz      .ET_CORE
            push    sET_DYN
            call    print 
            jmp     .end_type 
        .ET_CORE:
            push    sET_CORE
            call    print 
            jmp     .end_type 
        .end_type: 
            call    print_endl
    ; e_machine
    push        sMachine
    call        print 
    xor     eax,eax 
    mov     dl, byte [ebx +12h]
        .EM_M32:
            cmp     dl,1
            jnz      .EM_SPARC
            push    sEM_M32
            call    print
            jmp     .end_machine
        .EM_SPARC:    
            cmp     dl,2
            jnz      .EM_386
            push    sEM_SPARC
            call    print
            jmp     .end_machine
        .EM_386:    
            cmp     dl,3
            jnz      .EM_68K 
            push    sEM_386
            call    print
            jmp     .end_machine
        .EM_68K:    
            cmp     dl,4
            jnz      .EM_88K
            push    sEM_68K
            call    print
            jmp     .end_machine
        .EM_88K:    
            cmp     dl,5
            jnz      .EM_IAMCU
            push    sEM_88K
            call    print
            jmp     .end_machine
         .EM_IAMCU:    
            cmp     dl,6
            jnz      .EM_860
            push    sEM_IAMCU
            call    print
            jmp     .end_machine
        .EM_860:    
            cmp     dl,7
            jnz      .EM_MIPS 
            push    sEM_SPARC
            call    print
            jmp     .end_machine
        .EM_MIPS:    
            cmp     dl,8
            jnz      .EM_S370
            push    sEM_MIPS 
            call    print
            jmp     .end_machine
        .EM_S370:    
            cmp     dl,9
            jnz      .EM_MIPS_RS3_LE
            push    sEM_S370
            call    print
            jmp     .end_machine
        .EM_MIPS_RS3_LE:    
            push    sEM_MIPS_RS3_LE
            call    print
            jmp     .end_machine
     .end_machine:   
        call    print_endl
    ; e_version 
    push    sVersion
    call    print 
    mov     edi, [ebx+14h]
    push    edi 
    push    hexString
    call    ltoh
    mov     byte [ hexString+eax],0ax
    push    hexString
    call    print 
        call    print_endl
    mov     ecx,18h
    ;e_entry 
    push    sEntryPointAddress
    call    print 
    xor     edi,edi
    cmp     byte [isELF32], 1
    jnz     .entry64
    .entry32:
        mov     edi, dword [ebx + ecx]
        jmp     .endEntry
    .entry64:   
        mov     edi, dword [ebx + ecx]
        add     ecx, 4  
    .endEntry:
        push    edi 
        push    hexString
        call    ltoh 
        mov     byte [hexString+eax],0ah 
        push    hexString
        call    print 
    add     ecx,4
    ; e_phoff 
    call    print_endl
    push    sStartProgram
    call    print   
    xor     edi,edi
    cmp     byte [isELF32], 1
    jnz     .phoff64
    .phoff32:
        mov     edi,  [ebx + ecx]
        jmp     .endPhoff
    .phoff64:
        mov     edi,  [ebx + ecx]
        add     ecx, 4  
    .endPhoff:
        mov     [isphoff],edi
        push    edi 
        push    hexString
        call    ltoh
        mov     byte [ hexString+eax],0ah
        push    hexString
        call    print 
    call    print_endl
    add     ecx,4
    ; se_shoff
    push    sStartSection
    call    print   
    cmp     byte [isELF32], 1
    jnz     .shoff64
    .shoff32:
        mov     edi, [ebx + ecx]
        mov     dword [ishoff], edi
        jmp     .endShoff
    .shoff64:
        mov     edi, [ebx + ecx]
        mov     dword [ishoff], edi
    add     ecx, 4
    .endShoff:
    push    edi 
    push    hexString
    call    ltoh
    mov     byte[hexString+eax],0ah
    push    hexString
    call    print 
    ;flag

    call    print_endl
    add     ecx,4
    push    sFlags
    call    print 
    xor     edi,edi 
    mov     edi, [ebx +ecx]
    push    edi 
    push    hexString
    call    ltoh 
    mov     byte [hexString+eax ] , 0ah 
    push    hexString
    call    print 
        call    print_endl
    ; e_ehsize 
    add     ecx,4
    push    sSizeHeader
    call    print 
    xor     edi ,edi 
    mov     di, word [ebx+ecx ]
    push    edi 
    push    hexString
    call    ltoh
    mov     byte [ hexString+eax ],0ah 
    push    hexString
    call    print 
        call    print_endl
    ; e_phentsize 
    add     ecx,2
    push    sSizeProgram
    call    print 
    xor     edi,edi
    mov     di , word [ebx+ecx]
    mov     [iphentsize],edi
    push    edi 
    push    hexString 
    call    ltoh
    mov     byte [ hexString+eax],0ah
    push    hexString
    call    print
        call    print_endl
    add     ecx,2
    ;e_phnum
    push    sNumberProgram
    call    print 
    xor     edi,edi
    mov     di , word [ebx+ecx]
    mov     [iphnum], edi
    push    edi 
    push    hexString 
    call    ltoh
    mov     byte [ hexString+eax],0ah
    push    hexString
    call    print
        call    print_endl
    add     ecx,2
    ; e_shentsize 
    push    sSizeSection
    call    print 
    xor     edi,edi
    mov     di , word [ebx+ecx]
    mov     [ishentsize ], di
    push    edi 
    push    hexString 
    call    ltoh
    mov     byte [ hexString+eax],0ah
    push    hexString
    call    print
        call    print_endl
    add     ecx,2  
    ; eshnum 
    push    sNumberSection
    call    print 
    xor     edi,edi
    mov     di , word [ebx+ecx]
    mov     word [ishnum], di
    mov     word [ishnum1], di
    push    edi 
    push    hexString 
    call    ltoh
    mov     byte [ hexString+eax],0ah
    push    hexString
    call    print
        call    print_endl
    add     ecx,2  
    ; e_shstrdx
    push    sStringTableIndex
    call    print 
    xor     edi,edi
    mov     di , word [ebx+ecx]
    mov     [ishstrndx], di
    push    edi 
    push    hexString 
    call    ltoh
    mov     byte [ hexString+eax],0ah
    push    hexString
    call    print
        call    print_endl
    add     ecx,2 
    ; Section Header
    call    print_endl
    push    sSectionHeader
    call    print
    call    print_endl
    push    sSectionHeaderTable
    call    print 
    call    print_endl


    mov     ax,[ishentsize]
    mov     dx,[ishstrndx]
    mul     dx
    xor     edx,edx
    mov     edx,eax
    add     ebx,[ishoff]
    add     edx,ebx
    mov     [adrr_setion],edx
    .nextSection:
        ; name
        mov     byte [hexString ], 9
        mov     byte [hexString +1], 0
        push    hexString
        call    print
        mov     edx,[adrr_setion]
        cmp     byte [ishnum],0
        jz      .endSectionHeader
        mov     edi, dword [ebx]          ; sh_name
        cmp     byte [isELF32], 1
        jz      .sh_name32
        .sh_name64: ; actually im taking e_shoffset but i named this to show that this all is to take the correct sh_name
            add     edi, [edx + 18h]    ; -> sh_offset    
            add     edi, [filedata]     ; edi = &sectionname   
            jmp     .endSh_name
        .sh_name32:
            add     edi, [edx + 10h]     ; -> sh_offset
            add     edi, [filedata]     ; edi = &sectionname    
        .endSh_name:    
            mov     dword[len],0
            push    edi 
            call    print                ; str =len 
            mov    edx,[len]
    
        ; format output 
        mov     byte [hexString],9
        cmp     edx, 10h
        jl      .moreTab1
        jmp     .printTab
        .moreTab1:
            mov     byte [hexString+1],9
            cmp     edx, 07h
            jg      .printTab
            mov     byte [hexString+2],9
            jmp     .printTab
            ;mov     byte [hexString+2],9
            jmp     .printTab
        .printTab: 
            push    hexString
            call    print
        ;call    tab 
        ; type
        xor     edi,edi
        mov     edi, dword [ebx + 4]
        push    edi
        push    hexString
        call    ltoh
        mov     byte [hexString + eax], 9
        cmp     eax,7
        jg      .next
        mov     byte [hexString + eax+1], 9
        .next:
            push    hexString
            call    print
        ; sh_addr
        mov     ecx,0ch
        cmp     byte [isELF32], 1
        jz      .sh_addr32
        .sh_addr64:
            add     ecx, 4    
            mov     edi, [ebx + ecx]
            add     ecx, 4   
            jmp     .endSh_addr
        .sh_addr32:
            mov     edi, [ebx + ecx]
        .endSh_addr:
            push    edi
            push    hexString
            call    ltoh
            mov     byte [hexString + eax], 9
            push    hexString
            call    print
            add     ecx, 4
        ; sh_offset
        cmp     byte [isELF32], 1
        jz      .sh_offset32
        .sh_offset64:
            mov     edi, [ebx + ecx]
            add     ecx, 4   
            jmp     .endSh_offset
        .sh_offset32:
            mov     edi, [ebx + ecx]
        .endSh_offset:
            push    edi 
            push    hexString
            call    ltoh 
            mov     byte [hexString + eax], 9
            push    hexString
            call    print
            add     ecx, 4
        ; sh_size
        cmp     byte [isELF32], 1
        jz      .sh_size32
        .sh_size64:
            mov     edi, [ebx + ecx]
            add     ecx, 4   
            jmp     .endSh_size
        .sh_size32:
            mov     edi, [ebx + ecx]
        .endSh_size:
            push    edi 
            push    hexString
            call    ltoh
            mov     byte [hexString + eax], 9
            push    hexString
            call    print
            add     ecx, 4

            add     ecx, 8  
        ; sh_entsize
        ; 
        xor     edi,edi
        cmp     byte [isELF32], 1
        jz      .sh_entsize32
        .sh_entsize64:
            add     ecx, 8
            mov     edi, [ebx + ecx]
            sub     ecx, 10h        ; -> sh_link
            jmp     .endSh_entsize
        .sh_entsize32:
            add     ecx, 4
            mov     edi, [ebx + ecx]
            sub     ecx, 0ch        ; -> sh_link
        .endSh_entsize:
            push    edi 
            push    hexString
            call    ltoh    
            mov     byte [hexString + eax], 9
            push    hexString
            call    print   
        ; sh_flags
        cmp     byte [isELF32], 1
        jz      .sh_flag32
        .sh_flag64:
            mov     edi, [ebx + 8]
            jmp     .endSh_flag
        .sh_flag32:
            mov     edi, [ebx + 8]
        .endSh_flag:
            push    edi 
            push    hexString
            call    ltoh 
            mov     byte [hexString + eax], 9
            push    hexString
            call    print
        ; sh_link
        mov     edi, [ebx + ecx] 
        push    edi
        push    hexString
        call    ltoh
        mov     byte [hexString + eax], 9
        push    hexString
        call    print
        add     ecx, 4
        ; sh_info
        mov     edi, [ebx + ecx]
        push    edi 
        push    hexString
        call    ltoh
        mov     byte [hexString + eax], 9
        push    hexString
        call    print
        add     ecx, 4
        ; sh_addalign
        cmp     byte [isELF32], 1
        jz      .sh_addalign32
        .sh_addalign64:
            mov     edi, [ebx + ecx]
            jmp     .endSh_addalign
        .sh_addalign32:
            mov     edi, [ebx + ecx]
        .endSh_addalign:
        push    edi 
        push    hexString
        call    ltoh
        mov     byte [hexString + eax], 0
        push    hexString
        call    print
        call    print_endl
        sub     dword[ishnum],1
        add     ebx, [ishentsize]
        jmp     .nextSection
    .endSectionHeader:
        call    print_endl
     ; Program Header
    push   sProgramHeader
    call   print 
    call   print_endl
    push   sProgramHeaderTable
    call   print
    call    print_endl
    mov     ebx, [filedata]
    add     ebx, [isphoff]    ; + e_phoff => &Program header

    .nextEntry:
    cmp     dword [iphnum],0   ; e_phnum
    jz      .endProgramHeader
    mov     byte[hexString],9
    mov     byte[hexString+1],0
    push    hexString
    call    print
    mov     ecx, 0
    ; p_type
    xor     edi,edi 
    mov     edi, [ebx + ecx]
    push    edi
    push    hexString
    call    ltoh
    mov     byte [hexString + eax], 9
    push    hexString
    call    print
    add     ecx, 4
    cmp     byte [len],8
    jg      .next5
    mov     byte[hexString],9
    mov     byte[hexString+1],0
    push    hexString
    call    print
    .next5:
    ; p_offset
    cmp     byte [isELF32], 1
    jz      .p_offset32
    .p_offset64:
    add     ecx, 4
    mov     edi, [ebx + ecx]
    add     ecx, 4
    jmp     .endp_offset
    .p_offset32:
    mov     edi, [ebx + ecx]
    .endp_offset:
    push    edi
    push    hexString
    call    ltoh
    mov     byte [hexString + eax], 9
    push    hexString
    call    print
    add     ecx, 4
    mov     byte[hexString],9
    mov     byte[hexString+1],0
    push    hexString
    call    print
    ; p_vaddr
    cmp     byte [isELF32], 1
    jz      .p_vaddr32
    .p_vaddr64:
    mov     edi, [ebx + ecx]
    add     ecx, 4
    jmp     .endp_vaddr
    .p_vaddr32:
    mov     edi, [ebx + ecx]
    .endp_vaddr:
    push    edi
    push    hexString
    call    ltoh
    mov     byte [hexString + eax], 9
    inc     eax
    mov     byte [hexString + eax], 9
    push    hexString
    call    print
    add     ecx, 4

    ; p_paddr
    cmp     byte [isELF32], 1
    jz      .p_paddr32
    .p_paddr64:
    mov     edi, [ebx + ecx]
    add     ecx, 4
    jmp     .endp_paddr
    .p_paddr32:
    mov     edi, [ebx + ecx]
    .endp_paddr:
    push    edi
    push    hexString
    call    ltoh
    mov     byte [hexString + eax], 9
    inc     eax
    mov     byte [hexString + eax], 9
    push    hexString
    call    print
    add     ecx, 4

    ; p_filesz
    cmp     byte [isELF32], 1
    jz      .p_filesz32
    .p_filesz64:
    mov     edi, [ebx + ecx]
    add     ecx, 4
    jmp     .endp_filesz
    .p_filesz32:
    mov     edi, [ebx + ecx]
    .endp_filesz:
    push    edi
    push    hexString
    call    ltoh
    mov     byte [hexString + eax], 9
    push    hexString
    call    print
    add     ecx, 4

    ; p_memsz
    cmp     byte [isELF32], 1
    jz      .p_memsz32
    .p_memsz64:
    mov     edi, [ebx + ecx]
    jmp     .endp_memsz
    .p_memsz32:
    mov     edi, [ebx + ecx]
    .endp_memsz:
    push    edi 
    push    hexString
    call    ltoh
    mov     byte [hexString + eax], 9
    push    hexString
    call    print
    add     ecx, 8

    ; p_flags
    cmp     byte [isELF32], 1
    jz      .p_flags32
    .p_flags64:
    mov     edi, [ebx + 4]
    jmp     .endp_flags
    .p_flags32:
    mov     edi, [ebx + 18h]
    .endp_flags:
    push    edi 
    push    hexString
    call    ltoh
    mov     byte [hexString + eax], 9
    push    hexString
    call    print

    ; p_flags
    cmp     byte [isELF32], 1
    jz      .p_align32
    .p_align64:
    mov     edi, [ebx + ecx]
    add     ecx, 8
    jmp     .endp_align
    .p_align32:
    mov     edi, [ebx + ecx]
    add     ecx, 4
    .endp_align:
    push    edi
    push    hexString
    call    ltoh
    mov     byte [hexString + eax], 0ah
    push    hexString
    call    print
    call    print_endl
    dec     dword [iphnum]
    add     ebx, dword [iphentsize]
    jmp     .nextEntry

    .endProgramHeader:



    .errorExit:
    call    exitProcess
strlencalc:     ; calculate strlen(&edi), return in eax
    push    ebp
    mov     ebp, esp
    mov     eax, 0
    mov     ebp,[ebp+08h]
    .iter:
    cmp     byte [edi], 0xa
    jz      .finished
    cmp     byte [edi], 0
    jz      .finished
    inc     edi
    inc     eax
    jmp     .iter
    
    .finished:
    mov     esp, ebp
    pop     ebp
    ret     4

print_tab:
    push    ebp
    mov     ebp,esp
    push    eax
    push    ebx
    push    ecx
    push    edx 
    push    edi 
    push    esi
    mov     edx,2
    mov	    ecx, tab 
    mov	    ebx, 1
    mov	    eax, 4
    int 	0x80
    pop     esi
    pop     edi 
    pop     ecx
    pop     ebx 
    pop     eax
    mov	    esp, ebp
    pop	    ebp
    ret	    
print_endl:
    push    ebp
    mov     ebp,esp
    push    ebx
    push    ecx
    mov     edx,1
    mov	    ecx, endl
    mov	    ebx, 1
    mov	    eax, 4
    int 	0x80
    pop     ecx
    pop     ebx 
    mov	    esp, ebp
    pop	    ebp
    ret	    
ltoh:  ; ltoh([in] val, [out] hexString) convert int64 to hex string return szArr in eax
    push    ebp    
    mov     ebp, esp
    push    ebx
    push    ecx
    mov     edi,[ebp+08h]
    mov     eax,[ebp+0ch]
    mov     ebx, 16
    mov     ecx,20
    .loop_format:
        cmp     ecx,0
        jz      .done_format
		mov 	byte[edi],0
		inc 	edi 
        dec     ecx
		jmp 	.loop_format
    .done_format:
		mov 	edi,[ebp+08h]
    push    "#"                 ; pivot
    .getDigit:
    xor     edx, edx
    div     ebx
    cmp     edx, 0Ah
    jl      .xor30
    add     edx, 37h            ; if a - f -> "a"-"f"
    jmp     .saveDigit
    
    .xor30:
    xor     edx, 30h            ; if 0 - 9 -> "0" - "9"
    .saveDigit:
    push    edx
    test    eax, eax
    jz      .toString
    jmp     .getDigit

    .toString:                   ; get char from stack to hexString
    pop     eax
    cmp     al, "#"
    jz      .done
    stosb
    jmp     .toString

    .done:
    sub     edi,[ebp+08h]
    mov     eax,edi
    pop     ecx
    pop     ebx
    mov     esp, ebp
    pop     ebp
    ret   
str_len:
    push    ebp
    mov     ebp,esp 
    xor     eax,eax
    mov     edi,[ebp+08h]
    .loop_len:
        mov     cl, [edi]
        cmp     cl,0Ah
        jz      .done_len
        cmp     cl,0
        jz      .done_len
        inc     edi
        inc     eax 
        jmp     .loop_len
    .done_len:
        mov     esp,ebp
        pop     ebp 
        ret     4