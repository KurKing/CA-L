TITLE ЛР_5
;------------------------------------------------------------------------------
;ЛР  №5
;------------------------------------------------------------------------------
; Комп'ютерна архітектура
; ВУЗ:          НТУУ "КПІ"
; Факультет:    ФІОТ
; Курс:          1
; Група:       ІТ-01
;------------------------------------------------------------------------------
; Автор:        Бардін В. Д.
;               Задніпрянець А. А.
;               Куркін О. О.
;
; Дата:         04/04/21
;---------------------------------
IDEAL			; Директива - тип Асемблера tasm 
MODEL small		; Директива - тип моделі пам’яті 
STACK 2048		; Директива - розмір стеку 

DATASEG
array_stack db 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9
            db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7
            db 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8
            db 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
            db 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9
            db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7
            db 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8
            db 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
            db 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9
            db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7
            db 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8
            db 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
            db 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9
            db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7
            db 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8
            db 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
LEN DW 256

first_birthdate db "08102002"            
second_birthdate db "09102002"
third_birthdate db "24042003"
defaulf_birthdate db "00000000"
CODESEG
Start:
    mov ax, @data ; data segment init
    mov ds, ax
    mov es, ax

    mov cx, [LEN]   ;Cx is counter for OUTERLOOP CX=5    
    dec cx          ; CX = 4 
    call sort

; set params for copy_array
    mov cx, 256                 ; repeats amount
    call copy_arr
    
; set params for set_bdates
    mov cx, 8
    mov bp, 0151h
    call set_bdatesd

; set params for set_bdates
    mov cx, 8
    mov bp, 0161h
    call set_bdates1

; set params for set_bdates
    mov cx, 8
    mov bp, 0171h
    call set_bdates2

; set params for set_bdates
    mov cx, 8
    mov bp, 0181h
    call set_bdates3

; set params for set_bdates
    mov cx, 8
    mov bp, 0191h
    call set_bdatesd

; set params for set_bdates
    mov cx, 8
    mov bp, 01A1h
    call set_bdatesd

; set params for set_bdates
    mov cx, 8
    mov bp, 01B1h
    call set_bdatesd

; set params for set_bdates
    mov cx, 8
    mov bp, 01C1h
    call set_bdatesd


; application finishing
    mov ah, 4ch
    int 21h

;--------------------------------------------Copy array procedure-------------------------------------------         
; Input params: cx - initial array size,
; Output params: array copy placed at ds,
;----------------------------------------------------------------------------------------------------------- 
    PROC copy_arr       
        xor si, si                       ; set si to zero
        array_coping_loop:
            mov bx, [ds:si]              ; get number from array_array stack & set it to bx as a temp variable
            mov [ds:[si+270h]], bx       ; set value from bx to ds with offset 
            add si, 2                    ; si value + 2
            loop array_coping_loop

        ret
    ENDP   

;--------------------------------------------Add birthdate to stack-------------------------------------------         
; Input params: cx - symbols amount at birthday,
;               bp - offset
; Output params: array copy placed at ds,
;----------------------------------------------------------------------------------------------------------- 
    PROC set_bdates1       
        xor si,si                                 ; set si to zero
        birthdate1_label:
            mov ah, [first_birthdate+si]          ; set value to ah from first_birthdate with offset si
            mov [bp], ah                          ; add value to stack
            inc si                                ; increment si
            inc bp                                ; increment bp
            loop birthdate1_label

        ret
    ENDP

;--------------------------------------------Add birthdate to stack-------------------------------------------         
; Input params: cx - symbols amount at birthday,
;               bp - offset
; Output params: array copy placed at ds,
;----------------------------------------------------------------------------------------------------------- 
    PROC set_bdates2     
        xor si,si                                 ; set si to zero
        birthdate2_label:
            mov ah, [second_birthdate+si]          ; set value to ah from second_birthdate with offset si
            mov [bp], ah                          ; add value to stack
            inc si                                ; increment si
            inc bp                                ; increment bp
            loop birthdate2_label

        ret
    ENDP


;--------------------------------------------Add birthdate to stack-------------------------------------------         
; Input params: cx - symbols amount at birthday,
;               bp - offset
; Output params: array copy placed at ds,
;----------------------------------------------------------------------------------------------------------- 
    PROC set_bdates3
        xor si,si                                 ; set si to zero
        birthdate3_label:
            mov ah, [third_birthdate+si]          ; set value to ah from third_birthdate with offset si
            mov [bp], ah                          ; add value to stack
            inc si                                ; increment si
            inc bp                                ; increment bp
            loop birthdate3_label

        ret
    ENDP

;--------------------------------------------Add birthdate to stack-------------------------------------------         
; Input params: cx - symbols amount at birthday,
;               bp - offset
; Output params: array copy placed at ds,
;----------------------------------------------------------------------------------------------------------- 
    PROC set_bdatesd
        xor si,si                                 ; set si to zero
        dbirthdate_label:
            mov ah, [defaulf_birthdate+si]          ; set value to ah from third_birthdate with offset si
            mov [bp], ah                          ; add value to stack
            inc si                                ; increment si
            inc bp                                ; increment bp
            loop dbirthdate_label

        ret
    ENDP

    PROC sort
        nextscan:                ; do {    // outer loop
            mov bx,cx
            mov si,0 

        nextcomp:

            mov al,[array_stack+si]
            mov dl,[array_stack+si+1]
            cmp al,dl

            jnc noswap 

            mov [array_stack+si], dl
            mov [array_stack+si+1], al

        noswap: 
            inc si
            dec bx
            jnz nextcomp

            loop nextscan

        ret
    ENDP

end Start