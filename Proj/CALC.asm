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
	CMD12	DB "  E - Encerrar calculadora$"				;0
	CCMD	DB 0H
	OP1		DB 0H
	OP2		DB 0H
	OPA		DB 0H
	OLOP1	DB 0H
	RESUL	DB 0H
	CPRINT	DB 0H
	
	OP1B	DB 0H
	OP2B	DB 0H
	RESULB	DB 0H
	FOPBS	DB 0H	;first operand base set?
	
	DIVIS 	DB "--------------------------------------------$"
	DDIVIS	DB "============================================$"
	MODENT	DB "Modos de entrada:$"
	MODOUT	DB "Modos de saida:$"
	MOD1	DB "  1 - Binario$"
	MOD2	DB "  2 - Octal$"
	MOD3	DB "  3 - Decimal$"
	MOD4	DB "  4 - Hexadecimal$"
	ERRMSG	DB "Valor fora dos limites$"
	
	CMOD	DB 0H
	TEMP	DB 0H
	
	SEL1	DB "Modo BINARIO selecionado!$"
	SEL2	DB "Modo OCTAL selecionado!$"
	SEL3	DB "Modo DECIMAL selecionado!$"
	SEL4	DB "Modo HEXADEC selecionado!$"
	
	TEMPM	DB 0H
	MULTIB	DB 0H
	
	SEL		DB "Calculando operacao $"
	I1		DB "AND$"
	I2		DB "OR$"
	I3		DB "XOR$"
	I4		DB "NOT$"
	I5		DB "Soma$"
	I6		DB "Subtracao$"
	I7		DB "Multiplicacao$"
	I8		DB "Divisao$"
	I9		DB "Multiplicacao por potencia de 2$"
	I10		DB "Divisao por potencia de 2$"
	EXMES	DB "Encerrando calculadora...$"
<<<<<<< HEAD
	
	CMULVAL	DB 0H
	DELFLAG	DB 0H
	
	OPE1	DB " AND $"
	OPE2	DB " OR $"
	OPE3	DB " XOR $"
	OPE4	DB " NOT $"
	OPE5	DB " + $"
	OPE6	DB " - $"
	OPE7	DB " x $"
	OPE8	DB " / $"
	OPE9	DB " x2e $"
	OPE10	DB " /2e $"
	
	BAS1	DB "(2)$"
	BAS2	DB "(8)$"
	BAS4	DB "(16)$"
	CBAS	DB 0H
=======
>>>>>>> parent of 613a9c3... Adding 2 missing funcs, adding DEL
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
	
	CALL PRINTMEN
	
IMPINT:	
	MOV FOPBS,0
	
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
	;CALL PE
	MOV AX,3H			;limpar a tela
	INT 10H				;limpar a tela
	
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
	JE CHEL
	CMP AL,45H	;E
	JE CENC
	CMP AL,61H	;a
	JE COR
	CMP AL,62H	;b
	JE CHEL
	CMP AL,65H	;e
	JE CENC
	;se nenhum comando foi achado, ele nao existe
	;imprimir erro e pedir o comando de novo
	CALL PRERR
	JMP IMPINT
CAND:
	CALL OPAND
	JMP PRRES
COR:
	CALL OPOR
	JMP PRRES
CXOR:
	CALL OPXOR
	JMP PRRES
CNOT:
	CALL OPNOT
	JMP PRRES
CSUM:
	CALL OPADD
	JMP PRRES
CSUB:
	CALL OPSUB
	JMP PRRES
CMUL:
	CALL OPMUL
	JMP PRRES
CDIV:
	CALL OPDIV
	JMP PRRES
CMU2:
	CALL OPM2E
	JMP PRRES
CDV2:
	CALL OPD2E
	JMP PRRES
CHEL:
	CALL PRINTMEN
	JMP IMPINT
CENC:
	CALL ENDCALC
PRRES:				;aqui que tem que adicionar o negocinho
	;MOV AH,2
	;MOV DL,3DH
	;INT 21H
	;MOV AH,2
	;MOV DL,OP1		;get results from op1
	;ADD DL,30H
	;INT 21H
					;print results
	;CALL PE
	;CALL PRINTDLINE
	
	;JMP IMPINT		;REMOVER COMENTARIO ANTES DE ENVIAR PLMDDS
	
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
	CALL PRINTSLINE
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
	
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,MOD4
	MOV AH,09 ;imprimir strings
	INT 21H
	
	CALL PE
	CALL PRINTSLINE
	
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
	;CALL PE
	
	CMP CMOD,31H
	JE CAS1IJ
	
	CMP CMOD,32H
	JE CAS2IJ
	
	CMP CMOD,33H
	JE CAS3IJ
	
	CMP CMOD,34H
	JE CAS4I
	
	JMP IFERR
		;caso 4 HEXA
CAS4I:	
		MOV AX,@DATA
		MOV DS,AX
		LEA DX,SEL4
		MOV AH,09
		INT 21H
		
		MOV CBAS,4
		CALL WRITEBASE
		
		CALL PE
		CALL PRINTSLINE
CAS4:
		;MOV HFLAG,0
		MOV AH,01
		INT 21H
		CMP AL,0DH
		JZ JSHCT		;termina de receber o operando se receber CR
						;checar se esta fora dos limites
		
		CMP AL,30H		;<0
		JL NIFER
		CMP AL,3AH		;0 <= X <= 9
		JL HOKN
		CMP AL,41H		;<A
		JL NIFER
		CMP AL,47H		;A <= X <= F
		JL HOKA
		CMP AL,61H		;<a
		JL NIFER
		CMP AL,67H		;a <= X <= f
		JL HOKI
		JMP NIFER
CAS1IJ:					;extensor do jump
	JMP CAS1I
	
CAS2IJ:
	JMP CAS2I
	
CAS3IJ:
	JMP CAS3I
	
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
;CAS3IJ:
	;JMP CAS3I
CAS2DEL:
	MOV AL,OP1
	MOV CX,10
	DIV AL
	MOV OP1,AL
	JMP CAS2
	
CAS3I:	;caso 3 DECIM
		MOV AX,@DATA
		MOV DS,AX
		LEA DX,SEL3
		MOV AH,09
		INT 21H
		
		MOV CBAS,3
		CALL WRITEBASE
		
		CALL PE
		CALL PRINTSLINE
CAS3:
		MOV AH,01
		INT 21H
		CMP AL,0DH
		JZ EXITMIMPJ	;termina de receber um operando se receber CR
		
		CMP AL,08H
		JZ CAS2DEL
						;checar se esta fora dos limites
		CMP AL,30H
		JL IFERRJ
		CMP AL,39H
		JG IFERRJ
						;se chegou aqui, nao houveram erros de leitura
		MOV TEMP,AL
		MOV AL,OP1 
		MOV CX,10
		MUL CX
		MOV OP1,AL
		MOV AL,TEMP
		
		;MUL OP1,010
		SUB AL,30H
		ADD OP1,AL		
		JMP CAS3		;receber proximo caracter
	;JMP EXITMIMP
CAS2I:	;caso 2 OCT
		MOV AX,@DATA
		MOV DS,AX
		LEA DX,SEL2
		MOV AH,09
		INT 21H
		
		MOV CBAS,2
		CALL WRITEBASE
		
		CALL PE
		CALL PRINTSLINE
CAS2:
		MOV AH,01
		INT 21H
		CMP AL,0DH
		JZ EXITMIMP
						;checar se esta fora dos limites
		CMP AL,30H
		JL IFERR
		CMP AL,38H
		JG IFERR
						;se chegou aqui, nao houveram erros de leitura
		
		MOV TEMP,AL
		MOV AL,OP1 
		MOV CX, 8
		MUL CX
		MOV OP1,AL
		MOV AL,TEMP
		
		;MUL OP1,010
		SUB AL,30H
		ADD OP1,AL		
	
		JMP CAS2
	
IFERRJ: JMP IFERR
EXITMIMPJ: JMP EXITMIMP

CAS1I:	;caso 1 BIN
		MOV AX,@DATA
		MOV DS,AX
		LEA DX,SEL1
		MOV AH,09
		INT 21H
		
		MOV CBAS,1
		CALL WRITEBASE
		
		CALL PE
		CALL PRINTSLINE
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
	MOV AX,@DATA
	MOV DS,AX
	LEA DX,DIVIS
	MOV AH,09
	INT 21H
	CALL PE
	
	MOV FOPBS,1
	
	MOV AL,TEMP
	RET
GETINPUTENC ENDP

OPAND PROC
	CALL PRINTOPINTR
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,I1
	MOV AH,09 ;imprimir strings
	INT 21H
	CALL PE
	CALL PRINTSLINE
	
	CALL GETINPUTENC
	MOV BL,OP1
	MOV OP2,BL
	MOV OP1,0
	CALL GETINPUTENC
	AND BL,OP1
	
	MOV OP1,BL
	
	CALL OUTPUT
	RET
OPAND ENDP

OPOR PROC
	CALL PRINTOPINTR
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,I2
	MOV AH,09 ;imprimir strings
	INT 21H
	CALL PE
	CALL PRINTSLINE
	
	CALL GETINPUTENC
	MOV BL,OP1
	MOV OP2,BL
	MOV OP1,0
	CALL GETINPUTENC
	OR BL,OP1
	
	MOV OP1,BL
	
	CALL OUTPUT
	RET
OPOR ENDP

OPXOR PROC
	CALL PRINTOPINTR
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,I3
	MOV AH,09 ;imprimir strings
	INT 21H
	CALL PE
	CALL PRINTSLINE
	
	CALL GETINPUTENC
	MOV BL,OP1
	MOV OP2,BL
	MOV OP1,0
	CALL GETINPUTENC
	XOR BL,OP1
	
	MOV OP1,BL
	
	CALL OUTPUT
	RET
OPXOR ENDP

OPNOT PROC
	CALL PRINTOPINTR
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,I4
	MOV AH,09 ;imprimir strings
	INT 21H
	CALL PE
	CALL PRINTSLINE
	
	CALL GETINPUTENC
	
	MOV BL,OP1
	NOT BL
	MOV OP1,BL
	
	CALL OUTPUT
	RET
OPNOT ENDP

OPADD PROC
	CALL PRINTOPINTR
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,I5
	MOV AH,09 ;imprimir strings
	INT 21H
	CALL PE
	CALL PRINTSLINE
	
	CALL GETINPUTENC
	MOV BL,OP1
	MOV OP2,BL
	MOV OP1,0
	CALL GETINPUTENC
	ADD BL,OP1
	
	MOV OP1,BL
	
	CALL COUTPUT
	RET
OPADD ENDP

OPSUB PROC
	CALL PRINTOPINTR

	MOV AX, @DATA
	MOV DS,AX
	LEA DX,I6
	MOV AH,09 ;imprimir strings
	INT 21H
	CALL PE
	CALL PRINTSLINE
	
	CALL GETINPUTENC
	MOV BL,OP1
	MOV OP2,BL
	MOV OP1,0
	
	CALL GETINPUTENC
	MOV BL,OP1
	CMP OP2,BL
	JB NEGATIVO
	
	MOV BL,OP2
	SUB BL,OP1
	MOV OP1,BL
	CALL OUTPUT
	RET
	
NEGATIVO:
	MOV BL,OP1
	SUB BL,OP2
	MOV OP1,BL
	MOV OPA,1
	CALL OUTPUT
	RET
OPSUB ENDP

OPMUL PROC
	CALL PRINTOPINTR
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,I7
	MOV AH,09 ;imprimir strings
	INT 21H
	CALL PE
	CALL PRINTSLINE
	
	CALL GETINPUTENC
	MOV BL,OP1
	MOV OP2,BL
	MOV OP1,0
	CALL GETINPUTENC
	
	MOV TEMP,AL
	MOV AL,OP1 
	MOV Cl,OP2
	MOV CH,0H
	MUL CX
	MOV OP1,AL
	MOV AL,TEMP
	
	CALL OUTPUT
	RET
OPMUL ENDP

OPDIV PROC
	CALL PRINTOPINTR
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,I8
	MOV AH,09 ;imprimir strings
	INT 21H
	CALL PE
	CALL PRINTSLINE
	
	CALL GETINPUTENC
	MOV BL,OP1
	MOV OP2,BL
	MOV OP1,0
	CALL GETINPUTENC
	CMP OP1,0
	JZ DIVER
	
	MOV TEMP,AL
	MOV AL,OP2
	XOR AH,AH
	XOR BH,BH
	MOV BL,OP1
	DIV OP1
	MOV OP1,AL
	MOV AL,TEMP
	
	CALL OUTPUT
	RET
	
DIVER:
	CALL PRERR
	MOV OP1,0
	CALL OUTPUT
	RET
OPDIV ENDP

OPM2E PROC
	RET
OPM2E ENDP

OPD2E PROC
	RET
OPD2E ENDP

<<<<<<< HEAD
GET2OPS PROC
	CALL GETINPUTENC
	MOV BL,OP1
	MOV OP2,BL
	MOV OP1,0
	CALL GETINPUTENC
	MOV BL,OP1
	MOV OLOP1,BL
	RET
GET2OPS ENDP

=======
>>>>>>> parent of 613a9c3... Adding 2 missing funcs, adding DEL
ENDCALC PROC
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,EXMES
	MOV AH,09 ;imprimir strings
	INT 21H
	CALL PE
	CALL PRINTDLINE
	CALL PE
	
	MOV AH,4CH
	INT 21H

ENDCALC ENDP

GETINPUT PROC
	
	RET
GETINPUT ENDP

PRINTOPINTR PROC
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,SEL
	MOV AH,09 ;imprimir strings
	INT 21H
	RET
PRINTOPINTR ENDP

PRINTSLINE PROC
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,DIVIS
	MOV AH,09 ;imprimir strings
	INT 21H
	CALL PE
	RET
PRINTSLINE ENDP

PRINTDLINE PROC
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,DDIVIS
	MOV AH,09 ;imprimir strings
	INT 21H
	CALL PE
	RET
PRINTDLINE ENDP

DELCHAR PROC
	MOV AH,2
	MOV DX,20H
	INT 21H
	MOV DX,8
	INT 21H
DELCHAR ENDP

PRINTMEN PROC
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
	
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,CMD12
	MOV AH,09 ;imprimir strings
	INT 21H
	
	CALL PE
	
	RET
PRINTMEN ENDP

OUTPUT PROC
		CALL PE

		MOV AX, @DATA
		MOV DS,AX
		LEA DX,MODOUT
		MOV AH,09 ;imprimir strings
		INT 21H
		
		CALL PE

		CALL PRINTSLINE

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

		MOV AX, @DATA
		MOV DS,AX
		LEA DX,MOD4
		MOV AH,09 ;imprimir strings
		INT 21H
		
		CALL PE

		CALL PRINTSLINE

		;MOV AH,01			;recebe comando (salva em AL)
		;INT 21H				;esperar o CONFIRMA? (ENTER)

		MOV DX,03EH			;imprime seta
		INT 21H
	ASKAO:
		MOV AH,01			;recebe comando (salva em AL)
		INT 21H				
		CMP AL,0DH
		JZ GOTMOO
		MOV TEMPM,AL
		JMP ASKAO
	GOTMOO:
	
		;CALL PE
		CMP AL,31H			;verifica opção digitada
		JE CASE1

		CMP AL,32H
		JE CASE2

		CMP AL,33H
		JE CASE3

		CMP AL,34H
		JE CASE4
	
		CALL PRERR

		JMP OUTPUT

		CASE1:
		
		CALL PE
		;MOV BX,2
		MOV AX, @DATA
		MOV DS,AX
		LEA DX,SEL1
		MOV AH,09 ;imprimir strings
		INT 21H
		CALL PE
		CALL PRINTDLINE

		MOV BX,2
		JMP MAGIC

		CASE2:
		
		CALL PE
		MOV AX, @DATA
		MOV DS,AX
		LEA DX,SEL2
		MOV AH,09 ;imprimir strings
		INT 21H
		CALL PE
		CALL PRINTDLINE
		
		MOV BX,8
		JMP MAGIC

		CASE3:

		CALL PE
		;MOV BX,10
		MOV AX, @DATA
		MOV DS,AX
		LEA DX,SEL3
		MOV AH,09 ;imprimir strings
		INT 21H
		CALL PE
		CALL PRINTDLINE
		
		MOV BX,10
		JMP MAGIC

		CASE4:

		CALL PE
		;MOV BX,16
		MOV AX, @DATA
		MOV DS,AX
		LEA DX,SEL4
		MOV AH,09 ;imprimir strings
		INT 21H
		CALL PE
		CALL PRINTDLINE

		MOV BX,16
		JMP MAGIC

	MAGIC:
		CMP OPA,1
		JE DIMM

        MOV AL, OP1     ;move operador 1 para al            

        MOV CL, AL		;move al para cl
        ;MOV AX, 0       ;limpa ax    
		XOR AX,AX

        MOV AL, CL      ;retorna cl para al     

        ;MOV CX, 0       ;inicializa o contador
		XOR CX,CX

        ;MOV DX, 0       ;limpa dx
		XOR DX,DX

        DVD2:   		;divide por 16
            DIV BX      ; divide ax por bx, resultado da div em ax   

            PUSH DX    	;resto fica em dx e epilha

            ADD CX, 1   ;adiciona 1 ao contador

            ;MOV DX, 0   ;limpa dx
			XOR DX,DX

            CMP AX, 0   ;compara o resultado da div com 0

            JNE DVD2   	;se o resultado for !=0 faz a operação novamente

        GHEX:
            ;MOV DX, 0   ;limpa DX 
			XOR DX,DX

            POP DX   	;copia o conteúdo da memória indicado por dx

            ADD DL, 30h ;adiciona 30h em dl(conteudo de dx) devido a tabela ascii   


            CMP DL, 39h	;compara

            JG MHEX	;Caso o valor ultrapassar 9 pula para função mhex para descobrir letra equivalente

        PRINTHEX:        
            MOV AH, 02h  ;imprime resultado na tela

            INT 21H

            LOOP GHEX    ;executa ghex decrementando cx até que este seja 0        

            JMP STOP	;para o programa - NAO NAO NAO NAO NAO

        MHEX:
            ADD DL, 7h	;adiciona 7 devido ao espaço entre as letras e números da tabela ascii

            JMP PRINTHEX            

        STOP:
        MOV AH,4CH
		INT 21H
		
	DIMM:
	MOV DL,2DH
	MOV AH, 02h  ;imprime resultado na tela
    INT 21H
	MOV OPA,0
	JMP MAGIC
OUTPUT ENDP

COUTPUT PROC
		MOV BX,2
		CMP CBAS,1
		JE CMAGIC
		
		MOV BX,8
		CMP CBAS,2
		JE CMAGIC
		
		MOV BX,10
		CMP CBAS,3
		JE CMAGIC
		
		MOV BX,16

	CMAGIC:
		CMP OPA,1
		JE CDIMM

        MOV AL, CPRINT     ;move operador 1 para al            

        MOV CL, AL		;move al para cl
        ;MOV AX, 0       ;limpa ax    
		XOR AX,AX

        MOV AL, CL      ;retorna cl para al     

        ;MOV CX, 0       ;inicializa o contador
		XOR CX,CX

        ;MOV DX, 0       ;limpa dx
		XOR DX,DX

        CDVD2:   		;divide por 16
            DIV BX      ; divide ax por bx, resultado da div em ax   

            PUSH DX    	;resto fica em dx e epilha

            ADD CX, 1   ;adiciona 1 ao contador

            ;MOV DX, 0   ;limpa dx
			XOR DX,DX

            CMP AX, 0   ;compara o resultado da div com 0

            JNE CDVD2   	;se o resultado for !=0 faz a operação novamente

        CGHEX:
            ;MOV DX, 0   ;limpa DX 
			XOR DX,DX

            POP DX   	;copia o conteúdo da memória indicado por dx

            ADD DL, 30h ;adiciona 30h em dl(conteudo de dx) devido a tabela ascii   


            CMP DL, 39h	;compara

            JG CMHEX	;Caso o valor ultrapassar 9 pula para função mhex para descobrir letra equivalente

        CPRINTHEX:        
            MOV AH, 02h  ;imprime resultado na tela

            INT 21H

            LOOP CGHEX    ;executa ghex decrementando cx até que este seja 0        

            JMP CSTOP	;para o programa - NAO NAO NAO NAO NAO

        CMHEX:
            ADD DL, 7h	;adiciona 7 devido ao espaço entre as letras e números da tabela ascii

            JMP CPRINTHEX            

        CSTOP:
						;imprimir a base
		CMP CBAS,1
		JE PB1
		CMP CBAS,2
		JE PB2
		CMP CBAS,4
		JE PB4
		JMP ENDCOUT
	PB1:
		MOV AX, @DATA
		MOV DS,AX
		LEA DX,BAS1
		MOV AH,09 ;imprimir strings
		INT 21H
		JMP ENDCOUT
	PB2:
		MOV AX, @DATA
		MOV DS,AX
		LEA DX,BAS2
		MOV AH,09 ;imprimir strings
		INT 21H
		JMP ENDCOUT
	PB4:
		MOV AX, @DATA
		MOV DS,AX
		LEA DX,BAS4
		MOV AH,09 ;imprimir strings
		INT 21H
	ENDCOUT:
		RET
        ;MOV AH,4CH
		;INT 21H
		
	CDIMM:
	MOV DL,2DH
	MOV AH, 02h  ;imprime resultado na tela
    INT 21H
	MOV OPA,0
	JMP MAGIC
COUTPUT ENDP

NEWOUTPUT PROC
	CALL PRINTDLINE
	
	MOV BL,OLOP1
	MOV CPRINT,BL
	MOV BL,OP1B
	MOV CBAS,BL
	CALL COUTPUT
	
	MOV AX, @DATA
	MOV DS,AX
	
	;IMPRIMIR OPERADOR
	CMP CCMD,31H
	JE OOP1
	CMP CCMD,32H
	JE OOP2
	CMP CCMD,33H
	JE OOP3
	CMP CCMD,34H
	JE OOP4
	CMP CCMD,35H
	JE OOP5
	CMP CCMD,36H
	JE OOP6
	CMP CCMD,37H
	JE OOP7
	CMP CCMD,38H
	JE OOP8
	CMP CCMD,39H
	JE OOP9
	CMP CCMD,41H
	JE OOP10
	CMP CCMD,61H
	JE OOP9
	JMP OOP10
	
OOP1:
	LEA DX,OPE1
	MOV AH,09 ;imprimir strings
	INT 21H
	JMP POP2
OOP2:
	LEA DX,OPE2
	MOV AH,09 ;imprimir strings
	INT 21H
	JMP POP2
OOP3:
	LEA DX,OPE3
	MOV AH,09 ;imprimir strings
	INT 21H
	JMP POP2
OOP4:
	LEA DX,OPE4
	MOV AH,09 ;imprimir strings
	INT 21H
	JMP POP2
OOP5:
	LEA DX,OPE5
	MOV AH,09 ;imprimir strings
	INT 21H
	JMP POP2
OOP6:
	LEA DX,OPE6
	MOV AH,09 ;imprimir strings
	INT 21H
	JMP POP2
OOP7:
	LEA DX,OPE7
	MOV AH,09 ;imprimir strings
	INT 21H
	JMP POP2
OOP8:
	LEA DX,OPE8
	MOV AH,09 ;imprimir strings
	INT 21H
	JMP POP2
OOP9:
	LEA DX,OPE9
	MOV AH,09 ;imprimir strings
	INT 21H
	JMP POP2
OOP10:
	LEA DX,OPE10
	MOV AH,09 ;imprimir strings
	INT 21H
	
POP2:
	MOV BL,OP2
	MOV CPRINT,BL
	MOV BL,OP2B
	MOV CBAS,BL
	CALL COUTPUT
	
	MOV AH,2
	MOV DL,3DH
	INT 21H
	
	MOV BL,OP1
	MOV CPRINT,BL
	MOV BL,RESULB
	MOV CBAS,BL
	CALL COUTPUT
	
	CALL PE
	RET
NEWOUTPUT ENDP

WRITEBASE PROC
	CMP FOPBS,1
	JE WILLSET2
WILLSET1:
	MOV BL,CBAS
	MOV OP1B,BL
	JMP FINISHEDSET
WILLSET2:
	MOV BL,CBAS
	MOV OP2B,BL
FINISHEDSET:
	RET
WRITEBASE ENDP

END BEGIN