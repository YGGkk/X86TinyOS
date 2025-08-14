%include "boot.inc"
SECTION loader vstart=LOADER_BASE_ADDR

; print MBR
; A 表示绿色背景闪烁,4 表示前景色为红色
    mov byte [gs:0x00], '2' 
    mov byte [gs:0x01], 0xA4 

    mov byte [gs:0x02], 'L' 
    mov byte [gs:0x03], 0xA4 

    mov byte [gs:0x04], 'O' 
    mov byte [gs:0x05], 0xA4 

    mov byte [gs:0x06], 'A' 
    mov byte [gs:0x07], 0xA4 

    mov byte [gs:0x08], 'D' 
    mov byte [gs:0x09], 0xA4

    mov byte [gs:0x0a], 'E' 
    mov byte [gs:0x0b], 0xA4

    mov byte [gs:0x0c], 'R' 
    mov byte [gs:0x0d], 0xA4

jmp $