TITLE CALCULADORA SHOW
.MODEL SMALL
.STACK 100H
.DATA
	LF		EQU 0AH
	CR		EQU 0DH
	TITULO 	DB "              Calculadora$"
	DIGITE 	DB "Comandos:$"
	CMD1	DB "  1 - AND$"									;2
	CMD2	DB "  2 - OR$"									;2
	CMD3	DB "  3 - XOR$"									;2
	CMD4	DB "  4 - NOT$"									;1
	CMD5	DB "  5 - Soma$"								;2
	CMD6	DB "  6 - Subtracao$"							;2
	CMD7	DB "  7 - Multiplicacao$"						;2
	CMD8	DB "  8 - Divisao$"								;2
	CMD9	DB "  9 - Multiplicacao por 2 exp$"				;1
	CMD10	DB "  A - Divisao por 2 exp$"					;1
	CMD11	DB "  B - Ajuda (imprimir comandos novamente)$"	;0
	CCMD	DB 0H
	OP1		DB 0H
	OP2		DB 0H
	RESUL	DB 0H
	DIVIS 	DB "-----------------------------------------$"
	DDIVIS	DB "=========================================$"
	MODENT	DB "Modos de entrada:$"
	MOD1	DB "  1 - Binario$"
	MOD2	DB "  2 - Decimal (DEFAULT)$"
	MOD3	DB "  3 - Hexadecimal$"
	ERRMSG	DB "Valor fora dos limites$"
	CMOD	DB 0H
	TEMP	DB 0H
	SEL1	DB "Modo BINARIO selecionado!$"
	SEL2	DB "Modo DECIMAL selecionado!$"
	SEL3	DB "Modo HEXADEC selecionado!$"
	TEMPM	DB 0H
	HFLAG	DB 0H	;hexadec flag
.CODE
BEGIN PROC
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,DDIVIS
	MOV AH,09 ;imprimir strings
	INT 21H
	
	CALL PE
	
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,TITULO
	MOV AH,09 ;imprimir strings
	INT 21H
	
	CALL PE
	
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,DIVIS
	MOV AH,09 ;imprimir strings
	INT 21H
	
	CALL PE
	
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,DIGITE
	MOV AH,09 ;imprimir strings
	INT 21H
	
	CALL PE
	
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,CMD1
	MOV AH,09 ;imprimir strings
	INT 21H
	
	CALL PE
	
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,CMD2
	MOV AH,09 ;imprimir strings
	INT 21H
	
	CALL PE
	
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,CMD3
	MOV AH,09 ;imprimir strings
	INT 21H
	
	CALL PE
	
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,CMD4
	MOV AH,09 ;imprimir strings
	INT 21H
	
	CALL PE
	
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,CMD5
	MOV AH,09 ;imprimir strings
	INT 21H
	
	CALL PE
	
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,CMD6
	MOV AH,09 ;imprimir strings
	INT 21H
	
	CALL PE
	
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,CMD7
	MOV AH,09 ;imprimir strings
	INT 21H
	
	CALL PE
	
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,CMD8
	MOV AH,09 ;imprimir strings
	INT 21H
	
	CALL PE
	
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,CMD9
	MOV AH,09 ;imprimir strings
	INT 21H
	
	CALL PE
	
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,CMD10
	MOV AH,09 ;imprimir strings
	INT 21H
	
	CALL PE
	
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,CMD11
	MOV AH,09 ;imprimir strings
	INT 21H
	
	CALL PE
	
IMPINT:	
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,DDIVIS		;imprime linhas duplas
	MOV AH,09 
	INT 21H
	
	CALL PE

	MOV DX,03FH			;imprime interrogacao
	INT 21H
	
	MOV AH,01			;recebe comando (salva em AL)
	INT 21H				;esperar o CONFIRMA? (ENTER)
	MOV CCMD,AL
	CALL PE
	
	MOV OP1,0
	MOV OP1,0
	;XOR OP1,OP1
	;XOR OP2,OP2			;reseta os operandos
	
	;CALL GETINPUTENC	;reposicionar nas funcoes
	MOV AL,CCMD
	;comeca a comparar o comando, verificar a operacao a ser executada
	;em algumas, salvar OP1 em OP2 e chamar GETINPUTENC de novo
	CMP AL,31H	;1
	JE CAND
	CMP AL,32H	;2
	JE COR
	CMP AL,33H	;3
	JE CXOR
	CMP AL,34H	;...
	JE CNOT
	CMP AL,35H
	JE CSUM
	CMP AL,36H
	JE CSUB
	CMP AL,37H
	JE CMUL
	CMP AL,38H
	JE CDIV
	CMP AL,39H
	JE CAND
	CMP AL,41H	;A
	JE COR
	CMP AL,42H	;B
	JE COR
	CMP AL,61H	;a
	JE COR
	CMP AL,62H	;b
	JE COR
	;se nenhum comando foi achado, ele nao existe
	;imprimir erro e pedir o comando de novo
	CALL PRERR
	JMP IMPINT
CAND:
	JMP PRRES
COR:
	JMP PRRES
CXOR:
	JMP PRRES
CNOT:
	JMP PRRES
CSUM:
	CALL GETINPUTENC
	MOV BL,OP1
	MOV OP2,BL
	MOV OP1,0
	CALL GETINPUTENC
	ADD BL,OP1
	
	MOV OP1,BL
	JMP PRRES
CSUB:
	CALL GETINPUTENC
	MOV BL,OP1
	MOV OP2,BL
	MOV OP1,0
	CALL GETINPUTENC
	MOV BL,OP2
	SUB BL,OP1
	
	MOV OP1,BL
	JMP PRRES
CMUL:
	JMP PRRES
CDIV:
	JMP PRRES
CMU2:
	JMP PRRES
CDV2:
	JMP PRRES
CHEL:
	JMP IMPINT
PRRES:
	MOV AH,2
	MOV DL,OP1
	ADD DL,30H
	INT 21H
					;print results
	;JMP IMPINT
	
	MOV AH,4CH
	INT 21H
BEGIN ENDP

PRERR PROC	;print error
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,ERRMSG
	MOV AH,09 ;imprimir strings
	INT 21H
	
	CALL PE
	RET
PRERR ENDP

PE PROC
	MOV DX,LF
	MOV AH,02
	INT 21H
	MOV DX,CR
	MOV AH,02
	INT 21H ;enter
	
	RET
PE ENDP

GETINPUTENC PROC
BEINP:
	MOV TEMP,AL
	
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,MODENT
	MOV AH,09 ;imprimir strings
	INT 21H
	
	CALL PE
	
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,MOD1
	MOV AH,09 ;imprimir strings
	INT 21H
	
	CALL PE
	
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,MOD2
	MOV AH,09 ;imprimir strings
	INT 21H
	
	CALL PE
	
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,MOD3
	MOV AH,09 ;imprimir strings
	INT 21H
	
	CALL PE
	MOV DX,03EH			;imprime seta
	INT 21H
	MOV AL,32H			;default comando 2
ASKA:
	MOV AH,01			;recebe comando (salva em AL)
	INT 21H				
	CMP AL,0DH
	JZ GOTMO
	MOV TEMPM,AL
	JMP ASKA
GOTMO:
	MOV AL,TEMPM
	MOV CMOD,AL
	CALL PE
	CMP CMOD,31H
	JE CAS1IJ
	CMP CMOD,32H
	JE CAS2IJ
	CMP CMOD,33H
	JE CAS3I
	JMP IFERR
		;caso 3 HEXA
CAS3I:	
		MOV AX,@DATA
		MOV DS,AX
		LEA DX,SEL3
		MOV AH,09
		INT 21H
		CALL PE
CAS3:
		;MOV HFLAG,0
		MOV AH,01
		INT 21H
		CMP AL,0DH
		JZ JSHCT		;termina de receber o operando se receber CR
						;checar se esta fora dos limites
		
		CMP AL,30H		;<0
		JL NIFER
		CMP AL,39H		;0 <= X <= 9
		JL HOKN
		CMP AL,41H		;<A
		JL NIFER
		CMP AL,46H		;A <= X <= F
		JL HOKA
		CMP AL,61H		;<a
		JL NIFER
		CMP AL,39H		;a <= X <= f
		JL HOKI
		JMP NIFER
HJ1:

HOKA:	SUB AL,37H		;X - "A" + 10
		JMP HOK
HOKI:	SUB AL,57H		;X - "a" + 10
		JMP HOK
HOKN:	SUB AL,30H		;X - "0"
HOK:
		;JG NIFER
						;se chegou aqui, nao houveram erros de leitura
		MOV TEMP,AL
						;4 deslocamentos pra esquerda OU multiplica por 16
		MOV TEMP,AL
		MOV AL,OP1 
		MOV CX, 16
		MUL CX
		MOV OP1,AL
		MOV AL,TEMP
		
		;MUL OP1,010
		;SUB AL,30H
		ADD OP1,AL		
						
		JMP CAS2
	;JMP EXITMIMP
NIFER:
	CALL PRERR
	JMP BEINP
JSHCT:
	JMP EXITMIMP
CAS1IJ:					;extensor do jump
	JMP CAS1I
CAS2IJ:
	JMP CAS2I
CAS2DEL:
	MOV AL,OP1
	MOV CX,10
	DIV AL
	MOV OP1,AL
	JMP CAS2
CAS2I:	;caso 2 DECIM
		MOV AX,@DATA
		MOV DS,AX
		LEA DX,SEL2
		MOV AH,09
		INT 21H
		CALL PE
CAS2:
		MOV AH,01
		INT 21H
		CMP AL,0DH
		JZ EXITMIMP		;termina de receber um operando se receber CR
		
		CMP AL,08H
		JZ CAS2DEL
						;checar se esta fora dos limites
		CMP AL,30H
		JL IFERR
		CMP AL,39H
		JG IFERR
						;se chegou aqui, nao houveram erros de leitura
		MOV TEMP,AL
		MOV AL,OP1 
		MOV CX, 10
		MUL CX
		MOV OP1,AL
		MOV AL,TEMP
		
		;MUL OP1,010
		SUB AL,30H
		ADD OP1,AL		
		JMP CAS2		;receber proximo caracter
	;JMP EXITMIMP
CAS1I:	;caso 1 BIN
		MOV AX,@DATA
		MOV DS,AX
		LEA DX,SEL1
		MOV AH,09
		INT 21H
		CALL PE
CAS1:
		MOV AH,01
		INT 21H
		CMP AL,0DH
		JZ EXITMIMP
						;checar se esta fora dos limites
		CMP AL,30H
		JL IFERR
		CMP AL,31H
		JG IFERR
						;se chegou aqui, nao houveram erros de leitura
		;MOV TEMP,AL
		;MOV BL,OP1
		;MOV BH,0		;pode ser que de errado
		;SHL BX,1
		
		;MOV OP1,BL
		;MOV AL,TEMP
		
		;SUB AL,30H
		;ADD OP1,AL
		
		MOV TEMP,AL
		MOV AL,OP1 
		MOV CX, 2
		MUL CX
		MOV OP1,AL
		MOV AL,TEMP
		
		;MUL OP1,010
		SUB AL,30H
		ADD OP1,AL		
	
		JMP CAS1
	;JMP EXITMIMP
IFERR:
	CALL PRERR
	JMP BEINP
EXITMIMP:

	MOV AL,TEMP
	RET
GETINPUTENC ENDP


END BEGIN