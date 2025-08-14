; main boot record
%include "boot.inc"
SECTION MBR vstart=0x7c00
    mov ax, cs
    mov ds, ax
    mov ex, ax
    mov ss, ax
    mov fs, ax
    mov sp, 0x7c00
    mov ax, 0xb800
    mov gs, ax
; clear screen
    mov ax, 0x0600
    mov bx, 0x0700
    mov cx, 0
    mov dx, 0x184f
    int 0x10
; print MBR
; A 表示绿色背景闪烁,4 表示前景色为红色
    mov byte [gs:0x00], '1' 
    mov byte [gs:0x01], 0xA4 

    mov byte [gs:0x02], ' ' 
    mov byte [gs:0x03], 0xA4 

    mov byte [gs:0x04], 'M' 
    mov byte [gs:0x05], 0xA4 

    mov byte [gs:0x06], 'B' 
    mov byte [gs:0x07], 0xA4 

    mov byte [gs:0x08], 'R' 
    mov byte [gs:0x09], 0xA4

; set the hard disk attribute
    mov eax, LOADER_START_SECTOR  ; the addr for start sector
    mov bx, LOADER_BASE_ADDR      ; the addr of loader
    mov cx, 1                     ; read 1 sector
    call rd_disk_m_16

    jmp LOADER_BASE_ADDR

; read write hard disk
rd_disk_m_16:
    mov esi, eax
    mov di, cx

; set the number of sector
    mov dx, 0x1f2  ; set the port 0x1f2
    mov al, cl
    out dx, al

; save the LBA addr to 0x1f3 ~ 0x1f6
    mov dx, 0x1f3
    out dx, al

    mov cl, 8
    shr eax, cl
    mov dx, 0xf14
    out dx, al

    shr eax, cl
    mov dx, 0xf15
    out dx, al

    shr eax, cl
    and al, 0x0f
    or  al, 0xe0
    mov dx, 0x1f6
    out dx, al

; set the read mode: 0x20 to port 0x1f7
    mov dx, 0xf17
    mov al, 0x20
    out dx, al

; check the status
  .not_ready:
    nop
    int al, ax
    and al, 0x88
    cmp al, 0x08
    jnz .not_ready

; read data from port 0x1f0
    mov ax, di
    mov dx, 256  ; 256 = di*512/2, each time "in" operator will read 2 byte
    mul dx
    mov cx, ax
    mov dx, 0x1f0

; loop 256 times
  .go_on_read:
    in ax, dx
    mov [bx], ax
    add bx, 2
    loop .go_on_read
    ret

    times 510-($-$$) db 0
    db 0x55, 0xaa