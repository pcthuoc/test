.586
.model flat, stdcall
option casemap: none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc 
include \masm32\include\masm32.inc 
include \masm32\include\msvcrt.inc
include \masm32\include\comdlg32.inc
include \masm32\include\user32.inc
includelib \masm32\lib\msvcrt.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\user32.lib

.data
    szClassName         db  "TextReverse", 0
    lpMainWindowName    db  "Text Reverse", 0
    lpClassNameEdit     db  "EDIT", 0
    lpClassNameStatic   db  "STATIC", 0
    lpWindowNameInput    db  "Input string:", 0
    lpWindowNameOutput   db  "Reversed string:", 0
.data?
    wndclass    db  200  dup(?)      ; struct WNDCLASSEXA
    msg         db  48  dup(?)      ; struct MSG
    hwnd        dd  ?    
    buffer      db  255 dup(?)
 ; PROTO
;WinProc PROTO hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
.code
WinMainCRTStartup proc

    push    0
    call    GetModuleHandleA
    mov     ecx,eax
    call    GetCommandLineA
    push    10          ; nShowCmd
    push    eax         ; lpCmdLine
    push    0           ; hPrevInstance
    push    ecx         ; hInstance    
    call    WinMain
    push    0
    call    ExitProcess

WinMainCRTStartup endp
WinMain proc
    push    ebp
    mov     ebp,esp
    mov     ecx,[ebp+8h]
    mov     dword ptr [wndclass + 14h], ecx         ; ->hInstance
    mov     dword ptr [wndclass], 30h                ; ->cbSize = sizeof WNDCLASSEXA
    mov     dword ptr [wndclass + 4], 3        ; ->style = CS_HREDRAW | CS_VREDRAW
    mov     ecx,offset WinProc
    mov     dword ptr [wndclass + 8], ecx       ; ->lpfnWndProc = WinProc    
    mov     dword ptr [wndclass + 0ch], 0       ; ->cbClsExtra = 0
    mov     dword ptr [wndclass + 10h], 0       ; ->cbWndExtra = 0
    ;push    0 
    push    32512                               ; IDI_APPLICATION aka standard icon ids
    push    0
    call    LoadIconA
    mov     dword ptr [wndclass + 18h], eax     ; -> hIcon = LoadIconA(NULL, IDI_APPLICATION)
    ;push    0
    push    32512                          ; IDC_ARROW aka standard cursor ids
    push    0
    call    LoadCursorA
    mov     dword ptr [wndclass + 1ch], eax     ; ->hCursor = 
    mov     dword ptr [wndclass + 20h], 1       ; ->hbrBackgrount = COLOR_BACKGROUND
    mov     dword ptr [wndclass + 24h], 0       ; -> lpszMenuName = null
    mov     ecx, offset szClassName
    mov     dword ptr [wndclass + 28h], ecx     ; -> lpszClassName = "TextReverse"
    mov     ecx, dword ptr [wndclass + 18h]
    mov     dword ptr [wndclass + 2ch], ecx     ; -> hIconSm = LoadIconA(NULL, IDI_APPLICATION)

    ; try registering class
    push    offset wndclass
    call    RegisterClassExA
    test    ax, ax
    jz      exitProgram       

    ; once registered succeedfully create program...
    push    0               ; lpParam
    mov     eax,[ebp+8h]
    push    eax             ; hInstance
    push    0               ; hMenu
    push    0               ; hWndParent
    push    130             ; nHeight
    push    500             ; nWidth
    push    80000000h       ; Y
    push    80000000h       ; X
    push    0CF0000h        ; dwStyle
    push    offset lpMainWindowName                ; title text
    push    offset szClassName
    push    0               ; dwEXStyle
    call    CreateWindowExA
    mov     hwnd, eax

    ; make the window visible on screen
    push    1
    push    eax   
    call    ShowWindow

    ; run msg loop
    gettingMessage:
    push    0               ; wMsgFilterMax
    push    0               ; wMsgFilterMin
    push    0               ; hWnd
    push    offset msg 
    call    GetMessageA
    test    eax,eax
    jz      exitProgram     ; in fact it is return msg.wParam but it always is 0 (= PostQuitMessage() return value)
  

    ; translate virtual key msg into character msg
    push    offset msg 
    call    TranslateMessage    

    ; send to WinProc
    push    offset msg
    call    DispatchMessageA
    jmp     gettingMessage  ; loop
    exitProgram:
        call    ExitProcess
        ret     16


WinMain endp
;WinProc PROTO hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
;WinProc PROTO hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
WinProc proc 
    push    ebp 
    mov     ebp,esp
    ; mov    [ebp+14h]    ;      lParam     
    ; mov      [ebp+10h]    ;      wParam
    ; mov     [ebp+0ch]     ;      msg
    ; mov     [ebp+08h]     ;  hwnd
    mov     eax,[ebp+0ch]     ;&msg 

    ; implement switch-case
    dec     eax
    jz      @WM_CREATE       ; WM_CREATE = 1
    dec     eax
    jz      @WM_DESTROY      ; WM_DESTROY = 2
    sub     eax, 10fh       
    jz      @WM_COMMAND      ; WM_COMMAND = 0x0111
    ; for other messages  
    mov     eax ,[ebp+14h]
    push    eax 
    mov     eax ,[ebp+10h]
    push    eax
    mov     eax ,[ebp+0ch]
    push    eax
    mov     eax ,[ebp+08h]
    push    eax
    call    DefWindowProcA         ; DefWindowProcA(hwnd, message, wParam, lParam)
    jmp     @exitProc
    @WM_CREATE:
    ; first editbox and label
    push    0               ; lpParam
    push    0               ; hInstance
    push    11              ; hMenu
    mov     eax,[ebp+08h]   ; hwnd 
    push    eax 
    push    30              ; height = 30
    push    150             ; width = 250
    push    10              ; y = 10 form mainwindow
    push    10              ; x = 10 from mainwindow
    push    50000000h       ; dwStyle 
    push    offset lpWindowNameInput
    push    offset lpClassNameStatic
    push    0               ;  dwExStyle
    call    CreateWindowExA
    
    push    0               ; lpParam
    push    0               ; hInstance
    push    1               ; hMenu
    mov     eax,[ebp+08h]   ; hwnd 
    push    eax 
    push    30              ; height = 30
    push    250             ; width = 250
    push    10              ; y = 10 form mainwindow
    push    200             ; x = 10 from mainwindow
    push    50800000h        ; dwStyle 
    push    0
    push    offset lpClassNameEdit 
    push    0               ;  dwExStyle
    call    CreateWindowExA

    ; second editbox and label
    push    0               ; lpParam
    push    0               ; hInstance
    push    12              ; hMenu
    mov     eax,[ebp+08h]   ; hwnd 
    push    eax 
    push    30              ; height = 30
    push    150             ; width = 250
    push    50              ; y = 10 form mainwindow
    push    10              ; x = 10 from mainwindow
    push    50000000h       ; dwStyle 
    push    offset lpWindowNameOutput 
    push    offset lpClassNameStatic
    push    0               ;  dwExStyle
    call    CreateWindowExA

    push    0               ; lpParam
    push    0               ; hInstance
    push    2              ; hMenu
    mov     eax,[ebp+08]   ; hwnd 
    push    eax 
    push    30              ; height = 30
    push    250             ; width = 250
    push    50              ; y = 10 form mainwindow
    push    200              ; x = 10 from mainwindow
    push    50800000h       ; dwStyle 
    push    0
    push    offset lpClassNameEdit
    push    0               ;  dwExStyle
    call    CreateWindowExA
    jmp     @exitProc

    @WM_DESTROY:
    push    0
    call    PostQuitMessage
    jmp     @exitProc

    @WM_COMMAND:
    mov     eax, [ebp + 10h]
    sub     ax, 1       ; if hMenu = 1
    jz      @editBox1
    jmp     @exitProc

    @editBox1:
  
    
    push    255  
    push    offset buffer
    push    1
    mov     eax,[ebp+08h]   ; hwnd 
    push    eax 
    call    GetDlgItemTextA
    push    offset buffer 
    call    reverse

    
    push    offset buffer   ; lpString
    push    2               ; nIDDlgItem
    mov     eax,[ebp+08h]   
    push    eax             ; hwnd 
    call    SetDlgItemTextA

    @exitProc:
    mov     esp,ebp
    pop     ebp
    ret     16


WinProc endp 
reverse proc    ; reverse(str) use stack to reverse the string str, return strsize in rax
    push    ebp
    mov     ebp,esp 
    push    esi 
    push    edi 
    mov     edi, [ebp+08h]
    mov     esi, [ebp+08h]
    xor     eax,eax 
    xor     ecx,ecx
    cld     
    iterPush:               ; iterate string and push to stack
        lodsb                   ; al = byte ptr [rsi]++
        cmp     al, 0           ; check for 0 = end of data
        jz      startPop
        push    ax              ; push 16bit
        inc     cx
        jmp     iterPush

    startPop:
        sub     esi, edi
    iterPop:                ; pop back
        test    cx, cx
        jz      done
        pop     ax
        dec     cx
        stosb                   ; byte ptr [rdi]-- = al
        jmp     iterPop

    done:
        mov     eax,esi 
        dec     eax 
        pop     edi 
        pop     esi 
        mov     esp,ebp
        pop     ebp 
        ret     4
reverse endp
end WinMainCRTStartup