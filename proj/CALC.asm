TITLE CALCULADORA SHOW
.MODEL SMALL
.STACK 100H
.DATA
	LF		EQU 0AH
	CR		EQU 0DH
	BOUNDUP	DB "=======================================================$"
	TITULO 	DB "|                     Calculadora                     |$"
	DIGITE 	DB "|Comandos:                                            |$"
	CMD1	DB "|  1 - AND                                            |$"	;2
	CMD2	DB "|  2 - OR                                             |$"	;2
	CMD3	DB "|  3 - XOR                                            |$"	;2
	CMD4	DB "|  4 - NOT                                            |$"	;1
	CMD5	DB "|  5 - Soma                                           |$"	;2
	CMD6	DB "|  6 - Subtracao                                      |$"	;2
	CMD7	DB "|  7 - Multiplicacao                                  |$"	;2
	CMD8	DB "|  8 - Divisao                                        |$"	;2
	CMD9	DB "|  9 - Multiplicacao por 2 exp                        |$"	;1
	CMD10	DB "|  A - Divisao por 2 exp                              |$"	;1
	CMD11	DB "|  B - Ajuda (imprimir comandos novamente)            |$"	;0
	CMD12	DB "|  E - Encerrar calculadora                           |$"	;0
	CCMD	DB 0H
	OP1		DB 0H
	OP2		DB 0H
	OPA		DB 0H
	RESUL	DB 0H
	DIVIS 	DB "|-----------------------------------------------------|$"
	DDIVIS	DB "|=====================================================|$"
	MODENT	DB "|Modos de entrada:                                    |$"
	MODOUT	DB "|Modos de saida:                                      |$"
	MOD1	DB "|  1 - Binario                                        |$"
	MOD2	DB "|  2 - Octal                                          |$"
	MOD3	DB "|  3 - Decimal (DEFAULT)                              |$"
	MOD4	DB "|  4 - Hexadecimal                                    |$"
	ERRMSG	DB "|              Valor fora dos limites                 |$"
	CMOD	DB 0H
	TEMP	DB 0H
	SEL1	DB "|Modo BINARIO selecionado!                            |$"
	SEL2	DB "|Modo OCTAL selecionado!                              |$"
	SEL3	DB "|Modo DECIMAL selecionado!                            |$"
	SEL4	DB "|Modo HEXADEC selecionado!                            |$"
	TEMPM	DB 0H
	MULTIB	DB 0H
	SEL		DB "|Calculando operacao $"
	I1		DB "AND                              |$"
	I2		DB "OR                               |$"
	I3		DB "XOR                              |$"
	I4		DB "NOT                              |$"
	I5		DB "Soma                             |$"
	I6		DB "Subtracao                        |$"
	I7		DB "Multiplicacao                    |$"
	I8		DB "Divisao                          |$"
	I9		DB "Multiplicacao por potencia de 2  |$"
	I10		DB "Divisao por potencia de 2        |$"
	EXMES	DB "|              Encerrando calculadora...              |$"
	CMULVAL	DB 0H
	DELFLAG	DB 0H
.CODE
BEGIN PROC
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,BOUNDUP
	MOV AH,09 ;imprimir strings
	INT 21H
	
	CALL PE
	
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,TITULO
	MOV AH,09 ;imprimir strings
	INT 21H

	CALL PE


IMPINT:	
	
	
	CALL PRINTDLINE
	
	CALL PRINTMEN
	
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
	JE CMU2
	CMP AL,41H	;A
	JE CDV2
	;CMP AL,42H	;B
	;JE CHEL
	CMP AL,45H	;E
	JE CENC
	CMP AL,61H	;a
	JE CDV2
	;CMP AL,62H	;b
	;JE CHEL
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
;CHEL:
	;CALL PRINTMEN
	;JMP IMPINT
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
	CALL PE
	JMP IMPINT		;REMOVER COMENTARIO ANTES DE ENVIAR PLMDDS
	
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
	
	MOV DX,03EH			;imprime seta
	INT 21H
	MOV AL,33H			;default comando 2
	MOV TEMPM,33H
	MOV DX,03EH			;imprime seta
	INT 21H
	
ASKA:

	MOV AH,2
	;XOR DX,DX
	MOV DX,08H			;apaga ultimo valor
	INT 21H
	;MOV AH,2
	MOV DX,08H			;apaga ultimo valor
	INT 21H
	MOV DX,08H			;apaga ultimo valor
	INT 21H
	MOV DX,03EH			;imprime seta
	INT 21H
	
	;XOR DX,DX
	;MOV AH,2
	;MOV DL,TEMPM		;imprime ultimo valor
	;INT 21H
	
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
		CALL PE
		CALL PRINTSLINE
		MOV AH,2
	MOV DX,30H			;imprime zero
	INT 21H
	MOV DX,08H			;apaga ultimo valor
	INT 21H
CAS4:
		MOV CMULVAL,16
		;MOV HFLAG,0
		MOV AH,01
		INT 21H
		CMP AL,0DH
		JZ JSHCT		;termina de receber o operando se receber CR
		CALL DELCHAR
		CMP DELFLAG,1
		JE CAS4
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
		;MOV TEMP,AL
						;4 deslocamentos pra esquerda OU multiplica por 16
		CALL GETINPUT
		
		;MOV TEMP,AL
		;MOV AL,OP1 
		;MOV CX, 16
		;MUL CX
		;MOV OP1,AL
		;MOV AL,TEMP
		
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
		CALL PE
		CALL PRINTSLINE
		MOV AH,2
	MOV DX,30H			;imprime zero
	INT 21H
	MOV DX,08H			;apaga ultimo valor
	INT 21H
CAS3:
		MOV CMULVAL,10
		
		MOV AH,01
		INT 21H
		CMP AL,0DH
		JZ EXITMIMPJ	;termina de receber um operando se receber CR
		CALL DELCHAR
		CMP DELFLAG,1
		JE CAS3
		
		CMP AL,08H
		JZ CAS2DEL
						;checar se esta fora dos limites
		CMP AL,30H
		JL IFERRJ
		CMP AL,39H
		JG IFERRJ
						;se chegou aqui, nao houveram erros de leitura
		CALL GETINPUT
		;MOV TEMP,AL
		;MOV AL,OP1 
		;MOV CX,10
		;MUL CX
		;MOV OP1,AL
		;MOV AL,TEMP
		
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
		CALL PE
		CALL PRINTSLINE
		MOV AH,2
	MOV DX,30H			;imprime zero
	INT 21H
	MOV DX,08H			;apaga ultimo valor
	INT 21H
CAS2:
		MOV CMULVAL,8
		
		MOV AH,01
		INT 21H
		CMP AL,0DH
		JZ EXITMIMP
		CALL DELCHAR
		CMP DELFLAG,1
		JE CAS2
						;checar se esta fora dos limites
		CMP AL,30H
		JL IFERR
		CMP AL,38H
		JG IFERR
						;se chegou aqui, nao houveram erros de leitura
		CALL GETINPUT
		;MOV TEMP,AL
		;MOV AL,OP1 
		;MOV CX, 8
		;MUL CX
		;MOV OP1,AL
		;MOV AL,TEMP
		
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
		CALL PE
		CALL PRINTSLINE
		MOV AH,2
	MOV DX,30H			;imprime zero
	INT 21H
	MOV DX,08H			;apaga ultimo valor
	INT 21H
CAS1:
		MOV CMULVAL,2
		
		MOV AH,01
		INT 21H
		CMP AL,0DH
		JZ EXITMIMP
		CALL DELCHAR
		CMP DELFLAG,1
		JE CAS1
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
		
		;MOV TEMP,AL
		;MOV AL,OP1 
		;MOV CX, 2
		;MUL CX
		;MOV OP1,AL
		;MOV AL,TEMP
		
		CALL GETINPUT
		
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
	
	;CALL GETINPUTENC
	;MOV BL,OP1
	;MOV OP2,BL
	;MOV OP1,0
	;CALL GETINPUTENC
	CALL GET2OPS
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
	
	;CALL GETINPUTENC
	;MOV BL,OP1
	;MOV OP2,BL
	;MOV OP1,0
	;CALL GETINPUTENC
	CALL GET2OPS
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
	
	;CALL GETINPUTENC
	;MOV BL,OP1
	;MOV OP2,BL
	;MOV OP1,0
	;CALL GETINPUTENC
	CALL GET2OPS
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
	
	;CALL GETINPUTENC
	;MOV BL,OP1
	;MOV OP2,BL
	;MOV OP1,0
	;CALL GETINPUTENC
	CALL GET2OPS
	ADD BL,OP1
	
	MOV OP1,BL
	
	CALL OUTPUT
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
	
	;CALL GETINPUTENC
	;MOV BL,OP1
	;MOV OP2,BL
	;MOV OP1,0
	
	;CALL GETINPUTENC
	CALL GET2OPS
	
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
	
	;CALL GETINPUTENC
	;MOV BL,OP1
	;MOV OP2,BL
	;MOV OP1,0
	;CALL GETINPUTENC
	CALL GET2OPS
	
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
	
	;CALL GETINPUTENC
	;MOV BL,OP1
	;MOV OP2,BL
	;MOV OP1,0
	;CALL GETINPUTENC
	CALL GET2OPS
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
	CALL PRINTOPINTR
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,I9
	MOV AH,09 ;imprimir strings
	INT 21H
	CALL PE
	CALL PRINTSLINE
	
	;CALL GETINPUTENC
	;MOV BL,OP1
	;MOV OP2,BL
	;MOV OP1,0
	;CALL GETINPUTENC
	CALL GET2OPS
	
	MOV CL,OP1
	MOV BL,OP2
	SHL BL,CL
	
	MOV OP1,BL
	
	CALL OUTPUT
	
	RET
OPM2E ENDP

OPD2E PROC
	CALL PRINTOPINTR
	MOV AX, @DATA
	MOV DS,AX
	LEA DX,I9
	MOV AH,09 ;imprimir strings
	INT 21H
	CALL PE
	CALL PRINTSLINE
	
	;CALL GETINPUTENC
	;MOV BL,OP1
	;MOV OP2,BL
	;MOV OP1,0
	;CALL GETINPUTENC
	CALL GET2OPS
	
	MOV CL,OP1
	MOV BL,OP2
	SHR BL,CL
	
	MOV OP1,BL
	
	CALL OUTPUT
	
	RET
OPD2E ENDP

GET2OPS PROC
	CALL GETINPUTENC
	MOV BL,OP1
	MOV OP2,BL
	MOV OP1,0
	CALL GETINPUTENC
	RET
GET2OPS ENDP

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
	MOV TEMP,AL
	MOV AL,OP1 
	MOV CL,CMULVAL
	MUL CL
	MOV OP1,AL
	MOV AL,TEMP
	
	RET
GETINPUT ENDP

DELCHAR PROC
	;MOV TEMP,AL
	MOV DELFLAG,0
	CMP AL,8
	JNE RETU
	MOV DELFLAG,1
	MOV AL,OP1 
	XOR AH,AH
	XOR BH,BH
	MOV BL,CMULVAL
	DIV BL
	MOV OP1,AL
	
	MOV AH,2
	MOV DX,20H		;imprimir espaco em branco
	INT 21H
	MOV DX,8		;voltar o ponteiro
	INT 21H
RETU:
	;MOV AL,TEMP
	RET
DELCHAR ENDP

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
	
	;CALL PE
	
	;MOV AX, @DATA
	;MOV DS,AX
	;LEA DX,CMD11
	;MOV AH,09 ;imprimir strings
	;INT 21H
	
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
	
		MOV AL,TEMPM
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
		CALL LIKE

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
		CALL LIKE

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
		CALL LIKE
		
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
		CALL LIKE

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

        RET
       	;MOV AH,4CH
		;INT 21H
		
	DIMM:
	MOV DL,2DH
	MOV AH, 02h  ;imprime resultado na tela
    INT 21H
	MOV OPA,0
	JMP MAGIC
OUTPUT ENDP

LIKE PROC
		MOV AH,2
		MOV DX,20H		;imprimir espaco em branco
		INT 21H
		MOV AH,2
		MOV DX,3DH		;imprimir sinal de igual
		INT 21H
		MOV AH,2
		MOV DX,20H		;imprimir espaco em branco
		INT 21H
	RET
LIKE ENDP

END BEGIN