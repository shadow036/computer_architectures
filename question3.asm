.model small
.data
XFIELD DB "0", "0", "0", "0", "0", "0", "0", "0", "0", "5", "2", "3", "4", "5", "7", "0", "0", "4", "2", "2", "2", "2", "2", "0", "0", "6", "5", "4", "9", "8", "9", "0", "0", "7", "4", "1", "2", "4", "7", "0", "0", "9", "9", "9", "9", "9", "9", "0", "0", "4", "5", "6", "7", "6", "5", "0", "0", "0", "0", "0", "0", "0", "0", "0"
XRES DB ?
.code
.startup
main:
    push ax  ; avoid to overwrite the previous value of ax
    push bx  ; avoid to overwrite the previous value of bx
    mov bx, 10   ; assuming this is the input (index k), store it into the base register
    mov al, XFIELD[bx]  ; load the value at index bx in the lower part of ax, since each matrix entry corresponds to a single byte of data (it actually occupies at most 6 bits)
    cmp al, '0'      ; check if the chosen index corresponds to a location in a border position...
    jnz no_border  ; ...if not, skip the following 2 lines...
    mov XRES, 0 ; ... else store 0 and jump to the final part of the program
    jmp end
no_border: ; this section is executed if the index corresponds to an "internal" location of the matrix
    ; in the following I will use ah as the register to store the partial result:
    ; in this way I:
    ; 1) can save space (avoid using another register, say cx for example)
    ; 2) am sure not to overwrite the the existing value in al, since it doesn't occupy the ah part (the value in al is at most '9', which corresponds to 39 and occupies at most 6 bits)
    ; 3) am sure that ah is big enough for the same reason explained in the previous line
    mov ah, 0    ; set the accumulator register to 0
    add ah, XFIELD[bx-9]    ; sum the value in the upper left cell
    add ah, XFIELD[bx-7]    ; sum the value in the upper right cell
    add ah, XFIELD[bx+7]    ; sum the value in the lower left cell
    add ah, XFIELD[bx+9]    ; sum the value in the lower right cell
    sub ah, 0c0h            ; convert the resulting character into a number by subtracting 120 (since each there is an offset of 30 between a character representing a number and the number itself)
    mov XRES, ah            ; store final result
end:
    pop bx ; restore the initial value of bx
    pop ax ; restore the initial value of ax
.exit
end
