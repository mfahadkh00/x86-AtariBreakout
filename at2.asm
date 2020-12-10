; Atari Breakout Phase 2
;sound github
[org 0x0100]
jmp start


start:
	call clrscr
	call welcomeScr
	call boxCaller
	
	call ballCreator
	call boundarycreator
	call directionTester
	
x00:
	call padMovement
	jmp x00
boundarycreator:
	push ax
	push es
	push di
	
	mov ax,0x0b800
	mov es,ax
	
leftBorder:
	mov di,0 
	mov ax,[LborderVal]
lb:
	mov word[es:di],ax
	add di,160
	cmp di,3680
	jl lb
	
rightBorder:
	mov di,158
	mov ax,[RborderVal]
rb:
	mov word[es:di],ax
	add di,160
	cmp di,3838
	jl rb
		
	
	pop di
	pop es
	pop ax
	ret
	

ballMover:
	push di
	push es
	push ax
	mov ax,0xb800
	mov es,ax
	;1 = 90, 2=-90, 3=45, 4=135, 5=225, 6=315
	cmp byte [direction],1
	je up90
	jmp dir2
	
up90: ;x,y-1
	mov word di,[ballInd]
	mov ax,[ballCol] ;color loaded in ax
	mov word[es:di],0x0720 ;clear prev position
	sub byte [ballY],1
	call indexCalculator
	mov word di,[ballInd]
	mov word[es:di],ax
	jmp ender
	
dir2:
	cmp byte[direction],2
	je down90
	jmp dir3
down90: ;x, y+1
	mov word di,[ballInd]
	mov bx,[ballCol] ;color loaded in ax
	mov word[es:di],0x0720 ;clear prev position
	add byte [ballY],1
	call indexCalculator
	mov word di,[ballInd]
	mov word[es:di],bx
	jmp ender
	
dir3:	
	cmp byte [direction],3
	je ang45
	jmp dir4
	
ang45: ;x+1,y-1
	mov word di,[ballInd]
	mov ax,[ballCol] ;color loaded in ax
	mov word[es:di],0x0720 ;clear prev position
	sub byte [ballY],1
	add byte[ballX],1
	call indexCalculator
	mov word di,[ballInd]
	mov word[es:di],ax
	jmp ender

dir4:
	cmp byte [direction],4
	je ang135
	jmp dir5
	
ang135: ;x-1,y-1
	mov word di,[ballInd]
	mov ax,[ballCol] ;color loaded in ax
	mov word[es:di],0x0720 ;clear prev position
	sub byte [ballY],1
	sub byte[ballX],1
	call indexCalculator
	mov word di,[ballInd]
	mov word[es:di],ax
	jmp ender

dir5:
	cmp byte [direction],5
	je ang225
	jmp dir6
	
ang225: ;x-1,y+1
	mov word di,[ballInd]
	mov ax,[ballCol] ;color loaded in ax
	mov word[es:di],0x0720 ;clear prev position
	add byte [ballY],1
	sub byte[ballX],1
	call indexCalculator
	mov word di,[ballInd]
	mov word[es:di],ax
	jmp ender
	
dir6:	
ang315: ;x+1,y+1
	mov word di,[ballInd]
	mov ax,[ballCol] ;color loaded in ax
	mov word[es:di],0x0720 ;clear prev position
	add byte [ballY],1
	add byte[ballX],1
	call indexCalculator
	mov word di,[ballInd]
	mov word[es:di],ax
	jmp ender
	
	
	

ender:	
	pop ax
	pop es
	pop di
	ret

ballCreator:
	push di
	push es
	push ax
	mov ax,0xb800
	mov es,ax
	mov byte[ballX],35
	mov byte[ballY],23
	call indexCalculator
	mov word di,[ballInd]
	mov word[es:di],0x7020;ax;0x7020
	add di,2
	pop ax
	pop es
	pop di
	ret
	
indexCalculator: ;convert x,y coordinate to di index (x*80+y)*2
	;return value at bp+4
	push bp
	mov bp,sp
	push ax
	
	mov ax,0
	mov al,80
	mul byte[ballY] ;80*Y
	add byte al,[ballX] ;(80*Y)+X
	shl ax,1 ;2((80*Y)+X)
	mov word[ballInd],ax
	;mov word[bp+4],ax 
	pop ax
	pop bp
	ret	

padMovement:
	push es
	push ax
	push di
	push cx
	push bx
	
keyCheck:	
	;pad length 20
	int 0x16
	;mov ah,0x1
	in al,0x60 ;keyboard scan code check
	cmp al,77 ;right key
	je right
	cmp al,75 ;left key
	je left 
	jmp nokey
right: ;shift pad 4 units right means move 4 units of x1 to x2
	mov cx,2
	mov ax,0xb800
	mov es,ax
	cmp word[padX2],3998 ;boundarycheck
	jl r1
	jmp nokey	
	
r1:
	call clrLastRow
	add word[padX1],2
	add word[padX2],2
	mov word di,[padX1]
	mov ax,[padColor]
r2:
	mov word[es:di],ax
	add di,2
	cmp word di,[padX2]
	jne r2
	jmp nokey
	
.r1:
	;mov di,[padX1]
	;mov word[es:di],0x0720
	;add word[padX2],2
	;mov di,[padX2]
	;mov bx,[padColor]
	;mov word[es:di],bx
	;add word[padX1],2
	;cmp word[padX2],3998 ;boundarycheck
	;je nokey
	;loop .r1 
	
left:
	mov cx,2
	mov ax,0xb800
	mov es,ax
	cmp word[padX1],3842 ;boundarycheck
	jg l1
	jmp nokey
l1:
	call clrLastRow
	sub word[padX1],2
	sub word[padX2],2
	mov word di,[padX1]
	mov ax,[padColor]
l2:
	mov word[es:di],ax
	add di,2
	cmp word di,[padX2]
	jne l2
	jmp nokey
.l1:
	;mov di,[padX2]
	;mov word[es:di],0x0720
	;sub word[padX1],2
	;mov di,[padX1]
;	mov bx,padColor
	;mov word[es:di],bx
;	sub word[padX2],2
;	cmp word[padX1],3842 ;boundarycheck
;	jbe nokey
;	loop l1

nokey:
	pop bx
	pop cx
	pop di
	pop ax
	pop es
	ret

	
	;int 0x16
	
	;in al, 0x60
	;in al, 0x60
	;cmp al, 109 ;rigth key pressed
	;je right

saveBox:
	;push si
	push di
	push cx
	
	mov cx,di
	mov di,[memIndex] ;starting coordinate of box
	mov [boxMem+di],cx
	mov cx,[boxMem+di]
	mov word [es:si],cx
	add si,2
	inc di
	
	add dx,4 ;for space
	mov [boxMem+di],dx ;length of box + space
	add byte[memIndex],2
	
	mov cx,[boxMem+di]
	mov word [es:si],cx
	add si,2
	
	call delay
	pop cx
	pop di
	;pop si
	ret
	
nextBox:
	push 0
	;call RANDGEN
	call random_box
	pop dx
	;mov word[es:si],dx
	;add si,2
	;mov dx,[rand]
	;mov dl,
	;cmp dx,0 ;if randNum = 0 then call again
	;je RANDGEN
pbox:
	mov word [es:di],bx; [color]
	;call saveBox
	add di, 2
	sub cx,2 ;160 count line
	sub dx,2 ;rand val
	cmp cx,0
	jle nextRow
	;cmp cx,0
	;jle nextRow
	cmp dx,1
	jg pbox
	jmp nxtBox
	;jle nxtBox
	;jmp pbox
nxtBox:
	call spacePrint
	;call delay
	sub cx,4 ;4 units substracted for space 
	cmp cx,0
	jle nextRow
	jmp nextBox
	;jmp terminate
nextRow:
	ret
boxCaller:;for each row 
;green 2A, red 46, blue 13 
	;push bp
	;mov bp,sp
	push es
	push ax
	push di
	push cx
	push dx ;dx contains random number
	push si
	
	mov dx,0
	mov ax,0xb800
	mov es,ax
	mov di,320
	mov si,0
	mov cx,160

;strBreakout: ;Atari Breakout
;	mov ah, 0x13 ; service 13 - print string
;	mov al, 1 ; subservice 01 – update cursor
;	mov bh, 0 ; output on page 0
;	mov bl, 14 ; attribute
;	mov dx, 0x020; row 9 column 20
;	mov cx, 14 ; length of string
;	push cs
;	pop es ; segment of string
;	mov bp, arr1 ; offset of string
;	int 0x10
	
row1: ;each box has length 20 then space for 10 units
	mov bx,[green]
	mov [color],bx
	call nextBox
	mov di,480
	;add si,2
	mov cx,160
	;jmp terminate
row2: ;each box has length 20 then space for 10 units
	mov bx,[blue]
	mov [color],bx
	call nextBox
	mov di,640
	mov cx,160
	
row3: ;each box has length 20 then space for 10 units
	mov bx,[nBlue]
	mov [color],bx
	call nextBox
	mov di,800
	mov cx,160
	
row4: ;each box has length 20 then space for 10 units
	mov bx,[red]
	mov [color],bx
	call nextBox
	mov di,960
	mov cx,160

;ball:
;	mov di,2500
;.;ball
;	mov word[es:di],0x7020
;	add di,2
;	cmp di,2570
;	je .ball

PadCreator:
	mov di,3900
	mov word[padX1],3900
.Pad:
	mov word[es:di],0x3620
	add di,2
	cmp di,3920
	jne .Pad
	mov word[padX2],3920
	
	pop si
	pop dx
	pop cx
	pop di
	pop ax
	pop es
	ret

spacePrint:

	;push cx
	;mov cl,0
x1:	
	mov word[es:di],0x0720
	add di,2
	mov word[es:di],0x0720
	add di,2
	;add cl,2
	;cmp cl,4
	;jne x1
	;pop cx
	ret 	
delay:     
            push cx
			mov cx, 0xFFFF
loop1:		loop loop1
			pop cx
			ret	
random_box:              ; creates random size of box from 5 to 9

            push bp
            mov bp, sp

            push ax		
            push cx
            push dx

            mov ah,0h                       ; interrupts to get system time
			call delay;
			call delay
			call delay
            int 1ah                         ; CX:DX now hold number of clock ticks since midnight
            mov ax,dx
            xor dx,dx
            mov cx,6
            div cx                          ; here dx contains the remainder of the division - from 0 to 9
            cmp dx, 4
            jnb end_function

add_4:
            add dx, 4

end_function:
			shl dx,2
            mov [bp +4], dx                ; saves number in premade space
			mov word[es:si],dx
			add si,2
			pop dx
            pop cx
            pop ax
            pop bp
            ret	

welcomeScr:
	push ax
	call welc2

w2:
	mov ah,0
	int 0x16 			; keyboard activated	
	cmp al,27	;esc pressed
	je term
	in al, 0x60
	in al, 0x60
	cmp al,0x64 ;esc scancode
	je term
	cmp al, 0x1c
	jne w2
	;cmp al,0x1B ;enter pressed
	;je gback
	;jmp w2
gback:
	pop ax
	call clrscr
	ret
term:
	mov ax, 0x4c00		;terminate the program
	int 0x21
;==================================== Introduction screen ============================================

welc2:
	push bp
	mov bp,sp
	push ax
	push bx
	push cx				;pushing into stack
	push dx
	push es
	push di
	push si
	
	
str1: ;developed by
	mov ah, 0x13 ; service 13 - print string
	mov al, 1 ; subservice 01 – update cursor
	mov bh, 0 ; output on page 0
	mov bl, 14 ; attribute
	mov dx, 0x0115; row 1 column 15
	mov cx, 39 ; length of string
	push cs
	pop es ; segment of string
	mov bp, arr ; offset of string
	int 0x10

str2: ;COALE
	mov ah, 0x13 ; service 13 - print string
	mov al, 1 ; subservice 01 – update cursor
	mov bh, 0 ; output on page 0
	mov bl, 14 ; attribute
	mov dx, 0x0223; row 2 column 23
	mov cx, 8 ; length of string
	push cs
	pop es ; segment of string
	mov bp, arr0 ; offset of string
	int 0x10

str3: ;Atari Breakout
	mov ah, 0x13 ; service 13 - print string
	mov al, 1 ; subservice 01 – update cursor
	mov bh, 0 ; output on page 0
	mov bl, 14 ; attribute
	mov dx, 0x920; row 9 column 20
	mov cx, 14 ; length of string
	push cs
	pop es ; segment of string
	mov bp, arr1 ; offset of string
	int 0x10

str4: ;Press Enter/Escape
	mov ah, 0x13 ; service 13 - print string
	mov al, 1 ; subservice 01 – update cursor
	mov bh, 0 ; output on page 0
	mov bl, 14 ; attribute
	mov dx, 0x1013; row 9 column 20
	mov cx, 38 ; length of string
	push cs
	pop es ; segment of string
	mov bp, arr2 ; offset of string
	int 0x10

str5: ;break bricks....
	mov ah, 0x13 ; service 13 - print string
	mov al, 1 ; subservice 01 – update cursor
	mov bh, 0 ; output on page 0
	mov bl, 14 ; attribute
	mov dx, 0x1113; row 11 column 13
	mov cx, 35 ; length of string
	push cs
	pop es ; segment of string
	mov bp, arr3 ; offset of string
	int 0x10		

str6: ;keyboard nav
	mov ah, 0x13 ; service 13 - print string
	mov al, 1 ; subservice 01 – update cursor
	mov bh, 0 ; output on page 0
	mov bl, 14 ; attribute
	mov dx, 0x1219; row 12 column 13
	mov cx, 24	; length of string
	push cs
	pop es ; segment of string
	mov bp, arr4 ; offset of string
	int 0x10	

	
	mov ax , 0x0b800		
	mov es , ax
	mov di,1634
	mov al,'*'	
	mov ah, 0xcc
end11:
	mov word[es:di],ax
	add di,2
	cmp di,1714
	jne end11
	mov al,'*'
	mov ah, 0xcc
	mov di,1794
end22:
	mov al,'*'
	mov ah, 0xcc
	mov word [es:di],ax	
	add di,78
	mov word[es:di],ax
	add di,82
	cmp di,2434
	jne end22
	mov di,2434
end33:
	mov al,'*'
	mov ah, 0xcc
	mov word[es:di],ax
	add di,2
	cmp di,2514
	jne end33

	mov ax , 0x0b800		
	mov es , ax
	mov di,160
	mov ah,0x0e
	mov si,0



	pop si
	pop di
	pop es
	pop dx				;clearing entire stack
	pop cx
	pop bx
	pop ax
	pop bp
	ret
	


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
directionTester:
	push ax
	push cx
	
	add byte[direction],3
	mov cx,5
	mov ah,0
	int 0x16 ;press any key to start
x11:
	call ballMover
	;call keyCheck
	call delay
	;call delay
	;call delay
	loop x11
	
	;cmp di,0
	;jne op2
	;jmp terminate
	
	mov byte[direction],4
	mov cx,5
	mov ah,0
	int 0x16 ;press any key to start
	
	;jmp terminate
x2:
	call ballMover
	;call keyCheck
	call delay
	;call delay
	;call delay
	loop x2
	
	mov byte[direction],5
	mov cx,5
	mov ah,0
	int 0x16 ;press any key to start
x3:
	call ballMover
	;call keyCheck
	call delay
	;call delay
	;call delay
	loop x3
	mov byte[direction],6
	mov cx,5
	mov ah,0
	int 0x16 ;press any key to start
x4:
	call ballMover
	;call keyCheck
	call delay
	;call delay
	;call delay
	loop x4
	mov byte[direction],1
	mov cx,5
	mov ah,0
	int 0x16 ;press any key to start
x5:
	call ballMover
	;call keyCheck
	call delay
	;call delay
	;call delay
	loop x5
	mov byte[direction],2
	mov cx,5
	mov ah,0
	int 0x16 ;press any key to start
x6:
	call ballMover
	;call keyCheck
	call delay
	;call delay
	;call delay
	loop x6	
	
	pop cx
	pop ax
	ret
	
clrLastRow:
	push es
	push ax
	push di
	
	mov di,3840 ;last row col one
	mov ax,0xb800
	mov es,ax
	
.clrLastRow
	mov word[es:di],0x0720
	add di,2
	cmp di,4000
	jne .clrLastRow
	
	pop di
	pop ax
	pop es
	ret

arr: db 'Developed by M Fahad Khawaja - 19L-1244',0
arr0: db 'COAL - E',0
arr1: db 'Atari Breakout',0
arr2: db 'Press Enter to Continue or Esc to Exit',0
arr3: db 'Break Bricks and Dont Miss the Ball',0
arr4: db 'Use Keyboard to Navigate',0
green: dw 0x2A20
red: dw 0x4020
blue: dw 0x1320 ;1320
nBlue: dw 0x3520
color: dw 0 ;current color code placed here
padX1: dw 0 ;pad length 20
padX2: dw 0
padColor: dw 0x3020
ballX: db 0
ballY: db 0
ballInd: dw 0
ballCol: dw 0x7020
direction: db 0 ;1 = 90, 2=-90, 3=45, 4=135, 5=225, 6=315
score: dw 0 ;game score
LborderVal: dw 0x7020 ;border left value
RborderVal: dw 0x7020 ;right border value
rand: dw 0;
memIndex: db 0
boxMem: db 0


terminate:
mov ax, 0x4c00		;terminate the program
int 0x21	
