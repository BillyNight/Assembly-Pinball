;------------------------------------------------------------------------------
; ZONA I: Definicao de constantes
;         Pseudo-instrucao : EQU
;------------------------------------------------------------------------------
WRITE        	EQU     FFFEh
FIM_TEXTO       EQU     '@'
INITIAL_SP      EQU     FDFFh
CURSOR		    EQU     FFFCh
CURSOR_INIT		EQU		FFFFh
NUM_COLUMNS		EQU		80d
ROW_SHIFT		EQU		8d
NUM_ROWS		EQU		24d
CONFIG_TIMER 	EQU		FFF6h
ACTIVATE_TIMER	EQU		FFF7h
OFF				EQU		0d
ON				EQU		1d
CharZero		EQU		48d

;------------------------------------------------------------------------------
; ZONA II: definicao de variaveis
;          Pseudo-instrucoes : WORD - palavra (16 bits)
;                              STR  - sequencia de caracteres (cada ocupa 1 palavra: 16 bits).
;          Cada caracter ocupa 1 palavra
;------------------------------------------------------------------------------
			ORIG		8000h
ColumnIndex WORD		0d
RowIndex	WORD		0d
LineIndex	WORD		0d
TextIndex	WORD		0d
Lifes		WORD		50d
BallDir		WORD		1d
BallPosCol	WORD		0d
BallPosRow	WORD		0d
HasBall		WORD		OFF
LeftFlipUp	WORD		0d
RightFlipUp	WORD		0d
AnyFlipUp	WORD		0d
DezPoints	WORD		CharZero
CentPoints	WORD 		CharZero
MilPoints	WORD		CharZero
MilhPoints	WORD		CharZero


;------------------------------------------------------------------------------
; ZONA II: definicao de tabela de interrupções
;------------------------------------------------------------------------------
                ORIG    FE00h
INT0            WORD    MovFlipplerEsq
INT1            WORD    MovFlipplerDir
INT2			WORD	LaunchBall
				ORIG    FE0Fh
INT15			WORD	Timer
;------------------------------------------------------------------------------
; ZONA IV: codigo
;        conjunto de instrucoes Assembly, ordenadas de forma a realizar
;        as funcoes pretendidas
;------------------------------------------------------------------------------
                ORIG    0000h
                JMP     Main

;------------------------------------------------------------------------------
; Função MovFlipplerEsq
;------------------------------------------------------------------------------	
MovFlipplerEsq: PUSH R1
				PUSH R2
				PUSH R3
				PUSH R4
				PUSH R5
				PUSH R6

				MOV R1, 1d
				MOV M[LeftFlipUp], R1
				MOV M[AnyFlipUp], R1

				MOV R1, 30d
				MOV R2, 17d
				MOV R3, '_'
				MOV R4, 37d
				MOV M[ColumnIndex], R1
				MOV M[RowIndex], R2
				CALL PrintLinCar

				MOV R4, 32d;
				MOV R1, 31d;
				MOV M[ColumnIndex], R1;
				MOV R2, 18d;
				MOV M[RowIndex], R2;
				MOV R3, ' '
				CALL PrintLinCar;

				MOV R4, 33d;
				MOV R1, 32d;
				MOV M[ColumnIndex], R1;
				MOV R2, 19d;
				MOV M[RowIndex], R2;
				MOV R3, ' '
				CALL PrintLinCar;

				MOV R4, 34d;
				MOV R1, 33d;
				MOV M[ColumnIndex], R1;
				MOV R2, 20d;
				MOV M[RowIndex], R2;
				MOV R3, ' '
				CALL PrintLinCar

				MOV R1, M[HasBall]
				CMP R1, OFF
				JMP.Z EndMovFlipEsq

				MOV R4, M[BallDir]
				MOV R5, M[BallPosCol]
				MOV R6, M[BallPosRow]

				CMP R6, 17d
				JMP.P MaybeLeftArea
				JMP EndMovFlipEsq;

MaybeLeftArea:	CMP R6, 21d
				JMP.P EndMovFlipEsq
				CMP R5, 38d
				JMP.P EndMovFlipEsq
				
				MOV R2, M[BallPosRow]
				MOV R6, 16d
				MOV M[BallPosRow], R6;
				CMP R4, 1d;
				JMP.Z ToZeroLeft
				CMP R4, 2d
				JMP.Z ToThreeLeft

ToZeroLeft:		MOV R4, 0d;
				JMP ContinueLeft

ToThreeLeft:	MOV R4, 3d;
				JMP ContinueLeft

ContinueLeft:	MOV M[BallDir], R4

				MOV	R1, M[BallPosCol]
				MOV R4, R1;
				MOV M[ColumnIndex], R1
				MOV M[RowIndex], R2
				INC R4;
				MOV R3, ' '
				CALL PrintLinCar

				MOV M[ColumnIndex], R5
				MOV M[RowIndex], R6
				MOV R3, 'O'
				MOV R4, R5
				INC R4
				CALL PrintLinCar

				MOV M[BallPosCol], R5
				MOV M[BallPosRow], R6

EndMovFlipEsq:	POP R6
				POP R5
				POP R4
				POP R3
				POP R2
				POP R1

				RTI

;------------------------------------------------------------------------------
; Função MovFlipplerDir
;------------------------------------------------------------------------------	
MovFlipplerDir: PUSH R1
				PUSH R2
				PUSH R3
				PUSH R4
				PUSH R5
				PUSH R6
				
				MOV R1, 1d;
				MOV M[RightFlipUp], R1
				MOV M[AnyFlipUp], R1

				MOV R1, 41d
				MOV R2, 17d
				MOV R3, '_'
				MOV R4, 48d
				MOV M[ColumnIndex], R1
				MOV M[RowIndex], R2
				CALL PrintLinCar

				MOV R4, 47d;
				MOV R1, 46d;
				MOV M[ColumnIndex], R1;
				MOV R2, 18d;
				MOV M[RowIndex], R2;
				MOV R3, ' '
				CALL PrintLinCar;

				MOV R4, 46d;
				MOV R1, 45d;
				MOV M[ColumnIndex], R1;
				MOV R2, 19d;
				MOV M[RowIndex], R2;
				MOV R3, ' '
				CALL PrintLinCar;

				MOV R4, 45d;
				MOV R1, 44d;
				MOV M[ColumnIndex], R1;
				MOV R2, 20d;
				MOV M[RowIndex], R2;
				MOV R3, ' '
				CALL PrintLinCar;

				MOV R1, M[HasBall]
				CMP R1, OFF
				JMP.Z EndMovFlipDir

				MOV R4, M[BallDir]
				MOV R5, M[BallPosCol]
				MOV R6, M[BallPosRow]

				CMP R6, 17d
				JMP.P MaybeRightArea
				JMP EndMovFlipDir

MaybeRightArea: CMP R6, 21d
				JMP.P EndMovFlipDir
				CMP R5, 40d
				JMP.NP EndMovFlipDir

				MOV R2, M[BallPosRow]
				MOV R6, 16d
				MOV M[BallPosRow], R6;
				CMP R4, 1d;
				JMP.Z ToZeroRight
				CMP R4, 2d
				JMP.Z ToThreeRight

ToZeroRight:	MOV R4, 0d
				JMP ContinueRight

ToThreeRight:	MOV R4, 3d
				JMP ContinueRight

ContinueRight:	MOV M[BallDir], R4

				MOV	R1, M[BallPosCol]
				MOV R4, R1;
				MOV M[ColumnIndex], R1
				MOV M[RowIndex], R2
				INC R4;
				MOV R3, ' '
				CALL PrintLinCar

				MOV M[ColumnIndex], R5
				MOV M[RowIndex], R6
				MOV R3, 'O'
				MOV R4, R5
				INC R4
				CALL PrintLinCar

				MOV M[BallPosCol], R5
				MOV M[BallPosRow], R6


EndMovFlipDir:	POP R6
				POP R5
				POP R4
				POP R3
				POP R2
				POP R1

				RTI

;------------------------------------------------------------------------------
; Função Apaga pás pra cima
;------------------------------------------------------------------------------					

ClearFlip:		PUSH R1
				PUSH R2
				PUSH R3
				PUSH R4

				MOV R1, M[LeftFlipUp]
				CMP R1, OFF
				JMP.Z CompareRight
				MOV R1, 30d ;
				MOV R2, 17d
				MOV R3, ' '
				MOV R4, 37d
				MOV M[ColumnIndex], R1
				MOV M[RowIndex], R2
				CALL PrintLinCar
				MOV R1, OFF
				MOV M[LeftFlipUp], R1

				CALL PrintLFlip

CompareRight:	MOV R1, M[RightFlipUp]
				CMP R1, OFF
				JMP.Z EndClearFlip
				MOV R1, 41d 
				MOV R2, 17d
				MOV R3, ' '
				MOV R4, 48d
				MOV M[ColumnIndex], R1
				MOV M[RowIndex], R2
				CALL PrintLinCar
				MOV R1, OFF
				MOV M[RightFlipUp], R1

				CALL PrintRFlip

EndClearFlip:	POP R4
				POP R3
				POP R2
				POP R1
				
				RET


;------------------------------------------------------------------------------
; Função Timer
;------------------------------------------------------------------------------	

Timer:			MOV R1, M[Lifes]
				CMP R1, CharZero
				JMP.Z EndTimer
				MOV R1, M[HasBall]
				CMP R1, ON
				CALL.Z MovBall

				MOV R1, M[AnyFlipUp]
				CMP R1, OFF
				CALL.NZ ClearFlip
				MOV M[AnyFlipUp], R1	

				MOV R1, 6d
				MOV M[CONFIG_TIMER], R1
				MOV R1,ON
				MOV M[ACTIVATE_TIMER], R1

EndTimer:		RTI

;------------------------------------------------------------------------------
; Função Printa Pá esq
;------------------------------------------------------------------------------	

PrintLFlip:		PUSH R1
				PUSH R2
				PUSH R3
				PUSH R4

				MOV R4, 31d;
				MOV R1, 30d;
				MOV M[ColumnIndex], R1;
				MOV R2, 17d;
				MOV M[RowIndex], R2;
				MOV R3, '\'
				CALL PrintLinCar;

				MOV R4, 32d;
				MOV R1, 31d;
				MOV M[ColumnIndex], R1;
				MOV R2, 18d;
				MOV M[RowIndex], R2;
				MOV R3, '\'
				CALL PrintLinCar;

				MOV R4, 33d;
				MOV R1, 32d;
				MOV M[ColumnIndex], R1;
				MOV R2, 19d;
				MOV M[RowIndex], R2;
				MOV R3, '\'
				CALL PrintLinCar;

				MOV R4, 34d;
				MOV R1, 33d;
				MOV M[ColumnIndex], R1;
				MOV R2, 20d;
				MOV M[RowIndex], R2;
				MOV R3, '\'
				CALL PrintLinCar;
				JMP EndPrintLFlip

EndPrintLFlip:	POP R4
				POP R3
				POP R2
				POP R1
				RET 


;------------------------------------------------------------------------------
; Função Printa Pá dir
;------------------------------------------------------------------------------	

PrintRFlip: 	PUSH R1
				PUSH R2
				PUSH R3
				PUSH R4

				MOV R4, 48d;
				MOV R1, 47d;
				MOV M[ColumnIndex], R1;
				MOV R2, 17d;
				MOV	M[RowIndex], R2;
				MOV R3, '/';
				CALL PrintLinCar;

				MOV R4, 47d;
				MOV R1, 46d;
				MOV M[ColumnIndex], R1;
				MOV R2, 18d;
				MOV M[RowIndex], R2;
				MOV R3, '/'
				CALL PrintLinCar;

				MOV R4, 46d;
				MOV R1, 45d;
				MOV M[ColumnIndex], R1;
				MOV R2, 19d;
				MOV M[RowIndex], R2;
				MOV R3, '/'
				CALL PrintLinCar;

				MOV R4, 45d;
				MOV R1, 44d;
				MOV M[ColumnIndex], R1;
				MOV R2, 20d;
				MOV M[RowIndex], R2;
				MOV R3, '/'
				CALL PrintLinCar;

EndPrintRFlip:	POP R4
				POP R3
				POP R2
				POP R1
				RET 

;------------------------------------------------------------------------------
; Função Printa Linha
;------------------------------------------------------------------------------				

PrintLine:		MOV R1, M[ColumnIndex]
				MOV R2, M[RowIndex]
				MOV R3, '-'
				CMP R1, R4;
				JMP.Z EndPrintLine
				SHL R2, ROW_SHIFT;
				OR R1, R2;
				MOV M[CURSOR], R1
				MOV M[WRITE], R3
				INC M[ColumnIndex]
				JMP PrintLine

EndPrintLine:	RET

;------------------------------------------------------------------------------
; Função Printa Col
;------------------------------------------------------------------------------

PrintCol:		MOV R1, M[ColumnIndex]
				MOV R2, M[RowIndex]
				MOV R3, '|'
				CMP R2, R4
				JMP.Z EndPrintCol
				SHL R2, ROW_SHIFT
				OR R1, R2;
				MOV M[CURSOR], R1
				MOV M[WRITE], R3
				INC M[RowIndex]
				JMP PrintCol

EndPrintCol:	RET

;------------------------------------------------------------------------------
; Função Printa Caractér em formato de linha
;------------------------------------------------------------------------------

PrintLinCar:	PUSH R1
				PUSH R2
				PUSH R3
				PUSH R4

PrintLinCarLoop:MOV R1, M[ColumnIndex]
				MOV R2, M[RowIndex]
			
				MOV	M[ TextIndex ], R3
				CMP R1, R4;
				JMP.Z EndPrintLinCar
				SHL R2, ROW_SHIFT;
				OR R1, R2;
				MOV M[CURSOR], R1
				MOV M[WRITE], R3
				INC M[ColumnIndex]
				JMP PrintLinCarLoop

EndPrintLinCar:	POP R4
				POP R3
				POP R2
				POP R1
				RET

;------------------------------------------------------------------------------
; Função Printa pontos e vidas
;------------------------------------------------------------------------------
PrintStr:		PUSH R1
				PUSH R2
				PUSH R3
				PUSH R4

				MOV R4, 60d
				MOV R1, 59d
				MOV M[ColumnIndex], R1
				MOV R2, 4d
				MOV M[RowIndex], R2
				MOV R3, 'P'
				CALL PrintLinCar

				MOV R4, 61d
				MOV R1, 60d
				MOV M[ColumnIndex], R1
				MOV R2, 4d
				MOV M[RowIndex], R2
				MOV R3, 'o'
				CALL PrintLinCar

				MOV R4, 62d
				MOV R1, 61d
				MOV M[ColumnIndex], R1
				MOV R2, 4d
				MOV M[RowIndex], R2
				MOV R3, 'n'
				CALL PrintLinCar

				MOV R4, 63d
				MOV R1, 62d
				MOV M[ColumnIndex], R1
				MOV R2, 4d
				MOV M[RowIndex], R2
				MOV R3, 't'
				CALL PrintLinCar

				MOV R4, 64d
				MOV R1, 63d
				MOV M[ColumnIndex], R1
				MOV R2, 4d
				MOV M[RowIndex], R2
				MOV R3, 'o'
				CALL PrintLinCar

				MOV R4, 65d
				MOV R1, 64d
				MOV M[ColumnIndex], R1
				MOV R2, 4d
				MOV M[RowIndex], R2
				MOV R3, 's'
				CALL PrintLinCar

				MOV R4, 66d
				MOV R1, 65d
				MOV M[ColumnIndex], R1
				MOV R2, 4d
				MOV M[RowIndex], R2
				MOV R3, ':'
				CALL PrintLinCar; fim de pontos

				MOV R4, 60d
				MOV R1, 59d
				MOV M[ColumnIndex], R1
				MOV R2, 6d
				MOV M[RowIndex], R2
				MOV R3, 'V'
				CALL PrintLinCar

				MOV R4, 61d
				MOV R1, 60d
				MOV M[ColumnIndex], R1
				MOV R2, 6d
				MOV M[RowIndex], R2
				MOV R3, 'i'
				CALL PrintLinCar

				MOV R4, 62d
				MOV R1, 61d
				MOV M[ColumnIndex], R1
				MOV R2, 6d
				MOV M[RowIndex], R2
				MOV R3, 'd'
				CALL PrintLinCar

				MOV R4, 63d
				MOV R1, 62d
				MOV M[ColumnIndex], R1
				MOV R2, 6d
				MOV M[RowIndex], R2
				MOV R3, 'a'
				CALL PrintLinCar

				MOV R4, 64d
				MOV R1, 63d
				MOV M[ColumnIndex], R1
				MOV R2, 6d
				MOV M[RowIndex], R2
				MOV R3, 's'
				CALL PrintLinCar

				MOV R4, 65d
				MOV R1, 64d
				MOV M[ColumnIndex], R1
				MOV R2, 6d
				MOV M[RowIndex], R2
				MOV R3, ':'
				CALL PrintLinCar

				POP R4
				POP R3
				POP R2
				POP R1

				RET
;------------------------------------------------------------------------------
; Função Printa a Caixa
;------------------------------------------------------------------------------


PrintBox:		MOV R4, 80d;
				CALL PrintLine;

				MOV R4, 24d;
				MOV R1, 0d;
				MOV M[ColumnIndex], R1;
				CALL PrintCol;

				MOV R4, 24d;
				MOV R1, 79d;
				MOV M[ColumnIndex], R1;
				MOV R2, 0d;
				MOV M[RowIndex], R2;

				CALL PrintCol;

				MOV R4, 80d;
				MOV R1, 0d;
				MOV M[ColumnIndex], R1;
				MOV R2, 23d;
				MOV M[RowIndex], R2;

				CALL PrintLine;
				JMP EndPrintBox;

EndPrintBox:	RET

;------------------------------------------------------------------------------
; Função que para imprimir pontos na tela
;------------------------------------------------------------------------------
PrintPoints:	PUSH R1
				PUSH R2
				PUSH R3
				PUSH R4
				PUSH R5

				MOV R5, M[MilPoints]
				MOV R3, M[CentPoints]
				CMP R3,	58d
				JMP.NZ Skip1
				INC R5
				SUB R3, 10d

Skip1:			MOV R4, 70d
				MOV R1, 69d
				MOV M[ColumnIndex], R1
				MOV R2, 4d
				MOV M[RowIndex], R2
				CALL PrintLinCar; imprime centena
				MOV M[CentPoints], R3

				MOV R3, M[MilPoints]
				CMP R3, R5
				JMP.Z EndPrintPoints
				MOV R3, R5
				CMP R5, 58d
				JMP.NZ	Skip2
				MOV R5, M[MilhPoints]
				INC R5
				SUB R3, 10d

Skip2:			MOV R4, 69d
				MOV R1, 68d
				MOV M[ColumnIndex], R1
				MOV R2, 4d
				MOV M[RowIndex], R2
				CALL PrintLinCar; imprime centena
				MOV M[MilPoints], R3

				MOV R3, M[MilhPoints]
				CMP R3, R5
				JMP.Z EndPrintPoints
				CMP R5, 58d
				JMP.NZ Skip3
				MOV R3,R5
				SUB R3, 1d

Skip3:			MOV R4, 68d
				MOV R1, 67d
				MOV M[ColumnIndex], R1
				MOV R2, 4d
				MOV M[RowIndex], R2
				CALL PrintLinCar; imprime centena
				MOV M[MilhPoints], R3


EndPrintPoints:	POP R5
				POP R4
				POP R3
				POP R2
				POP R1

				RET

;------------------------------------------------------------------------------
; Função que imprime obstáculos
;------------------------------------------------------------------------------

PrintObs:		PUSH R1
				PUSH R2
				PUSH R3
				PUSH R4

				MOV R4, 33d; 					Primeira caixa
				MOV R3, '_'
				MOV R1, 30d
				MOV M[ColumnIndex],R1;
				MOV R2, 4d;
				MOV M[RowIndex],R2;
				CALL PrintLinCar;

				MOV R4, 33d;
				MOV R3, '|'
				MOV R1, 30d
				MOV M[ColumnIndex],R1;
				MOV R2, 5d;
				MOV M[RowIndex],R2;
				CALL PrintLinCar;

				MOV R4, 33d;
				MOV R3, '-'
				MOV R1, 30d
				MOV M[ColumnIndex],R1;
				MOV R2, 6d;
				MOV M[RowIndex],R2;
				CALL PrintLinCar;

				MOV R4, 45d; 					Segunda caixa
				MOV R3, '_'
				MOV R1, 42d
				MOV M[ColumnIndex],R1;
				MOV R2, 5d;
				MOV M[RowIndex],R2;
				CALL PrintLinCar;

				MOV R4, 45d;
				MOV R3, '|'
				MOV R1, 42d
				MOV M[ColumnIndex],R1;
				MOV R2, 6d;
				MOV M[RowIndex],R2;
				CALL PrintLinCar;

				MOV R4, 45d; 					
				MOV R3, '-'
				MOV R1, 42d
				MOV M[ColumnIndex],R1;
				MOV R2, 7d;
				MOV M[RowIndex],R2;
				CALL PrintLinCar;

				MOV R4, 34d; 					Terceira caixa
				MOV R3, '_'
				MOV R1, 31d
				MOV M[ColumnIndex],R1;
				MOV R2, 9d;
				MOV M[RowIndex],R2;
				CALL PrintLinCar;

				MOV R4, 34d;
				MOV R3, '|'
				MOV R1, 31d
				MOV M[ColumnIndex],R1;
				MOV R2, 10d;
				MOV M[RowIndex],R2;
				CALL PrintLinCar;

				MOV R4, 34d; 					Terceira caixa
				MOV R3, '-'
				MOV R1, 31d
				MOV M[ColumnIndex],R1;
				MOV R2, 11d;
				MOV M[RowIndex],R2;
				CALL PrintLinCar;
			
EndPrintObs:	POP R4
				POP R3
				POP R2
				POP R1
				RET

;------------------------------------------------------------------------------
; Função que lança a bola
;------------------------------------------------------------------------------
LaunchBall:		PUSH R1
				PUSH R2
				PUSH R3
				PUSH R4

				MOV R1, M[HasBall]
				CMP R1, ON
				JMP.Z EndLaunchBall
				MOV R1, ON;
				MOV M[HasBall], R1
				
				MOV R4, 47d
				MOV R1, 46d
				MOV M[BallPosCol], R1
				MOV M[ColumnIndex], R1
				MOV R2, 13d
				MOV M[BallPosRow], R2
				MOV M[RowIndex], R2
				MOV R3, 'O'
				CALL PrintLinCar		

EndLaunchBall: 	POP R4
				POP R3
				POP R2
				POP R1
				RTI



;------------------------------------------------------------------------------
; Função para mover a bola
;------------------------------------------------------------------------------

MovBall:		PUSH R1
				PUSH R2
				PUSH R3
				PUSH R4
				PUSH R5
				PUSH R6

				MOV R5, M[BallPosCol]
				MOV R6, M[BallPosRow]
				MOV R4, M[BallDir]
				CMP R4, 0d;				R4 indica a direção que a bola está indo
				JMP.Z UP_RIGHT
				CMP R4, 1d
				JMP.Z DOWN_RIGHT
				CMP R4, 2d
				JMP.Z DOWN_LEFT
				CMP R4, 3d
				JMP.Z UP_LEFT

;Aqui são feitas as atribuições dos novo caminho da bola, dependendo da sua direção;
;R5 guarda a coluna onde está a bola,
;R6 guarda a linha onde está a bola

DOWN_RIGHT: 	INC R5
				INC R6
				JMP PickCharacter

DOWN_LEFT:		DEC R5
				INC R6
				JMP PickCharacter

UP_RIGHT:		INC R5
				DEC R6
				JMP PickCharacter

UP_LEFT:		DEC R5
				DEC R6
				JMP PickCharacter


PickCharacter:	CMP R5, 23d
				JMP.Z WallHit
				CMP R5, 54d
				JMP.Z WallHit

				CMP R6, 0d
				JMP.Z FloorHit
				CMP R6, 23d
				JMP.Z FloorHit

				CMP R6, 4d
				JMP.Z Line4
				CMP R6, 5d
				JMP.Z Line5
				CMP R6, 6d
				JMP.Z Line6
				CMP R6, 7d
				JMP.Z Line7
				CMP R6, 9d
				JMP.Z Line9
				CMP R6, 10d
				JMP.Z Line10
				CMP R6, 11d
				JMP.Z Line11
				CMP R6, 12d
				JMP.Z Line12
				CMP R6, 13d
				JMP.Z Line13
				CMP R6, 14d
				JMP.Z Line14
				CMP R6, 15d
				JMP.Z Line15
				CMP R6, 16d
				JMP.Z Line16
				CMP R6, 17d
				JMP.Z Line17
				CMP R6, 18d
				JMP.Z Line18
				CMP R6, 19d
				JMP.Z Line19
				CMP R6, 20d
				JMP.Z Line20
				CMP R6, 21d
				JMP.Z Line21

				JMP BlankSpace

Line4:			CMP R5, 30d
				JMP.Z CornerPoint
				CMP R5, 31d
				JMP.Z FlatPoint
				CMP R5, 32d
				JMP.Z CornerPoint

				JMP BlankSpace

Line5:			CMP R5, 30d
				JMP.Z WallPoint
				CMP R5, 32d
				JMP.Z WallPoint
				CMP R5, 42d
				JMP.Z CornerPoint
				CMP R5, 43d
				JMP.Z FlatPoint
				CMP R5, 44d
				JMP.Z CornerPoint

				JMP BlankSpace

Line6:			CMP R5, 30d
				JMP.Z CornerPoint
				CMP R5, 31d
				JMP.Z FlatPoint
				CMP R5, 32d
				JMP.Z CornerPoint
				CMP R5, 42d
				JMP.Z WallPoint
				CMP R5, 44d
				JMP.Z WallPoint

				JMP BlankSpace

Line7:			CMP R5, 42d
				JMP.Z CornerPoint
				CMP R5, 43d
				JMP.Z FlatPoint
				CMP R5, 44d
				JMP.Z CornerPoint

				JMP BlankSpace

Line9:			CMP R5, 31d
				JMP.Z CornerPoint
				CMP R5, 32d
				JMP.Z FlatPoint
				CMP R5, 33d
				JMP.Z CornerPoint

				JMP BlankSpace

Line10:			CMP R5, 31d
				JMP.Z WallPoint
				CMP R5, 33d
				JMP.Z WallPoint

				JMP BlankSpace

Line11:			CMP R5, 24d
				JMP.Z ToOne
				CMP R5, 23d
				JMP.Z ToOne
				CMP R5, 53d
				JMP.Z ToTwo
				CMP R5, 54d
				JMP.Z ToTwo

				CMP R5, 31d
				JMP.Z CornerPoint
				CMP R5, 32d
				JMP.Z FlatPoint
				CMP R5, 33d
				JMP.Z CornerPoint

				JMP BlankSpace

Line12:			CMP R5, 25d
				JMP.Z ToOne
				CMP R5, 24d
				JMP.Z ToOne
				CMP R5, 52d
				JMP.Z ToTwo
				CMP R5, 53d
				JMP.Z ToTwo

				JMP BlankSpace

Line13:			CMP R5, 26d
				JMP.Z ToOne
				CMP R5, 25d
				JMP.Z ToOne
				CMP R5, 51d
				JMP.Z ToTwo
				CMP R5, 52d
				JMP.Z ToTwo

				JMP BlankSpace

Line14:			CMP R5, 27d
				JMP.Z ToOne
				CMP R5, 26d
				JMP.Z ToOne
				CMP R5, 50d
				JMP.Z ToTwo
				CMP R5, 51d
				JMP.Z ToTwo

				JMP BlankSpace

Line15:			CMP R5, 28d
				JMP.Z ToOne
				CMP R5, 27d
				JMP.Z ToOne
				CMP R5, 49d
				JMP.Z ToTwo
				CMP R5, 50d
				JMP.Z ToTwo

				JMP BlankSpace				

Line16:			CMP R5, 29d
				JMP.Z ToOne
				CMP R5, 28d
				JMP.Z ToOne
				CMP R5, 48d
				JMP.Z ToTwo
				CMP R5, 49d
				JMP.Z ToTwo

				JMP BlankSpace

Line17:			CMP R5, 30d
				JMP.Z ToOne
				CMP R5, 29d
				JMP.Z ToOne
				CMP R5, 47d
				JMP.Z ToTwo
				CMP R5, 48d
				JMP.Z ToTwo

				JMP BlankSpace

Line18:			CMP R5, 31d
				JMP.Z ToOne
				CMP R5, 30d
				JMP.Z ToOne
				CMP R5, 46d
				JMP.Z ToTwo
				CMP R5, 47d
				JMP.Z ToTwo

				JMP BlankSpace

Line19:			CMP R5, 32d
				JMP.Z ToOne
				CMP R5, 31d
				JMP.Z ToOne
				CMP R5, 45d
				JMP.Z ToTwo
				CMP R5, 46d
				JMP.Z ToTwo

				JMP BlankSpace

Line20:			CMP R5, 33d
				JMP.Z ToOne
				CMP R5, 32d
				JMP.Z ToOne
				CMP R5, 44d
				JMP.Z ToTwo
				CMP R5, 45d
				JMP.Z ToTwo

				JMP BlankSpace

Line21:			CMP R5, 34d
				JMP.Z ToOne
				CMP R5, 33d
				JMP.Z ToOne
				CMP R5, 43d
				JMP.Z ToTwo
				CMP R5, 44d
				JMP.Z ToTwo

				JMP BlankSpace

WallPoint:		MOV R2, M[CentPoints]
				INC R2
				MOV M[CentPoints], R2

				MOV R4, M[BallDir]

				CALL PrintPoints
				JMP WallHit;

FlatPoint:		MOV R2, M[CentPoints]
				INC R2
				MOV M[CentPoints], R2

				CALL PrintPoints

				MOV R4, M[BallDir]

				CMP R4, 0d
				JMP.Z ToOne
				CMP R4, 1d
				JMP.Z ToZero
				CMP R4, 2d
				JMP.Z ToThree
				CMP R4, 3d
				JMP.Z ToTwo


CornerPoint:	MOV R2, M[CentPoints]
				INC R2
				MOV M[CentPoints], R2


				CALL PrintPoints

				MOV R4, M[BallDir]
				CMP R4, 0d
				JMP.Z ToThree
				CMP R4, 1d
				JMP.Z ToZero
				CMP R4, 2d
				JMP.Z ToOne
				CMP R4, 3d
				JMP.Z ToTwo


BaseHit:		CMP R4, 1d
				JMP.Z ToZero
				CMP	R4, 2d
				JMP.Z ToThree


WallHit:		CMP R4, 0d
				JMP.Z ToThree
				CMP R4, 1d
				JMP.Z ToTwo
				CMP R4, 2d
				JMP.Z ToOne
				CMP R4, 3d
				JMP.Z ToZero

FloorHit:		CMP R4, 0d
				JMP.Z ToOne
				CMP R4,	1d
				JMP.Z DeleteBall
				CMP R4, 2d
				JMP.Z DeleteBall
				CMP R4, 3d
				JMP.Z ToTwo

				MOV R4, 56d ;debug ---------------------------------------
				MOV R1, 55d
				MOV M[ColumnIndex], R1;
				MOV R2, 22d;
				MOV M[RowIndex], R2;
				MOV R3, 'x'
				CALL PrintLinCar;


ToZero:			MOV R4, 0d
				MOV M[BallDir], R4
				JMP EndMovBall

ToOne:			MOV R4, 1d
				MOV M[BallDir], R4
				JMP EndMovBall

ToTwo:			MOV R4, 2d
				MOV M[BallDir], R4
				JMP EndMovBall
				
ToThree:		MOV R4, 3d
				MOV M[BallDir], R4
				JMP EndMovBall

BlankSpace:		MOV	R1, M[BallPosCol]
				MOV M[ColumnIndex], R1
				MOV R2, M[BallPosRow]
				MOV M[RowIndex], R2
				MOV R4, R1;
				INC R4;
				MOV R3, ' '
				CALL PrintLinCar

				MOV M[ColumnIndex], R5
				MOV M[RowIndex], R6
				MOV R3, 'O'
				MOV R4, R5
				INC R4
				CALL PrintLinCar

				MOV M[BallPosCol], R5
				MOV M[BallPosRow], R6

				JMP EndMovBall;

DeleteBall:		MOV R1, OFF
				MOV M[HasBall], R1
				MOV	R1, M[BallPosCol]
				MOV M[ColumnIndex], R1
				MOV R2, M[BallPosRow]
				MOV M[RowIndex], R2
				MOV R4, R1;
				INC R4;
				MOV R3, ' '
				CALL PrintLinCar
				
				MOV R1, M[Lifes]
				DEC R1
				MOV M[Lifes], R1 ;PRINTAR AS VIDAS NA TELA------------------------------------------

				MOV R3, R1
				MOV R4, 66d
				MOV R1, 65d
				MOV M[ColumnIndex], R1
				MOV R2, 6d
				MOV M[RowIndex], R2
				CALL PrintLinCar

				MOV R1, M[Lifes]
				CMP R1, 48d
				CALL.Z EndGame



EndMovBall:		POP R6
				POP R5
				POP R4
				POP R3
				POP R2
				POP R1
				
				RET
;------------------------------------------------------------------------------
; Função para terminar o jogo
;------------------------------------------------------------------------------
EndGame:		MOV R4, 60d
				MOV R1, 59d
				MOV M[ColumnIndex], R1
				MOV R2, 10d
				MOV M[RowIndex], R2
				MOV R3, 'G'
				CALL PrintLinCar

				MOV R4, 61d
				MOV R1, 60d
				MOV M[ColumnIndex], R1
				MOV R2, 10d
				MOV M[RowIndex], R2
				MOV R3, 'A'
				CALL PrintLinCar

				MOV R4, 62d
				MOV R1, 61d
				MOV M[ColumnIndex], R1
				MOV R2, 10d
				MOV M[RowIndex], R2
				MOV R3, 'M'
				CALL PrintLinCar

				MOV R4, 63d
				MOV R1, 62d
				MOV M[ColumnIndex], R1
				MOV R2, 10d
				MOV M[RowIndex], R2
				MOV R3, 'E'
				CALL PrintLinCar

				MOV R4, 65d
				MOV R1, 64d
				MOV M[ColumnIndex], R1
				MOV R2, 10d
				MOV M[RowIndex], R2
				MOV R3, 'O'
				CALL PrintLinCar

				MOV R4, 66d
				MOV R1, 65d
				MOV M[ColumnIndex], R1
				MOV R2, 10d
				MOV M[RowIndex], R2
				MOV R3, 'V'
				CALL PrintLinCar

				MOV R4, 67d
				MOV R1, 66d
				MOV M[ColumnIndex], R1
				MOV R2, 10d
				MOV M[RowIndex], R2
				MOV R3, 'E'
				CALL PrintLinCar

				MOV R4, 68d
				MOV R1, 67d
				MOV M[ColumnIndex], R1
				MOV R2, 10d
				MOV M[RowIndex], R2
				MOV R3, 'R'
				CALL PrintLinCar

				RET

;------------------------------------------------------------------------------
; Função que barreiras acima das pas
;------------------------------------------------------------------------------

PrintBarriers:	MOV R4, 30d;
				MOV R1, 29d;
				MOV M[ColumnIndex], R1;
				MOV R2, 16d;
				MOV M[RowIndex], R2;
				MOV R3, '\'
				CALL PrintLinCar;

				MOV R4, 49d;
				MOV R1, 48d;
				MOV M[ColumnIndex], R1;
				MOV M[RowIndex], R2;
				MOV R3, '/'
				CALL PrintLinCar;
				
				MOV R4, 29d;
				MOV R1, 28d;
				MOV M[ColumnIndex], R1;
				MOV R2, 15d;
				MOV M[RowIndex], R2;
				MOV R3, '\'
				CALL PrintLinCar;

				MOV R4, 50d;
				MOV R1, 49d;
				MOV M[ColumnIndex], R1;
				MOV M[RowIndex], R2;
				MOV R3, '/'
				CALL PrintLinCar;

				MOV R4, 28d;
				MOV R1, 27d;
				MOV M[ColumnIndex], R1;
				MOV R2, 14d;
				MOV M[RowIndex], R2;
				MOV R3, '\'
				CALL PrintLinCar;

				MOV R4, 51d;
				MOV R1, 50d;
				MOV M[ColumnIndex], R1;
				MOV M[RowIndex], R2;
				MOV R3, '/'
				CALL PrintLinCar;

				MOV R4, 27d;
				MOV R1, 26d;
				MOV M[ColumnIndex], R1;
				MOV R2, 13d;
				MOV M[RowIndex], R2;
				MOV R3, '\'
				CALL PrintLinCar;

				MOV R4, 52d;
				MOV R1, 51d;
				MOV M[ColumnIndex], R1;
				MOV M[RowIndex], R2;
				MOV R3, '/'
				CALL PrintLinCar;

				MOV R4, 26d;
				MOV R1, 25d;
				MOV M[ColumnIndex], R1;
				MOV R2, 12d;
				MOV M[RowIndex], R2;
				MOV R3, '\'
				CALL PrintLinCar;

				MOV R4, 53d;
				MOV R1, 52d;
				MOV M[ColumnIndex], R1;
				MOV M[RowIndex], R2;
				MOV R3, '/'
				CALL PrintLinCar;

				RET

;------------------------------------------------------------------------------
; Main
;------------------------------------------------------------------------------
Main:			ENI

				MOV		R1, INITIAL_SP
				MOV		SP, R1		 		; We need to initialize the stack
				MOV		R1, CURSOR_INIT		; We need to initialize the cursor 
				MOV		M[ CURSOR ], R1		; with value CURSOR_INIT

				MOV R1,10d					; Inicialização do timer
				MOV M[CONFIG_TIMER], R1
				MOV R1,ON
				MOV M[ACTIVATE_TIMER], R1


				CALL PrintBox

				MOV R4, 24d;
				MOV R1, 23d;
				MOV M[ColumnIndex], R1;
				MOV R2, 0d;
				MOV M[RowIndex], R2;
				CALL PrintCol;
				
				
				MOV R4, 24d;
				MOV R1, 54d;
				MOV M[ColumnIndex], R1;
				MOV R2, 0d;
				MOV M[RowIndex], R2;
				CALL PrintCol;

				MOV R4, 24d;
				MOV R1, 56d;
				MOV M[ColumnIndex], R1;
				MOV R2, 0d;
				MOV M[RowIndex], R2;
				CALL PrintCol;

				MOV R4, 55d
				MOV R1, 54d
				MOV M[ColumnIndex], R1;
				MOV R2, 1d;
				MOV M[RowIndex], R2;
				MOV R3, ' '
				CALL PrintLinCar;


				MOV R4, 30d;
				MOV R1, 24d;
				MOV M[ColumnIndex], R1;
				MOV R2, 17d;
				MOV	M[RowIndex], R2;
				CALL PrintLine;

				MOV R4, 54d;
				MOV R1, 48d;
				MOV M[ColumnIndex], R1;
				CALL PrintLine;

				CALL PrintBarriers
				
				CALL PrintLFlip
				CALL PrintRFlip

				CALL PrintStr

				CALL PrintObs;

				MOV R4, 71d
				MOV R1, 70d
				MOV M[ColumnIndex], R1
				MOV R2, 4d
				MOV M[RowIndex], R2
				MOV R3, '0'
				CALL PrintLinCar; imprime centena
				MOV M[CentPoints], R3

				MOV R4, 70d
				MOV R1, 69d
				MOV M[ColumnIndex], R1
				MOV R2, 4d
				MOV M[RowIndex], R2
				MOV R3, '0'
				CALL PrintLinCar; imprime centena
				MOV M[CentPoints], R3

				MOV R4, 69d
				MOV R1, 68d
				MOV M[ColumnIndex], R1
				MOV R2, 4d
				MOV M[RowIndex], R2
				MOV R3, '0'
				CALL PrintLinCar; imprime centena
				MOV M[CentPoints], R3

				MOV R4, 68d
				MOV R1, 67d
				MOV M[ColumnIndex], R1
				MOV R2, 4d
				MOV M[RowIndex], R2
				MOV R3, '0'
				CALL PrintLinCar; imprime centena
				MOV M[CentPoints], R3

				MOV R4, 67d
				MOV R1, 66d
				MOV M[ColumnIndex], R1
				MOV R2, 4d
				MOV M[RowIndex], R2
				MOV R3, '0'
				CALL PrintLinCar; imprime centena
				MOV M[CentPoints], R3

				MOV R4, 66d
				MOV R1, 65d
				MOV M[ColumnIndex], R1
				MOV R2, 4d
				MOV M[RowIndex], R2
				MOV R3, '0'
				CALL PrintLinCar; imprime centena
				MOV M[CentPoints], R3

				MOV R3, M[Lifes]
				MOV R4, 66d
				MOV R1, 65d
				MOV M[ColumnIndex], R1
				MOV R2, 6d
				MOV M[RowIndex], R2
				CALL PrintLinCar




Cycle: 			BR		Cycle	
Halt:           BR		Halt