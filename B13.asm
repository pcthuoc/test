;C:\Users\thuocpc\source\repos\Project2\Debug\Easy_CrackMe.exe
.386
.model flat, stdcall
option casemap: none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc 
include \masm32\include\masm32.inc 
include \masm32\include\msvcrt.inc
include \masm32\include\comdlg32.inc
includelib \masm32\lib\msvcrt.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib
.data
	fileName1									db		'C:\Users\thuocpc\source\repos\Project2\Debug\Easy_CrackMe.exe',0
	NL											db		0Ah, 0
	TAB											db		09h, 0
	hex											db		'0x',0
	msg											db		'Enter link to PE file: ', 0Ah, 0
	errMsg										db		'[!] Error while extracting file!', 0
	tab											db		9,0
	sDOSHeader									db		'******* DOS HEADER *******',0
		se_magic								db		9,'Magic number',0
		se_cblp									db		9,'Bytes on last page of file',0
		se_cp									db		9,'Pages in file',0
		se_crlc									db		9,'Relocations',0
		se_cparhdr								db		9,'Size of header in paragraphs',0
		se_minalloc								db		9,'Minimum extra paragraphs needed',0
		se_maxalloc								db		9,'tMaximum extra paragraphs needed',0
		se_ss									db		9,'Initial (relative) SS value',0
		se_sp									db		9,'Initial SP value',0
		se_csum									db		9,'tChecksum',0
		se_ip									db		9,'Initial IP value',0
		se_cs									db		9,'Initial (relative) CS value',0
		se_lfarlc								db		9,'File address of relocation table',0
		se_ovon									db		9,'Overlay number',0
		se_oemid								db		9,'OEM identifier (for e_oeminfo)',0
		se_oeminfo								db		9,'OEM information e_oemid specific',0
		se_lfanew								db		9,'File address of new exe header', 0
	sPEHeader									db		'******* NT HEADERS *******', 0
		sSignature								db		9, 'Signature', 0
	sFileHeader									db		'******* FILE HEADER *******', 0
			sMachine							db		9, 'Machine ', 0
			sNumberOfSections					db		9, 'Number Of Sections: ', 0
			sTimeDateStamp						db		 'Time Stamp ', 0
			sPointerToSymbolTable				db		9, 'Pointer to Symbol Table ', 0
			sNumberOfSymbols					db		9, 'Number of Symbols ', 0
			sSizeOfOptionalHeader				db		9, 'Size of Optional Header', 0
			sCharacteristics					db		9, 'Characteristics', 0
	sOptionalHeader								db		'******* OPTIONAL HEADER *******', 0
			sMagic								db		9,'Magic',0
			sMajorLinkerVersion					db		9,'MajorLinkerVersion',0
			sMinorLinkerVersion					db		9,'MinorLinkerVersion',0
			sSizeOfCode							db		9,'Size Of Code ',0
			sSizeOfInitializedData				db		9,'Size Of Initialized Data',0
			sSizeOfUninitializedData			db		9,'Size Of Uninitialized Data',0
 			sAddressOfEntryPoint				db		9, 'Address Of Entry Point ', 0
			sBaseOfCode							db		9,'Base Of Code',0		
			sImageBase							db		'Image Base ', 0
			sSectionAlignment					db		9, 'Section Alignment: ', 0
			sFileAlignment						db		9, 'File Alignment: ', 0
			sSizeOfImage						db		9, 'Size Of Image: ', 0
			sSizeOfHeaders						db		9, 'Size Of Headers ', 0
			sNumberOfRvaAndSizes				db		9,'Number Of Rva And Sizes',0
			sDataDirectory						db		'******* DATA DIRECTORIES *******', 0
				sExportDRVA						db		9, 'Export Directory RVA ', 0
				sExportDSize					db      9, 'Export Directory Size ', 0
				sImportDRVA						db		9, 'Import Directory RVA ', 0
				sImportDSize					db		9, 'Import Directory Size ', 0
				sResourceDRVA					db		9, 'Resource Directory RVA', 0
				sResourceDSize					db      9, 'Resource Directory Size ', 0
				sExceptionDRVA					db		9, 'Exception Directory RVA', 0
				sExceptionDSize					db      9, 'Exception Directory Size ', 0
				sSecurityDRVA					db		9, 'Security Directory RVA ', 0
				sSecurityDSize					db      9, 'Security Directory Size ', 0
				sRelocationDRVA					db		9, 'Relocation Directory RVA ', 0
				sRelocationDSize				db      9, 'Relocation Directory Size ', 0
				sDebugDRVA						db		9, 'Debug Directory RVA ', 0
				sDebugDSize						db      9, 'Debug Directory Size ', 0
				sArchitectureDRVA				db		9, 'Architecture Directory RVA ', 0
				sArchitectureDSize				db      9, 'Architecture Directory Size ', 0
				sReservedDRVA					db		9, 'Reserved Directory RVA ', 0
				sReservedDSize					db      9, 'Reserved Directory Size ', 0
				sTLSDRVA						db		9, 'TLS Directory RVA ', 0
				sTLSDSize						db      9, 'TLS Directory Size ', 0
				sConfigurationDRVA				db		9, 'Configuration Directory RVA ', 0
				sConfigurationDSize				db      9, 'Configuration Directory Size ', 0
				sBoundImportDRVA				db		9, 'BoundImport Directory RVA ', 0
				sBoundImportDSize				db      9, 'BoundImport Directory Size ', 0
				sIATDRVA						db		9, 'IAT Directory RVA ', 0
				sIATDSize						db      9, 'IAT Directory Size', 0
				sDelayDRVA						db		9, 'Delay Directory RVA', 0
				sDelayDSize						db      9, 'Delay Directory Size', 0
				sNETDRVA						db		9, '.NET Directory RVA ', 0
				sNETDSize						db      9, '.NET Directory Size ', 0
	sSectionTable								db		'******* SECTION HEADERS *******', 0
		sName1									db		9, 'Name1 ', 0
		sVirtualSize							db		9, 'Virtual Size ', 0
		sVirtualAddress							db		9, 'Virtual Address', 0
		sSizeOfRawData							db		9, 'Size Of Raw Data', 0
		sPointerToRawData						db		9, 'Pointer To Raw Data ', 0
		sPointerToRelocations					db		9, 'Pointer To Relocations',0
		sPointerToLinenumbers					db		9,'Pointer To Line numbers',0
		sNumberOfRelocations					db		9,'Number Of Relocations',0
		sNumberOfLinenumbers					db		9,'Number Of Line numbers'
		ssCharacteristics						db		 'Characteristics', 0
	sExportSection								db		'**********Export******** ', 0
	sNoExport									db		9, 'No Export!', 0
		snName									db		9, 'nName', 0
		snBase									db		9, 'nBase', 0
		sNumberOfFunctions						db		9, 'Number Of Functions ', 0
		sNumberOfNames							db		9, 'Number Of Names', 0
		sRVA									db		9,9, 'RVA ', 0
		sOrdinal								db		9, 'Ordinal ', 0
		sFuncName								db		9, 'Function Name ', 0
	sImportSection								db		0Ah, '******* DLL IMPORTS *******', 0
		sDLLName								db		9, 'DLL Name ', 0
		TAB_x2									db		9, 9, 0
.data?
	sTemp										db	9	dup(0),0
	hFile										HANDLE	?
	fileName									db	512	dup(?)
	fileSize									dd		?
	hMap										HANDLE	?
	pMap										dd		?
	imRVA										dd		?
	exRVA										dd		?
	exOrdinalOffset								dd		?
	exFuncOffset								dd		?
	exNameOffset								dd		? 
	sectionHeaderOffset							dd		?
	nSection									dd		?
	nName										dd		?
	nBase										dd		?
	
.code
main PROC
	push	offset msg
	call	StdOut

	push	128
	push	offset fileName
	call	StdIn
	
openFile:
	push	NULL
	push	FILE_ATTRIBUTE_NORMAL
	push	OPEN_EXISTING
	push	NULL
	push	FILE_SHARE_READ
	push	GENERIC_READ
	push	offset fileName
	call	CreateFile
	mov		hFile, eax

	cmp		eax, INVALID_HANDLE_VALUE
	je		errExit

mapFile:
	push	NULL
	push	NULL
	push	NULL
	push	PAGE_READONLY
	push	NULL
	push	hFile
	call	CreateFileMapping
	mov		hMap, eax

	; if the map handle is valid
	cmp		eax, INVALID_HANDLE_VALUE
	je		errExit

	push	NULL
	push	NULL
	push	NULL
	push	FILE_MAP_READ
	push	hMap
	call	MapViewOfFile
	mov		pMap, eax

	; if file is mapped correctly in memory
	cmp		eax, 0
	je		errExit

extract:
	; DOS Header contains some, but most significant is e_magic contains file signature valued MZ, e_lfanew contains offset of PE Header (beginning of file)
	_DOSHeader:
		mov		edi, pMap
		assume	edi: ptr IMAGE_DOS_HEADER
		cmp		[edi].e_magic, IMAGE_DOS_SIGNATURE	; if the file is a DOS file
		jne		errExit
		push	offset sDOSHeader
		call	println
				_e_magic:					; contains magic bytes
				movzx	edx, [edi].e_magic			; e_magic has size dw
				push	edx
				call	printn
				push	offset se_magic
				call	println
				_e_cblp:					
				movzx	edx, [edi].e_cblp			; e_cblp has size dw
				push	edx
				call	printn
				push	offset se_cblp
				call	println
				_e_cp:					
				movzx	edx, [edi].e_cp			; e_cp has size dw
				push	edx
				call	printn
				push	offset se_cp
				call	println
				_e_crlc:					
				movzx	edx, [edi].e_crlc			; e_crlc has size dw
				push	edx
				call	printn
				push	offset se_crlc
				call	println
				_e_cparhdr:					
				movzx	edx, [edi].e_cparhdr			; e_cparhdr  has size dw
				push	edx
				call	printn
				push	offset se_cparhdr
				call	println
				_e_minalloc:					
				movzx	edx, [edi].e_minalloc		; e_minalloc has size dw
				push	edx
				call	printn
				push	offset se_minalloc
				call	println
				_e_maxalloc:					; contains magic bytes
				movzx	edx, [edi].e_maxalloc			;e_maxalloc has size dw
				push	edx
				call	printn
				push	offset se_maxalloc
				call	println
				_e_ss:					
				movzx	edx, [edi].e_ss		; e_ss	 has size dw
				push	edx
				call	printn
				push	offset se_ss
				call	println
				_e_sp:					
				movzx	edx, [edi].e_sp		;e_sp	 has size dw
				push	edx
				call	printn
				push	offset se_sp
				call	println
				_e_csum:					
				movzx	edx, [edi].e_csum		; e_csum has size dw
				push	edx
				call	printn
				push	offset se_csum
				call	println
				_e_ip:					
				movzx	edx, [edi].e_ip			; e_ip has size dw
				push	edx
				call	printn
				push	offset se_ip
				call	println
				_e_cs:					; contains magic bytes
				movzx	edx, [edi].e_cs			;e_cs	 has size dw
				push	edx
				call	printn
				push	offset se_cs
				call	println
				_e_lfarlc:					
				movzx	edx, [edi].e_lfarlc		; e_lfarlc	 has size dw
				push	edx
				call	printn
				push	offset se_lfarlc
				call	println
				_e_oemid:					
				movzx	edx, [edi].e_oemid			; e_oemid	 has size dw
				push	edx
				call	printn
				push	offset se_oemid
				call	println
				_e_oeminfo:					; contains magic bytes
				movzx	edx, [edi].e_oeminfo			; e_oeminfo has size dw
				push	edx
				call	printn
				push	offset se_oeminfo
				call	println
				_e_lfanew:					; contains offset of PE Header relative to file beginning so that loader can skip DOS stub
				push	[edi].e_lfanew				; size dd
				call	printn				
				push	offset se_lfanew 
				call	StdOut
		push	offset NL
		call	StdOut

	; IMAGE_NT_HEADERS (PE Header) contains Signature, FileHeader and OptionalHeader
		add		edi, [edi].e_lfanew					; offset PE Header
		assume	edi: ptr IMAGE_NT_HEADERS
		cmp		[edi].Signature, IMAGE_NT_SIGNATURE ; if this is PE, Signature must contains 50h, 45h, 00h, 00h - PE\0\0
		jne		errExit
		push	offset	sPEHeader
		call	println	
		_Signature:
			push	[edi].Signature	
			call	printn	
			push	offset sSignature	
			call	StdOut
		push	offset NL
		call	StdOut
	; OPTIONAL_HEADER ; FileHeader contains 20 bytes info about physical layout and properties of the file
	_FileHeader:
		add		edi, 4 ; size of nt signature
		assume	edi: ptr IMAGE_FILE_HEADER
		push	offset	sFileHeader	
		call	println	
		_Machine:
			movzx	edx,[edi].Machine
			push	edx
			call	printn 
			push	offset sMachine
			call	println	
		_NumberOfSections:
			movzx	edx,[edi].NumberOfSections
			mov		nSection, edx
			push	edx
			call	printn 
			push	offset sNumberOfSections
			call	println		
		_TimeDateStamp:			
			push	[edi].TimeDateStamp
			call	printn 
			push	offset sTimeDateStamp
			call	println			
		_PointerToSymbolTable:			
			push	[edi].PointerToSymbolTable
			call	printn 
			push	offset sPointerToSymbolTable
			call	println
		_NumberOfSymbols:
			push	[edi].NumberOfSymbols
			call	printn 
			push	offset sNumberOfSymbols
			call	println	
		_SizeOfOptionalHeader:
			movzx	edx,[edi].SizeOfOptionalHeader
			push	edx
			call	printn 
			push	offset sSizeOfOptionalHeader
			call	println	
		_Characteristics:
			movzx	edx,[edi].NumberOfSections
			push	edx
			call	printn 
			push	offset sCharacteristics
			call	println	


	_OPTIONAL_HEADER:
			add		edi, 14h						; sizeof image file header
			assume	edi: ptr IMAGE_OPTIONAL_HEADER
			push	offset	sOptionalHeader
			call	println

				_Magic:		
					movzx	edx,[edi].Magic
					push	edx
					call	printn
					push	offset sMagic
					call	println	
				_MajorLinkerVersion:		
					movzx	edx,[edi].MajorLinkerVersion
					push	edx
					call	printn
					push	offset sMajorLinkerVersion
					call	println	
				_MinorLinkerVersion:		
					movzx	edx,[edi].MinorLinkerVersion
					push	edx
					call	printn
					push	offset sMinorLinkerVersion
					call	println	
				_SizeOfCode:		
					;movzx	edx,[edi].SizeOfCode
					push	[edi].SizeOfCode
					call	printn
					push	offset sSizeOfCode
					call	println
				_SizeOfInitializedData:		
					;movzx	edx,[edi].SizeOfInitializedData	
					push	[edi].SizeOfInitializedData	
					call	printn
					push	offset sSizeOfInitializedData	
					call	println	
				_SizeOfUninitializedData:		
					;movzx	edx,[edi].SizeOfUninitializedData
					push	[edi].SizeOfUninitializedData
					call	printn
					push	offset sSizeOfUninitializedData
					call	println	
				_AddressOfEntryPoint:		; RVA of 1st instruction will be executed when PE loader about to run PE file. Can be used to divert flo of execution from the start
					push	[edi].AddressOfEntryPoint
					call	printn
					push	offset sAddressOfEntryPoint
					call	println	
				_BaseOfCode:		
					;movzx	edx,[edi].BaseOfCode
					push	[edi].BaseOfCode
					call	printn
					push	offset sBaseOfCode
					call	println	
				_ImageBase:		
					;movzx	edx,[edi].ImageBase	
					push	[edi].ImageBase	
					call	printn
					push	offset sImageBase	
					call	println	
				_SectionAlignment:		
					;movzx	edx,[edi].SectionAlignment
					push	[edi].SectionAlignment
					call	printn
					push	offset sSectionAlignment
					call	println	
				_FileAlignment:		
					;movzx	edx,[edi].FileAlignment
					push	[edi].FileAlignment
					call	printn
					push	offset sMagic
					call	println	
				_SizeOfImage:		
					;movzx	edx,[edi].SizeOfImage	
					push	[edi].SizeOfImage	
					call	printn
					push	offset sSizeOfImage	
					call	println	
				_SizeOfHeaders:		
					;movzx	edx,[edi].SizeOfHeaders	
					push	[edi].SizeOfHeaders	
					call	printn
					push	offset sSizeOfHeaders	
					call	println	
				_NumberOfRvaAndSizes:		
					;movzx	edx,[edi].SizeOfHeaders	
					push	[edi].NumberOfRvaAndSizes	
					call	printn
					push	offset sNumberOfRvaAndSizes
					call	println	
	_DataDirectory:				; Last 128 bytes. Array of 16 IMAGE_DATA_DIRECTORY
		push	offset sDataDirectory
		call	println
		add		edi, 60h
		_ExportDirectory:
			mov		edx, dword ptr [edi]
			mov		exRVA, edx
			push	edx
			call	printn
			push	offset sExportDRVA
			call	println	
			push	dword ptr [edi + 4h]
			call	printn
			push	offset sExportDSize
			call	println
		_ImportDirectory:
			mov		edx, dword ptr [edi + 8h]
			mov		imRVA, edx
			push	edx
			call	printn
			push	offset sImportDRVA
			call	println
			push	dword ptr [edi + 0Ch]
			call	printn
			push	offset sImportDSize
			call	println
		_ResourceDirectory:
			push	dword ptr [edi + 10h]
			call	printn
			push	offset sResourceDRVA
			call	println
			push	dword ptr [edi + 14h]
			call	printn
			push	offset sResourceDSize
			call	println
		_ExceptionDirectory:
			push	dword ptr [edi + 18h]
			call	printn
			push	offset sExceptionDRVA
			call	println
			push	dword ptr [edi + 1Ch]
			call	printn
			push	offset sExceptionDSize
			call	println
		_SecurityDirectory:
			push	dword ptr [edi + 20h]
			call	printn
			push	offset sSecurityDRVA
			call	println			
			push	dword ptr [edi + 24h]
			call	printn
			push	offset sSecurityDSize
			call	println
		_RelocationDirectory:
			push	dword ptr [edi + 28h]
			call	printn
			push	offset sRelocationDRVA
			call	println
			push	dword ptr [edi + 2Ch]
			call	printn
			push	offset sRelocationDSize
			call	println
		_DebugDirectory:
			push	dword ptr [edi + 30h]
			call	printn
			push	offset sDebugDRVA
			call	println
			push	dword ptr [edi + 34h]
			call	printn
			push	offset sDebugDSize
			call	println
		_ArchitectureDirectory:
			push	dword ptr [edi + 38h]
			call	printn
			push	offset sArchitectureDRVA
			call	println
			push	dword ptr [edi + 3Ch]
			call	printn
			push	offset sArchitectureDSize
			call	println
		_ReservedDirectory:
			push	dword ptr [edi + 40h]
			call	printn
			push	offset sReservedDRVA
			call	println
			push	dword ptr [edi + 44h]
			call	printn
			push	offset sReservedDSize
			call	println
		_TLSDirectory:
			push	dword ptr [edi + 48h]
			call	printn
			push	offset sTLSDRVA
			call	println
			push	dword ptr [edi + 4Ch]
			call	printn
			push	offset sTLSDSize
			call	println		
		_ConfigurationDirectory:
			push	dword ptr [edi + 50h]
			call	printn
			push	offset sConfigurationDRVA
			call	println
			push	dword ptr [edi + 54h]
			call	printn
			push	offset sConfigurationDSize
			call	println
		_BoundImportDirectory:
			push	dword ptr [edi + 58h]
			call	printn
			push	offset sBoundImportDRVA
			call	println
			push	dword ptr [edi + 5Ch]
			call	printn
			push	offset sBoundImportDSize
			call	println
		_IATDirectory:
			push	dword ptr [edi + 60h]
			call	printn
			push	offset sIATDRVA
			call	println
			push	dword ptr [edi + 64h]
			call	printn
			push	offset sIATDSize
			call	println
		_DelayDirectory:
			push	dword ptr [edi + 68h]
			call	printn
			push	offset sDelayDRVA
			call	println
			push	dword ptr [edi + 6Ch]
			call	printn
			push	offset sDelayDSize
			call	println
		_NETDirectory:
			push	dword ptr [edi + 70h]
			call	printn
			push	offset sNETDRVA
			call	println
			push	dword ptr [edi + 74h]
			call	printn
			push	offset sNETDSize
			call	println

	sub		edi, 60h						; back to 1st offset of PE Header
	_SectionTable:							; Array of IMAGE_SECTION_HEADER
		add		edi, sizeof IMAGE_OPTIONAL_HEADER
		assume	edi: ptr IMAGE_SECTION_HEADER
		mov		sectionHeaderOffset, edi
		push	offset sSectionTable
		call	println

		mov		ebx, nSection					; Check if the file has any sections
		test	ebx, ebx
		je		_ExportSection

		_IMAGE_SECTION_HEADER:					; main contents of file
			test	ebx, ebx
			jz		_ExportSection
			dec		ebx

		_Name:								; 8 bytes Label, can be blank, not have \0 as string
			push	offset TAB
			call	StdOut
			push	edi
			call	println
		_VirtualSize:						; The actual size of section data, the real memory loader allocates
			push	offset TAB
			call	StdOut
			push	dword ptr [edi + 8h]
			call	printn	
			push	offset sVirtualSize
			call	println
		_VirtualAddress:					; RVA of section
			push	offset TAB
			call	StdOut
			push	[edi].VirtualAddress
			call	printn
			push	offset sVirtualAddress
			call	println
		_SizeOfRawData:						; Size of section data in file on disk, rounded up aligned by compiler
			push	offset TAB
			call	StdOut
			push	[edi].SizeOfRawData
			call	printn
			push	offset sSizeOfRawData
			call	println
		_PointerToRawData:					; Offset from the file beginning to section data. If 0 -> section data not contained 
			push	offset TAB
			call	StdOut
			push	[edi].PointerToRawData
			call	printn
			push	offset sPointerToRawData
			call	println
		_PointerToRelocations:					 
			push	offset TAB
			call	StdOut
			push	[edi].PointerToRelocations
			call	printn
			push	offset sPointerToRelocations
			call	println
		_PointerToLinenumbers:					
			push	offset TAB
			call	StdOut
			push	[edi].PointerToLinenumbers
			call	printn
			push	offset sPointerToLinenumbers
			call	println
		_NumberOfRelocations:					
			push	offset TAB
			call	StdOut
			movzx	edx,[edi].NumberOfRelocations
			push	edx
			call	printn
			push	offset sNumberOfRelocations
			call	println

		__Characteristics:
			push	offset TAB
			call	StdOut
			push	[edi].Characteristics
			call	printn
			push	offset sCharacteristics
			call	println
		add		edi, 28h
		push	offset NL
		call	StdOut
		jmp		_IMAGE_SECTION_HEADER


	_ExportSection:							; DLL export functions by name/ordinal only (dw unique identifies a function in a DLL.
		push	offset sExportSection
		call	println
		cmp		exRVA, 0
		jnz		_Export
		push	offset sNoExport
		call	println
		jmp		_ImportSection
	
			_Export:							
			push	nSection
			push	sectionHeaderOffset
			push	exRVA
			call	RVAtoOffset
			mov		edi, eax
			add		edi, pMap
			assume	edi: ptr IMAGE_EXPORT_DIRECTORY

				_nName:							; Internal name of module in case user changed name of file
				push	nSection
				push	sectionHeaderOffset
				push	[edi].nName
				call	RVAtoOffset
				add		eax, pMap
				mov		ebx, eax
				push	offset	TAB
				call	StdOut
				push	ebx
				call	println
				_nBase:							; Starting ordinal number
				push	offset	TAB
				call	StdOut
				mov		edx, [edi].nBase
				mov		nBase, edx
				push	edx
				call	printn
				push	offset snBase
				call	println

				_NumberOfFunctions:				; total functions that are exported by this module
				push	offset	TAB
				call	StdOut
				push	[edi].NumberOfFunctions
				call	printn
				push	offset sNumberOfFunctions
				call	println
				_NumberOfNames:					; total symbols exported by name. If export by ordinal, it may not needed.
				push	offset	TAB
				call	StdOut
				mov		edx, [edi].NumberOfNames
				mov		nName, edx
				push	edx
				call	printn
				push	offset sNumberOfNames
				call	println
				_AddressOfNameOrdinal:
				push	offset	TAB_x2
				call	StdOut
				push	nSection
				push	sectionHeaderOffset
				push	[edi].AddressOfNameOrdinals
				call	RVAtoOffset
				add		eax, pMap
				mov		exOrdinalOffset, eax

				@noOrdinalExport:
					_AddressOfFunctions:
					push	nSection
					push	sectionHeaderOffset
					push	[edi].AddressOfFunctions
					call	RVAtoOffset
					add		eax, pMap
					mov		exFuncOffset, eax
				
					_AddressOfNames:
					push	nSection
					push	sectionHeaderOffset
					push	[edi].AddressOfNames
					call	RVAtoOffset
					add		eax, pMap
					mov		exNameOffset, eax

				@nextExport:
					cmp		nName, 0
					jng		_ImportSection

					_RVA:

					mov		eax, exOrdinalOffset
					xor		ebx, ebx
					mov		bx, [eax]
					push	ebx						; save ebx
					shl		ebx, 2
					add		ebx, exFuncOffset
					push	dword ptr [ebx]
					call	printnum 
					push	offset sRVA
					call	println
					_Ordinal:
					push	offset	TAB_x2
					call	StdOut
					pop		ebx						; pop to ebx
					add		ebx, nBase
					push	ebx
					call	printnum
					push	offset	TAB
					call	StdOut
					push	offset sOrdinal
					call	println
					_Name1:
					push	offset	TAB_x2
					call	StdOut
					mov		edx, dword ptr exNameOffset
					push	nSection
					push	sectionHeaderOffset
					push	dword ptr [edx]
					call	RVAtoOffset
					add		eax, pMap
					push	eax	
					call	println
					push	offset	TAB
					call	StdOut
					push	offset sFuncName
					call	println
				dec		nName
				add		exNameOffset, 4			; next name
				add		exOrdinalOffset, 2			
				jmp		@nextExport

	_ImportSection:
	push	offset sImportSection
	call	println
	push	nSection
	push	sectionHeaderOffset
	push	imRVA
	call	RVAtoOffset						; calculate offset

	mov		edi, eax
	add		edi, pMap
	assume	edi: ptr IMAGE_IMPORT_DESCRIPTOR

		@nextImportDLL:
		cmp		[edi].OriginalFirstThunk, 0
		jne		_Import
		cmp		[edi].TimeDateStamp, 0
		jne		_Import
		cmp		[edi].ForwarderChain, 0
		jne		_Import
		cmp		[edi].Name1, 0
		jne		_Import
		cmp		[edi].FirstThunk, 0
		jne		_Import
		jmp		_CloseHandle			; no imports left

		_Import:
			push	nSection
			push	sectionHeaderOffset
			push	[edi].Name1
			call	RVAtoOffset
			mov		ebx, eax
			add		ebx, pMap

			_NameOfDLL:
			push	offset TAB
			call	StdOut
			push	ebx
			call	println
			
			push	nSection
			push	sectionHeaderOffset
				@byOriginalFirstThunkOrbyFirstThunk:
				cmp		[edi].OriginalFirstThunk, 0
				jne		@byOriFirstThunk
					@byFirstThunk:
					push	[edi].FirstThunk
					jmp		@calc
					@byOriFirstThunk:
					push	[edi].OriginalFirstThunk
			@calc:
			call	RVAtoOffset
			add		eax, pMap
			mov		esi, eax

			_FunctionsList:					; IMAGE_IMPORT_BY_NAME
			push	edi

				_Function:
				cmp		dword ptr [esi], 0
				je		@nextDLL
					@byNameorbyOrdinal:
					test	dword ptr [esi], IMAGE_ORDINAL_FLAG32
					jnz		@byOrdinal

					@byName:
					push	nSection
					push	sectionHeaderOffset
					push	dword ptr [esi]
					call	RVAtoOffset
					mov		edi, eax
					add		edi, pMap
					assume	edi: ptr IMAGE_IMPORT_BY_NAME

						__Name1:
							push	offset TAB_x2
							call	StdOut
						lea		edx, [edi].Name1
						push	edx
						call	println
						jmp		@nextImport
					@byOrdinal:
					mov		edx, dword ptr [esi]
					and		edx, 0FFFFh
					push	edx
					call	printn
			
				@nextImport:
				add		esi, 4
				jmp		_Function
			
			@nextDLL:
			pop		edi
			add		edi, sizeof IMAGE_IMPORT_DESCRIPTOR
			jmp		@nextImportDLL

	_CloseHandle:									; Close handle, unmap, exit
	push	pMap
	call	UnmapViewOfFile
	push	hFile
	call	CloseHandle
	push	hMap
	call	CloseHandle
	ret


errExit:
	push	hFile
	call	CloseHandle
	push	hMap
	call	CloseHandle
	push	offset errMsg
	call	StdOut
	ret

main ENDP
print_tabx2 PROC	; print with linefeed
	push	ebp
	mov		ebp, esp
	push	offset TAB
	call	StdOut
	push	offset TAB
	call	StdOut
	mov		esp, ebp
	pop		ebp
	ret		4h
print_tabx2 ENDP
println PROC	; print with linefeed
	push	ebp
	mov		ebp, esp
	push	ecx
	push	[ebp + 8h]
	call	StdOut
	push	offset NL
	call	StdOut
	pop		ecx
	mov		esp, ebp
	pop		ebp
	ret		4h
println ENDP
printtb PROC	; print with linefeed
	push	ebp
	mov		ebp, esp
	push	ecx
	push	[ebp + 8h]
	call	StdOut
	push	offset TAB
	call	StdOut
	pop		ecx
	mov		esp, ebp
	pop		ebp
	ret		4h
printtb ENDP


printn PROC
	push	ebp
	mov		ebp, esp
	push	offset TAB
	call	StdOut
	push	offset hex
	call	StdOut
	push	[ebp + 8] ; value
	push	offset sTemp ; value as string
	call	itoa
	push	eax
	call	printtb

	mov		esp, ebp	
	pop		ebp
	ret		4
printn ENDP

printnum PROC
	push	ebp
	mov		ebp, esp

	push	offset hex
	call	StdOut
	push	[ebp + 8] ; value
	push	offset sTemp ; value as string
	call	itoa
	push	eax
	call	StdOut
	mov		esp, ebp	
	pop		ebp
	ret		4
printnum ENDP
itoa PROC	; para1 = val, para2 = string
	push	ebp
	mov		ebp, esp
	push	edi
	push	ebx
	push	edx
	push	ecx
	mov		ebx, 10h
	mov		eax, [ebp + 0Ch]
	mov		edi, [ebp + 8h]
	clearstring:
		push	eax
		cld
		mov		ecx, 9
		mov		al, 0
		rep		stosb
		pop		eax
	dec		edi
	@nxtChr:
		dec		edi
		xor		edx, edx
		div		ebx
		cmp		edx, 0Ah
		jl		@xor30
		add		edx, 37h
		jmp		@continue
		@xor30:
		xor		edx, 30h
		@continue:
		mov		byte ptr [edi], dl
		test	eax, eax			
		jnz		@nxtChr
	mov		eax, edi
	pop		ecx
	pop		edx
	pop		ebx
	pop		edi
	mov		esp, ebp
	pop		ebp
	ret		8h
itoa ENDP
RVAtoOffset PROC
	push	ebp
	mov		ebp, esp
	push	edi
	push	edx
	mov		edx, [ebp + 8h]					; RVA
	mov		edi, [ebp + 0Ch]				; offset section Header
	assume	edi: ptr IMAGE_SECTION_HEADER
	mov		ecx, [ebp + 10h]				; number of sections

		@sectionIterate:
		test	ecx, ecx
		jz		@return
			cmp		edx, [edi].VirtualAddress	; if RVA of current is less -> jump next section
			jl		@nextSection
				mov		eax, [edi].VirtualAddress
				add 	eax, dword ptr [edi + 8h]
				cmp		edx, eax					; if RVA is greater than sectionHeader + virtualSize ->  next
				jge		@nextSection
					mov		eax, [edi].VirtualAddress
					sub		edx, eax
					mov		eax, [edi].PointerToRawData 
					add		eax, edx					; Offset = Ptr - VirtualAddress + PointerToRawData
					jmp		@return
		@nextSection:
		add		edi, sizeof IMAGE_SECTION_HEADER
		dec		ecx
		jmp		@sectionIterate
		mov		eax, edx
	@return:
	pop		edx
	pop		edi
	mov		esp, ebp
	pop		ebp
	ret		0Ch
RVAtoOffset ENDP
end main