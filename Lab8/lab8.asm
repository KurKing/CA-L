;------------------------------------------------------------------------------
; Дисципліна: Архітектура комп'ютера
; НТУУ "КПІ"
; Факультет: ФІОТ
; Курс: 1
; Група: ІТ-01
;------------------------------------------------------------------------------
; Автор: Бардін, Задніпрянець, Куркін
; Дата: 06/05/2021
;----------------------------I.ЗАГОЛОВОК ПРОГРАМИ------------------------------
.model small
.stack 512
;-----------------------II.ПОЧАТОК СЕГМЕНТУ ДАНИХ------------------------------
.data
    ; Масив в якому буде знайдено найменше число
    array  dw 1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,0000h,1111h,1111h,1111h,1111h,1111h
        dw 1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h
        dw 1111h,1111h,1111h,9999h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h
        dw 1111h,1111h,1111h,1111h,1111h,1111h,8888h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h
        dw 1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h
        dw 1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h
        dw 1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h
        dw 1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h
        dw 1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h
        dw 1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h
        dw 1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h
        dw 1111h,1111h,2222h,1111h,0009h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h
        dw 1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h
        dw 1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h
        dw 1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h
        dw 1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h,1111h 

    len dw 100h
    string db 254       ;змінна для строки - string,

    port_b equ 61h
    command_reg equ 43h ;адреса командного регістру 
    channel_2 equ 42h   ;адреса каналу 2
    toprow equ 08       ;верхній рядок меню
    botrow equ 15       ;нижній рядок меню
    lefcol equ 26       ;лівий стовпчик меню
    attrib db ?         ;атрибути екрану
    row db 00           ;рядок екрану

    ;рядки головного меню
    shadow db 20 dup(0dbh);
    menu db 0c9h, 17 dup(0cdh), 0bbh
    db 0bah, '   Team number   ',0bah
    db 0bah, '   Team members  ',0bah
    db 0bah, '      Count      ',0bah
    db 0bah, '      Sound      ',0bah
    db 0bah, '    Min value    ',0bah
    db 0bah, '      Exit       ',0bah
    db 0c8h, 17 dup(0cdh), 0bch
    ;допоміжні повідомлення
    prompt db 'To select an item use arrows'
    db ' and press enter'
    db 13, 10, 'Press esc to exit                         '
    .386
    message_1 db "END", 13, 10, '$'
    message_2 db "BEEP", 13, 10, '$'
    message_3 db "RESULT:                               ", 13, 10, '$'   
    message_4 db "MIN VALUE:", 13, 10, '$'
    empty_message db " ", 13, 10, '$'
    ;рядки символів для виводу на екран
    team db "Team #1",10,13,'$'
    member1 db "Bardin Vlad",10,13,'$'
    member2 db "Zadnipryanets Artur",10,13,'$'
    member3 db "Kurkin Oleksii",10,13,'$'

;-----------------------III. ПОЧАТОК СЕГМЕНТУ КОДУ------------------------------
.code
    
    a10main proc far
            mov ax,@data 
            mov ds,ax 
            mov es,ax 
            call q10clear ; очистка екрану
            mov row,botrow+4 
        a20:
            call b10menu ;вивід меню
            mov row,toprow+1 ;вибір верхнього пункту меню 
            ; у якості початкового значення
            mov attrib,16h
            call d10disply
            call c10input

        jmp a20 ;
        a10main endp

        ; Вивід інтерфейсу користувача
        b10menu proc near
            pusha
            mov ax,1301h
            mov bx,0060h
            lea bp,shadow
            mov cx,19
            mov dh,toprow+1
            mov dl,lefcol+1

        b20: int 10h
            inc dh ;наступний рядок
            cmp dh,botrow+2
            jne b20
            mov attrib,25h
            mov ax,1300h
            movzx bx,attrib
            lea bp,menu
            mov cx,19 
            mov dh,toprow
            mov dl,lefcol
        b30:
            int 10h
            add bp,19
            inc dh
            cmp dh,botrow+1
            jne b30
            mov ax,1301h
            movzx bx,attrib
            lea bp,prompt
            mov cx,79
            mov dh,botrow+4
            mov dl,00
            int 10h
            popa
            ret
        b10menu endp
        ; натискування клавіш, управління через клавиші і enter
        ; для вибору пункту меню і клавіші esc для виходу
        c10input proc near
        pusha
        main_cycle: 
            mov ah,10h ;запитати один символ з кл.
            int 16h
            cmp ah,50h ;стрілка до низу
            je down_arrow_pressed
            cmp ah,48h ;стрілка до гори
            je up_arrow_pressed
            cmp al,0dh ;натистнено enter
            je enter_pressed ; enter_pressed
            cmp al,1bh ;натиснено escape
            je ecs_pressed ; вихід
        jmp main_cycle ;жодна не натиснена, повторення

        ; натиснено стрілка до низу
        down_arrow_pressed:
            mov attrib,25h
            call d10disply
            inc row
            cmp row,botrow-1
            jbe c50
            mov row,toprow+1
            jmp c50
        ; натиснено стрілка до гори
        up_arrow_pressed:
            mov attrib,25h
            call d10disply
            dec row
            cmp row,toprow+1
            jae c50
            mov row,botrow-1
        ; заливка виділеного поля
        c50:
            mov attrib,17h
            call d10disply
            jmp main_cycle
        ; натиснено esc
        ecs_pressed:
            jmp exit
        ; натиснено enter
        enter_pressed:
            popa 
            lea si,row
            mov ax,[ds:si]
            xor ah,ah
            mov bx, 8
            sub ax, bx
            ; вибір потрібної дії в залежності від натисненої кнопки
            cmp ax, 01h
            je  print_team_number
            cmp ax, 02h
            je print_team
            cmp ax, 03h
            je count
            cmp ax, 04h
            je beep
            cmp ax, 05h
            je min
            cmp ax, 06h
            je exit
            ret
        c10input endp
        ; вивід номеру команди
        print_team_number:
            mov dx, offset empty_message
            call display_information
            mov dx, offset team
            call display_information
            call pause1
            call screenClear
            jmp main_cycle
        ; вивід учасників команди
        print_team:
            mov dx, offset empty_message
            call display_information
            push ds
            mov ah, 25h
            mov al, 58h
            lea dx, print
            mov bx, seg print
            mov ds, bx
            int 21h
            pop ds
            int 58h
            jmp main_cycle
        ; обрахунок виразу
        count:
            mov dx, offset empty_message
            call display_information
            mov dx, offset message_3
            call display_information
            call math
            jmp main_cycle
        ; звуковий сигнал
        beep:
            mov dx, offset empty_message 
            call display_information
            mov dx, offset message_2 
            call display_information
            call sound; виклик функції звуку
            jmp main_cycle
        ; пошук найменшого значення
        min:
            mov dx, offset empty_message 
            call display_information
            mov dx, offset message_4
            call display_information
            call sort 
            mov ax, [ds:0000h]
            call output 
            jmp main_cycle
        ; стандартний вихід з програми
        exit:
            mov dx, offset empty_message 
            call display_information
            mov dx, offset message_1 
            call display_information
            mov ax,4c00h
            int 21h
        ; вивід повідомлення
        display_information proc
            mov ah,9
            int 21h
            xor dx, dx
            ret
        display_information  endp
        ; вивід числового значення
        output proc 
            mov [es:0475h],' '
            mov [es:0474h],' '
            mov [es:0473h],' '
            mov [es:0472h],' '
            mov [es:0471h],' '
            mov di,0470h

            push cx
            push dx
            push bx
            mov bx,10
            xor cx,cx
                
            flag1:   
                xor dx,dx
                div bx
                push dx
                inc cx
                test ax,ax
                jnz flag1
            flag2:   
                pop ax
                add al,'0'
                stosb
                loop flag2

                pop bx
                pop dx
                pop cx 

                mov [es:0475h],'$'
                mov dx, 0470h
                mov ah,09h
                int 21h
                
            call pause1
            call screenclear
            ret 
        output endp
        ; процедура виклику звукового сигналу
        sound proc
            lab8: 
                                ;встановлення частоти 440 гц
                                ;дозвіл каналу 2 встановлення порту в мікросхеми 8255
            in al,port_b        ;читання
            or al,3             ;встановлення двох молодших бітів
            out port_b,al       ;пересилка байта в порт b мікросхеми 8255
                                ;встановлення регістрів порту вводу-виводу
            mov al,10110110b    ;біти для каналу 2
            out command_reg,al  ;байт в порт командний регістр
                                ;встановлення лічильника 
            mov ax,2705         ;лічильник = 1190000/440
            out channel_2,al    ;відправка al
            mov al,ah           ;відправка старшого байту в al
            out channel_2,al    ;відправка старшого байту 
            ; пауза 1 секундy
            call pause1
            ; вимкнення звуку 
            in al,port_b        ;отримуємо байт з порту в
            and al,11111100b    ;скидання двох молодших бітів
            out port_b,al       ;пересилка байтів в зворотному напрямку
            ret
        sound endp
        ; процедура розрахунку математичного виразу
        math proc
            mov ax, -7
            mov bx, 3
            add ax, bx
            mov cl, 2h
            imul cl
            mov bl, 4
            idiv bl
            mov bl, 1
            add al, bl

            call output
            ret
        math endp
        ; процедура сортування масиву
        sort proc
            lea si, array
            mov cx, len    
                push    bx
                push    cx
                push    dx
                push    si
                push    di

                mov     bx,     si
                mov     dx,     cx
                dec     dx
                shl     dx,     1               
                dec     cx                      
                mov     si,     0
            fori:
                mov     di,     dx             
            forj:                                 
                mov     ax,     [bx+di]       
                cmp     ax,     [bx+di-2]
                jbe     nextj                
                xchg    ax,     [bx+di]         
                xchg    ax,     [bx+di-2]       
                xchg    ax,     [bx+di]         
            nextj:
                sub     di,     2              
                cmp     di,     si             
                ja      forj
                add     si,     2              
                loop    fori
            mov ax, [ds:01feh]
            call output       

            pop di
            pop si
            pop dx
            pop cx
            pop bx

            ret
        sort  endp
        ; забарвлення виділеного рядка
        d10disply proc near
            pusha 
            movzx ax,row 
            sub ax,toprow
            imul ax,19 
            lea si,menu+1 
            add si,ax
            mov ax,1300h 
            movzx bx,attrib 
            mov bp,si 
            mov cx,17 
            mov dh,row 
            mov dl,lefcol+1 
            int 10h
            popa 
            ret
        d10disply endp
        ; очищення екрану
        q10clear proc near
            pusha 
            mov ax,0600h
            mov bh,25h ;Встановлення кольору екрану 
            mov cx,00 
            mov dx,184fh
            int 10h
            popa 
            ret
        q10clear endp
        ; вивід імен учасників команди
        print proc far
            mov ah,09h
            mov dx, offset member1
            int 21h	
            mov dx, offset member2
            int 21h	
            mov dx, offset member3
            int 21h
            call pause1
            call screenclear
            iret
        print endp
        ; процедура очищення екрану
        screenclear proc
            call q10clear ; очистка екрану
            call b10menu ;вивід меню
            mov attrib,16h
            call d10disply
            ret
        screenclear endp
        ; пауза 1 секундy
        pause1 proc
            mov cx, 40 
            classic_loop:
                mov bx, cx
                mov  ah,86h
                xor cx, cx
                mov  dx,25000
                int  15h
                mov cx, bx 
            loop classic_loop
            ret
        pause1 endp
    end a10main