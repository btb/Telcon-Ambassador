; f9dasm: M6800/1/2/3/8/9 / H6309 Binary/OS9/FLEX9 Disassembler V1.80
; Loaded binary file U2-80-C01.bin

;****************************************************
;* Used Labels                                      *
;****************************************************

counter EQU     $0000
char_gen_ptr EQU     $0001
char_gen_ptr_l EQU     $0002
char_buffer_ptr EQU     $0003
char_buffer EQU     $0005
char_buffer_end EQU     $0055
char_buffer_end1 EQU     $0056
stack_top EQU     $007F
head_data EQU     $0080
head_control EQU     $0081
port_data EQU     $0082
port_control EQU     $0083

;****************************************************
;* Program Code / Data Areas                        *
;****************************************************

        ORG     $F821

; Character generator data. For each ASCII character N, from 21 to 5f,
; the five columns of pixels are at f800+N, f83f+N, f87e+N, f8bd+N, f8fc+N
char_gen FCB     $7F,$7F                  ;F821: 7F 7F 
        FCC     "k[\O"                   ;F823: 6B 5B 5C 4F 
        FCB     $7F                      ;F827: 7F 
        FCC     "c"                      ;F828: 63 
        FCB     $7F                      ;F829: 7F 
        FCC     "kw"                     ;F82A: 6B 77 
        FCB     $7F                      ;F82C: 7F 
        FCC     "w"                      ;F82D: 77 
        FCB     $7F,$1F                  ;F82E: 7F 1F 
        FCC     "A"                      ;F830: 41 
        FCB     $7F,$1D                  ;F831: 7F 1D 
        FCC     "]gXC"                   ;F833: 5D 67 58 43 
        FCB     $1E                      ;F837: 1E 
        FCC     "Iy"                     ;F838: 49 79 
        FCB     $7F,$7F                  ;F83A: 7F 7F 
        FCC     "w"                      ;F83C: 77 
        FCB     $7F,$7F                  ;F83D: 7F 7F 
        FCC     "}A"                     ;F83F: 7D 41 
        FCB     $01,$00                  ;F841: 01 00 
        FCC     "A>"                     ;F843: 41 3E 
        FCB     $00,$00                  ;F845: 00 00 
        FCC     "A"                      ;F847: 41 
        FCB     $00,$7F                  ;F848: 00 7F 
        FCC     "_"                      ;F84A: 5F 
        FCB     $00,$00,$00,$00          ;F84B: 00 00 00 00 
        FCC     "A"                      ;F84F: 41 
        FCB     $00                      ;F850: 00 
        FCC     "A"                      ;F851: 41 
        FCB     $00                      ;F852: 00 
        FCC     "9~@`"                   ;F853: 39 7E 40 60 
        FCB     $00,$1C                  ;F857: 00 1C 
        FCC     "x"                      ;F859: 78 
        FCB     $1E,$7F,$1F,$7F          ;F85A: 1E 7F 1F 7F 
        FCC     "{w"                     ;F85E: 7B 77 
        FCB     $7F                      ;F860: 7F 
        FCC     "x"                      ;F861: 78 
        FCB     $00                      ;F862: 00 
        FCC     "Ul1"                    ;F863: 55 6C 31 
        FCB     $7F                      ;F866: 7F 
        FCC     "\"                      ;F867: 5C 
        FCB     $7F                      ;F868: 7F 
        FCC     "ww'w"                   ;F869: 77 77 27 77 
        FCB     $1F                      ;F86D: 1F 
        FCC     "o.=.>k:5n66I$kk>~>v6>"  ;F86E: 6F 2E 3D 2E 3E 6B 3A 35 6E 36 36 49 24 6B 6B 3E 7E 3E 76 36 3E 
        FCB     $00                      ;F883: 00 
        FCC     "6v>w>?w?}y>v>v6~?__kw"  ;F884: 36 76 3E 77 3E 3F 77 3F 7D 79 3E 76 3E 76 36 7E 3F 5F 5F 6B 77 
        FCC     "."                      ;F899: 2E 
        FCB     $00                      ;F89A: 00 
        FCC     "o>}w "                  ;F89B: 6F 3E 7D 77 20 
        FCB     $7F                      ;F8A0: 7F 
        FCC     "k"                      ;F8A1: 6B 
        FCB     $00                      ;F8A2: 00 
        FCC     "w"                      ;F8A3: 77 
        FCB     $26                      ;F8A4: 26 
        FCC     "t>>AAGw"                ;F8A5: 74 3E 3E 41 41 47 77 
        FCB     $1F                      ;F8AC: 1F 
        FCC     "w6"                     ;F8AD: 77 36 
        FCB     $00                      ;F8AF: 00 
        FCC     "66m:6v66ID]k]."         ;F8B0: 36 36 6D 3A 36 76 36 36 49 44 5D 6B 5D 2E 
        FCB     $22                      ;F8BE: 22 
        FCC     "v6>>6v>w"               ;F8BF: 76 36 3E 3E 36 76 3E 77 
        FCB     $00                      ;F8C7: 00 
        FCC     ">k?sw>v.f6"             ;F8C8: 3E 6B 3F 73 77 3E 76 2E 66 36 
        FCB     $00                      ;F8D2: 00 
        FCC     "??gw"                   ;F8D3: 3F 3F 67 77 
        FCB     $0F                      ;F8D7: 0F 
        FCC     "6>w>"                   ;F8D8: 36 3E 77 3E 
        FCB     $00                      ;F8DC: 00 
        FCC     "w"                      ;F8DD: 77 
        FCB     $7F                      ;F8DE: 7F 
        FCC     "x"                      ;F8DF: 78 
        FCB     $00                      ;F8E0: 00 
        FCC     "U"                      ;F8E1: 55 
        FCB     $1B                      ;F8E2: 1B 
        FCC     "Yx"                     ;F8E3: 59 78 
        FCB     $7F                      ;F8E5: 7F 
        FCC     "\ww"                    ;F8E6: 5C 77 77 
        FCB     $7F                      ;F8E9: 7F 
        FCC     "w"                      ;F8EA: 77 
        FCB     $7F                      ;F8EB: 7F 
        FCC     "{:?66"                  ;F8EC: 7B 3A 3F 36 36 
        FCB     $00                      ;F8F1: 00 
        FCC     ":6z6V"                  ;F8F2: 3A 36 7A 36 56 
        FCB     $7F,$7F                  ;F8F7: 7F 7F 
        FCC     ">kkv*v6>]>~.w>@]?}O>v"  ;F8F9: 3E 6B 6B 76 2A 76 36 3E 5D 3E 7E 2E 77 3E 40 5D 3F 7D 4F 3E 76 
        FCC     "^V6~?__kw:>{"           ;F90E: 5E 56 36 7E 3F 5F 5F 6B 77 3A 3E 7B 
        FCB     $00                      ;F91A: 00 
        FCC     "}w"                     ;F91B: 7D 77 
        FCB     $7F,$7F                  ;F91D: 7F 7F 
        FCC     "km"                     ;F91F: 6B 6D 
        FCB     $1D                      ;F921: 1D 
        FCC     "/"                      ;F922: 2F 
        FCB     $7F,$7F                  ;F923: 7F 7F 
        FCC     "ckw"                    ;F925: 63 6B 77 
        FCB     $7F                      ;F928: 7F 
        FCC     "w"                      ;F929: 77 
        FCB     $7F                      ;F92A: 7F 
        FCC     "|A"                     ;F92B: 7C 41 
        FCB     $7F                      ;F92D: 7F 
        FCC     "9IoFO|Ia"               ;F92E: 39 49 6F 46 4F 7C 49 61 
        FCB     $7F,$7F,$7F,$7F          ;F936: 7F 7F 7F 7F 
        FCC     "wya"                    ;F93A: 77 79 61 
        FCB     $01                      ;F93D: 01 
        FCC     "I]c>~M"                 ;F93E: 49 5D 63 3E 7E 4D 
        FCB     $00,$7F                  ;F944: 00 7F 
        FCC     "~>?"                    ;F946: 7E 3E 3F 
        FCB     $00,$00                  ;F949: 00 00 
        FCC     "Ay!9N~@`"               ;F94B: 41 79 21 39 4E 7E 40 60 
        FCB     $00,$1C                  ;F953: 00 1C 
        FCC     "x<"                     ;F955: 78 3C 
        FCB     $7F                      ;F957: 7F 
        FCC     "|"                      ;F958: 7C 
        FCB     $7F                      ;F959: 7F 
        FCC     "{"                      ;F95A: 7B 

        ORG     $FC00 

hdlr_RST LDS     #stack_top               ;FC00: 8E 00 7F 
        CLR     >counter                 ;FC03: 7F 00 00 
        LDAA    #%11111111               ;FC06: 86 FF          set printer head and motor as outputs (PA0-PA7)
        STAA    head_data                ;FC08: 97 80 
        LDAB    #%00000101               ;FC0A: C6 05          enable port A, enable irq for phototransistor (CA1)
        STAB    head_control             ;FC0C: D7 81 
        STAA    head_data                ;FC0E: 97 80          turn heads and motor off (HIGH)
        LDAB    #%10000000               ;FC10: C6 80 
        LDAA    #%00111110               ;FC12: 86 3E 
        LDAA    head_data                ;FC14: 96 80 
        BSR     motor_on                 ;FC16: 8D 41 
        JSR     delay_0x20000            ;FC18: BD FC F2 
        LDAA    head_data                ;FC1B: 96 80 
        BSR     wait_photo_clear         ;FC1D: 8D 26 
ZFC1F   CLRA                             ;FC1F: 4F             not sure - print 256 columns of solid pixels?
        JSR     print_column             ;FC20: BD FD 18 
        INC     >counter                 ;FC23: 7C 00 00 
        BNE     ZFC1F                    ;FC26: 26 F7 
        LDX     #char_gen                ;FC28: CE F8 21 
        STX     char_gen_ptr             ;FC2B: DF 01 
        LDX     #char_buffer             ;FC2D: CE 00 05 
        STX     char_buffer_ptr          ;FC30: DF 03 
        BSR     clear_char_buffer        ;FC32: 8D 41 
        JSR     delay_0x20000            ;FC34: BD FC F2 
        LDAB    #%10000000               ;FC37: C6 80          set port high bit as output, rest as inputs
        STAB    port_data                ;FC39: D7 82 
        LDAA    #%00111110               ;FC3B: 86 3E          set PRCON (CB2) high, enable port B
        STAA    port_control             ;FC3D: 97 83 
        CLR     >port_data               ;FC3F: 7F 00 82 
        JMP     process_buffer           ;FC42: 7E FC CD       start by jumping into the buffer processing part of main loop

; loop until phototransistor stops interrupting
wait_photo_clear CLRB                             ;FC45: 5F 
ZFC46   LDAA    head_data                ;FC46: 96 80 
        PSHB                             ;FC48: 37 
        JSR     delay_0xe0               ;FC49: BD FC EA 
        PULB                             ;FC4C: 33 
        LDAA    head_control             ;FC4D: 96 81 
        ROLA                             ;FC4F: 49             check phototransistor interrupt
        BCS     ZFC46                    ;FC50: 25 F4 
        TSTB                             ;FC52: 5D             check it twice...
        BEQ     ZFC56                    ;FC53: 27 01 
        RTS                              ;FC55: 39 
ZFC56   INCB                             ;FC56: 5C 
        BRA     ZFC46                    ;FC57: 20 ED 

motor_on LDAA    #%01111111               ;FC59: 86 7F 
        STAA    head_data                ;FC5B: 97 80 
        LDX     #$2500                   ;FC5D: CE 25 00 
ZFC60   DEX                              ;FC60: 09 
        BNE     ZFC60                    ;FC61: 26 FD 
        RTS                              ;FC63: 39 

all_off LDAA    #%11111111               ;FC64: 86 FF 
        STAA    head_data                ;FC66: 97 80 
        RTS                              ;FC68: 39 

; count down from 00 to 00, 21 times...
delay_0x15ff LDAB    #21                      ;FC69: C6 15 
ZFC6B   PSHB                             ;FC6B: 37 
        CLRB                             ;FC6C: 5F 
ZFC6D   DECB                             ;FC6D: 5A 
        BNE     ZFC6D                    ;FC6E: 26 FD 
        PULB                             ;FC70: 33 
        DECB                             ;FC71: 5A 
        BNE     ZFC6B                    ;FC72: 26 F7 
        RTS                              ;FC74: 39 

; fill character buffer with spaces
clear_char_buffer LDAA    #$20                     ;FC75: 86 20 
        LDX     #char_buffer             ;FC77: CE 00 05 
ZFC7A   STAA    ,X                       ;FC7A: A7 00 
        INX                              ;FC7C: 08 
        CPX     #char_buffer_end1        ;FC7D: 8C 00 56 
        BNE     ZFC7A                    ;FC80: 26 F8 
        RTS                              ;FC82: 39 

print_buffered_characters LDX     #char_buffer             ;FC83: CE 00 05 
        STX     char_buffer_ptr          ;FC86: DF 03 
ZFC88   LDX     char_buffer_ptr          ;FC88: DE 03 
        LDAA    ,X                       ;FC8A: A6 00          get char from buffer
        INX                              ;FC8C: 08 
        CPX     #char_buffer_end1        ;FC8D: 8C 00 56 
        BEQ     clear_char_buffer        ;FC90: 27 E3 
        STX     char_buffer_ptr          ;FC92: DF 03 
        STAA    char_gen_ptr_l           ;FC94: 97 02          prepare to print this character
        CMPA    #$20                     ;FC96: 81 20          is char a space?
        BNE     ZFC9F                    ;FC98: 26 05 
        JSR     print_space              ;FC9A: BD FD 2B 
        BRA     ZFC88                    ;FC9D: 20 E9 
ZFC9F   JSR     print_character          ;FC9F: BD FC FE 
        BRA     ZFC88                    ;FCA2: 20 E4 
; toggle PRCON (CB2)
toggle_prcon LDAB    #%00110110               ;FCA4: C6 36 
        STAB    port_control             ;FCA6: D7 83 
        LDAB    #%00111110               ;FCA8: C6 3E 
        STAB    port_control             ;FCAA: D7 83 
        RTS                              ;FCAC: 39 

; recive characters from port, buffer them, process the buffer, repeat
main_loop LDAA    port_control             ;FCAD: 96 83 
        ROLA                             ;FCAF: 49             check port interrupt
        BCC     main_loop                ;FCB0: 24 FB 
        BSR     toggle_prcon             ;FCB2: 8D F0 
        LDAA    port_data                ;FCB4: 96 82          get byte from port
        COMA                             ;FCB6: 43             invert it
        ANDA    #$7F                     ;FCB7: 84 7F          lower seven bits only
        LDX     char_buffer_ptr          ;FCB9: DE 03 
        CMPA    #$05                     ;FCBB: 81 05          got ENQuiry?
        BEQ     restart_main_loop        ;FCBD: 27 31 
        CMPA    #$1F                     ;FCBF: 81 1F          got some other control code?
        BLS     process_buffer           ;FCC1: 23 0A 
        STAA    ,X                       ;FCC3: A7 00          store in character buffer
        INX                              ;FCC5: 08 
        STX     char_buffer_ptr          ;FCC6: DF 03 
        CPX     #char_buffer_end         ;FCC8: 8C 00 55 
        BNE     main_loop                ;FCCB: 26 E0 
process_buffer LDAA    #%10000000               ;FCCD: 86 80          set PRD7 high - tell main CPU we're busy?
        STAA    port_data                ;FCCF: 97 82 
        JSR     motor_on                 ;FCD1: BD FC 59 
        JSR     wait_photo_clear         ;FCD4: BD FC 45 
        JSR     print_buffered_characters ;FCD7: BD FC 83 
        LDX     #char_buffer             ;FCDA: CE 00 05 
        STX     char_buffer_ptr          ;FCDD: DF 03 
        JSR     delay_0x15ff             ;FCDF: BD FC 69 
        JSR     all_off                  ;FCE2: BD FC 64 
        CLR     >port_data               ;FCE5: 7F 00 82       clear PRD7 - tell main CPU we're ready to receive again?
        BRA     main_loop                ;FCE8: 20 C3 

; decrement from 224 to zero
delay_0xe0 LDAB    #224                     ;FCEA: C6 E0 
ZFCEC   DECB                             ;FCEC: 5A 
        BNE     ZFCEC                    ;FCED: 26 FD 
        RTS                              ;FCEF: 39 

restart_main_loop BRA     main_loop                ;FCF0: 20 BB 

; increment X register from 0 to ffff twice.
delay_0x20000 LDAB    #2                       ;FCF2: C6 02 
ZFCF4   LDX     #$0000                   ;FCF4: CE 00 00 
ZFCF7   INX                              ;FCF7: 08 
        BNE     ZFCF7                    ;FCF8: 26 FD 
        DECB                             ;FCFA: 5A 
        BNE     ZFCF4                    ;FCFB: 26 F7 
        RTS                              ;FCFD: 39 

print_character LDX     char_gen_ptr             ;FCFE: DE 01 
        LDAA    #%01111111               ;FD00: 86 7F          motor on, heads off
        BSR     print_column             ;FD02: 8D 14          blank column
        BSR     print_column             ;FD04: 8D 12          blank column
        LDAA    ,X                       ;FD06: A6 00 
        BSR     print_column             ;FD08: 8D 0E 
        LDAA    $3F,X                    ;FD0A: A6 3F 
        BSR     print_column             ;FD0C: 8D 0A 
        LDAA    $7E,X                    ;FD0E: A6 7E 
        BSR     print_column             ;FD10: 8D 06 
        LDAA    $BD,X                    ;FD12: A6 BD 
        BSR     print_column             ;FD14: 8D 02 
        LDAA    $FC,X                    ;FD16: A6 FC 
print_column LDAB    head_control             ;FD18: D6 81 
        ROLB                             ;FD1A: 59             check phototransistor interrupt
        BCC     print_column             ;FD1B: 24 FB          loop until we are lined up
        STAA    head_data                ;FD1D: 97 80          send pixels to heads
        LDAB    #32                      ;FD1F: C6 20 
ZFD21   DECB                             ;FD21: 5A 
        BNE     ZFD21                    ;FD22: 26 FD 
        LDAB    #%01111111               ;FD24: C6 7F          motor on, heads off
        STAB    head_data                ;FD26: D7 80 
        LDAB    head_data                ;FD28: D6 80 
do_rts  RTS                              ;FD2A: 39 


print_space LDAA    #%01111111               ;FD2B: 86 7F 
        LDAB    #8                       ;FD2D: C6 08          loop 8 times
ZFD2F   DECB                             ;FD2F: 5A 
        BEQ     do_rts                   ;FD30: 27 F8          return
        PSHB                             ;FD32: 37 
        BSR     print_column             ;FD33: 8D E3 
        PULB                             ;FD35: 33 
        BRA     ZFD2F                    ;FD36: 20 F7 

        ORG     $FFF8 

svec_IRQ FDB     hdlr_RST                 ;FFF8: FC 00 
svec_SWI FDB     hdlr_RST                 ;FFFA: FC 00 
svec_NMI FDB     hdlr_RST                 ;FFFC: FC 00 
svec_RST FDB     hdlr_RST                 ;FFFE: FC 00 

        END
