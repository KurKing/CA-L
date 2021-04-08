TITLE ЛР_4 
;------------------------------------------------------------------------------
;ЛР  №4
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
STACK 1024		; Директива - розмір стеку 

DATASEG
array_stack dw 2E2Eh, 2098h, 6847h, 7230h, 5182h, 1964h, 7350h, 1628h, 9823h, 5927h, 2343h, 7515h, 5238h, 8272h, 6576h, 2619h
            dw 9520h, 6608h, 5535h, 9745h, 8314h, 1683h, 2065h, 3718h, 3198h, 5267h, 1546h, 2273h, 9317h, 2181h, 7466h, 1940h
            dw 7417h, 2385h, 2240h, 8346h, 9246h, 9573h, 5050h, 1549h, 4402h, 7854h, 8126h, 9060h, 3476h, 7497h, 3703h, 1857h
            dw 8794h, 8017h, 3227h, 1033h, 7980h, 8658h, 6475h, 2653h, 4970h, 3343h, 3788h, 4600h, 4953h, 5156h, 7128h, 9539h
            dw 4889h, 8734h, 8685h, 3104h, 5514h, 9721h, 5958h, 4611h, 7759h, 1725h, 6059h, 7499h, 9681h, 4573h, 6929h, 1387h
            dw 2772h, 5484h, 7392h, 8250h, 5503h, 6080h, 1249h, 3413h, 3167h, 9250h, 7496h, 7533h, 2101h, 4007h, 6810h, 4531h
            dw 4979h, 9050h, 8589h, 6962h, 5374h, 3451h, 2971h, 6612h, 8002h, 4074h, 2634h, 3694h, 7979h, 7571h, 7333h, 9852h
            dw 9847h, 3270h, 2426h, 6722h, 2697h, 9765h, 2203h, 3222h, 6819h, 5024h, 5846h, 3619h, 9626h, 2638h, 4465h, 2E2Eh
            
first_birthdate db "8.10|09.10|24.04"           

CODESEG
Start:
    mov ax, @data ; data segment init
    mov ds, ax
    mov es, ax

; set params for copy_array
    mov cx, 128                 ; repeats amount
    call copy_arr
    
; set params for array_to_stack
    mov cx, 128                 ; repeats amount
    call array_to_stack

    mov ax, @stack

; set params for set_bdates
    mov cx, 16
    mov bp, 0150h
    call set_bdates

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
            mov [ds:[si+130h]], bx       ; set value from bx to ds with offset 
            add si, 2                    ; si value + 2
            loop array_coping_loop

        ret
    ENDP   

;--------------------------------------------Put array to stack procedure-------------------------------------------         
; Input params:  cx - initial array size,
; Output params: array copy placed at ds,
;------------------------------------------------------------------------------------------------------------------- 
    PROC array_to_stack            
        xor si, si                       ; set si to zero
        push_to_stack:
            mov ax,[ds:[si]]             ; set value to ax from ds with offset si
            push ax                      ; push ax value to stack
            add si, 2                    ; si + 2
            loop push_to_stack

        ret
    ENDP

;--------------------------------------------Add birthdate to stack-------------------------------------------         
; Input params: cx - symbols amount at birthday,
;               bp - offset
; Output params: array copy placed at ds,
;----------------------------------------------------------------------------------------------------------- 
    PROC set_bdates       
        xor si,si                                 ; set si to zero
        birthdate_label:
            mov ah, [first_birthdate+si]          ; set value to ah from first_birthdate with offset si
            mov [bp], ah                          ; add value to stack
            inc si                                ; increment si
            inc bp                                ; increment bp
            loop birthdate_label

        ret
    ENDP
end Start