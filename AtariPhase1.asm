; Atari Breakout Phase 1
[org 0x0100]
jmp start

start:
	call clrscr
	call boxCaller
	jmp terminate
	
clrscr:	
	push es
	push ax
	push di

	mov ax, 0xb800
	mov es, ax					; point es to video base
	mov di, 0					; point di to top left column

nextloc:	
	mov word [es:di], 0x0720	; clear next char on screen
	add di, 2					; move to next screen location
	cmp di, 4000				; has the whole screen cleared
	jne nextloc					; if no clear next position			
	pop di
	pop ax
	pop es
	ret

spacePrint:

	push cx
	mov cl,0
x1:	
	mov word[es:di],0x0720
	add di,2
	add cl,2
	cmp cl,2
	jne x1
	pop cx
	ret 
	
boxCaller:;for each row 
;12 boxes of one color ==> 6 boxes per row in 2 rows 
;green 2A, red 46, blue 13, purple 
	push es
	push ax
	push di
	push cx
	push dx
	push si
	
	mov ax,0xb800
	mov es,ax
	mov di,320
	mov dx,340
	mov cx,6
	mov si,0
	;call spacePrint
row1: ;each box has length 20 then space for 10 units
	mov word [es:di], 0x2A20	
	add di, 2					
	cmp di, dx			
	jne row1
	call spacePrint
	add dx,26
	loop row1
	inc si
	mov di,480
	mov dx,500
	mov cx,6
	cmp si,1
	je row1
	
	mov di,640
	mov dx,660
	mov cx,6
	mov si,0
	;jmp terminate
row2: ;each box has length 20 then space for 10 units
	mov word [es:di], 0x4620	
	add di, 2					
	cmp di, dx				
	jne row2
	call spacePrint
	add dx,26
	loop row2
	inc si
	mov di,800
	mov dx,820
	mov cx,6
	cmp si,1
	je row2
	
	mov di,960
	mov dx,980
	mov cx,6
	mov si,0
	
row3: ;each box has length 20 then space for 10 units
	mov word [es:di], 0x1320	
	add di, 2					
	cmp di, dx				
	jne row3
	call spacePrint
	add dx,26
	loop row3
	inc si
	mov di,1120
	mov dx,1140
	mov cx,6
	cmp si,1
	je row3

	mov di,1280
	mov dx,1300
	mov cx,6
	mov si,0
	
row4: ;each box has length 20 then space for 10 units
	mov word [es:di], 0x6E20	
	add di, 2					
	cmp di, dx				
	jne row4
	call spacePrint
	add dx,26
	loop row4
	inc si
	mov di,1440
	mov dx,1460
	mov cx,6
	cmp si,1
	je row4
	;jmp terminate
	
ball:
	mov di,2500
.ball
	mov word[es:di],0x7020
	add di,2
	cmp di,2570
	je .ball

bluePad:
	mov di,3900
.bluePad:
	mov word[es:di],0x3620
	add di,2
	cmp di,3920
	jne .bluePad
	
	
	pop si
	pop dx
	pop cx
	pop di
	pop ax
	pop es
	ret
	
	
terminate:
mov ax, 0x4c00		;terminate the program
int 0x21
