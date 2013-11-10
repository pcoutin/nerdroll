[BITS 16]
[ORG 0x7C00]

main:

    ; zero the data segment.
    mov ax,0x0000
    mov ds,ax

    mov si, Start
    call PutStr

    mov cx, 18h
    call timer

    mov si, keybord
    call PutStr

    mov cx, 24h
    call timer
    call rickroll

jmp $

; Procedures
saynever:
    mov si,nevers
    call PutStr
    ret

PutStr:        ; Procedure label/start
    mov ah,0x0E    ; The function to display a chacter (teletype)
    mov bh,0x00    ; Page number
    mov bl,0x07    ; Normal text attribute

    .nextchar
    lodsb
    or al,al
    jz .return

    int 0x10
    jmp .nextchar
    .return
    ret

timer: ;bit more than a second
    mov ah, 86h
    mov dx, 0000h
    int 15h
    ret

; these are macros defining values to represent frequencies to be
; played by the PC speaker as notes... sort of
%define _cm 00000100b
%define _cl 01110100b
%define _dm 00000011b
%define _dl 11110111b
%define _em 00000011b
%define _el 10001000b
%define _fm 00000011b
%define _fl 01010110b
%define _gm 00000010b
%define _gl 11111000b
%define _am 00000010b
%define _al 10100101b

beep:

    mov al, bl ;LSB
    out 42h,al

    mov al, bh ;MSB
    out 42h,al

    in al,61h
    or al,00000011b
    out 61h,al

    call timer
    in al,61h
    and al,11111100b
    out 61h,al
    ret

cnot:
    mov bl,_cl
    mov bh,_cm
    call beep
    ret
dnot:
    mov bl,_dl
    mov bh,_dm
    call beep
    ret
enot:
    mov bl,_el
    mov bh,_dm
    call beep
    ret
fnot:
    mov bl,_fl
    mov bh,_fm
    call beep
    ret
gnot:
    mov bl,_gl
    mov bh,_gm
    call beep
    ret
anot:
    mov bl,_al
    mov bh,_gm
    call beep
    ret

rickroll:
    mov al,10110110b 
    out 43h,al

    call saynever
    call nevergonna

    mov si,gives
    call PutStr
    call giveyouup

    call saynever
    call nevergonna

    mov si,lets
    call PutStr
    call letyoudown

    call saynever
    call nevergonna

    call dessert
    call rickroll
    ;ret


nevergonna:
    mov cx,2h

    call cnot
    call dnot
    call fnot
    call dnot
    
    ret

giveyouup:
    mov cx,3h

    call anot
    call timer

    call anot
    call timer

    mov cx,10h
    call gnot

    ret

letyoudown:
    mov cx,3h

    call gnot

    call timer

    call gnot

    call timer

    mov cx,10h
    call fnot
    ret

dessert:
    mov cx,8h
    mov si, runs
    call PutStr

    call fnot

    mov cx,4h
    call gnot

    mov cx,6h
    call enot

    mov cx,2h
    call dnot

    mov cx,4h
    call cnot

    mov cx,6h
    call timer

    mov si,deserts
    call PutStr

    mov cx,2h
    call cnot

    mov cx,8h
    call gnot

    call fnot
    call timer
    ret



Start db 'Starting MS-DOS...',13,10,13,10,13,10,'C:\>',0
keybord db 13,10,'Keyboard not found!',13,10,13,10,'Press any key to continue...',13,10,0

nevers db 13,10,'NEVER GONNA ',0
deserts db 13,10,'DESERT YOU',0
gives db 'GIVE YOU UP ',0
lets db 'LET YOU DOWN ',0
runs db 'RUN AROUND AND ',0


; End Matter
times 510-($-$$) db 0    ; Fill the rest with zeros
dw 0xAA55        ; Boot loader signature
