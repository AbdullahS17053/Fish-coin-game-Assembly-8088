[org 0x0100]

jmp start

data1: db '|'  
data2: db '_' 
data3: db '^'
oldisr: dd 0
oldtimer: dd 0
fishbuffer: times 40 dd 0
escFlag: dw 0
enterFlag: dw 0
score: dw 0
scoreName: dw 'Points:$'


getName: db 'Anyone there? Enter your name to start!$'
gameName: dw ' - Fishy Valley -  $'
greetings: dw 'Welcome to Fishy Valley,$' 
ctrls: dw 'Move using arrow keys: $'
up: db 'Up$'
down: db 'Down$' 
left: db  'Left$'
right: db 'Right$'

coinIns: db 'Collectibles!$'
green: db '10 pts$'
red: db '50 pts$'

dvlprs: dw 'Developed by$'
rollnum: dw'5386 & 7718$'
names:   dw' MAS & HZK $'

startGame: dw 'Enter to start, Esc to exit$'
quit: dw 'Are you sure you want$'
quit1: db 'to quit?$'
quitOptions: dw 'Yes[y]             No[n]$'

endName: dw 'Thank you for playing with us.$'
comeBack: dw 'Come back soon :p, $'
trademark: dw ' - Fishy Valley inc - $'

name:		db 80 								
db 0 											
times 80 db 0 

blank: dd '                                                             $'
gameBuffer: times 1000 dd 0
endBuffer: times 1000 dd 0
escBuffer: times 1000 dd 0
gameBufferPos: dw 0
endBufferPos: dw 0

coinLocs: dw 0,0
currentTicks: dw 0,0
maxTicks: dw 0,0
soundVal: db 0



fishPos: dw 0,0,0
random: dw 0


setSail: dw ' Press S to set Sail!$'
hintStr: dw ' Hint: Have fun$'
loadingStr: dw ' Loading...$'
welcomeStr: dw 'Welcome to Fishy Valley$' 
font: times 256*16 db 0 ; space for font
delayFlag: dw 0


pcb: times 32*16 dw 0 ; space for 32 PCBs

stack: times 32*256 dw 0 ; space for 32 512 byte stacks

nextpcb: dw 1 ; index of next free pcb

current: dw 0 ; index of current pcb



         
clrscr:

pusha

mov ax, 0xb800
mov es, ax	
xor di, di	

mov ax, 0x0720
mov cx, 2000
	
cld
rep stosw
	
popa

ret



graphclrscr:

pusha

mov ax, 0x0C00
mov cx, 0
mov dx, 0


clrLoop:
int 0x10
inc cx
cmp cx, 320
jne clrLoop

inc dx
mov cx, 0
cmp dx, 200
jne clrLoop

popa

ret







printDelay:
push cx

cmp word[cs:delayFlag], 1
jz skipdelay

mov cx, 0x3FFF

l1:
loop l1

skipdelay:

pop cx
ret











graphicsRight:
call printDelay
add cx, 1
int 0x10

ret

graphicsLeft:
call printDelay
sub cx, 1
int 0x10

ret

graphicsUp:
call printDelay
sub dx, 1
int 0x10

ret

graphicsDown:
call printDelay
add dx, 1
int 0x10

ret









graphCoin:
push bp
mov bp,sp
pusha
mov dx, word[bp+4]
mov cx, word[bp+6]
mov ax, word[bp+8]

mov di, 9

top:
call graphicsRight
dec di
cmp di, 0
jnz top

mov di, 3

topR:
add dx, 1
call graphicsRight
dec di
cmp di, 0
jnz topR

mov di, 13

rightCoin:
call graphicsDown
dec di
cmp di, 0
jnz rightCoin


mov di, 3

bottomR:
add dx, 1
call graphicsLeft
dec di
cmp di, 0
jnz bottomR


mov di, 9

bottomCoin:
call graphicsLeft
dec di
cmp di, 0
jnz bottomCoin


mov di, 3

bottomL:
sub dx, 1
call graphicsLeft
dec di
cmp di, 0
jnz bottomL

mov di, 13

leftCoin:
call graphicsUp
dec di
cmp di, 0
jnz leftCoin


mov di, 3

topL:
sub dx, 1
call graphicsRight
dec di
cmp di, 0
jnz topL

add cx, 4
add dx, 4

mov di, 10

add al, 0x08

centre:
call graphicsDown
dec di
cmp di, 0
jnz centre



popa
pop bp

ret 6










GraphicCoins:

push bp
mov bp,sp
pusha

mov ax, word[bp+4]

mov cx, 25
mov dx, 155

push ax
push cx
push dx
call graphCoin

mov cx, 280
mov dx, 155

push ax
push cx
push dx
call graphCoin


popa
pop bp

ret 2









graphLine:

pusha

mov ax, 0x0C0B

mov di, 88
lineLoopLeft:
call graphicsRight
dec di
cmp di, 0
jne lineLoopLeft

add cx, 20
mov di, 18
lineLoopMid:
call graphicsRight
dec di
cmp di, 0
jne lineLoopMid

add cx, 45
mov di, 149
lineLoopRight:
call graphicsRight
dec di
cmp di, 0
jne lineLoopRight




popa

ret















printSmallSail:
pusha

mov ax, 0X0C0C

mov di, 60

boatSmalltop:
call graphicsRight
dec di
cmp di, 0
jnz boatSmalltop

mov di, 8

boatSmallR:
call graphicsDown
call graphicsDown
call graphicsLeft
call graphicsLeft
dec di
cmp di, 0
jnz boatSmallR


mov di, 28

boatSmallD:
call graphicsLeft
dec di
cmp di, 0
jnz boatSmallD


mov di, 8

boatSmallL:
call graphicsUp
call graphicsUp
call graphicsLeft
call graphicsLeft
dec di
cmp di, 0
jnz boatSmallL

add cx, 22

mov di, 25

mov ax, 0X0C06

flagSmallL:
call graphicsUp
dec di
cmp di, 0
jnz flagSmallL

mov di, 16

mov ax, 0X0C0F

flagSmallLS:
call graphicsDown
call graphicsLeft
dec di
cmp di, 0
jnz flagSmallLS

mov di, 15

flagSmallLD:
call graphicsRight
dec di
cmp di, 0
jnz flagSmallLD

mov ax, 0X0C06

add cx, 8
add dx, 9

mov di, 32

flagSmallR:
call graphicsUp
dec di
cmp di, 0
jnz flagSmallR

mov di, 20

mov ax, 0X0C0F

flagSmallRS:
call graphicsDown
call graphicsRight
dec di
cmp di, 0
jnz flagSmallRS

mov di, 19

flagSmallRD:
call graphicsLeft
dec di
cmp di, 0
jnz flagSmallRD

popa

ret














printSail:
pusha

mov ax, 0X0C0C
mov cx, 47
mov dx, 110

mov di, 220

boattop:
call graphicsRight
dec di
cmp di, 0
jnz boattop

mov di, 16

boatR:
call graphicsDown
call graphicsDown
call graphicsLeft
call graphicsLeft
dec di
cmp di, 0
jnz boatR


mov di, 156

boatD:
call graphicsLeft
dec di
cmp di, 0
jnz boatD


mov di, 16

boatL:
call graphicsUp
call graphicsUp
call graphicsLeft
call graphicsLeft
dec di
cmp di, 0
jnz boatL

add cx, 60

mov di, 70

mov ax, 0X0C06

flagL:
call graphicsUp
dec di
cmp di, 0
jnz flagL

mov di, 50

mov ax, 0X0C0F

flagLS:
call graphicsDown
call graphicsLeft
dec di
cmp di, 0
jnz flagLS

mov di, 49

flagLD:
call graphicsRight
dec di
cmp di, 0
jnz flagLD



mov ax, 0X0C06

add cx, 20
add dx, 20

mov di, 95

flagR:
call graphicsUp
dec di
cmp di, 0
jnz flagR

mov di, 80

mov ax, 0X0C0F

flagRS:
call graphicsDown
call graphicsRight
dec di
cmp di, 0
jnz flagRS

mov di, 79

flagRD:
call graphicsLeft
dec di
cmp di, 0
jnz flagRD

popa

ret























loadBar:

pusha
mov cx, 80
mov dx, 130
mov ax, 0x0C0F

push dx

mov dx, 0x0E0F	;loading string
push dx
mov dx, loadingStr
push dx
call biosStr

pop dx

mov di, 0
loadUp:         
call graphicsDown
call graphicsDown
call graphicsDown
inc cx
sub dx, 3
inc di
cmp di, 160
jne loadUp

add dx, 4
dec cx

mov di, 0

loadSideR:
call graphicsRight
call graphicsRight
call graphicsRight
inc dx
sub cx, 3
inc di
cmp di, 16
jne loadSideR

dec dx

mov di, 0
loadDown:
call graphicsDown
call graphicsDown
call graphicsDown
dec cx
sub dx, 3
inc di
cmp di, 160
jne loadDown


inc cx

mov di, 0

loadSideL:
call graphicsLeft
call graphicsLeft
call graphicsLeft
dec dx
add cx, 3
inc di
cmp di, 16
jne loadSideL

add dx, 3
add cx, 3
mov al, 0x02

mov di, 0
mov si, 0

push dx

mov dx, 0x0A0C	;loading string
push dx
mov dx, hintStr
push dx
call biosStr


mov dx, 0x0E0F	;loading string
push dx
mov dx, loadingStr
push dx
call biosStr

pop dx

bar:

barLoop:
call graphicsDown
inc si
cmp si, 10
jne barLoop

mov si, 0
inc cx
sub dx, 10
inc di
cmp di, 154
jne bar


popa

ret















gameBanner:

push bp
			
mov bp, sp			
push es						
push cx			
push si		
push di
push ax

mov ax, 0xb800
mov es, ax	
mov ax, [bp + 8]
mov cx, 160			
mul cx
mov cx, ax
mov ax, [bp + 6]
shl ax, 1
add ax, cx
mov di, ax
mov si, ax
mov bh, 0x2F
mov bl, '|'
mov ah, 0x2F
mov al, '_'

mov cx, 30

bannerUp:
call posxline
loop bannerUp

mov cx, 7
add di, 160

bannerRight:
call negyline
loop bannerRight

mov cx, 30
sub di, 162
mov al, ' '

bannerdown:
call negxline
loop bannerdown

mov cx, 7

bannerLeft:
call posyline
loop bannerLeft

pop ax		
pop di
pop si
pop cx
pop es
pop bp
ret 6





sky:                  ;prints mountain in sky
push bp
			
mov bp, sp			
push es						
push cx			
push si		
push di
push ax

mov ax, 0xb800
mov es, ax	
mov ax, [bp + 8]
mov cx, 160			
mul cx
mov cx, ax
mov ax, [bp + 6]
shl ax, 1
add ax, cx
mov di, ax
mov bx, [bp + 12]
mov ax, [bp + 10]


mov cx, [bp + 4]

			
printleft:                 ;prints left part of mountain
call leftstep
loop printleft

mov cx, [bp + 4]
			
printright:                 ;prints right part of mountain
call rightstep
loop printright

pop ax		
pop di
pop si
pop cx
pop es
pop bp
ret 6






bird:                  ;bird printing

push bp
mov bp, sp	
		
push es						
push cx					
push di
push ax

mov ax, 0xb800
mov es, ax	
mov ax, [bp + 8]
mov cx, 160			
mul cx
mov cx, ax
mov ax, [bp + 6]
shl ax, 1
add ax, cx
mov di, ax
mov ax, [bp + 16]

mov cx, [bp + 4]

printbird:
stosw
cld
stosw
add di,162
loop printbird

pop ax		
pop di
pop cx
pop es
pop bp
ret 6







boat:                  ;print boat

push bp
			
mov bp, sp			
push es						
push cx			
push si		
push di
push ax

mov ax, 0xb800
mov es, ax	
mov ax, [bp + 8]
mov cx, 160			
mul cx
mov cx, ax
mov ax, [bp + 6]
shl ax, 1
add ax, cx
mov di, ax
mov bx, [bp + 12]
mov ax, [bp + 10]


mov cx, [bp + 4]

leftBoat:                 ;prints left part of boatbase
call rightstep
cmp cx, [bp + 4]
jnz skipleft
sub di, 164
mov word[es:di], 0x3020
add di, 164
skipleft:
loop leftBoat

mov cx, [bp + 4]
shl cx, 1

bottom:                 ;prints bottom part of boatbase
call posxline
loop bottom

mov cx, [bp + 4]

rightBoat:                 ;prints right part of boatbase
call leftstep
cmp cx, 1
jnz skipright
sub di, 2
mov word[es:di], 0x3020
skipright:
loop rightBoat

sub di, 4
mov cx, [bp + 4]
shl cx, 1
sub cx, 2

div1:                 ;prints upper part of boatbase
call negxline
loop div1

mov cx, [bp + 4]

call rightflag                 ;prints right flag

shl cx, 1
sub cx, 2
sub di, 2

div2:
call negxline
loop div2

mov cx, [bp + 4]

call leftflag                 ;prints left flag

shl cx, 1
sub cx, 2
sub di, 2


div3:
call negxline
loop div3

			
pop ax		
pop di
pop si
pop cx
pop es
pop bp
ret 6






rightflag:

push di
push cx

mov cx, [bp + 4]

call posyline

rightflagy:
call posyline
loop rightflagy

mov cx, [bp + 4]
add di, 2

rightflagz:
call rightstep
loop rightflagz

mov cx, [bp + 4]
shl cx, 1
sub cx, 1
sub di, 4

rightflagx:
call negxline
loop rightflagx

pop cx
pop di
ret






leftflag:

push di
push cx

mov cx, [bp + 4]
add cx, 1

call posyline

call negxline

leftflagx:
call negxline
loop leftflagx

mov cx, [bp + 4]
add cx, 1

leftflagz:
call leftstep
loop leftflagz

mov cx, [bp + 4]
add cx, 1
add di, 160


leftflagy:
call negyline
loop leftflagy

sub di,162
mov cx, [bp + 4]
sub cx, 1

leftflagx2:
call negxline
loop leftflagx2


pop cx
pop di
ret






posyline:

push dx
push bx

mov dx,[es:di]
mov bh, dh
mov [es:di], bx
;call delay
sub di, 160

pop bx
pop dx

ret



negyline:

push dx
push bx

mov dx,[es:di]
mov bh, dh
mov [es:di], bx
add di, 160

pop bx
pop dx

ret


posxline:

push dx
push ax

mov dx,[es:di]
mov ah, dh
stosw

pop ax
pop dx
ret

negxline:

push dx
push ax

mov dx,[es:di]
mov ah, dh
stosw
sub di, 4

pop ax
pop dx

ret






leftstep:	

push bx
push dx

mov dx,[es:di]
mov bh, dh
mov [es:di], bx
;call delay
add di, 2
sub di , 160

mov dx,[es:di]
mov ah,dh
cld
stosw
	
pop dx
pop bx
ret






rightstep:

push bx
push dx

mov dx,[es:di]
mov ah,dh
cld
stosw	
add di, 160
;call delay
mov dx,[es:di]
mov bh, dh
mov [es:di], bx
add di, 2

pop dx
pop bx	
ret




delay:

push cx
mov cx, 0xFFFF

loop1:
loop loop1

mov cx, 0xFFFF

loop2:
loop loop2

pop cx
ret







line:              ;prints division lines
push bp
mov bp, sp

push es
push cx
push bx
push di
push ax

mov cx, 0xb800
mov es, cx


mov ax, [bp + 4]
mov cx, 160
mul cx
mov di , ax
mov cx, 80
mov bl, 95
mov ax, bx

cld 
rep stosw

pop ax
pop di
pop bx
pop cx
pop es
pop bp
ret 2








moveleft:            ;moveleft

push bp
mov bp, sp

push es
push di
push si
push ax
push cx
push bx
push ds

mov ax, 0xb800
mov es, ax
mov ds, ax
mov ax, [bp + 4]
mov cx, 160
mul cx
mov di, ax
add ax, 2
mov si, ax

mov bx, [es:di]
mov cx, 79

cld
rep movsw

mov [es:di], bx

pop ds
pop bx
pop cx
pop ax
pop si
pop di
pop es
pop bp
ret 2






moveright:            ;moveright

push bp
mov bp, sp

push es
push di
push si
push ax
push cx
push bx
push ds

mov ax, 0xb800
mov es, ax
mov ds, ax
mov ax, [bp + 4]
inc ax
mov cx, 160
mul cx
sub ax, 2
mov di, ax
sub ax, 2
mov si, ax

mov bx, [es:di]
mov cx, 79

std
rep movsw

mov [es:di], bx

pop ds
pop bx
pop cx
pop ax
pop si
pop di
pop es
pop bp
ret 2













colorBg:            ;colorBg takes two sets of r,c as parameters and colors between them   

push bp
mov bp, sp

push es
push di
push ax
push cx
push bx
push dx

mov ax, 0xb800
mov es, ax

mov ax, [bp + 12]
mov cx, 160
mul cx
mov di, ax
mov ax, [bp + 10]
shl ax, 1
add di, ax

mov ax, [bp + 8]
mov cx, 160
mul cx
mov cx, ax
mov ax, [bp + 6]
shl ax, 1
add cx, ax
sub cx, di
shr cx, 1
inc cx
mov ax, [bp + 4]

cld

color:
;mov bx, [es:di]
;mov al, bl
stosw
loop color

pop dx
pop bx
pop cx
pop ax
pop di
pop es
pop bp
ret 10



colormount:            ;colormount

push ax
push si
push ax
push di
mov bx, 0x2F20
cmp cx, 1
jnz snow1
mov bx, 0xFF20
snow1:
push bx

call colorBg
dec ax
add si, 2
sub di, 2

loop colormount

ret




colorboat:            ;colorboat    

push ax
push si
push ax
push di
mov bx, 0x4F20
push bx

call colorBg
inc ax
add si, 2
sub di, 2

loop colorboat

ret



colorleftsail:    

push ax
push si
push ax
push di
mov bx, 0x7F20
push bx

call colorBg
dec ax
add si, 2

loop colorleftsail

ret



colorrightsail:    

push ax
push si
push ax
push di
mov bx, 0x7F20
push bx

call colorBg
dec ax
sub di, 2

loop colorrightsail

ret







showbirds:          ;birds

mov ax, 2
push ax
mov ax, 2
push ax
mov ax, 2
push ax					
call bird

mov ax, 1
push ax
mov ax, 14
push ax
mov ax, 1
push ax					
call bird

mov ax, 3
push ax
mov ax, 24
push ax
mov ax, 1
push ax					
call bird

mov ax, 4
push ax
mov ax, 38
push ax
mov ax, 1
push ax					
call bird

mov ax, 1
push ax
mov ax, 45
push ax
mov ax, 3
push ax					
call bird

mov ax, 3
push ax
mov ax, 60
push ax
mov ax, 1
push ax					
call bird

mov ax, 2
push ax
mov ax, 70
push ax
mov ax, 1
push ax					
call bird

ret









seaBg:     ;sea bg

mov ax, 17
push ax
mov ax, 0
push ax
mov ax, 24
push ax
mov ax, 79
push ax
mov bl, 0x20
mov bh, 0x1F
push bx
call colorBg

ret













colorfish:              ;color finish given only starting r,c

push bp
mov bp,sp

push es
push ax
push cx
push di
push bx
push dx
push si


call setEsDi
mov si,di

cld
mov ax,0x6620
mov cx, 7

colorU:
mov dx,[es:di]
mov al,dl
stosw
loop colorU

sub di, 160
mov cx, 2
finup:
mov ax,0xF720
mov dx,[es:di]
mov al,dl
stosw
loop finup


add di, 316
mov cx, 2
findown:
mov ax,0xF720
mov dx,[es:di]
mov al,dl
stosw
loop findown

mov ax, 0x6620
mov di,si
stosw
stosw

sub di, 160

mov ax, 0x6620
stosw
stosw

pop si
pop dx
pop bx
pop di
pop cx
pop ax
pop es
pop bp

ret 4














checkMove:

pusha
push es
push ds
push cs
pop ds

mov ax, 0xb800
mov es, ax

cmp word[es:di],0xAF7C
je collectGreen
cmp word[es:di],0xCF7C
je collectRed
jmp noCoin



collectGreen:

sub di, 2
push di
call popCoin

add word[cs:score], 10
call showScore

jmp noCoin





collectRed:

sub di, 2
push di
call popCoin

add word[cs:score], 50
call showScore

jmp noCoin



noCoin:

pop ds
pop es
popa

ret



















kbisr:                    ;kbisr	

pusha
push es
push ds

mov ax, 0xb800
mov es, ax

in al, 0x60






escapeCase:

in al, 0x60
cmp al, 0x01
jne upcase

mov al, byte[cs:soundVal]
out 61h, al

call escScreen
call escapeBanner


noLoop:

in al, 0x60
cmp al, 0x31
jne yesLoop
call restoreScreen
jmp escapeCase

yesLoop:

in al, 0x60
cmp al, 0x15
jne noLoop

mov word[cs:escFlag] , 1

jmp nomatch







playsound:


call delay
call delay
mov al, byte[cs:soundVal]
out 61h, al
call sound
call delay
call delay


jmp nomatch







upcase:

cmp al, 0x48
jne downcase

cld
mov di, word[cs:fishPos]
sub di, 160

cmp di, 2720
jb playsound



mov si, word[cs:fishPos]
mov ax, 0xb800
mov ds, ax

mov cx, 3

moveUp:
call checkMove
movsw
loop moveUp


mov ax, 0x1F20

mov cx, 3
mov si, 0

clearUp:
mov di, word[cs:fishPos + si]
stosw
sub word[cs:fishPos + si], 160
add si, 2
loop clearUp

	
jmp nomatch







downcase:

cmp al, 0x50
jne leftcase

cld
mov di, word[cs:fishPos]
add di, 160

cmp di, 4000
ja playsound


mov si, word[cs:fishPos]
mov ax, 0xb800
mov ds, ax

mov cx, 3

moveDown:
call checkMove
movsw
loop moveDown

mov ax, 0x1F20
mov cx, 3
mov si, 0

clearDown:
mov di, word[cs:fishPos + si]
stosw
add word[cs:fishPos + si], 160
add si, 2
loop clearDown


jmp nomatch






leftcase:

cmp al, 0x4B
jne rightcase

cld

mov ax, 0xb800
mov ds, ax

mov cx, 3
mov bx, 0


fishLeft:

mov dx, 0
mov di, word[cs:fishPos + bx]
sub di, 2

mov si, word[cs:fishPos + bx]

push bx
mov ax, si
mov bx, 160
div bx
pop bx

cmp dx, 0
jne noWallLeft

mov di, si
add di, 158



noWallLeft:

mov word[cs:fishPos + bx], di
call checkMove

movsw

add bx, 2

loop fishLeft



mov ax, di
mov bx, 160
div bx
cmp dx, 0
jne clearLeft

sub di, 160

clearLeft:


mov ax, 0x1F20

stosw



jmp nomatch









rightcase:

cmp al, 0x4D
jne nomatch

std

mov ax, 0xb800
mov ds, ax

mov cx, 3
mov bx, 4





fishRight:

mov dx, 0
mov di, word[cs:fishPos + bx]
add di, 2

mov si, word[cs:fishPos + bx]

push bx
mov ax, di
mov bx, 160
div bx
pop bx

cmp dx, 0
jne noWallRight


sub di, 160



noWallRight:

mov word[cs:fishPos + bx], di
call checkMove
std

movsw

sub bx, 2

loop fishRight






mov ax, di
add ax, 2
mov bx, 160
div bx
cmp dx, 0
jne clearRight

add di, 160

clearRight:


mov ax, 0x1F20

stosw

jmp nomatch
		




nomatch:

call recoverFish

mov al, 0x20
out 0x20, al

pop ds
pop es
popa
iret
			







		
moveBoth:

mov cx, 16

moveboat:              ;moves boat rightward
push cx
call moveright
dec cx
cmp cx, 7
jnz moveboat

movesky:               ;moves sky leftward
push cx
call moveleft
loop movesky


ret
















sound:

push ax
push cx

mov al, 0b6h
out 43h, al

;load the counter 2 value for G5
mov ax, 1522
out 42h, al
mov al, ah
out 42h, al

;turn the speaker on
in al, 61h
mov ah,al
or al, 3h
out 61h, al
call delay
mov al, ah
out 61h, al

call delay
call delay
call delay

;load the counter 2 value for D5
mov ax, 2032
out 42h, al
mov al, ah
out 42h, al

;turn the speaker on
in al, 61h
mov ah,al
or al, 3h
out 61h, al
call delay
mov al, ah
out 61h, al

call delay
call delay
call delay
	
;load the counter 2 value for F5
mov ax, 1708
out 42h, al
mov al, ah
out 42h, al
	
;turn the speaker on
in al, 61h
mov ah,al
or al, 3h
out 61h, al
call delay
mov al, ah
out 61h, al

call delay
call delay
call delay

;load the counter 2 value for F5
mov ax, 1708
out 42h, al
mov al, ah
out 42h, al
	
;turn the speaker on
in al, 61h
mov ah,al
or al, 3h
out 61h, al
call delay
mov al, ah
out 61h, al

pop cx
pop ax

ret












bgMusic:

push ax
push cx

mov al, 0b6h
out 43h, al

infSound:


;load the counter 2 value for G5
mov ax, 1522
out 42h, al
mov al, ah
out 42h, al


;turn the speaker on
in al, 61h
mov ah,al
or al, 3h
out 61h, al
call delay
mov al, ah
out 61h, al



call delay
call delay






;load the counter 2 value for D5
mov ax, 2032
out 42h, al
mov al, ah
out 42h, al


;turn the speaker on
in al, 61h
mov ah,al
or al, 3h
out 61h, al
call delay
mov al, ah
out 61h, al


call delay
call delay






	
;load the counter 2 value for F5
mov ax, 1708
out 42h, al
mov al, ah
out 42h, al

	
;turn the speaker on
in al, 61h
mov ah,al
or al, 3h
out 61h, al
call delay
mov al, ah
out 61h, al


call delay
call delay







;load the counter 2 value for F5
mov ax, 1708
out 42h, al
mov al, ah
out 42h, al


;turn the speaker on
in al, 61h
mov ah,al
or al, 3h
out 61h, al
call delay
call delay
call delay
mov al, ah
out 61h, al


call delay
call delay










;load the counter 2 value for e5
mov ax, 1810
out 42h, al
mov al, ah
out 42h, al

	
;turn the speaker on
in al, 61h
mov ah,al
or al, 3h
out 61h, al
call delay
mov al, ah
out 61h, al


call delay
call delay






;load the counter 2 value for d5
mov ax, 2032
out 42h, al
mov al, ah
out 42h, al
	

;turn the speaker on
in al, 61h
mov ah,al
or al, 3h
out 61h, al
call delay
mov al, ah
out 61h, al


call delay
call delay






;load the counter 2 value for g5
mov ax, 1522
out 42h, al
mov al, ah
out 42h, al


;turn the speaker on
in al, 61h
mov ah,al
or al, 3h
out 61h, al
call delay
call delay
call delay
mov al, ah
out 61h, al


call delay
call delay



;load the counter 2 value for F5
mov ax, 1708
out 42h, al
mov al, ah
out 42h, al

	
;turn the speaker on
in al, 61h
mov ah,al
or al, 3h
out 61h, al
call delay
mov al, ah
out 61h, al


call delay
call delay




;load the counter 2 value for e5
mov ax, 1810
out 42h, al
mov al, ah
out 42h, al

	
;turn the speaker on
in al, 61h
mov ah,al
or al, 3h
out 61h, al
call delay
mov al, ah
out 61h, al


call delay
call delay






;load the counter 2 value for d5
mov ax, 2032
out 42h, al
mov al, ah
out 42h, al

	
;turn the speaker on
in al, 61h
mov ah,al
or al, 3h
out 61h, al
call delay
call delay
call delay
mov al, ah
out 61h, al


call delay
call delay


jmp infSound

pop cx
pop ax

ret












escScreen:

push escBuffer
call saveScreen

ret





saveScreen:	

push bp
mov bp,sp
pusha	
push ds
push es

mov cx, 2000

mov ax, 0xb800
mov ds, ax

push cs
pop es
		
mov si, 0
mov di, [bp + 4]

cld
rep movsw

pop es
pop ds			
popa
pop bp

ret 2







restoreScreen:		

pusha	
push ds
push es


mov cx, 2000

mov ax, 0xb800
mov es, ax

push cs
pop ds
		
mov si, escBuffer
mov di, 0

cld
rep movsw

pop es
pop ds
popa
ret









scrollUp:

push bp
mov bp,sp
pusha

mov ax, 0xb800
mov es, ax
mov ds, ax

mov di, 0
mov si, 160

mov cx, 1920
rep movsw

push cs
pop ds
mov si, word[bp + 4]
mov bx, word[bp + 6]
add si, word[bx]

mov cx, 80

cld
rep movsw

add word[bx] , 160

popa
pop bp

ret 4












biosStr:

push bp
mov bp,sp
push ax
push dx
push cs
pop ds

mov ah, 0x02        ;set cursor
mov bh, 0
mov dx, [bp + 6]
int 0x10

mov dx, [bp + 4]       ;take name					
mov ah, 0x09							
int 0x21

pop dx
pop ax
pop bp

ret 4










setEsDi:


mov ax, 0xb800
mov es, ax	
mov ax, [bp + 6]
mov cx, 160			
mul cx
mov cx, ax
mov ax, [bp + 4]
inc ax
shl ax, 1
add ax, cx
mov di,ax

ret









printCoin:

push bp
mov bp,sp
pusha
push es


mov ax, 0xb800
mov es, ax
mov di, [bp + 4]
mov ax, [bp+10]

cld
mov bx,word[es:di]
mov ah,bh
stosw
mov ax,[bp + 6]
stosw
sub di, 162
mov bx, word[es:di]
mov bl,0x5F
mov word[es:di], bx
add di, 162
mov bx,word[es:di]
mov ah,bh
stosw

pop es
popa
pop bp

ret 4

















popCoin:

push bp
mov bp,sp
pusha
push es

mov ax, 0xb800
mov es, ax
mov di, [bp + 4]
mov ax, 0x1F20

cld

cmp word[es:di], 0x1F7C
jne skipCoinLeft
mov word[es:di], ax
skipCoinLeft:
add di, 2

mov bx, word[es:di]
cmp bl, 0x7C
jne skipCoinMid
mov word[es:di], ax
skipCoinMid:
add di, 2

mov si, di
sub si, 162
mov bx,word[es:si]
cmp bh, 0x1F
jne skipLid
sub di, 162
stosw
add di, 160
skipLid:

cmp word[es:di], 0x1F7C
jne skipCoinRight
mov word[es:di], ax
skipCoinRight:

mov si, 0
mov cx,2
mov di,[bp + 4]

setCoinVals:

cmp word[cs:coinLocs + si], di
je break

add si, 2
loop setCoinVals

break:

mov word[cs:coinLocs + si], 0
mov word[cs:currentTicks + si], 0
mov word[cs:maxTicks + si], 0

pop es
popa
pop bp

ret 2









escapeBanner:

pusha

mov cx, 7
mov ax, 9
mov dx, 25
mov di, 54

colorescbanner: 
push ax 
push dx
push ax
push di
mov bl, 0x20
mov bh, 0x6F
push bx
call colorBg
inc ax
loop colorescbanner






mov bl, byte[cs:data1]			
mov bh, 0x2F
push bx

mov bl, byte[cs:data2]			
mov bh, 0x2F
push bx

mov ax, 8      
push ax
mov ax, 25
push ax
mov ax, gameName
push ax
call gameBanner

pop dx
pop dx

mov dx, 0x0A1E
push dx
mov dx, quit
push dx	
call biosStr

mov dx, 0x0C24
push dx
mov dx, quit1
push dx	
call biosStr

mov dx, 0x0D1C
push dx
mov dx, quitOptions
push dx	
call biosStr

mov ah, 0x02        ;set cursor
mov bh, 0
mov dx, 0x1800
int 0x10


popa

ret













printfish:

push bp
mov bp,sp
pusha

mov ax, 0xb800
mov es, ax
mov di,[bp + 4]



cld

mov ax, 0x6F7E
mov [fishPos], di
stosw

mov ax, 0x7F20
mov [fishPos + 2], di
stosw

mov ax, 0x6620
mov [fishPos + 4], di
stosw

popa
pop bp

ret 2






recoverFish:

pusha
push es

mov ax, 0xb800
mov es, ax




cld

mov di,word[cs:fishPos]
mov ax, 0x6F7E
stosw

mov di,word[cs:fishPos + 2]
mov ax, 0x7F20
stosw

mov di,word[cs:fishPos + 4]
mov ax, 0x6620
stosw

pop es
popa

ret








placeCoin:

push bp
mov bp, sp
pusha
push es


mov si, data1
mov bl, [si]			
mov bh, 0x30
push bx

mov si, data2
mov bl, [si]			
mov bh, 0x30
push bx

mov ax, 0xb800
mov es, ax

mov cx, 2
mov si, [bp + 4]






cmp word[coinLocs + si], 0
jne skipCoin





rand:

call genRand

xor dx,dx
mov ax,word[random]
mov bx,2
div bx
push dx

mov ax,word[random]
mov bx, 60
mul bx
add ax, 2720

;call genRand

push ax

mov ax,word[random]
mov bx, 60
mul bx
pop bx
add ax,bx

pop dx




mov di, 0xAF7C
cmp dx, 0
je skipred
mov di, 0xCF7C
skipred:





mov bx, di
mov di, ax
mov ax, bx





doublecheck:

mov bx, word[es:di]
cmp bx, 0x1F20
jne rand

mov word[coinLocs + si], di




mov bx, 0

checkTicks:

mov bx, 11000
cmp ax, 0xAF7C
je placeTick
mov bx, 5500



placeTick:

mov word[maxTicks + si], bx



push ax
push di
call printCoin


skipCoin:



pop ax
pop ax
pop es
popa
pop bp

ret 2




checkCoins:

pusha

mov ax, 0
push ax
call placeCoin

;call delay

mov ax, 2
push ax
call placeCoin

popa

ret

















genRand:

pusha

mov ax, 25173
mul word[random]
add ax, 13849
mov word[random],ax


popa

ret












showScore: 

push bp
mov bp, sp
push es
pusha

mov ax, 0xb800
mov es, ax

mov ax, word[cs:score]
mov bx, 10
mov cx, 0

nextdigit:		
mov dx, 0
div bx
add dl, 0x30
push dx

inc cx
cmp ax, 0
jnz nextdigit


				
mov di, 152


nextpos:		

pop dx
mov dh, 0x3F
				
mov [es:di], dx
add di, 2
loop nextpos

popa
pop es
pop bp

ret














initpcb: 

push bp
mov bp, sp
push ax
push bx
push cx
push si

mov bx, [nextpcb] ; read next available pcb index
cmp bx, 32 ; are all PCBs used
je pcbExit ; yes, exit

mov cl, 5
shl bx, cl ; multiply by 32 for pcb start

mov ax, [bp+6] ; read segment parameter
mov [pcb+bx+18], ax ; save in pcb space for cs

mov ax, [bp+4] ; read offset parameter
mov [pcb+bx+16], ax ; save in pcb space for ip

mov [pcb+bx+22], ds ; set stack to our segment

mov si, [nextpcb] ; read this pcb index
mov cl, 9
shl si, cl ; multiply by 512
add si, 256*2+stack ; end of stack for this thread

;mov ax, [bp+4] ; read parameter for subroutine
;sub si, 2 ; decrement thread stack pointer
;mov [si], ax ; pushing param on thread stack

sub si, 2 ; space for return address
mov [pcb+bx+14], si ; save si in pcb space for sp
mov word [pcb+bx+26], 0x0200 ; initialize thread flags
mov ax, [pcb+28] ; read next of 0th thread in ax
mov [pcb+bx+28], ax ; set as next of new thread
mov ax, [nextpcb] ; read new thread index
mov [pcb+28], ax ; set as next of 0th thread
inc word [nextpcb] ; this pcb is now used

pcbExit: 

pop si
pop cx
pop bx
pop ax
pop bp
ret 4















timer: 

pusha
push es

mov byte[cs:soundVal], ah

mov ax, 0xb800
mov es, ax


inc word[cs:currentTicks]
inc word[cs:currentTicks + 2]

mov cx, 2
mov si, 0



tickCheck:

cmp word[cs:coinLocs + si], 0
je skipPop

mov ax, word[cs:currentTicks + si]
cmp ax, word[cs:maxTicks + si]
jb skipPop

cmp word[cs:maxTicks + si], 0
je exitCheck
push word[cs:coinLocs + si]
call popCoin


skipPop:

add si, 2
loop tickCheck


exitCheck:

pop es
popa




push ds
push bx
push cs
pop ds ; initialize ds to data segment
mov bx, [current] ; read index of current in bx
shl bx, 1
shl bx, 1
shl bx, 1
shl bx, 1
shl bx, 1 ; multiply by 32 for pcb start
mov [pcb+bx+0], ax ; save ax in current pcb
mov [pcb+bx+4], cx ; save cx in current pcb
mov [pcb+bx+6], dx ; save dx in current pcb
mov [pcb+bx+8], si ; save si in current pcb
mov [pcb+bx+10], di ; save di in current pcb
mov [pcb+bx+12], bp ; save bp in current pcb
mov [pcb+bx+24], es ; save es in current pcb

pop ax ; read original bx from stack
mov [pcb+bx+2], ax ; save bx in current pcb
pop ax ; read original ds from stack
mov [pcb+bx+20], ax ; save ds in current pcb
pop ax ; read original ip from stack
mov [pcb+bx+16], ax ; save ip in current pcb
pop ax ; read original cs from stack
mov [pcb+bx+18], ax ; save cs in current pcb
pop ax ; read original flags from stack
mov [pcb+bx+26], ax ; save cs in current pcb
mov [pcb+bx+22], ss ; save ss in current pcb
mov [pcb+bx+14], sp ; save sp in current pcb
mov bx, [pcb+bx+28] ; read next pcb of this pcb
mov [current], bx ; update current to new pcb
mov cl, 5
shl bx, cl ; multiply by 32 for pcb start
mov cx, [pcb+bx+4] ; read cx of new process
mov dx, [pcb+bx+6] ; read dx of new process
mov si, [pcb+bx+8] ; read si of new process
mov di, [pcb+bx+10] ; read diof new process
mov bp, [pcb+bx+12] ; read bp of new process
mov es, [pcb+bx+24] ; read es of new process
mov ss, [pcb+bx+22] ; read ss of new process
mov sp, [pcb+bx+14] ; read sp of new process
push word [pcb+bx+26] ; push flags of new process
push word [pcb+bx+18] ; push cs of new process
push word [pcb+bx+16] ; push ip of new process
push word [pcb+bx+20] ; push ds of new process

mov al, 0x20
out 0x20, al ; send EOI to PIC
mov ax, [pcb+bx+0] ; read ax of new process
mov bx, [pcb+bx+2] ; read bx of new process
pop ds ; read ds of new process
iret ; return to new process








start:                         ;start	


mov ax, 1100                   ;increase timer speed
out 0x40, al
mov al, ah
out 0x40, al


;end screen code

call clrscr

push endBuffer
call saveScreen
call clrscr



mov si, data3 ;^
mov bl, [si]			
mov bh, 0x30
push bx

mov si, data1 ;|
mov bl, [si]			
mov bh, 0x2F
push bx

mov si, data2  ;_
mov bl, [si]			
mov bh, 0x2F
push bx



		
mov ax, 0     ;sky bg
push ax
mov ax, 0
push ax
mov ax, 4
push ax
mov ax, 79
push ax
mov bl, 0x20
mov bh, 0x3F
push bx
call colorBg
 
mov ax, 5
push ax
mov ax, 0
push ax
mov ax, 7
push ax
mov ax, 79
push ax
mov bl, 0x20
mov bh, 0x6F
push bx
call colorBg

mov ax, 8     ;boat bg
push ax
mov ax, 0
push ax
mov ax, 16
push ax
mov ax, 79
push ax
mov bl, 0x20
mov bh, 0x30
push bx
call colorBg



call seaBg







mov ax,6           ;mountains
push ax
mov ax,0
push ax
mov ax,2
push ax					
call sky

mov cx, 2
mov si, 1
mov di, 6
mov ax, 6
call colormount





mov ax,6
push ax
mov ax,9
push ax
mov ax,4
push ax					
call sky

mov cx, 4
mov si, 10
mov di, 23
mov ax, 6
call colormount






mov ax,4
push ax
mov ax,25
push ax
mov ax,3
push ax					
call sky

mov cx, 3
mov si, 26
mov di, 35
mov ax, 4
call colormount





    
mov ax,6
push ax
mov ax,37
push ax
mov ax,4
push ax					
call sky

mov cx, 4
mov si, 38
mov di, 51
mov ax, 6
call colormount





mov ax,4
push ax
mov ax,53
push ax
mov ax,2
push ax					
call sky

mov cx, 2
mov si, 54
mov di, 59
mov ax, 4
call colormount





mov ax,4
push ax
mov ax,72
push ax
mov ax,2
push ax					
call sky

mov cx, 2
mov si, 73
mov di, 78
mov ax, 4
call colormount





mov ax,6
push ax
mov ax,57
push ax
mov ax,5
push ax					
call sky

mov cx, 5
mov si, 58
mov di, 75
mov ax, 6
call colormount





call showbirds





			
         

mov ax, 7         ;line
push ax
mov bh, 0x6F
call line



mov ax, 16
push ax
mov bh, 0x3F
call line







pop bx
pop bx

mov si, data1
mov bl, [si]			
mov bh, 0x30
push bx

mov si, data2
mov bl, [si]			
mov bh, 0x30
push bx










mov ax, 13      ;boat number 1
mov si, 8
mov di, 15
mov cx, 2
call colorboat

mov ax, 11
mov si, 7
mov di, 12
mov cx, 3
call colorleftsail

mov ax, 11
mov si, 14
mov di, 17
mov cx, 2
call colorrightsail

mov ax, 12
push ax
mov ax, 6
push ax
mov ax, 2
push ax
call boat









mov ax, 14      ;boat number 2
mov si, 27
mov di, 41
mov cx, 3
call colorboat

mov ax, 12
mov si, 27
mov di, 34
mov cx, 4
call colorleftsail

mov ax, 12
mov si, 37
mov di, 42
mov cx, 3
call colorrightsail

mov ax, 13
push ax
mov ax, 25
push ax
mov ax, 3
push ax
call boat









mov ax, 14      ;boat number 3
mov si, 52
mov di, 59
mov cx, 2
call colorboat

mov ax, 12
mov si, 51
mov di, 56
mov cx, 3
call colorleftsail

mov ax, 12
mov si, 58
mov di, 61
mov cx, 2
call colorrightsail

mov ax, 13
push ax
mov ax, 50
push ax
mov ax, 2
push ax
call boat








mov ax, 13      ;boat number 4
mov si, 66
mov di, 73
mov cx, 2
call colorboat

mov ax, 11
mov si, 65
mov di, 70
mov cx, 3
call colorleftsail

mov ax, 11
mov si, 72
mov di, 75
mov cx, 2
call colorrightsail

mov ax, 12
push ax
mov ax, 64
push ax
mov ax, 2
push ax
call boat






mov ax, 3280
push ax
call printfish






xor ax,ax               ;random seed
mov ah,0x00
int 0x1A

mov ax,dx
xor dx,dx
mov bx,10
div bx
inc dx

mov word[random], dx

mov dx, 0x0044		;show score	
push dx
mov dx, scoreName
push dx	
call biosStr

call showScore



call checkCoins



push gameBuffer
call saveScreen                   ;buffer to save game screen
;call clrscr




;graphics start




mov ax, 0x000D ; set 320x200 graphics mode
int 0x10 ; bios video services

xor bx, bx ; page number 0

mov dx, 0x140A		;sail text
push dx
mov dx, setSail
push dx
call biosStr



call printSail

mov cx, 16
mov dx, 42
call printSmallSail



add cx, 180
sub dx, 5

call printSmallSail

add dx, 5

mov cx, -1
add dx, 17
call graphLine

mov word[delayFlag], 1


mov cx, 0
mov dx, 100



sailLoop:
mov ax, 0x0C04
push ax
call GraphicCoins


call delay
call delay
call delay
call delay

mov ax, 0x0C02
push ax
call GraphicCoins

call delay
call delay
call delay
call delay

mov ah, 0 ; service 0 – get keystroke
int 0x16 ; bios keyboard services

cmp ah, 0x1F
jne sailLoop

mov word[delayFlag], 0

call graphclrscr

call loadBar

push dx

mov dx, 0x0A09	;loading string
push dx
mov dx, welcomeStr
push dx
call biosStr

pop dx

mov cx, 40
delayLoop:
call delay
loop delayLoop


call graphclrscr

mov ax, 0x0003 ; 80x25 text mode
int 0x10 ; bios video services




;home screen starts




mov ax, 0     ;home screen Bg
push ax
mov ax, 0
push ax
mov ax, 24
push ax
mov ax, 79
push ax
mov bl, 0x20
mov bh, 0x3F
push bx
call colorBg





mov cx, 7
mov ax, 8
mov dx, 25
mov di, 54

colorGamebanner:          ;banner bg
push ax 
push dx
push ax
push di
mov bl, 0x20
mov bh, 0x2F
push bx
call colorBg
inc ax
loop colorGamebanner

mov ax, 7      ;show game banner
push ax
mov ax, 25
push ax
mov ax, gameName
push ax
call gameBanner







mov dx, 0x091F		;show game name	
push dx
mov dx, gameName
push dx	
call biosStr			




mov ax, 12          ;fish
push ax
mov ax, 35
push ax
call colorfish



mov dx, 0x1503         ;get name text
push dx
mov dx, getName
push dx				
call biosStr




mov ah, 0x02        ;set cursor
mov bh, 0
mov dx, 0x152C
int 0x10

mov dx, name		;get name			
mov ah, 0x0A 							
int 0x21




mov dx, 0x1503		;delete name from screen
push dx
mov dx, blank
push dx
call biosStr



mov cx, 7
introScroll:
push gameBufferPos
push gameBuffer
call scrollUp
call delay
call delay
loop introScroll




mov dx, 0x0901		;greet player
push dx
mov dx, greetings
push dx
call biosStr

mov bh, 0
mov bl, [name + 1] 
mov byte[name + 2 + bx], '!'
mov byte[name + 3 + bx], '$'

mov dx, 0x091B		;player name
push dx
mov dx, name + 2
push dx
call biosStr



mov dx, 0x0C01		;controls
push dx
mov dx, ctrls
push dx
call biosStr






mov dx, 0x1002		;up
push dx
mov dx, up
push dx
call biosStr


mov ax, 16         ;fish
push ax
mov ax, 4
push ax
call colorfish


mov ax, 0xAF7C         ;coin
push ax
mov ax, 2246
push ax
call printCoin










mov dx, 0x100F		;down
push dx
mov dx, down
push dx
call biosStr


mov ax, 15         ;fish
push ax
mov ax, 19
push ax
call colorfish


mov ax, 0xCF7C        ;coin
push ax
mov ax, 2764
push ax
call printCoin








mov dx, 0x0D25		;left
push dx
mov dx, left
push dx
call biosStr


mov ax, 16         ;fish
push ax
mov ax, 35
push ax
call colorfish


mov ax, 0xAF7C         ;coin
push ax
mov ax, 2622
push ax
call printCoin








mov dx, 0x0D31		;right
push dx
mov dx, right
push dx
call biosStr


mov ax, 16         ;fish
push ax
mov ax, 47
push ax
call colorfish


mov ax, 0xCF7C         ;coin
push ax
mov ax, 2676
push ax
call printCoin







mov dx, 0x0A40		;coins
push dx
mov dx, coinIns
push dx
call biosStr


mov ax, 0xAF7C         ;green
push ax
mov ax, 2050
push ax
call printCoin

mov dx, 0x0E40		;greenpts
push dx
mov dx, green
push dx
call biosStr

mov ax, 0xCF7C         ;red
push ax
mov ax, 2066
push ax
call printCoin

mov dx, 0x0E48		;redpts
push dx
mov dx, red
push dx
call biosStr








mov dx, 0x0043		;developers
push dx
mov dx, dvlprs
push dx
call biosStr

mov dx, 0x0244		
push dx
mov dx, rollnum
push dx
call biosStr

mov dx, 0x0344		
push dx
mov dx, names
push dx
call biosStr












mov ax, 11    
push ax
mov ax, 27
push ax
mov ax, 11
push ax
mov ax, 54
push ax
mov bl, 0x20
mov bh, 0xBF
push bx
call colorBg



mov dx, 0x0B1B		;start game
push dx
mov dx, startGame
push dx
call biosStr



mov ah, 0x02        ;set cursor
mov bh, 0
mov dx, 0x1800
int 0x10





xor ax, ax
mov es, ax	

mov ax, [es:9*4]
mov [oldisr], ax	
mov ax, [es:9*4+2]
mov [oldisr+2], ax

mov ax, [es:8*4]
mov [oldtimer], ax	
mov ax, [es:8*4+2]
mov [oldtimer+2], ax

pop dx
pop dx
pop dx





enterLoop:            ;get enter

mov ah, 0
int 0x16

cmp ah, 0x1C
jne escLoop
jmp playgame


escLoop:

cmp ah, 0x01
jne enterLoop
call escScreen
call escapeBanner

noloop:

mov ah, 0
int 0x16

cmp ah, 0x31
jne yesloop
call restoreScreen
jmp enterLoop


yesloop:


cmp ah, 0x15
jne noloop
je escape








playgame:

mov cx, 18
gameScroll:
push gameBufferPos
push gameBuffer
call scrollUp
call delay
call delay
loop gameScroll











xor ax, ax       
mov es, ax	








xor ax, ax                         ;hooking
mov es, ax	

cli
mov word [es:9*4], kbisr
mov [es:9*4+2], cs
sti

cli
mov word [es:8*4], timer
mov [es:8*4+2], cs
sti





push cs
mov ax, bgMusic
push ax

call initpcb






processZero:         ;infinite loop for moving



call moveBoth
 
call checkCoins

call delay

cmp word[escFlag], 1

jne processZero





escape:



xor ax, ax                         ;unhooking
mov es, ax	


mov ax, [oldisr]	
mov bx, [oldisr + 2]
			
cli
mov [es:9*4], ax	
mov [es:9*4+2], bx
sti	

cli

mov al, byte[cs:soundVal]
out 61h, al

mov ax, [oldtimer]	
mov bx, [oldtimer + 2]
			




mov [es:8*4], ax	
mov [es:8*4+2], bx
sti

mov cx, 25
showEnd:
push endBufferPos
push endBuffer
call scrollUp
call delay
loop showEnd

;end screen

mov ax, 0x000D ; set 320x200 graphics mode
int 0x10 ; bios video services

xor bx, bx ; page number 0



mov dx, 0x0905		;show thank you message	
push dx
mov dx, endName
push dx	
call biosStr

mov dx, 0x0D09	;show comeback message
push dx
mov dx, comeBack
push dx	
call biosStr


mov dx, 0x0D1C	;show name
push dx
mov dx, name + 2
push dx	
call biosStr

mov dx, 0x1709  ;show trademark	
push dx
mov dx, trademark
push dx	
call biosStr



mov ah, 0 ; service 0 – get keystroke
int 0x16 ; bios keyboard services

call graphclrscr

mov ax, 0x0003 ; 80x25 text mode
int 0x10 ; bios video services

mov ax, 0x4c00
int 0x21
