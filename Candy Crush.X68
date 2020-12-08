*-----------------------------------------------------------
* Title      : Candy Crash      
* Written by : Rafael Pires Orozco & Irtaza Ali Ajmal
* Date       : 15-05-2017
* Description: All copyrights reserved.
*-----------------------------------------------------------
    ORG    $1000
                           JSR HELLO_PLAYER *mensaje inicial y autores
    
                           JSR CREAR_TABLA  *crea matriz visual
    
                           JSR REFRESCO_PANTALLA *pone los primeros candys
                           
                           
    MOVE.L #RESERVA,PUNTERO_RESERVA
    MOVE.L #TABLERO, PUNTERO
    
******************************************************* 
   
ELEGIR 

                           JSR REFRESCO_PUNTERO *poner puntero en pos inicial   

                           JSR MOVER_PUNTERO    *permite mover puntero                   
        
                           JSR MOVER_CANDY
                           
                           MOVE.L #20,D5   *retardo temporal
                           JSR WASTE_TIME
                           
COMPROBADOR_DE_ESTADO      
     
     MOVE.L ESTADO_SELECCION,D4
     CMP.L #1,D4
     BEQ SIGUIENTE_1
     JMP ELEGIR
    
SIGUIENTE_1                          
    
                        JSR BORRAR
    
                        JSR RECTIFICAR
                           
                           
COMPROBADOR_DE_BORRADO   * pregunta si se ha borrado en caso afirmativo caer
     MOVE.L NUM_JUGADAS,D4      
     SUB.L #1,D4
     MOVE.L D4,NUM_JUGADAS
     
     MOVE.L N_CANCEL, D4
     CMP.L #1,D4
     BGE SIGUIENTE_2
     
    
     JMP ELEGIR
                           
SIGUIENTE_2
    MOVE.L #0,N_CANCEL    
    
                            JSR CAIDA
                            
    MOVE.L NUM_JUGADAS,D4   *comprueba si no se te han terminado las jugadas
    CMP.L #0,D4
    BEQ END_GAME
    MOVE.L #0,ESTADO_SELECCION
    
    JMP ELEGIR
    
END_GAME    
    
    JSR BYE_PLAYER
    
    JMP THE_END *FINAL DEL PROGRAMA
    
    SIMHALT
                       
    
**********************************************************
*FUNCIONES PRINCIPALES
**********************************************************
MOVER_PUNTERO      *D6 SERÁ NUESTRO PUNTERO PARA PODER ESCOGER EL CANDY*
                    
      
      
LOOP_1                       *LEER TECLADO ACCIÓN DEL TECLADO*                            
      MOVE.L  PUNTERO, D6                           
      MOVE.L  #19,D0            
      CLR.L D1 
      MOVE.L #$25262728,D1                 
      TRAP  #15
           
      CMP.L #$00FF0000,D1 
      BEQ MOVE_UP              *FLECHA ARRIBA
      CMP.L #$0000FF00,D1 
      BEQ MOVE_RIGHT           *FLECHA DERECHA
      CMP.L #$000000FF,D1 
      BEQ MOVE_DOWN            *FLECHA ABAJO
      CMP.L #$FF000000,D1 
      BEQ MOVE_LEFT            *FLECHA IZQUIERDA
      
      MOVE.L  PUNTERO, D6                           
      MOVE.L  #19,D0             
      MOVE.L #$0000000D,D1     *seleccionar               
      TRAP  #15
      MOVE.L D1, KEYBOARD_INPUT
            
      CMP.L #$000000FF,D1
      BEQ CHOOSE
      
*     CMP.L #$001B001B,D1
*     BEQ EXIT
      
      CLR.L D1
      CLR.L D2
      MOVE.L #0,KEYBOARD_INPUT
          
      JMP LOOP_1
EXIT
      MOVE.B #1,FINISH_GAME
      RTS
      
      
FIN_MOV_1

     MOVE.L #13,D5
*    JSR WASTE_TIME
     JSR TIEMPO_TECLADO  
     JMP LOOP_1

FIN_MOV_2

      RTS       

MOVE_UP
     MOVE.L #0,ESTADO_SELECCION
     
     SUB.L #$10,D6
     JSR ALLOWED_AD
     CLR.L D5
     MOVE.B ALLOWED, D5
     CMP.B #1, D5
     BNE LOOP_1
     MOVE.L D6, PUNTERO
     
     JSR BORRAR_PUNTERO
     JSR REFRESCO_PUNTERO
     
     
 
     CLR.L D1
     JMP FIN_MOV_1
MOVE_RIGHT
     MOVE.L #0,ESTADO_SELECCION
     
     ADD.L #$1,D6
     JSR ALLOWED_AD
     MOVE.B ALLOWED, D5
     CMP.B #1, D5
     BNE LOOP_1 
     MOVE.L D6, PUNTERO
     
     JSR BORRAR_PUNTERO
     JSR REFRESCO_PUNTERO
     
     
     
     CLR.L D1
     JMP FIN_MOV_1
     
MOVE_DOWN
     MOVE.L #0,ESTADO_SELECCION
     
     ADD.L #$10,D6
     JSR ALLOWED_AD
     MOVE.B ALLOWED, D5
     CMP.B #1, D5
     BNE LOOP_1 
     MOVE.L D6, PUNTERO
     
     JSR BORRAR_PUNTERO
     JSR REFRESCO_PUNTERO
     
   
     
     CLR.L D1
     JMP FIN_MOV_1
     
MOVE_LEFT
     MOVE.L #0,ESTADO_SELECCION
     
     SUB.L #$1,D6
     JSR ALLOWED_AD
     MOVE.B ALLOWED, D5
     CMP.B #1, D5
     BNE LOOP_1 
     MOVE.L D6, PUNTERO
     
     JSR BORRAR_PUNTERO
     JSR REFRESCO_PUNTERO
     
     
     
     CLR.L D1
     JMP FIN_MOV_1
     
CHOOSE 
     MOVE.L #1, ESTADO_SELECCION
     MOVE.L D6, PUNTERO
     CLR.L D1
     JSR BORRAR_PUNTERO
     JSR REFRESCO_PUNTERO    
     JMP FIN_MOV_2
     
NO_CHOOSE
     MOVE.L #0, ESTADO_SELECCION
     JSR BORRAR_PUNTERO
     JSR REFRESCO_PUNTERO
     CLR.L D1
     JMP FIN_MOV_2
     
***********************************************************************

MOVER_CANDY  *EFECTUA EL MOVIMIENTO EN MEMORIA    

      

LOOP_2                                
                                       
      MOVE.L  #19,D0            
      CLR.L D1                  
      TRAP  #15                 
      MOVE.L D1,KEYBOARD_INPUT          
                                
      CMP.L #0,D1               
      BNE MOVIMIENTO        
                                
      JMP LOOP_2

MOVIMIENTO   
      CLR.L D4
      CLR.L D5
      
      CMP.L #$00260026,D1 
      BEQ MOVIMIENTO_ARRIBA      *FLECHA ARRIBA
      CMP.L #$00270027,D1 
      BEQ MOVIMIENTO_DERECHA     *FLECHA DERECHA
      CMP.L #$00280028,D1 
      BEQ MOVIMIENTO_ABAJO       *FLECHA ABAJO
      CMP.L #$00250025,D1 
      BEQ MOVIMIENTO_IZQUIERDA   *FLECHA IZQUIERDA 
      CMP.L #$001B001B,D1 
      BEQ NO_CHOOSE         *TECLA ESC

      JMP LOOP_2

MOVIMIENTO_ARRIBA 
    
    MOVE.L PUNTERO,D4           *PTO INICIAL DEL MOVIMIENTO
    MOVE.L D4,D5
    SUB.L  #$10,D5              *PTO FINAL DEL MOVIMIENTO
    MOVE.L D4,DIR_INICIAL
    MOVE.L D5,DIR_FINAL
    JMP MOVIMIENTO_MEMORIA
   
    SIMHALT
    
MOVIMIENTO_DERECHA 
    MOVE.L PUNTERO,D4           *PTO INICIAL DEL MOVIMIENTO
    MOVE.L D4,D5
    ADD.L  #$1,D5               *PTO FINAL DEL MOVIMIENTO
    MOVE.L D4,DIR_INICIAL
    MOVE.L D5,DIR_FINAL                                                      
    JMP MOVIMIENTO_MEMORIA
    
    SIMHALT
    
MOVIMIENTO_ABAJO 
    MOVE.L PUNTERO,D4           *PTO INICIAL DEL MOVIMIENTO
    MOVE.L D4,D5
    ADD.L  #$10,D5              *PTO FINAL DEL MOVIMIENTO
    MOVE.L D4,DIR_INICIAL
    MOVE.L D5,DIR_FINAL
    JMP MOVIMIENTO_MEMORIA
    
    SIMHALT
    
MOVIMIENTO_IZQUIERDA  
    MOVE.L PUNTERO,D4          *PTO INICIAL DEL MOVIMIENTO
    MOVE.L D4,D5
    SUB.L  #$1,D5              *PTO FINAL DEL MOVIMIENTO
    MOVE.L D4,DIR_INICIAL
    MOVE.L D5,DIR_FINAL
    JMP MOVIMIENTO_MEMORIA
    
        
MOVIMIENTO_MEMORIA    
    CLR.L D4
    CLR.L D5
        
    MOVE.L DIR_INICIAL,A4
    MOVE.L DIR_FINAL,A5
    
    MOVE.B (A4),D4
    MOVE.B (A5),D5
    
    MOVE.B D4,(A5)
    MOVE.B D5,(A4)
    
    JSR BORRAR_PUNTERO    
    
    JSR REFRESCO_PANTALLA 
    
    MOVE.L #5,D5
    JSR WASTE_TIME
    
    RTS
    
**************************************************************************************     
BORRAR **********************ENCARGADO DE DAR VALOR CERO A LOS CANDY QUE SE CANCELEN *

    
    
BORRADO_HORIZONTAL
    MOVE.L #TABLERO,MARCA_HORIZONTAL
    MOVE.L #0, A1
    CLR.L D0
    CLR.L D1
    CLR.L D6
    CLR.L D7 
    
LOOP_3
    CLR.L D2
    CLR.L D3
       
    MOVE.L MARCA_HORIZONTAL,A2
    
    MOVE.L A2,A3
LOOP_4
    CLR.L D4    
    ADD.L #1,A3
    MOVE.B (A2),D2
    MOVE.B (A3),D3
    CMP D2,D3
    BEQ SUMA_HORIZONTAL
    BNE PREGUNTA_HORIZONTAL        
    
SUMA_HORIZONTAL

    MOVE.L SUM_HORIZONTAL,D4
    ADD.L #1,D4
    MOVE.L D4,SUM_HORIZONTAL
    JMP LOOP_4
    
PREGUNTA_HORIZONTAL *ES SUFICIENTE SUM_HORIZONTAL COMO PARA QUE SE BORRE?
    MOVE.L SUM_HORIZONTAL,D4
    CMP #2,D4
    BGE CANCEL_HORIZONTAL
    
NEXT_1  
    MOVE.L #0,SUM_HORIZONTAL
    CLR.L D4
    CLR.L D5
    JMP FIN_LINEA
NEXT_2    
    MOVE.L A3,MARCA_HORIZONTAL
    JMP LOOP_3
    
FIN_LINEA          *EL PROGRAMA SE PREGUNTA SI SE HA LLEGADO AL FINAL DE UNA FILA
    
    
    CMPA.L #$3008,A3 *FINAL 1A FILA
    BEQ SALTO_H1
    CMPA.L #$3018,A3 *FINAL 2A FILA
    BEQ SALTO_H2
    CMPA.L #$3028,A3 *FINAL 3A FILA
    BEQ SALTO_H3
    CMPA.L #$3038,A3 *FINAL 4A FILA
    BEQ SALTO_H4
    CMPA.L #$3048,A3   *FINAL ULTIMA FILA
    BEQ BORRADO_VERTICAL
    
NEXT_3    
    JMP NEXT_2          
    SIMHALT
    
SALTO_H1
   MOVE.L #$3010,A3
   JMP NEXT_3

SALTO_H2
   MOVE.L #$3020,A3
   JMP NEXT_3
    
SALTO_H3
   MOVE.L #$3030,A3
   JMP NEXT_3

SALTO_H4
   MOVE.L #$3040,A3
   JMP NEXT_3



CANCEL_HORIZONTAL
    MOVE.L N_CANCEL,D4
    ADD.L #1,D4
    MOVE.L D4,N_CANCEL
    CLR.L D4
    CLR.L D5
    MOVE.L #0,A4
    MOVE.L SUM_HORIZONTAL,D4
    MOVE.L N_PUNTOS,D5
    ADD.L D4,D5
    ADD.L #1,D5
    MOVE.L D5, N_PUNTOS
    MOVE.L MARCA_HORIZONTAL,A4
    
    
    
LOOP_5    
    MOVE.B #0,(A4)
    ADD.L #1,A4
    
    
    CMP.L #0,D4
    BEQ NEXT_1
    
    SUB.L #1,D4
    JMP LOOP_5
     
    
************************************************************

BORRADO_VERTICAL
    MOVE.L #TABLERO,MARCA_VERTICAL 
    
LOOP_6
    CLR.L D2
    CLR.L D3
       
    MOVE.L MARCA_VERTICAL,A2
    
    MOVE.L A2,A3
LOOP_7
    CLR.L D4    
    ADD.L #$10,A3
    MOVE.B (A2),D2
    MOVE.B (A3),D3
    CMP D2,D3
    BEQ SUMA_VERTICAL
    BNE PREGUNTA_VERTICAL
      
SUMA_VERTICAL

    MOVE.L SUM_VERTICAL,D4
    ADD.L #1,D4
    MOVE.L D4,SUM_VERTICAL
    JMP LOOP_7
    
PREGUNTA_VERTICAL   *ES SUFICIENTE SUM_HORIZONTAL COMO PARA QUE SE BORRE?
    MOVE.L SUM_VERTICAL,D4
    CMP #2,D4
    BGE CANCEL_VERTICAL
NEXT_4    
    MOVE.L #0,SUM_VERTICAL
    CLR.L D4
    CLR.L D5
    JMP FIN_COLUMNA
NEXT_5   
    MOVE.L A3,MARCA_VERTICAL
    JMP LOOP_6
    
FIN_COLUMNA          *EL PROGRAMA SE PREGUNTA SI SE HA LLEGADO AL FINAL DE UNA COLUMNA
    
    
    CMPA.L #$3050,A3 *FINAL 1A COLUMNA
    BEQ SALTO_V1
    CMPA.L #$3051,A3 *FINAL 2A COLUMNA
    BEQ SALTO_V2
    CMPA.L #$3052,A3 *FINAL 3A COLUMNA
    BEQ SALTO_V3
    CMPA.L #$3053,A3 *FINAL 4A COLUMNA
    BEQ SALTO_V4
    CMPA.L #$3054,A3 *FINAL 5A COLUMNA
    BEQ SALTO_V5
    CMPA.L #$3055,A3 *FINAL 6A COLUMNA
    BEQ SALTO_V6
    CMPA.L #$3056,A3 *FINAL 7A COLUMNA
    BEQ SALTO_V7
    CMPA.L #$3057,A3 *FINAL ULTIMA COLUMNA
    BEQ FIN_BORRADO    

NEXT_6    
    JMP NEXT_5          
    SIMHALT
    
SALTO_V1
   MOVE.L #$3001,A3
   JMP NEXT_6

SALTO_V2
   MOVE.L #$3002,A3
   JMP NEXT_6
    
SALTO_V3
   MOVE.L #$3003,A3
   JMP NEXT_6

SALTO_V4
   MOVE.L #$3004,A3
   JMP NEXT_6
   
SALTO_V5
   MOVE.L #$3005,A3
   JMP NEXT_6
   
SALTO_V6
   MOVE.L #$3006,A3
   JMP NEXT_6   
   
SALTO_V7
   MOVE.L #$3007,A3
   JMP NEXT_6

CANCEL_VERTICAL
    MOVE.L N_CANCEL,D4
    ADD.L #1,D4
    MOVE.L D4,N_CANCEL
    
    CLR.L D4
    CLR.L D5
    
    MOVE.L #0,A4
    MOVE.L SUM_VERTICAL,D4
    MOVE.L MARCA_VERTICAL,A4
    MOVE.L N_PUNTOS,D5
    ADD.L D4,D5
    ADD.L #1,D5
    MOVE.L D5, N_PUNTOS

    
LOOP_8   
    MOVE.B #0,(A4)
    ADD.L #$10,A4
    
    CMP.L #0,D4
    BEQ NEXT_4
    
    SUB.L #1,D4
    JMP LOOP_8


FIN_BORRADO
    JSR REFRESCO_PANTALLA
    RTS
************************************************************
RECTIFICAR   
*   PARA RECTIFICAR UNA JUGADA SE LLAMA OTRA VEZ A LA FUNCION
*   MOVIMIENTO DE MEMORIA
    MOVE.L #10,D5 
    JSR WASTE_TIME
  
    MOVE.L N_CANCEL, D3
    CMP.L #0,D3
    BNE FIN_RECTIFICADO
    
    JSR MOVIMIENTO_MEMORIA
    JSR REFRESCO_PANTALLA
    

FIN_RECTIFICADO
    RTS
*********************************************************
*************************************************************     
CAIDA   *RELLENA LOS ESPACIOS QUE HAN QUEDADO EN BLANCO TRAS UNA CANCELACION*
      
    
    
    CLR.L D4
    CLR.L D2
    CLR.L D3
    MOVE.L #0,A2
   
INITIAL
    MOVE.L #TABLERO,A2
    JSR LINEA_UNOS
       
NEXT_7    
    MOVE.B (A2),D2
    CMP.B #0,D2
    BEQ POSICION
        
NEXT_8
    JMP END_LINEA
         
END_LINEA

    CMP.L #$3008,A2
    BEQ JUMP_1
    CMP.L #$3018,A2
    BEQ JUMP_2
    CMP.L #$3028,A2
    BEQ JUMP_3
    CMP.L #$3038,A2
    BEQ JUMP_4
    CMP.L #$3048,A2     
    BEQ NUM_ZEROS
    ADD.L #1,A2
    JMP NEXT_7
    
NUM_ZEROS

    MOVE.L N_ZEROS, D5
    CMP.L #0, D5  
    BEQ END_CAIDA
    MOVE.L #0, N_ZEROS 
    JMP INITIAL
    
    
POSICION  

    MOVE.L N_ZEROS,D6
    ADD.L #1,D6
    MOVE.L D6,N_ZEROS
    CLR.L D6
    
    MOVE.L A2,A3   
    SUB.L #$10,A3
    MOVE.B (A3),D3
    CMP.B #$FF,D3
    BEQ LLAMAR_RESERVA 
    
   
NEXT_9
    CMP.B #0,D3
    BNE CAE_CANDY
    
    
LLAMAR_RESERVA
    
    MOVE.L PUNTERO_RESERVA, A4
    MOVE.B (A4),(A3)
    ADD.L #1,A4
    MOVE.L A4, PUNTERO_RESERVA
    JMP NEXT_9
    
           
CAE_CANDY 
    MOVE.L A2,DIR_INICIAL  
    MOVE.L A3,DIR_FINAL

    JSR MOVIMIENTO_MEMORIA
    JSR REFRESCO_PANTALLA
    
    MOVE.L #3,D5
    JSR WASTE_TIME
    JMP NEXT_8 
    
    
    

    
JUMP_1
    MOVE.L #$3010,A2
    JMP NEXT_7
    
JUMP_2
    MOVE.L #$3020,A2
    JMP NEXT_7
    
JUMP_3
    MOVE.L #$3030,A2
    JMP NEXT_7
    
JUMP_4
    MOVE.L #$3040,A2
    JMP NEXT_7
    
END_CAIDA         *se llama otra vez a borrado para comprobar si se ha producido reacciones en cadena   

    MOVE.L #0,N_ZEROS
    
    JSR BORRAR
    
    MOVE.L N_CANCEL,D4
    CMP.L #0,D4
    BEQ SALTO
    JSR REFRESCO_PANTALLA
    
    MOVE.L #7,D5
    JSR WASTE_TIME
    
    MOVE.L #0,N_CANCEL
    JMP INITIAL
                      
SALTO
    JSR REFRESCO_PANTALLA    
    RTS 


LINEA_UNOS
    MOVE.L #TABLERO,D5
    SUB.L #$10,D5
    MOVE.L D5,A5
    MOVE.L #$FFFFFFFF,(A5)
    ADD.L #$4,D5  
    MOVE.L D5,A5
    MOVE.L #$FFFFFFFF,(A5)
    CLR.L D5
    MOVE.L #0,A5
    RTS
        
  
    


**********************************************************
**********************************************************
*FUNCIONES SECUNDARIAS
**********************
**********************
WASTE_TIME 
            
      MOVE.L #$FFFFFFFF,D7 

PER_TIEMPO      
      NOP
      DBF D7, PER_TIEMPO
      
      DBF D5,WASTE_TIME
      
      RTS
**********************
ALLOWED_AD *PARA QUE EL PUNTERO NO SE SALGA DEL TABLERO

    MOVE.L D6, ADDR
    
STEP1   
    MOVE.L ADDR,D5
    MULU #16,D5
    CLR.W D5
    SWAP D5
    CMP.L #2,D5
    BNE STEP2
    
    MOVE.B #0,ALLOWED
    RTS
    
STEP2    
    MOVE.L ADDR,D5
    MULU #16,D5
    
    CMP.B #$80,D5
    BNE STEP3
    
    MOVE.B #0,ALLOWED
    RTS 
STEP3
    CMP.B #$F0,D5     
    BNE STEP4
    
    MOVE.B #0,ALLOWED
    RTS
    
STEP4   
    MOVE.L ADDR,D5
    MULU #16,D5
    CLR.B D5
    SWAP D5
    CLR.W D5
    SWAP D5
    DIVU #16,D5
    DIVU #16,D5
    CMP.L #5,D5
    BNE FIN_ALLOWED
    
    MOVE.B #0,ALLOWED
    RTS
    
FIN_ALLOWED    
     
    MOVE.B #1,ALLOWED
    RTS
******************************    
TIEMPO_TECLADO *solo lee una vez y no vuelve 
               *a leer hasta que no sueltes la tecla
               
    MOVE.L  PUNTERO, D6                           
    MOVE.L  #19,D0            
    CLR.L D1 
    MOVE.L #$25262728,D1                 
    TRAP  #15
    
    CMP.L #$00000000,D1        
    BEQ FIN_TECLADO
    JMP TIEMPO_TECLADO
    
    
FIN_TECLADO
 
    RTS
*******************************   
       
**********************************************************    
**********************************************************
*FUNCIONES GRAFICAS
*******************
REFRESCO_PANTALLA *DIBUJA CANDYS
    
    MOVE.L #0,A1
    CLR.L D1
    CLR.L D2
    CLR.L D3
    CLR.L D4
    CLR.L D7
    MOVE.L #TABLERO,A3
    
    MOVE.L #39,D7
NEXT_10    
    JSR POSITION *detecta posicion   
    JSR DIBUJAR_CANDY *lee de memoria y escoge el color
    JSR S_LINEA * comprueba que se ha llegado al final de una linea
    DBF D7,NEXT_10 
    RTS
POSITION
    MOVE.L A3,D1
    MULU #16,D1
    SWAP D1
    CLR.W D1
    SWAP D1
    MULU #16,D1
    MULU #16,D1
    SWAP D1
    MOVE.W D1,D2
    CLR.W D1
    SWAP D1
    
    DIVU #16,D1
    DIVU #16,D1
    DIVU #16,D1
    
    MOVE.L D1,D3
    MOVE.L D2,D4
    
    MULU #50,D1 *X_1
    MULU #50,D2 *Y_1
    MULU #50,D3 *X_2
    MULU #50,D4 *Y_2
    
    ADD.L #60,D1  
    ADD.L #60,D2
    ADD.L #90,D3  
    ADD.L #90,D4
    
    MOVE.L D1,S_HORIZONTAL_1
    MOVE.L D2,S_VERTICAL_1 
    MOVE.L D3,S_HORIZONTAL_2
    MOVE.L D4,S_VERTICAL_2
 
    CLR.L D1
    CLR.L D2
    CLR.L D3
    CLR.L D4
      
    RTS
        
DIBUJAR_CANDY   
    MOVE.B (A3),D3
    CMP.L #01,D3
    BEQ DIBUJAR_AMARILLO
    CMP.L #02,D3
    BEQ DIBUJAR_AZUL
    CMP.L #03,D3
    BEQ DIBUJAR_MORADO
    CMP.L #04,D3
    BEQ DIBUJAR_ROJO
    CMP.L #05,D3
    BEQ DIBUJAR_VERDE
    CMP.L #00,D3
    BEQ DIBUJAR_NEGRO
    RTS
    
DIBUJAR_AMARILLO
    MOVE.L COLOR_AMARILLO,D1
    JMP DIBUJAR
DIBUJAR_AZUL
    MOVE.L COLOR_AZUL,D1
    JMP DIBUJAR
DIBUJAR_MORADO
    MOVE.L COLOR_MORADO,D1
    JMP DIBUJAR
DIBUJAR_ROJO
    MOVE.L COLOR_ROJO,D1
    JMP DIBUJAR
DIBUJAR_VERDE
    MOVE.L COLOR_VERDE,D1
    JMP DIBUJAR
DIBUJAR_NEGRO
    MOVE.L COLOR_NEGRO,D1
    JMP DIBUJAR
   
DIBUJAR

    MOVE.L #80,D0
    TRAP #15
    MOVE.L #81,D0
    TRAP #15
    MOVE.L	S_HORIZONTAL_1,D1		
	MOVE.L	S_VERTICAL_1,D2		
	MOVE.L	S_HORIZONTAL_2,D3		
	MOVE.L	S_VERTICAL_2,D4	
	MOVE.B	#87,D0	
	TRAP	#15
	RTS

S_LINEA
    CMP.L #$3007,A3
    BEQ SALTO1
    CMP.L #$3017,A3
    BEQ SALTO2
    CMP.L #$3027,A3
    BEQ SALTO3
    CMP.L #$3037,A3
    BEQ SALTO4
    CMP.L #$3047,A3
    BEQ SALTO5
    
    ADD.L #1,A3
    RTS
    
SALTO1
    MOVE.L #$3010,A3
    RTS
SALTO2
    MOVE.L #$3020,A3
    RTS
SALTO3
    MOVE.L #$3030,A3
    RTS
SALTO4
    MOVE.L #$3040,A3
    RTS
SALTO5
    MOVE.L #$3050,A3
    RTS
        
    SIMHALT
*******************
REFRESCO_PUNTERO
      
      MOVE.L #$FFFFFFFF,D7
      
 
    
    MOVE.L #0,A1
    CLR.L D0
    CLR.L D1
    CLR.L D2
    CLR.L D3
    CLR.L D4
    CLR.L D7
    MOVE.L #TABLERO,A3
NEXT_11    
    JSR POS   
    JSR SELEC 
    RTS
    
POS
    MOVE.L PUNTERO,D1
    MULU #16,D1
    SWAP D1
    CLR.W D1
    SWAP D1
    MULU #16,D1
    MULU #16,D1
    SWAP D1
    MOVE.W D1,D2
    CLR.W D1
    SWAP D1
    
    DIVU #16,D1
    DIVU #16,D1
    DIVU #16,D1
    

    
    MULU #50,D1 *X_1
    MULU #50,D2 *Y_1

    
    ADD.L #51,D1  
    ADD.L #51,D2

    
    MOVE.L D1,S_HORIZONTAL_1
    MOVE.L D2,S_VERTICAL_1 

 
    CLR.L D1
    CLR.L D2
    CLR.L D3
    CLR.L D4
      
    RTS

SELEC   
    MOVE.L ESTADO_SELECCION,D3
    CMP.L #01,D3
    BEQ DIBUJAR_SPUNTERO
    JMP DIBUJAR_PUNTERO 
   
DIBUJAR_SPUNTERO *puntero cuando está seleccionado
    MOVE.L #COLOR_SPUNTERO,A5
    JMP DRAW_PUNTERO 
DIBUJAR_PUNTERO *puntero cuando se va a escoger candy
    MOVE.L #COLOR_PUNTERO,A5
    JMP DRAW_PUNTERO 
BORRAR_PUNTERO *borrado de puntero
    MOVE.L #COLOR_BP,A5    
    JMP DRAW_PUNTERO 

	
DRAW_PUNTERO   *con la posicion calculada dibuja varios cuadrados con 4 líneas
    CLR.L D5
    MOVE.L #2,D6
    
DIB_LOOP                 

    MOVE.L #80,D0
    MOVE.L (A5)+,D1
    TRAP #15
    
    MOVE.L  S_HORIZONTAL_1,D1
	ADD.L   D5,D1	
	MOVE.L  S_VERTICAL_1,D2
    ADD.L   D5,D2
    
    MOVE.L #86,D0
    TRAP #15
    
    MOVE.L  S_HORIZONTAL_1,D1
    ADD.L   #48,D1
	SUB.L   D5,D1	
	MOVE.L  S_VERTICAL_1,D2
    ADD.L   D5,D2
    
    MOVE.L #85,D0
    TRAP #15
    
    MOVE.L  S_HORIZONTAL_1,D1
    ADD.L   #48,D1
	SUB.L   D5,D1	
	MOVE.L  S_VERTICAL_1,D2
	ADD.L   #48,D2
    SUB.L   D5,D2
    
    MOVE.L #85,D0
    TRAP #15
    
    MOVE.L  S_HORIZONTAL_1,D1
	ADD.L   D5,D1	
	MOVE.L  S_VERTICAL_1,D2
	ADD.L   #48,D2
    SUB.L   D5,D2
    
    MOVE.L #85,D0
    TRAP #15
    		
    MOVE.L  S_HORIZONTAL_1,D1
	ADD.L   D5,D1	
	MOVE.L  S_VERTICAL_1,D2
    ADD.L   D5,D2
    
    MOVE.L #85,D0
    TRAP #15		

	
	ADD.L #1,D5
    DBF D6, DIB_LOOP 
	
    RTS

*******************
CREAR_TABLA

    MOVE.L #16,D7
    MOVE.L #TABLA,A1

RETAR 
    
    MOVE.L #80,D0
    MOVE.L #$FFFFFF,D1
    TRAP #15
    MOVE.L (A1)+,D1
    MOVE.L (A1)+,D2
    MOVE.L (A1)+,D3
    MOVE.L (A1)+,D4
    MOVE.L #84,D0
    TRAP #15
    DBF D7,RETAR
    
    RTS
*********************    
HELLO_PLAYER                                        
    MOVE.L #LINEA_VACIA,A1
    MOVE.L #13,D0
    TRAP #15
    
    MOVE.L #MENSAJE_INICIAL, A1
    MOVE.L #13,D0
    TRAP #15
    
    MOVE.L #20,D7
    
LOOP_0   *salto de lineas para luego poner autores
    MOVE.L #LINEA_VACIA,A1
    MOVE.L #13,D0
    TRAP #15
    DBF D7,LOOP_0
    
    MOVE.L #AUTORES, A1
    MOVE.L #13,D0
    TRAP #15
    
    RTS
*************************

BYE_PLAYER
    
    MOVE.L #80, D0     *color de letra
    CLR.L D1
    MOVE.L #$FFFFFFFF,D1
    TRAP #15

    MOVE.L #81, D0     * color de fondo
    CLR.L D1
    MOVE.L #$00000000,D1
    TRAP #15
    
    MOVE.L #LINEA_VACIA,A1
    MOVE.L #13,D0
    TRAP #15

    MOVE.L #MENSAJE_FINAL1, A1 *fin juego, presiona flecha
    MOVE.L #13,D0
    TRAP #15
    
    CLR.L D1

LOOP_FINAL_1 *ESPERA ENTRADA DE TECLADO PARA DAR LA PUNTUACION DEL JUGADOR    
                              
     MOVE.L  #19,D0            
     CLR.L D1 
     MOVE.L #$25262728,D1                 
     TRAP  #15
     
    CMP.L #0, D1

    BEQ LOOP_FINAL_1
    
    CLR.L D1       *CLEAR THE BOARD 
    MOVE.W #$FF00,D1
    MOVE.L #11,D0
    TRAP #15
    
    MOVE.L #LINEA_VACIA,A1
    MOVE.L #13,D0
    TRAP #15
    
    MOVE.L #MENSAJE_FINAL2, A1
    MOVE.L #13,D0
    TRAP #15
    
    CLR.L D5
    CLR.L D6
    CLR.L D7
    
    
    MOVE.L #15,D6
LOOP_FINAL_2  *pone ptos mientras que calcula el resultado
    
    MOVE.L #LINEA_PUNTOS, A1
    MOVE.L #13,D0
    TRAP #15
    
    MOVE.L #30,D5
    JSR WASTE_TIME
    CLR.L D5
    
    
    DBF D6,LOOP_FINAL_2 * fin loop ptos
       
    MOVE.L #MENSAJE_FINAL3,A1 
    MOVE.L #14,D0
    TRAP #15
    
    MOVE.L N_PUNTOS,D1
    MOVE.L #3,D0
    TRAP #15
    
    MOVE.L #LINEA_VACIA,A1
    MOVE.L #13,D0
    TRAP #15
    
    MOVE.L #MENSAJE_FINAL4,A1 
    MOVE.L #13,D0
    TRAP #15
    
    
    
    
    RTS    




    
*********************************************
*CTES
       ORG $2000
     
RESERVA
* COLUMNAS   1  2  3  4  5  6  7  8 
       DC.B 03,04,03,02,01,01,05,05 * 1 FILAS
       DC.B 04,03,04,01,02,05,04,02 * 2
       DC.B 05,03,02,04,03,05,04,01 * 3
       DC.B 04,03,01,05,03,03,03,01 * 4
       DC.B 02,01,02,05,02,02,04,01 * 5
       DC.B 05,03,03,01,03,04,03,02 * 6
       DC.B 05,03,04,04,05,05,04,01 * 7
       DC.B 01,01,03,02,01,01,05,05 * 8
       DC.B 04,03,01,05,03,03,04,01 * 9
       DC.B 02,01,02,05,02,02,04,01 * 10
       DC.B 05,03,03,01,03,04,03,02 * 11
       DC.B 05,03,02,04,05,05,04,01 * 12
       DC.B 01,01,03,02,01,01,05,05 * 13
       DC.B 04,03,01,05,03,03,04,01 * 14
       DC.B 02,01,02,05,02,02,04,01 * 15
       

       ORG $3000
     
TABLERO
 *COLUMNAS    0  1  2  3  4  5  6  7   FILAS
       DC.B 05,03,03,01,03,04,04,02   * 0
       ORG $3010
       DC.B 05,03,02,04,05,05,04,03   * 1
       ORG $3020
       DC.B 01,01,03,02,01,01,05,05   * 2
       ORG $3030
       DC.B 04,03,01,05,03,03,04,01   * 3
       ORG $3040
       DC.B 02,01,02,05,02,02,04,01  * 4
       
       ORG $4000
       
       
MENSAJE_INICIAL
       DC.B '       BIENVENIDO A CANDY CRUSH! '
       DC.B 'TIENES 10 JUGADAS',0
LINEA_VACIA
       DC.B '',0
AUTORES
       DC.B '                                    REALIZADO POR RAFAEL PIRES E IRTAZA ALI',0
MENSAJE_FINAL1
       DC.B '   FIN DE JUEGO, PRESIONE UNA FLECHA CUALQUIERA SI DESEA SABER SU PUNTUACIÓN ',0
       
MENSAJE_FINAL2
       DC.B '         SU PUNTUACIÓN HA SIDO',0 

LINEA_PUNTOS   
       DC.B '         .',0   
MENSAJE_FINAL3
       DC.B '         PTOS:',0  
MENSAJE_FINAL4
       DC.B '                           GRACIAS POR JUGAR :)',0   
       
       ORG $5000
PUNTERO
       DS.L 1
PUNTERO_RESERVA
       DS.L 1
       
ESTADO_SELECCION                    *SI ES IGUAL A 0 NO ESTÁ SELECCIONADO                               
       DC.L 0                       *SI ES 1 ESTÁ SELECIONADO
KEYBOARD_INPUT                      *PERMITE VISUALIZAR LA ENTRADA DEL TECLADO EN LA MEMORIA
       DS.L 1
DIR_INICIAL
       DS.L 1
DIR_FINAL
       DS.L 1 
N_PUNTOS
       DC.L 0
    
TABLA                               * DIBUJO DE LAS CASILLAS
    *PARA LINEAS VERTICALES
    DC.L 50,50,50,300
    DC.L 100,50,100,300
    DC.L 150,50,150,300
    DC.L 200,50,200,300
    DC.L 250,50,250,300
    DC.L 300,50,300,300
    DC.L 350,50,350,300
    DC.L 400,50,400,300
    DC.L 450,50,450,300
    
    *PARA LINEAS HORIZANTALES
    DC.L 50,50,450,50
    DC.L 50,100,450,100
    DC.L 50,150,450,150
    DC.L 50,200,450,200
    DC.L 50,250,450,250
    DC.L 50,300,450,300
    
    ORG $A000
    
MARCA_HORIZONTAL   *MARCA PARA GESTIONAR EL BORRADO HORIZONTAL
    DS.L 1
    
MARCA_VERTICAL
    DS.L 1

    ORG $B000   
    
SUM_HORIZONTAL
    DC.L 0    
    
SUM_VERTICAL
    DC.L 0  

N_ZEROS
    DC.L 0
        
    ORG $C000  
COLOR_AMARILLO 
     DC.L $0000FFFF
     
     ORG $C010   
COLOR_AZUL
     DC.L $00FFFF00 
     
     ORG $C020  
COLOR_MORADO
     DC.L $00800080
     
     ORG $C030         
COLOR_ROJO
     DC.L $000000FF
     
     ORG $C040   
COLOR_VERDE
     DC.L $0000FF00
     
     ORG $C050
COLOR_NEGRO
     DC.L $00000000
     
     ORG $D000
     
S_HORIZONTAL_1
     DS.L 1

S_VERTICAL_1
     DS.L 1

S_HORIZONTAL_2
     DS.L 1 

S_VERTICAL_2
     DS.L 1
     
COLOR_SPUNTERO
      DC.L $00FFFFFF,$00FFFFFF,$00FFFFFF
COLOR_PUNTERO
      DC.L $00FFFFFF,$00000000,$00FFFFFF
COLOR_BP      
      DC.L $00000000,$00000000,$00000000
         
ADDR
      DS.L 1
      
ALLOWED
      DS.B 1 

FINISH_GAME
      DC.B 0
         
      ORG $E000
**************************************
*ESTADO DEL JUEGO
N_CANCEL
    DC.L 0
    
NUM_JUGADAS
    DC.L $A,0    
**************************************     
THE_END
       SIMHALT    
       END $1000

        
    
    
    
















*~Font name~Courier New~
*~Font size~8~
*~Tab type~1~
*~Tab size~4~
