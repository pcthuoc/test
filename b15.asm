.586
.model flat, stdcall
option casemap: none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc 
include \masm32\include\masm32.inc 
include \masm32\include\msvcrt.inc
include \masm32\include\comdlg32.inc
include \masm32\include\user32.inc
include \masm32\include\msimg32.inc
include \masm32\include\gdi32.inc
includelib \masm32\lib\msvcrt.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\msimg32.lib
includelib \masm32\lib\gdi32.lib

.data
    szClassName         db  "BoucingBall", 0
    lpMainWindowName    db  "Boucing Ball", 0
.data?
    wndclass    db  80  dup(?)      ; WNDCLASSEXA
    msg         db  48  dup(?)      ;  MSG
    hdc         dd  ?               ; HDC
    hwnd        dd  ?    
    lpTime      db  16  dup(?)      ; SYSTEMTIME
    rect        db  16  dup(?)      ; RECT
    tmpRect     db  16  dup(?)      ; RECT
    hWhiteBrush dd  ?
    hRedBrush   dd  ?
    xDir        dd  ?
    yDir        dd  ?
    x           dd  ?
    y           dd  ?
    xOld        dd  ?
    yOld        dd  ?
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
    xor     eax,eax
    push    0ffh
    call    CreateSolidBrush
    mov     hRedBrush, eax   

    mov     dword ptr [wndclass + 20h], 0      ; ->hbrBackgrount = COLOR_BACKGROUND
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
    push    300             ; nHeight
    push    400             ; nWidth
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
    push    ebx
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
    sub     eax, 111h       
    jz      @WM_TIMER        ; WM_COMMAND = 113h
    sub     eax, 101h       
    jz      @WM_SIZING       ; WM_SIZING = 214h
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
        ; Randomize direction
        push    offset lpTime
        call    GetLocalTime
        mov     bx, word ptr [lpTime + 0ch]  ; lpTime->wSecond
        and     bx, 3               ; clear out and save only last 2 bits (so that result only have 4 possible values)
        jz      rightUp             ; bl == 0
        dec     bl
        jz      leftUp              ; bl == 1
        dec     bl                  
        jz      rightDown           ; bl == 2
        jmp     leftDown            ; bl == 3   
        ; set direction
        rightUp:
            mov     xDir, 5
            mov     yDir, 5
            jmp     setLocation
        leftUp:
            mov     xDir, -5
            mov     yDir, 5
            jmp     setLocation
        rightDown:
            mov     xDir, 5
            mov     yDir, -5
            jmp     setLocation
        leftDown:
            mov     xDir, -5
            mov     yDir, -5

        setLocation:                ; set the ball at middle of window
            push    offset rect
            push    [ebp+08h]
            call    GetClientRect
            mov     eax, dword ptr [rect + 8]     ; rect->right
            shr     eax, 1              ; >> 1 (equal /2)
            sub     eax, 10             ; rBall = 10
            mov     x, eax
            mov     eax, dword ptr [rect + 0ch]   ; rect->bottom
            shr     eax, 1              ; >> 1 (equal /2)
            sub     eax, 10             ; rBall = 10
            mov     y, eax  
            ; create timer
            push    0               ; null
            push    17
            push    1
            push    [ebp+08h]
            call    SetTimer            ; SetTimer(hwnd, 1, 14, NULL)
            jmp     @exitProc
    @WM_DESTROY:
        push    1
        push    [ebp+08h]
        call    KillTimer
        push    0
        call    PostQuitMessage
        jmp     @exitProc

    @WM_TIMER:
        push    [ebp + 08h]
        call    GetDC
        mov     hdc, eax
        push    hWhiteBrush
        push    hdc
        call    SelectObject
        mov     ebx, eax

        ; fill in tmpRect old position of the ball
        mov     eax, xOld   
        mov     dword ptr [tmpRect], eax          ; temp.left = oldX;
        add     eax, 20                 
        mov     dword ptr [tmpRect + 8], eax      ; temp.right = oldX + 20;
        mov     eax, yOld               ; temp.top = oldY;
        mov     dword ptr [tmpRect + 4], eax
        add     eax, 20
        mov     dword ptr [tmpRect + 0ch], eax    ; temp.bottom = oldY + 20;

        push    ebx                 ; hbrl
        push    offset  tmpRect     ;*lprc,
        push    hdc
        call    FillRect                ; erase the old ball 

        ; paint new ball
    
        push    hRedBrush
        push    hdc
        call    SelectObject
        mov     eax, y
        add     eax, 20
        push    eax                 ; y+20
        mov     eax, x
        add     eax, 20
        push    eax                 ; x+20
        push    y                       ; y
        push    x                   ; x
        push    hdc                 ; hdc
        call    Ellipse         ; Ellipse(hdc, x, y, 20 + x, 20 + y);
    
        mov     eax, x
        mov     xOld, eax
        mov     eax, y
        mov     yOld, eax
    
        ; prep new coordinates for the ball 
        ; if the ball is going to go off the edges, reverse direction
        mov     ebx, -1
        mov     eax, x
        add     eax, xDir
        cmp     eax, 0                  ; if x + xDir < 0
        jl      reverseX
        add     eax, 20                 
        cmp     eax, dword ptr [rect + 8]         ; if x + xDir + 20 > rect.right
        jg      reverseX

        checkY:
        mov     eax, y
        add     eax, yDir
        cmp     eax, 0                  ; if y + yDir < 0
        jl      reverseY
        add     eax, 20                 
        cmp     eax, dword ptr [rect + 0ch]       ; if y + yDir + 20 > rect.bottom
        jg      reverseY
        jmp     updateCoordinates

        reverseX:
        mov     eax, xDir
        imul    ebx
        mov     xDir, eax
        jmp     checkY

        reverseY:
        mov     eax, yDir
        imul    ebx
        mov     yDir, eax

        ; update coordinates
        updateCoordinates:
        mov     eax, x
        add     eax, xDir
        mov     x, eax
        mov     eax, y
        add     eax, yDir
        mov     y, eax

        ; release DC
        push    hdc
        push    [ebp + 08h]
        call    ReleaseDC
        jmp     @exitProc

    @WM_SIZING:
        push    offset rect
        push    [ebp+08h]
        call    GetClientRect
        ; if the ball is outside the window, put it back
        checkEdge:
        mov     eax, x
        cmp     eax, 0
        jl      putLeftEdge
        add     eax, 20
        cmp     eax, dword ptr [rect + 8]
        jg      putRightEdge
        mov     eax, y
        cmp     eax, 0
        jl      putTopEdge
        add     eax, 20
        cmp     eax, dword ptr [rect + 0ch]
        jg      putBottomEdge
        jmp     @exitProc

        putLeftEdge:
        xor     eax, eax
        mov     x, eax
        jmp     checkEdge

        putRightEdge:
        mov     eax, dword ptr [rect + 8]
        sub     eax, 20
        mov     x, eax
        jmp     checkEdge

        putTopEdge:
        xor     eax, eax
        mov     y, eax
        jmp     checkEdge

        putBottomEdge:
        mov     eax, dword ptr [rect + 0ch]
        sub     eax, 20
        mov     x, eax
        jmp     checkEdge

    @exitProc:
    pop     ebx
    mov     esp,ebp
    pop     ebp
    ret     16


WinProc endp 
end WinMainCRTStartup