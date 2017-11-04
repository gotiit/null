;еееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееее

;                Tarea 5 Brian Morera Ramirez
;                carnet: A84375
;                fecha:31/10/2017
;                version: 4.6

;еееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееее
;                LECTURA DE TECLADO MATRICIAL
;еееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееее
  ; El presente programa se basa en la configuraciєn de un teclado matricial
  ; para ingresar valores, el cual tiene los valores del 0 al 9 ademсs de un
  ; botєn de borrado y otro de entre.

;еееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееее
;                DECLARACION DE ESTRUCTURAS DE DATOS
;еееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееее


#include registers.inc

                       ORG $1000

CONT_MAN:    db 0
CONT_FREE:   db 0
LEDS:        db 0
BRILLO:      db 0   ;tiene que estar ente 0 y 20
CONT_DIG:    db 0
CONT_TICKS:  db 0
DT:          db 0    ;dt = N-K

                      ORG $1010

BCD1:        db 0  ;para cond free
BCD2:        db 0  ;para cond man
DIG1:        db 0
DIG2:        db 0
DIG3:        db 0
DIG4:        db 0

                      ORG $1020
                      
SEGMENT:     db $01,$02,$03,$04,$05,$06,$07,$08,$09,$B,$0,$E

                     ORG $1100


;*******************************************************************************
  ;         DEFINICION DE VECTORES DE INTERRUPCION
;*******************************************************************************
        ;usaremos Debug12
        ;ORG $3E70   ;estamos usando el simulador, asi q las subrutinas estan en la posicion original, si se usa debug12 hay q revisar el rediccionamiento
        ;dw RTI_ISR ;rellenar con la direccion de la subrutina de interrupcion


;еееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееее
;                CONFIGURACION DE HARDWARE
;еееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееее


    ;configuracion de los LEDS puerto paralelo B
            Movb #$FF, DDRB       ;define puerto B como salidas
            Bset DDRJ, $02        ;definimos como salida para poder escribirle
            Bclr PTJ, $02         ;habilita los LEDs, se pone posicion1 en PTJ en cero para activar LEDS

     ;configuaracion puerto A
            movb #$F0,DDRA  ;los primeros 4 bits de salida y los ultimos 4 de entrada
            bset PUCR,#1  ; encender las resistencias de pull-up

     ;configuracion de la RTI
            Movb #%10000000,CRGINT    ; habilitar subituna RTI
            Movb #$17, RTICTL         ;velocidad  de interrupcion

     ;otras configuraciones
            Lds #$3BFF                ;si es en la dragon 12 hay que cambiarlo a #$3BFF, si simulador #$4000
            Cli                       ;se habilita las interrupciones mascarables

;еееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееее
;                Subrutina BIN_BCD
;еееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееее
;               Variables Locales

bin:         db $38
tempa:       db 0
low          db 0
BCD_L        DB 0
BCD_H        DB 0
        
;еееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееее

                   ORG $1300
                   
               ldaa bin
               ldab #7
               movb #0,BCD_L
               movb #0,BCD_H
vuelva         lsla
               rol BCD_L
               rol BCD_H
               staa tempa
               ldaa #$0F
               anda BCD_L
               cmpa #5 ;si algun cuarteto es mayor o  igual a 5, se debe sumar 3
               bmi menor
               inca
               inca
               inca
menor          staa low
               ldaa #$F0
               anda BCD_L
               cmpa #50 ;si algun cuarteto es mayor o  igual a 5, se debe sumar 3
               bmi menor2
               adda #$30
menor2         adda low
               staa BCD_L
               ldaa tempa
               dbne B,vuelva
               lsla
               rol BCD_L
               rol BCD_H
              ; brclr %11110000
               bra *
               
               
               

                   


