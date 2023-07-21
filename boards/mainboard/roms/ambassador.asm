; f9dasm: M6800/1/2/3/8/9 / H6309 Binary/OS9/FLEX9 Disassembler V1.82
; Loaded binary file U5-DT.bin
; Loaded binary file U6-DT.bin

;****************************************************
;* Used Labels                                      *
;****************************************************

null_ptr EQU     $0000
stack_top EQU     $0027                    ; top of stack
duplexing_mode EQU     $0028                    ; char: duplexing control byte. PAG=1, HDX=0, FDX=-1
receive_buffer_tail_ptr EQU     $0029                    ; char *: pointer to tail of receive buffer FIFO
key_buffer_head_ptr EQU     $002B                    ; char *: pointer to head of keyboard buffer FIFO
cursor_position_ptr EQU     $002D                    ; word: cursor position
serial_mode EQU     $002F                    ; char: control byte for setting USART serial mode
temp_char EQU     $0030                    ; char: for temporarily saving character
baud_gen_ptr EQU     $0032                    ; struct void *: pointer to baud generator set address
current_row_end_ptr EQU     $0034                    ; char *: pointer to end of current row
baud_config_ptr EQU     $0036                    ; struct baud *: pointer to current baud config struct
parity_config_ptr EQU     $0038                    ; struct parity *: pointer to current parity config struct
stop_bits_config_ptr EQU     $003A                    ; struct stop_bits *: pointer to current stop bits config struct
columns_config_ptr EQU     $003C                    ; struct columns *: pointer to current columns config struct
duplexing_config_ptr EQU     $003E                    ; struct duplexing *: pointer to current duplexing config struct
break_mode_on EQU     $0040                    ; char: are we putting USART into break mode
max_column_temp EQU     $0041                    ; char: for temporarily saving max_column
read_buffer_head_ptr EQU     $0042                    ; char *: pointer to head of receive buffer FIFO
current_row EQU     $0044                    ; char: current row
current_column EQU     $0045                    ; char: current column
scroll_position EQU     $0046                    ; char *: current position during scroll operation
max_column EQU     $0048                    ; char: highest column that can be displayed
key_buffer_tail_ptr EQU     $0049                    ; char *: pointer to tail of keyboard buffer FIFO
M004B   EQU     $004B                    ; char *: temp pointer
M004C   EQU     $004C
M004D   EQU     $004D
M004F   EQU     $004F                    ; void *: temp pointer
M0050   EQU     $0050
stack_ptr_save EQU     $0053                    ; void *: for temporarily saving the location of the stack pointer
last_char_ptr EQU     $0055                    ; char *: pointer to last non-space character in screen buffer
M0057   EQU     $0057                    ; word:
M0058   EQU     $0058
source_ptr EQU     $0059                    ; char *: source parameter for copy operations
dest_ptr EQU     $005B                    ; char *: destination parameter for copy operations
M005C   EQU     $005C
M005D   EQU     $005D                    ; void *: for temporarily storing pointer to current config item
print_enabled EQU     $005F                    ; char: printing enabled. set by DC2, cleared by DC4
M0060   EQU     $0060
counter EQU     $0061                    ; char: loop counter
tty_mode EQU     $0062                    ; char: tty mode. no=0, yes=1
tty_config_ptr EQU     $0063                    ; struct tty *: pointer to current tty config
transmit_off EQU     $0065                    ; char: transmit suspension flag
receive_buffer_count EQU     $0066                    ; short count of bytes in the receive buffer
xoff_count EQU     $0068                    ; char: incremented if we send XOFF
misc_data EQU     $0069                    ; char: data byte sent out to the speaker/ind4/ind5/ind6 port
beep_timer EQU     $006A                    ; char: increments while speaker is sounding, stops when it reaches 150
beep_delay EQU     $006B                    ; char: no speaker until this matches some bits of $03 ?
param1  EQU     $006C                    ; char: first parameter in escape sequence
param2  EQU     $006D                    ; char: second parameter in escape sequence
param3  EQU     $006E                    ; char: third parameter in escape sequence
param_ptr EQU     $006F                    ; char *: pointer to next parameter in escape sequence
seq_process_ptr EQU     $0071                    ; void *: pointer to next routine to use to process escape sequences
seq_processing EQU     $0073                    ; char: incremented when we're currently processing a received escape sequence
flow_control_mode EQU     $0078                    ; char: flow control mode. 0==XON/XOFF
hide_control_chars EQU     $0079                    ; char: clear for visible control characters, $08 for invisible
show_cursor EQU     $007A                    ; char: clear for no invert, $80 for invert
screen_buffer EQU     $0080                    ; char[80x24]: the screen buffer
last_line_ptr EQU     $07B0                    ; address of start of last line of SCREEN
screen_max_ptr EQU     $07FF                    ; last address of SCREEN
key_buffer EQU     $0800                    ; char[34?]: keyboard buffer FIFO
tab_stop_array EQU     $0823                    ; char[10]: tab stops
receive_buffer EQU     $082E                    ; char[768]: received data buffer
line_buffer EQU     $0B30                    ; char[80]: buffer for current(?) line

; I/O addresses
baud_gen_base_addr EQU     $8000                    ; void[16]: baud generator control
serial_data_addr EQU     $B004                    ; char: serial data
serial_control_addr EQU     $B005                    ; char: serial control
kbd_data_addr EQU     $B008                    ; char: keyboard data
kbd_control_addr EQU     $B009                    ; char: keyboard control
printer_data_addr EQU     $B00A                    ; char: printer data
printer_control_addr EQU     $B00B                    ; char: printer control
preset_data EQU     $B00C                    ; char: P1 socket data
preset_control EQU     $B00D                    ; char: P1 socket control
misc_port_data EQU     $B00E                    ; char: speaker, ind4, ind5, ind6 data
misc_port_control EQU     $B00F                    ; char: speaker, ind4, ind5, ind6 control

;****************************************************
;* Program Code / Data Areas                        *
;****************************************************

        ORG     $F000

; RESET handler
; set stack pointer to $27
hdlr_RST LDS     #stack_top               ;F000: 8E 00 27 
; clear registers
        LDX     #null_ptr                ;F003: CE 00 00 
        CLRA                             ;F006: 4F 
        CLRB                             ;F007: 5F 
; clear memory from 0 to mem_max  (0BFFh)
ZF008   STAA    ,X                       ;F008: A7 00 
        INX                              ;F00A: 08 
        CPX     mem_max                  ;F00B: BC FD 26 
        BNE     ZF008                    ;F00E: 26 F8 
        LDAA    #$80                     ;F010: 86 80 
        STAA    show_cursor              ;F012: 97 7A 
        JSR     clear_screen             ;F014: BD F3 2D 
; disable interrupts
        SEI                              ;F017: 0F 
; enable interrupt on low-going KBINT, enable keyboard port
        LDAA    #%00000101               ;F018: 86 05 
        STAA    kbd_control_addr         ;F01A: B7 B0 09 
; set misc port as outputs
        LDAA    #%11111111               ;F01D: 86 FF 
        STAA    misc_port_data           ;F01F: B7 B0 0E 
; enable interrupt on high-going RXRDY, enable misc port
        LDAA    #%00000111               ;F022: 86 07 
        STAA    misc_port_control        ;F024: B7 B0 0F 
; send misc_data out to speaker and IND4,5,6
        LDAA    misc_data                ;F027: 96 69 
        STAA    misc_port_data           ;F029: B7 B0 0E 
; set to 300 baud
        LDAA    baud_gen_base_addr+6     ;F02C: B6 80 06 
; simultaneously send 01111111 to printer data port, 00111100 to printer control port
        LDX     #$7F3C                   ;F02F: CE 7F 3C       printer high bit is input, rest are outputs
        STX     printer_data_addr        ;F032: FF B0 0A       set PRCON high, enable printer port
; fill line_buffer with spaces
        LDAB    #80                      ;F035: C6 50 
        LDAA    #$20                     ;F037: 86 20          SP - Space
        LDX     #line_buffer             ;F039: CE 0B 30 
ZF03C   STAA    ,X                       ;F03C: A7 00 
        INX                              ;F03E: 08 
        DECB                             ;F03F: 5A 
        BNE     ZF03C                    ;F040: 26 FA 
        LDX     #baud_gen_base_addr      ;F042: CE 80 00 
        STX     baud_gen_ptr             ;F045: DF 32 
; enable presets port
        LDAA    #%00000100               ;F047: 86 04 
        STAA    preset_control           ;F049: B7 B0 0D 
        LDAA    preset_data              ;F04C: B6 B0 0C 
; set tty config from preset
        LDX     #tty_no                  ;F04F: CE FE 0D 
        BITA    #%00000001               ;F052: 85 01 
        BNE     ZF059                    ;F054: 26 03 
        LDX     #tty_yes                 ;F056: CE FE 13 
ZF059   STX     tty_config_ptr           ;F059: DF 63 
; set baud config from preset
        LDX     #baud_300                ;F05B: CE FD 90 
        BITA    #%00000010               ;F05E: 85 02 
        BNE     ZF065                    ;F060: 26 03 
        LDX     #baud_1200               ;F062: CE FD 9E 
ZF065   STX     baud_config_ptr          ;F065: DF 36 
; set stop bits config from preset
        LDX     #stop_bits_1             ;F067: CE FD CA 
        BITA    #%00000100               ;F06A: 85 04 
        BNE     ZF071                    ;F06C: 26 03 
        LDX     #stop_bits_2             ;F06E: CE FD CE 
ZF071   STX     stop_bits_config_ptr     ;F071: DF 3A 
; set parity config from preset
        LDX     #parity_none_8           ;F073: CE FD C4 
        BITA    #%00001000               ;F076: 85 08 
        BNE     ZF084                    ;F078: 26 0A 
        LDX     #parity_even_7           ;F07A: CE FD BC 
        BITA    #%00010000               ;F07D: 85 10 
        BNE     ZF084                    ;F07F: 26 03 
        LDX     #parity_odd_7            ;F081: CE FD C0 
ZF084   STX     parity_config_ptr        ;F084: DF 38 
; set duplexing config from preset
        LDX     #duplexing_page          ;F086: CE FD F9 
        BITA    #%00100000               ;F089: 85 20 
        BNE     ZF097                    ;F08B: 26 0A 
        LDX     #duplexing_half          ;F08D: CE FD FF 
        BITA    #%01000000               ;F090: 85 40 
        BEQ     ZF097                    ;F092: 27 03 
        LDX     #duplexing_full          ;F094: CE FE 05 
ZF097   STX     duplexing_config_ptr     ;F097: DF 3E 
; set columns config to 80
        LDX     #columns_80              ;F099: CE FD F2 
        STX     columns_config_ptr       ;F09C: DF 3C 
        JSR     serial_init              ;F09E: BD F5 B4 
        LDAA    serial_data_addr         ;F0A1: B6 B0 04 
        LDAA    serial_data_addr         ;F0A4: B6 B0 04 
        LDX     #key_buffer              ;F0A7: CE 08 00 
        STX     key_buffer_head_ptr      ;F0AA: DF 2B 
        STX     key_buffer_tail_ptr      ;F0AC: DF 49 
        LDX     #receive_buffer          ;F0AE: CE 08 2E 
        STX     read_buffer_head_ptr     ;F0B1: DF 42 
        STX     receive_buffer_tail_ptr  ;F0B3: DF 29 
        LDX     #handle_received_escape_sequence ;F0B5: CE FA FB 
        STX     seq_process_ptr          ;F0B8: DF 71 
        CLI                              ;F0BA: 0E 

main    LDAA    beep_timer               ;F0BB: 96 6A 
        CMPA    #150                     ;F0BD: 81 96 
        BEQ     ZF0C4                    ;F0BF: 27 03 
        JSR     speaker_control          ;F0C1: BD FA BF 
; check read buffer
ZF0C4   LDX     receive_buffer_tail_ptr  ;F0C4: DE 29 
        CPX     read_buffer_head_ptr     ;F0C6: 9C 42 
        BNE     ZF0CD                    ;F0C8: 26 03 
        JMP     check_key_buffer         ;F0CA: 7E F1 6D 
; process read buffer
ZF0CD   LDAA    ,X                       ;F0CD: A6 00 
        INX                              ;F0CF: 08 
; fold read buffer tail if necessary
        CPX     receive_buffer_max       ;F0D0: BC FD 22 
        BNE     ZF0D8                    ;F0D3: 26 03 
        LDX     #receive_buffer          ;F0D5: CE 08 2E 
; update read buffer tail
ZF0D8   STX     receive_buffer_tail_ptr  ;F0D8: DF 29 
        SEI                              ;F0DA: 0F 
        LDX     receive_buffer_count     ;F0DB: DE 66 
        DEX                              ;F0DD: 09 
        STX     receive_buffer_count     ;F0DE: DF 66 
        CLI                              ;F0E0: 0E 
        CPX     receive_buffer_fill_low  ;F0E1: BC FD 2A 
        BNE     ZF0EE                    ;F0E4: 26 08 
        TST     >xoff_count              ;F0E6: 7D 00 68 
        BEQ     ZF0EE                    ;F0E9: 27 03 
        JSR     send_xon                 ;F0EB: BD F2 B4 
; if we've started handling an escape sequence, resume that
ZF0EE   TST     >seq_processing          ;F0EE: 7D 00 73 
        BEQ     ZF0F7                    ;F0F1: 27 04 
        LDX     seq_process_ptr          ;F0F3: DE 71 
        JMP     ,X                       ;F0F5: 6E 00 
; is this a printable character (space or above)
ZF0F7   CMPA    #$20                     ;F0F7: 81 20 
        BGE     ZF157                    ;F0F9: 2C 5C 
; handle non-printable characters
        CMPA    #$0D                     ;F0FB: 81 0D          CR - Carriage Return
        BNE     ZF103                    ;F0FD: 26 04 
        LDAA    #$90                     ;F0FF: 86 90          command_carriage_return
        BRA     handle_received_command_code ;F101: 20 67 
ZF103   CMPA    #$0A                     ;F103: 81 0A          LF - Line Feed
        BNE     ZF125                    ;F105: 26 1E 
        TST     >print_enabled           ;F107: 7D 00 5F 
        BEQ     ZF119                    ;F10A: 27 0D 
        TST     >M0060                   ;F10C: 7D 00 60 
        BNE     ZF114                    ;F10F: 26 03 
        JSR     print_character          ;F111: BD FA 14 
; loop until printer high bit clear
ZF114   LDAA    printer_data_addr        ;F114: B6 B0 0A 
        BPL     ZF114                    ;F117: 2A FB 
ZF119   TST     >M0060                   ;F119: 7D 00 60 
        BNE     check_key_buffer         ;F11C: 26 4F 
        CLR     >M0060                   ;F11E: 7F 00 60 
ZF121   LDAA    #$91                     ;F121: 86 91          command_line_feed
        BRA     handle_received_command_code ;F123: 20 45 
ZF125   CLR     >M0060                   ;F125: 7F 00 60 
        CMPA    #$08                     ;F128: 81 08          BS - Backspace
        BNE     ZF130                    ;F12A: 26 04 
        LDAA    #$9A                     ;F12C: 86 9A          command_backspace2
        BRA     handle_received_command_code ;F12E: 20 3A 
ZF130   CMPA    #$09                     ;F130: 81 09          HT - Horizontal Tab
        BNE     ZF138                    ;F132: 26 04 
        LDAA    #$92                     ;F134: 86 92          command_horizontal_tab
        BRA     handle_received_command_code ;F136: 20 32 
ZF138   CMPA    #$12                     ;F138: 81 12          DC2 - Device Control Two
        BNE     ZF140                    ;F13A: 26 04 
        LDAA    #$93                     ;F13C: 86 93          command_print_enable
        BRA     handle_received_command_code ;F13E: 20 2A 
ZF140   CMPA    #$14                     ;F140: 81 14          DC4 - Device Control Four
        BNE     ZF148                    ;F142: 26 04 
        LDAA    #$94                     ;F144: 86 94          command_print_disable
        BRA     handle_received_command_code ;F146: 20 22 
ZF148   CMPA    #$07                     ;F148: 81 07          BEL - Bell, Alert
        BNE     ZF150                    ;F14A: 26 04 
        LDAA    #$95                     ;F14C: 86 95          command_bell
        BRA     handle_received_command_code ;F14E: 20 1A 
ZF150   CMPA    #$1B                     ;F150: 81 1B          ESC - Escape
        BNE     ZF164                    ;F152: 26 10 
        JMP     handle_received_escape_sequence ;F154: 7E FA FB 
ZF157   CLR     >M0060                   ;F157: 7F 00 60 
        TST     >print_enabled           ;F15A: 7D 00 5F 
        BEQ     ZF164                    ;F15D: 27 05 
        PSHA                             ;F15F: 36 
        JSR     print_character          ;F160: BD FA 14 
        PULA                             ;F163: 32 
ZF164   JSR     add_character_to_screen  ;F164: BD F1 E7 
        JMP     check_key_buffer         ;F167: 7E F1 6D 

handle_received_command_code JMP     handle_command_code      ;F16A: 7E F4 5A 

check_key_buffer LDX     key_buffer_tail_ptr      ;F16D: DE 49 
        CPX     key_buffer_head_ptr      ;F16F: 9C 2B 
        BNE     ZF176                    ;F171: 26 03 
        JMP     main                     ;F173: 7E F0 BB 
ZF176   LDAA    ,X                       ;F176: A6 00 
        INX                              ;F178: 08 
        CPX     key_buffer_max           ;F179: BC FD 20 
        BNE     ZF181                    ;F17C: 26 03 
        LDX     #key_buffer              ;F17E: CE 08 00 
ZF181   STX     key_buffer_tail_ptr      ;F181: DF 49 
        TSTA                             ;F183: 4D 
        BPL     ZF189                    ;F184: 2A 03 
        JMP     handle_command_code      ;F186: 7E F4 5A 
ZF189   CMPA    #$07                     ;F189: 81 07          BEL - Bell, Alert
        BNE     ZF190                    ;F18B: 26 03 
        CLR     >beep_timer              ;F18D: 7F 00 6A 
ZF190   TST     >duplexing_mode          ;F190: 7D 00 28 
        BGT     ZF1A0                    ;F193: 2E 0B          PAG
        JSR     transmit_character       ;F195: BD F1 C8 
        TST     >duplexing_mode          ;F198: 7D 00 28 
        BPL     ZF1A0                    ;F19B: 2A 03          HDX
        JMP     main                     ;F19D: 7E F0 BB 
ZF1A0   CMPA    #$0A                     ;F1A0: 81 0A          LF - Line Feed
        BNE     ZF1A7                    ;F1A2: 26 03 
        JMP     ZF121                    ;F1A4: 7E F1 21 
ZF1A7   JSR     add_character_to_screen  ;F1A7: BD F1 E7 
        JMP     main                     ;F1AA: 7E F0 BB 

send_escape_sequence TST     >duplexing_mode          ;F1AD: 7D 00 28 
        BGT     ZF1C0                    ;F1B0: 2E 0E          PAG
ZF1B2   LDAA    ,X                       ;F1B2: A6 00 
        BEQ     ZF1BB                    ;F1B4: 27 05 
        BSR     transmit_character       ;F1B6: 8D 10 
        INX                              ;F1B8: 08 
        BRA     ZF1B2                    ;F1B9: 20 F7 
ZF1BB   TST     >duplexing_mode          ;F1BB: 7D 00 28 
        BNE     ZF1C1                    ;F1BE: 26 01          HDX
ZF1C0   RTS                              ;F1C0: 39 
ZF1C1   LDX     cursor_position_ptr      ;F1C1: DE 2D 
        INS                              ;F1C3: 31 
        INS                              ;F1C4: 31 
        JMP     paint_cursor             ;F1C5: 7E F3 C8 

transmit_character TST     >transmit_off            ;F1C8: 7D 00 65 
        BNE     transmit_character       ;F1CB: 26 FB 

send_serial_byte LDAB    serial_control_addr      ;F1CD: F6 B0 05 
        BITB    #$04                     ;F1D0: C5 04 
        BEQ     send_serial_byte         ;F1D2: 27 F9 
        TST     >tty_mode                ;F1D4: 7D 00 62 
        BEQ     ZF1E3                    ;F1D7: 27 0A          not TTY
        CMPA    #$7B                     ;F1D9: 81 7B 
        BGE     ZF1E3                    ;F1DB: 2C 06 
        CMPA    #$40                     ;F1DD: 81 40 
        BLE     ZF1E3                    ;F1DF: 2F 02 
        ANDA    #$5F                     ;F1E1: 84 5F 
ZF1E3   STAA    serial_data_addr         ;F1E3: B7 B0 04 
        RTS                              ;F1E6: 39 

add_character_to_screen TST     >tty_mode                ;F1E7: 7D 00 62 
        BEQ     ZF1F6                    ;F1EA: 27 0A          not TTY
; if alphabetic, make uppercase
        CMPA    #$7B                     ;F1EC: 81 7B 
        BGE     ZF1F6                    ;F1EE: 2C 06 
        CMPA    #$40                     ;F1F0: 81 40 
        BLE     ZF1F6                    ;F1F2: 2F 02 
        ANDA    #$5F                     ;F1F4: 84 5F 
ZF1F6   TST     >duplexing_mode          ;F1F6: 7D 00 28 
        BGE     ZF209                    ;F1F9: 2C 0E          PAG or HDX
        CMPA    #$20                     ;F1FB: 81 20          SP - Space
        BGE     ZF209                    ;F1FD: 2C 0A          not a control character
        TST     >hide_control_chars      ;F1FF: 7D 00 79 
        BNE     ZF209                    ;F202: 26 05 
        LDX     cursor_position_ptr      ;F204: DE 2D 
        JMP     paint_cursor             ;F206: 7E F3 C8 
ZF209   LDX     cursor_position_ptr      ;F209: DE 2D 
        STAA    ,X                       ;F20B: A7 00 
        LDAA    current_row              ;F20D: 96 44 
        LDAB    current_column           ;F20F: D6 45 
        INCB                             ;F211: 5C 
ZF212   CMPB    max_column               ;F212: D1 48 
        BLE     ZF22E                    ;F214: 2F 18 
        TST     >print_enabled           ;F216: 7D 00 5F 
        BEQ     ZF21F                    ;F219: 27 04 
        CMPB    #80                      ;F21B: C1 50 
        BNE     increment_row            ;F21D: 26 03 
ZF21F   INC     >M0060                   ;F21F: 7C 00 60 

increment_row CLRB                             ;F222: 5F 
        INCA                             ;F223: 4C 
        CMPA    #23                      ;F224: 81 17 
        BLE     ZF22E                    ;F226: 2F 06 
        STAB    current_column           ;F228: D7 45 
        JSR     scroll_screen            ;F22A: BD F4 3A 
        RTS                              ;F22D: 39 
ZF22E   JSR     get_position             ;F22E: BD F3 D1 
        JSR     paint_cursor             ;F231: BD F3 C8 
        RTS                              ;F234: 39 

hdlr_IRQ LDAB    kbd_control_addr         ;F235: F6 B0 09 
        BMI     handle_keyboard_interrupt ;F238: 2B 4D 
        LDAA    misc_port_data           ;F23A: B6 B0 0E 
        LDAB    serial_control_addr      ;F23D: F6 B0 05 
        BITB    #%00000010               ;F240: C5 02          RxRDY
        BNE     handle_receive_ready     ;F242: 26 01 
        RTI                              ;F244: 3B 

handle_receive_ready ANDB    #%01110000               ;F245: C4 70          Sync Detect/Break Detect, Framing Error, Overrun Error
        BEQ     handle_received_valid_byte ;F247: 27 0C 
        LDAB    #%00110111               ;F249: C6 37          RTS, error reset, Rx enable, DTR, Tx enable
        STAB    serial_control_addr      ;F24B: F7 B0 05 
        LDAA    serial_data_addr         ;F24E: B6 B0 04       chomp invalid byte
        LDAA    #$3F                     ;F251: 86 3F          "?"
        BRA     ZF258                    ;F253: 20 03 
handle_received_valid_byte LDAA    serial_data_addr         ;F255: B6 B0 04 
ZF258   ANDA    #$7F                     ;F258: 84 7F          strip high bit
        CMPA    #$11                     ;F25A: 81 11          DC1 - XON
        BEQ     handle_received_xon      ;F25C: 27 4A 
        CMPA    #$13                     ;F25E: 81 13          DC3 - XOFF
        BEQ     handle_received_xoff     ;F260: 27 3C 
        LDX     receive_buffer_count     ;F262: DE 66 
        CPX     receive_buffer_fill_high ;F264: BC FD 2C 
        BNE     handle_received_character ;F267: 26 01 
        RTI                              ;F269: 3B 

handle_received_character LDX     read_buffer_head_ptr     ;F26A: DE 42 
        STAA    ,X                       ;F26C: A7 00 
        INX                              ;F26E: 08 
        CPX     receive_buffer_max       ;F26F: BC FD 22 
        BNE     ZF277                    ;F272: 26 03 
        LDX     #receive_buffer          ;F274: CE 08 2E 
ZF277   STX     read_buffer_head_ptr     ;F277: DF 42 
        LDX     receive_buffer_count     ;F279: DE 66 
        INX                              ;F27B: 08 
        STX     receive_buffer_count     ;F27C: DF 66 
        CPX     receive_buffer_fill_medium ;F27E: BC FD 28 
        BNE     ZF286                    ;F281: 26 03 
        JSR     send_xoff                ;F283: BD F2 AC 
ZF286   RTI                              ;F286: 3B 

handle_keyboard_interrupt LDAA    kbd_data_addr            ;F287: B6 B0 08 
        CMPA    #$96                     ;F28A: 81 96          command_nop
        BEQ     soft_reset               ;F28C: 27 2E 
        LDX     key_buffer_head_ptr      ;F28E: DE 2B 
        STAA    ,X                       ;F290: A7 00 
        INX                              ;F292: 08 
        CPX     key_buffer_max           ;F293: BC FD 20 
        BNE     ZF29B                    ;F296: 26 03 
        LDX     #key_buffer              ;F298: CE 08 00 
ZF29B   STX     key_buffer_head_ptr      ;F29B: DF 2B 
        RTI                              ;F29D: 3B 

handle_received_xoff TST     >flow_control_mode       ;F29E: 7D 00 78 
        BNE     ZF2A7                    ;F2A1: 26 04 
        LDAA    #1                       ;F2A3: 86 01 
        STAA    transmit_off             ;F2A5: 97 65 
ZF2A7   RTI                              ;F2A7: 3B 

handle_received_xon CLR     >transmit_off            ;F2A8: 7F 00 65 
        RTI                              ;F2AB: 3B 

send_xoff LDAA    #$13                     ;F2AC: 86 13          DC3 - XOFF
        INC     >xoff_count              ;F2AE: 7C 00 68 
        JMP     send_serial_byte         ;F2B1: 7E F1 CD 

send_xon PSHA                             ;F2B4: 36 
        LDAA    #$11                     ;F2B5: 86 11          DC1 - XON
        JSR     send_serial_byte         ;F2B7: BD F1 CD 
        PULA                             ;F2BA: 32 
        RTS                              ;F2BB: 39 

soft_reset LDX     #key_buffer              ;F2BC: CE 08 00 
        STX     key_buffer_head_ptr      ;F2BF: DF 2B 
        STX     key_buffer_tail_ptr      ;F2C1: DF 49 
        LDX     #receive_buffer          ;F2C3: CE 08 2E 
        STX     read_buffer_head_ptr     ;F2C6: DF 42 
        STX     receive_buffer_tail_ptr  ;F2C8: DF 29 
        LDX     #handle_received_escape_sequence ;F2CA: CE FA FB 
        STX     seq_process_ptr          ;F2CD: DF 71 
        CLR     >seq_processing          ;F2CF: 7F 00 73 
        CLRA                             ;F2D2: 4F 
        STAA    transmit_off             ;F2D3: 97 65 
        STAA    print_enabled            ;F2D5: 97 5F 
        STAA    xoff_count               ;F2D7: 97 68 
        STAA    M0060                    ;F2D9: 97 60 
        STAA    break_mode_on            ;F2DB: 97 40 
        CLR     >receive_buffer_count    ;F2DD: 7F 00 66 
        LDAA    #150                     ;F2E0: 86 96 
        STAA    beep_timer               ;F2E2: 97 6A 
        LDS     #stack_top               ;F2E4: 8E 00 27 
        JSR     screen_strip_hibits      ;F2E7: BD F3 07 
        JSR     move_home                ;F2EA: BD F3 63 
        LDAA    preset_data              ;F2ED: B6 B0 0C       printer disabled?
        BPL     ZF2F5                    ;F2F0: 2A 03 
        JSR     do_command_97            ;F2F2: BD FA 9F 
ZF2F5   LDAA    #%00110111               ;F2F5: 86 37          RTS, error reset, Rx enable, DTR, Tx enable
        STAA    serial_control_addr      ;F2F7: B7 B0 05 
        LDAA    misc_port_data           ;F2FA: B6 B0 0E 
        LDAA    serial_data_addr         ;F2FD: B6 B0 04 
        LDAA    serial_data_addr         ;F300: B6 B0 04 
        CLI                              ;F303: 0E 
        JMP     main                     ;F304: 7E F0 BB 

screen_strip_hibits LDX     #screen_buffer           ;F307: CE 00 80 
ZF30A   CPX     #key_buffer              ;F30A: 8C 08 00 
        BEQ     ZF31D                    ;F30D: 27 0E 
        LDAA    ,X                       ;F30F: A6 00 
        BMI     ZF316                    ;F311: 2B 03 
        INX                              ;F313: 08 
        BRA     ZF30A                    ;F314: 20 F4 
ZF316   ANDA    #$7F                     ;F316: 84 7F 
        STAA    ,X                       ;F318: A7 00 
        INX                              ;F31A: 08 
        BRA     ZF30A                    ;F31B: 20 ED 
ZF31D   RTS                              ;F31D: 39 

; CTRL+CLEAR SCRN key pressed
do_command_clear LDX     #esc_seq_clear           ;F31E: CE FE 36 
        JSR     send_escape_sequence     ;F321: BD F1 AD 
        BRA     clear_screen             ;F324: 20 07 

; Control Function - Erase In Display
cs_ED   LDAA    param1                   ;F326: 96 6C 
        CMPA    #2                       ;F328: 81 02 
        BEQ     clear_screen             ;F32A: 27 01 
        RTS                              ;F32C: 39 

; fill memory from 0080 to 07ff with spaces
clear_screen SEI                              ;F32D: 0F 
        LDAB    #10                      ;F32E: C6 0A 
        STS     stack_ptr_save           ;F330: 9F 53 
        LDS     #screen_max_ptr          ;F332: 8E 07 FF 
        CLR     >screen_buffer           ;F335: 7F 00 80 
        LDAA    #$20                     ;F338: 86 20          SP - Space
ZF33A   PSHA                             ;F33A: 36 
        PSHA                             ;F33B: 36 
        PSHA                             ;F33C: 36 
        PSHA                             ;F33D: 36 
        PSHA                             ;F33E: 36 
        PSHA                             ;F33F: 36 
        PSHA                             ;F340: 36 
        PSHA                             ;F341: 36 
        DECB                             ;F342: 5A 
        BNE     ZF352                    ;F343: 26 0D 
        STS     M004F                    ;F345: 9F 4F 
        LDS     stack_ptr_save           ;F347: 9E 53 
        CLI                              ;F349: 0E 
        NOP                              ;F34A: 01 
        NOP                              ;F34B: 01 
        NOP                              ;F34C: 01 
        SEI                              ;F34D: 0F 
        LDS     M004F                    ;F34E: 9E 4F 
        LDAB    #10                      ;F350: C6 0A 
ZF352   TST     >screen_buffer           ;F352: 7D 00 80 
        BEQ     ZF33A                    ;F355: 27 E3 
        LDS     stack_ptr_save           ;F357: 9E 53 
        CLI                              ;F359: 0E 
        JMP     move_home                ;F35A: 7E F3 63 

; HOME key pressed
do_command_home LDX     #esc_seq_home            ;F35D: CE FE 1B 
        JSR     send_escape_sequence     ;F360: BD F1 AD 
move_home CLRA                             ;F363: 4F 
        CLRB                             ;F364: 5F 
        JSR     get_position             ;F365: BD F3 D1 
        JMP     paint_cursor             ;F368: 7E F3 C8 

; RIGHT key pressed
do_command_right LDX     #esc_seq_right           ;F36B: CE FE 31 
        JSR     send_escape_sequence     ;F36E: BD F1 AD 
; CUF received
do_cursor_forward LDAA    current_row              ;F371: 96 44 
        LDAB    current_column           ;F373: D6 45 
        INCB                             ;F375: 5C 
        CMPB    max_column               ;F376: D1 48 
        BLE     ZF37D                    ;F378: 2F 03 
        CLRB                             ;F37A: 5F 
        BRA     ZF38B                    ;F37B: 20 0E 
ZF37D   JSR     get_position             ;F37D: BD F3 D1 
        JMP     paint_cursor             ;F380: 7E F3 C8 

; DOWN key pressed
do_command_down LDX     #esc_seq_down            ;F383: CE FE 27 
        JSR     send_escape_sequence     ;F386: BD F1 AD 
; CUD received
do_cursor_down LDAB    current_column           ;F389: D6 45 
ZF38B   LDAA    current_row              ;F38B: 96 44 
        INCA                             ;F38D: 4C 
        CMPA    #$17                     ;F38E: 81 17 
        BLE     ZF394                    ;F390: 2F 02 
        LDAA    #$00                     ;F392: 86 00 
ZF394   JSR     get_position             ;F394: BD F3 D1 
        JMP     paint_cursor             ;F397: 7E F3 C8 

; LEFT key pressed
do_command_left LDX     #esc_seq_left            ;F39A: CE FE 2C 
        JSR     send_escape_sequence     ;F39D: BD F1 AD 
; CUB received
do_cursor_backward LDAA    current_row              ;F3A0: 96 44 
        LDAB    current_column           ;F3A2: D6 45 
        DECB                             ;F3A4: 5A 
        BGE     ZF3AB                    ;F3A5: 2C 04 
        LDAB    max_column               ;F3A7: D6 48 
        BRA     ZF3B9                    ;F3A9: 20 0E 
ZF3AB   JSR     get_position             ;F3AB: BD F3 D1 
        JMP     paint_cursor             ;F3AE: 7E F3 C8 

; UP key pressed
do_command_up LDX     #esc_seq_up              ;F3B1: CE FE 22 
        JSR     send_escape_sequence     ;F3B4: BD F1 AD 
; CUU received
do_cursor_up LDAB    current_column           ;F3B7: D6 45 
ZF3B9   LDAA    current_row              ;F3B9: 96 44 
        DECA                             ;F3BB: 4A 
        CMPA    #$00                     ;F3BC: 81 00 
        BGE     ZF3C2                    ;F3BE: 2C 02 
        LDAA    #$17                     ;F3C0: 86 17 
ZF3C2   JSR     get_position             ;F3C2: BD F3 D1 
        JMP     paint_cursor             ;F3C5: 7E F3 C8 

; make X the current cursor position.
; invert character if show_cursor is set
paint_cursor LDAA    ,X                       ;F3C8: A6 00 
        ORAA    show_cursor              ;F3CA: 9A 7A 
        STAA    ,X                       ;F3CC: A7 00 
        STX     cursor_position_ptr      ;F3CE: DF 2D 
        RTS                              ;F3D0: 39 

; given a row and column, find the address in the screen buffer,
; as well as the address of the end of the current row
get_position STAA    current_row              ;F3D1: 97 44 
        STAB    current_column           ;F3D3: D7 45 
; multiply row by 80
        ASLA                             ;F3D5: 48 
        ASLA                             ;F3D6: 48 
        ADDA    current_row              ;F3D7: 9B 44 
        ASLA                             ;F3D9: 48 
        CLRB                             ;F3DA: 5F 
        ASLA                             ;F3DB: 48 
        ROLB                             ;F3DC: 59 
        ASLA                             ;F3DD: 48 
        ROLB                             ;F3DE: 59 
        ASLA                             ;F3DF: 48 
        ROLB                             ;F3E0: 59 
; add column
        ADDA    current_column           ;F3E1: 9B 45 
; add offset of screen_buffer
        ADCB    #$00                     ;F3E3: C9 00 
        ADDA    #$80                     ;F3E5: 8B 80 
        ADCB    #$00                     ;F3E7: C9 00 
        STAB    M004B                    ;F3E9: D7 4B 
        STAB    current_row_end_ptr      ;F3EB: D7 34 
        STAA    M004C                    ;F3ED: 97 4C 
        LDAB    max_column               ;F3EF: D6 48 
        SUBB    current_column           ;F3F1: D0 45 
        ABA                              ;F3F3: 1B 
        STAA    current_row_end_ptr+1    ;F3F4: 97 35 
        BCC     ZF3FB                    ;F3F6: 24 03 
        INC     >current_row_end_ptr     ;F3F8: 7C 00 34 
ZF3FB   LDX     M004B                    ;F3FB: DE 4B 
        RTS                              ;F3FD: 39 

scroll_screen_sub LDX     #screen_buffer           ;F3FE: CE 00 80 
        STX     scroll_position          ;F401: DF 46 
        LDAA    scroll_position+1        ;F403: 96 47 
        ASLB                             ;F405: 58 
        ASLB                             ;F406: 58 
        ASLB                             ;F407: 58 
ZF408   SEI                              ;F408: 0F 
        STS     stack_ptr_save           ;F409: 9F 53 
ZF40B   LDS     $58,X                    ;F40B: AE 58 
        STS     $08,X                    ;F40D: AF 08 
        LDS     $56,X                    ;F40F: AE 56 
        STS     $06,X                    ;F411: AF 06 
        LDS     $54,X                    ;F413: AE 54 
        STS     $04,X                    ;F415: AF 04 
        LDS     $52,X                    ;F417: AE 52 
        STS     $02,X                    ;F419: AF 02 
        LDS     $50,X                    ;F41B: AE 50 
        STS     ,X                       ;F41D: AF 00 
        ADDA    #$0A                     ;F41F: 8B 0A 
        STAA    scroll_position+1        ;F421: 97 47 
        BCC     ZF428                    ;F423: 24 03 
        INC     >scroll_position         ;F425: 7C 00 46 
ZF428   LDX     scroll_position          ;F428: DE 46 
        DECB                             ;F42A: 5A 
        BITB    #$03                     ;F42B: C5 03 
        BNE     ZF40B                    ;F42D: 26 DC 
        LDS     stack_ptr_save           ;F42F: 9E 53 
        CLI                              ;F431: 0E 
        NOP                              ;F432: 01 
        NOP                              ;F433: 01 
        NOP                              ;F434: 01 
        TSTB                             ;F435: 5D 
        BNE     ZF408                    ;F436: 26 D0 
        INCB                             ;F438: 5C 
        RTS                              ;F439: 39 

scroll_screen LDAB    #23                      ;F43A: C6 17 
        JSR     scroll_screen_sub        ;F43C: BD F3 FE 
        LDX     #last_line_ptr           ;F43F: CE 07 B0 
        JSR     blank_line               ;F442: BD F4 4F 
        LDAA    #23                      ;F445: 86 17 
        LDAB    current_column           ;F447: D6 45 
        JSR     get_position             ;F449: BD F3 D1 
        JMP     paint_cursor             ;F44C: 7E F3 C8 

; fill line with spaces
blank_line LDAB    #80                      ;F44F: C6 50 
        LDAA    #$20                     ;F451: 86 20          SP - Space
ZF453   STAA    ,X                       ;F453: A7 00 
        INX                              ;F455: 08 
        DECB                             ;F456: 5A 
        BNE     ZF453                    ;F457: 26 FA 
        RTS                              ;F459: 39 

handle_command_code CMPA    #$FF                     ;F45A: 81 FF 
        BNE     ZF461                    ;F45C: 26 03 
        JMP     main                     ;F45E: 7E F0 BB 
; use A to calculate offset into array at FCE6, jump to address found there
ZF461   ASLA                             ;F461: 48 
        TAB                              ;F462: 16 
        CLRA                             ;F463: 4F 
        ADDB    #$E6                     ;F464: CB E6 
        ADCA    #$FC                     ;F466: 89 FC 
        STAA    M004F                    ;F468: 97 4F 
        STAB    M0050                    ;F46A: D7 50 
        LDX     cursor_position_ptr      ;F46C: DE 2D 
        LDAA    ,X                       ;F46E: A6 00 
        ANDA    #$7F                     ;F470: 84 7F 
        STAA    ,X                       ;F472: A7 00 
        LDX     M004F                    ;F474: DE 4F 
        LDX     ,X                       ;F476: EE 00 
        JSR     ,X                       ;F478: AD 00 
        JMP     main                     ;F47A: 7E F0 BB 

; SHIFT+CTRL+D key pressed
; CTRL+: key pressed
do_command_nop RTS                              ;F47D: 39 

; BREAK key pressed
do_command_break LDX     cursor_position_ptr      ;F47E: DE 2D 
        JSR     paint_cursor             ;F480: BD F3 C8 
        LDAA    break_mode_on            ;F483: 96 40 
        EORA    #1                       ;F485: 88 01 
        STAA    break_mode_on            ;F487: 97 40 
        BNE     ZF491                    ;F489: 26 06 
        LDAA    #%00110111               ;F48B: 86 37          RTS, error reset, Rx enable, DTR, Tx enable
        STAA    serial_control_addr      ;F48D: B7 B0 05 
        RTS                              ;F490: 39 
ZF491   LDAA    #%00111111               ;F491: 86 3F          RTS, error reset, send break character, Rx enable, DTR, Tx enable
        STAA    serial_control_addr      ;F493: B7 B0 05 
        RTS                              ;F496: 39 

; RETURN key pressed
do_command_return TST     >duplexing_mode          ;F497: 7D 00 28 
        BGT     ZF4AB                    ;F49A: 2E 0F          PAG
        LDAA    #$0D                     ;F49C: 86 0D          CR - Carriage Return
        JSR     transmit_character       ;F49E: BD F1 C8 
        TST     >duplexing_mode          ;F4A1: 7D 00 28 
        BEQ     ZF4AB                    ;F4A4: 27 05          HDX
        LDX     cursor_position_ptr      ;F4A6: DE 2D 
        JMP     paint_cursor             ;F4A8: 7E F3 C8 
ZF4AB   LDAA    current_row              ;F4AB: 96 44 
        JSR     increment_row            ;F4AD: BD F2 22 
        RTS                              ;F4B0: 39 

; BACK SPACE key pressed
do_command_backspace TST     >duplexing_mode          ;F4B1: 7D 00 28 
        BGT     do_command_backspace2    ;F4B4: 2E 0F          PAG
        LDAA    #$08                     ;F4B6: 86 08          BS - Backspace
        JSR     transmit_character       ;F4B8: BD F1 C8 
        TST     >duplexing_mode          ;F4BB: 7D 00 28 
        BEQ     do_command_backspace2    ;F4BE: 27 05          HDX
        LDX     cursor_position_ptr      ;F4C0: DE 2D 
        JMP     paint_cursor             ;F4C2: 7E F3 C8 

; BS received
do_command_backspace2 LDX     cursor_position_ptr      ;F4C5: DE 2D 
        LDAA    #$20                     ;F4C7: 86 20 
        STAA    ,X                       ;F4C9: A7 00 
        LDAB    current_column           ;F4CB: D6 45 
        BNE     ZF4D2                    ;F4CD: 26 03 
        JMP     paint_cursor             ;F4CF: 7E F3 C8 
ZF4D2   LDAA    current_row              ;F4D2: 96 44 
        DECB                             ;F4D4: 5A 
        JMP     ZF212                    ;F4D5: 7E F2 12 

; PRINT XMIT key pressed
do_command_transmit TST     >duplexing_mode          ;F4D8: 7D 00 28 
        BGT     ZF4E0                    ;F4DB: 2E 03          PAG
        JMP     ZF51E                    ;F4DD: 7E F5 1E 
ZF4E0   JSR     screen_find_last_char    ;F4E0: BD F5 46 
        CPX     #null_ptr                ;F4E3: 8C 00 00 
        BNE     ZF4E9                    ;F4E6: 26 01 
        RTS                              ;F4E8: 39 
ZF4E9   STX     last_char_ptr            ;F4E9: DF 55 
        LDAA    #$00                     ;F4EB: 86 00 
        STAA    M004D                    ;F4ED: 97 4D 
        CLRB                             ;F4EF: 5F 
ZF4F0   JSR     get_position             ;F4F0: BD F3 D1 
        STX     M0057                    ;F4F3: DF 57 
        JSR     ZF52A                    ;F4F5: BD F5 2A 
        STX     source_ptr               ;F4F8: DF 59 
        LDX     M0057                    ;F4FA: DE 57 
ZF4FC   LDAA    ,X                       ;F4FC: A6 00 
        JSR     transmit_character       ;F4FE: BD F1 C8 
        CPX     source_ptr               ;F501: 9C 59 
        BEQ     ZF508                    ;F503: 27 03 
        INX                              ;F505: 08 
        BRA     ZF4FC                    ;F506: 20 F4 
ZF508   JSR     transmit_CR_LF           ;F508: BD F5 1F 
        CPX     last_char_ptr            ;F50B: 9C 55 
        BEQ     ZF51B                    ;F50D: 27 0C 
        LDAA    M004D                    ;F50F: 96 4D 
        INCA                             ;F511: 4C 
        STAA    M004D                    ;F512: 97 4D 
        CMPA    #$18                     ;F514: 81 18 
        BEQ     ZF51B                    ;F516: 27 03 
        CLRB                             ;F518: 5F 
        BRA     ZF4F0                    ;F519: 20 D5 
ZF51B   JSR     move_home                ;F51B: BD F3 63 
ZF51E   RTS                              ;F51E: 39 

transmit_CR_LF LDAA    #$0D                     ;F51F: 86 0D 
        JSR     transmit_character       ;F521: BD F1 C8 
        LDAA    #$0A                     ;F524: 86 0A 
        JSR     transmit_character       ;F526: BD F1 C8 
        RTS                              ;F529: 39 
ZF52A   STX     M004F                    ;F52A: DF 4F 
        LDX     current_row_end_ptr      ;F52C: DE 34 
ZF52E   LDAA    ,X                       ;F52E: A6 00 
        ANDA    #$7F                     ;F530: 84 7F 
        CMPA    #$20                     ;F532: 81 20 
        BNE     ZF545                    ;F534: 26 0F 
        DEX                              ;F536: 09 
        CPX     M004F                    ;F537: 9C 4F 
        BNE     ZF52E                    ;F539: 26 F3 
        LDAA    ,X                       ;F53B: A6 00 
        ANDA    #$7F                     ;F53D: 84 7F 
        CMPA    #$20                     ;F53F: 81 20 
        BNE     ZF545                    ;F541: 26 02 
        LDX     M004F                    ;F543: DE 4F 
ZF545   RTS                              ;F545: 39 

screen_find_last_char LDX     #screen_max_ptr          ;F546: CE 07 FF 
        NOP                              ;F549: 01 
ZF54A   LDAA    ,X                       ;F54A: A6 00 
        ANDA    #$7F                     ;F54C: 84 7F 
        CMPA    #$20                     ;F54E: 81 20 
        BNE     ZF563                    ;F550: 26 11 
        DEX                              ;F552: 09 
        CPX     #screen_buffer           ;F553: 8C 00 80 
        BNE     ZF54A                    ;F556: 26 F2 
        LDAA    ,X                       ;F558: A6 00 
        ANDA    #$7F                     ;F55A: 84 7F 
        CMPA    #$20                     ;F55C: 81 20 
        BNE     ZF563                    ;F55E: 26 03 
        LDX     #$0000                   ;F560: CE 00 00 
ZF563   RTS                              ;F563: 39 

; SET MODE key pressed
do_command_set_mode SEI                              ;F564: 0F 
        LDAA    #$4F                     ;F565: 86 4F 
        STAA    max_column               ;F567: 97 48 
        JSR     copy_screen_to_line_buffer ;F569: BD FC BD 
        JSR     move_home                ;F56C: BD F3 63 
        JSR     blank_line               ;F56F: BD F4 4F 
        LDX     #config_text             ;F572: CE FD 43 
        JSR     print_text               ;F575: BD F7 E3 
        LDX     baud_config_ptr          ;F578: DE 36 
        LDAB    $05,X                    ;F57A: E6 05 
        JSR     ZF655                    ;F57C: BD F6 55 
        LDX     parity_config_ptr        ;F57F: DE 38 
        LDAB    $02,X                    ;F581: E6 02 
        JSR     ZF655                    ;F583: BD F6 55 
        LDX     stop_bits_config_ptr     ;F586: DE 3A 
        LDAB    $02,X                    ;F588: E6 02 
        JSR     ZF655                    ;F58A: BD F6 55 
        LDX     columns_config_ptr       ;F58D: DE 3C 
        LDAB    $03,X                    ;F58F: E6 03 
        JSR     ZF655                    ;F591: BD F6 55 
        LDX     duplexing_config_ptr     ;F594: DE 3E 
        LDAB    $04,X                    ;F596: E6 04 
        JSR     ZF655                    ;F598: BD F6 55 
        LDX     tty_config_ptr           ;F59B: DE 63 
        LDAB    $04,X                    ;F59D: E6 04 
        JSR     ZF655                    ;F59F: BD F6 55 
jmp_configure_baud JMP     configure_baud           ;F5A2: 7E F6 04 
jmp_configure_parity JMP     configure_parity         ;F5A5: 7E F6 62 
jmp_configure_stop_bits JMP     configure_stop_bits      ;F5A8: 7E F6 AD 
jmp_configure_columns JMP     configure_columns        ;F5AB: 7E F6 F8 
jmp_configure_duplexing JMP     configure_duplexing      ;F5AE: 7E F7 45 
jmp_configure_tty JMP     configure_tty            ;F5B1: 7E F7 94 

serial_init LDX     baud_config_ptr          ;F5B4: DE 36 
        LDAA    $06,X                    ;F5B6: A6 06 
        STAA    baud_gen_ptr+1           ;F5B8: 97 33 
        LDX     baud_gen_ptr             ;F5BA: DE 32 
        LDAA    ,X                       ;F5BC: A6 00 
        LDX     parity_config_ptr        ;F5BE: DE 38 
        LDAA    $03,X                    ;F5C0: A6 03 
        LDX     stop_bits_config_ptr     ;F5C2: DE 3A 
        ORAA    $03,X                    ;F5C4: AA 03 
        STAA    serial_mode              ;F5C6: 97 2F 
        LDX     columns_config_ptr       ;F5C8: DE 3C 
        LDAA    $04,X                    ;F5CA: A6 04 
        STAA    max_column               ;F5CC: 97 48 
        LDX     duplexing_config_ptr     ;F5CE: DE 3E 
        LDAA    $05,X                    ;F5D0: A6 05 
        STAA    duplexing_mode           ;F5D2: 97 28 
        LDX     tty_config_ptr           ;F5D4: DE 63 
        LDAA    $05,X                    ;F5D6: A6 05 
        STAA    tty_mode                 ;F5D8: 97 62 
        LDAA    #$81                     ;F5DA: 86 81 
        STAA    serial_control_addr      ;F5DC: B7 B0 05 
        STAA    serial_control_addr      ;F5DF: B7 B0 05 
        STAA    serial_control_addr      ;F5E2: B7 B0 05 
        STAA    serial_control_addr      ;F5E5: B7 B0 05 
        LDAA    #$40                     ;F5E8: 86 40 
        STAA    serial_control_addr      ;F5EA: B7 B0 05 
        NOP                              ;F5ED: 01 
        NOP                              ;F5EE: 01 
        NOP                              ;F5EF: 01 
        LDAA    serial_mode              ;F5F0: 96 2F 
        STAA    serial_control_addr      ;F5F2: B7 B0 05 
        NOP                              ;F5F5: 01 
        NOP                              ;F5F6: 01 
        NOP                              ;F5F7: 01 
        LDAA    #%00110111               ;F5F8: 86 37          RTS, error reset, Rx enable, DTR, Tx enable
        STAA    serial_control_addr      ;F5FA: B7 B0 05 
        JSR     copy_line_buffer_to_screen ;F5FD: BD FC D9 
        JSR     move_home                ;F600: BD F3 63 
        RTS                              ;F603: 39 

configure_baud LDX     baud_config_ptr          ;F604: DE 36 
        LDAB    $05,X                    ;F606: E6 05 
        CLRA                             ;F608: 4F 
        JSR     get_position             ;F609: BD F3 D1 
        JSR     paint_cursor             ;F60C: BD F3 C8 
        JSR     get_key                  ;F60F: BD F7 FA 
        TSTB                             ;F612: 5D 
        BNE     ZF618                    ;F613: 26 03 
        JMP     serial_init              ;F615: 7E F5 B4 
ZF618   BPL     ZF61D                    ;F618: 2A 03 
        JMP     ZF648                    ;F61A: 7E F6 48 
ZF61D   TSTA                             ;F61D: 4D 
        BEQ     ZF638                    ;F61E: 27 18 
        LDX     baud_config_ptr          ;F620: DE 36 
        CPX     #baud_110                ;F622: 8C FD 82 
        BEQ     ZF62E                    ;F625: 27 07 
        DEX                              ;F627: 09 
        DEX                              ;F628: 09 
        DEX                              ;F629: 09 
        DEX                              ;F62A: 09 
        DEX                              ;F62B: 09 
        DEX                              ;F62C: 09 
        DEX                              ;F62D: 09 
ZF62E   STX     baud_config_ptr          ;F62E: DF 36 
        LDAB    $05,X                    ;F630: E6 05 
        JSR     ZF655                    ;F632: BD F6 55 
        JMP     configure_baud           ;F635: 7E F6 04 
ZF638   LDX     baud_config_ptr          ;F638: DE 36 
        CPX     baud_max                 ;F63A: BC FD BA 
        BEQ     ZF62E                    ;F63D: 27 EF 
        INX                              ;F63F: 08 
        INX                              ;F640: 08 
        INX                              ;F641: 08 
        INX                              ;F642: 08 
        INX                              ;F643: 08 
        INX                              ;F644: 08 
        INX                              ;F645: 08 
        BRA     ZF62E                    ;F646: 20 E6 
ZF648   JSR     ZF7F1                    ;F648: BD F7 F1 
        CMPB    #$FF                     ;F64B: C1 FF 
        BNE     ZF652                    ;F64D: 26 03 
        JMP     jmp_configure_baud       ;F64F: 7E F5 A2 
ZF652   JMP     jmp_configure_parity     ;F652: 7E F5 A5 
ZF655   STX     M005D                    ;F655: DF 5D 
        CLRA                             ;F657: 4F 
        JSR     get_position             ;F658: BD F3 D1 
        STX     cursor_position_ptr      ;F65B: DF 2D 
        LDX     M005D                    ;F65D: DE 5D 
        JMP     print_text               ;F65F: 7E F7 E3 

configure_parity LDX     parity_config_ptr        ;F662: DE 38 
        LDAB    $02,X                    ;F664: E6 02 
        CLRA                             ;F666: 4F 
        JSR     get_position             ;F667: BD F3 D1 
        JSR     paint_cursor             ;F66A: BD F3 C8 
        JSR     get_key                  ;F66D: BD F7 FA 
        TSTB                             ;F670: 5D 
        BNE     ZF676                    ;F671: 26 03 
        JMP     serial_init              ;F673: 7E F5 B4 
ZF676   BPL     ZF67B                    ;F676: 2A 03 
        JMP     ZF6A0                    ;F678: 7E F6 A0 
ZF67B   TSTA                             ;F67B: 4D 
        BEQ     ZF693                    ;F67C: 27 15 
        LDX     parity_config_ptr        ;F67E: DE 38 
        CPX     #parity_even_7           ;F680: 8C FD BC 
        BEQ     ZF689                    ;F683: 27 04 
        DEX                              ;F685: 09 
        DEX                              ;F686: 09 
        DEX                              ;F687: 09 
        DEX                              ;F688: 09 
ZF689   STX     parity_config_ptr        ;F689: DF 38 
        LDAB    $02,X                    ;F68B: E6 02 
        JSR     ZF655                    ;F68D: BD F6 55 
        JMP     configure_parity         ;F690: 7E F6 62 
ZF693   LDX     parity_config_ptr        ;F693: DE 38 
        CPX     parity_max               ;F695: BC FD C8 
        BEQ     ZF689                    ;F698: 27 EF 
        INX                              ;F69A: 08 
        INX                              ;F69B: 08 
        INX                              ;F69C: 08 
        INX                              ;F69D: 08 
        BRA     ZF689                    ;F69E: 20 E9 
ZF6A0   JSR     ZF7F1                    ;F6A0: BD F7 F1 
        CMPB    #$FF                     ;F6A3: C1 FF 
        BNE     ZF6AA                    ;F6A5: 26 03 
        JMP     jmp_configure_baud       ;F6A7: 7E F5 A2 
ZF6AA   JMP     jmp_configure_stop_bits  ;F6AA: 7E F5 A8 

configure_stop_bits LDX     stop_bits_config_ptr     ;F6AD: DE 3A 
        LDAB    $02,X                    ;F6AF: E6 02 
        CLRA                             ;F6B1: 4F 
        JSR     get_position             ;F6B2: BD F3 D1 
        JSR     paint_cursor             ;F6B5: BD F3 C8 
        JSR     get_key                  ;F6B8: BD F7 FA 
        TSTB                             ;F6BB: 5D 
        BNE     ZF6C1                    ;F6BC: 26 03 
        JMP     serial_init              ;F6BE: 7E F5 B4 
ZF6C1   BPL     ZF6C6                    ;F6C1: 2A 03 
        JMP     ZF6EB                    ;F6C3: 7E F6 EB 
ZF6C6   TSTA                             ;F6C6: 4D 
        BEQ     ZF6DE                    ;F6C7: 27 15 
        LDX     stop_bits_config_ptr     ;F6C9: DE 3A 
        CPX     #stop_bits_1             ;F6CB: 8C FD CA 
        BEQ     ZF6D4                    ;F6CE: 27 04 
        DEX                              ;F6D0: 09 
        DEX                              ;F6D1: 09 
        DEX                              ;F6D2: 09 
        DEX                              ;F6D3: 09 
ZF6D4   STX     stop_bits_config_ptr     ;F6D4: DF 3A 
        LDAB    $02,X                    ;F6D6: E6 02 
        JSR     ZF655                    ;F6D8: BD F6 55 
        JMP     configure_stop_bits      ;F6DB: 7E F6 AD 
ZF6DE   LDX     stop_bits_config_ptr     ;F6DE: DE 3A 
        CPX     stop_bits_max            ;F6E0: BC FD D2 
        BEQ     ZF6D4                    ;F6E3: 27 EF 
        INX                              ;F6E5: 08 
        INX                              ;F6E6: 08 
        INX                              ;F6E7: 08 
        INX                              ;F6E8: 08 
        BRA     ZF6D4                    ;F6E9: 20 E9 
ZF6EB   JSR     ZF7F1                    ;F6EB: BD F7 F1 
        CMPB    #$FF                     ;F6EE: C1 FF 
        BNE     ZF6F5                    ;F6F0: 26 03 
        JMP     jmp_configure_parity     ;F6F2: 7E F5 A5 
ZF6F5   JMP     jmp_configure_columns    ;F6F5: 7E F5 AB 

configure_columns LDX     columns_config_ptr       ;F6F8: DE 3C 
        LDAB    $03,X                    ;F6FA: E6 03 
        CLRA                             ;F6FC: 4F 
        JSR     get_position             ;F6FD: BD F3 D1 
        JSR     paint_cursor             ;F700: BD F3 C8 
        JSR     get_key                  ;F703: BD F7 FA 
        TSTB                             ;F706: 5D 
        BNE     ZF70C                    ;F707: 26 03 
        JMP     serial_init              ;F709: 7E F5 B4 
ZF70C   BPL     ZF711                    ;F70C: 2A 03 
        JMP     ZF738                    ;F70E: 7E F7 38 
ZF711   TSTA                             ;F711: 4D 
        BEQ     ZF72A                    ;F712: 27 16 
        LDX     columns_config_ptr       ;F714: DE 3C 
        CPX     #columns_40              ;F716: 8C FD D4 
        BEQ     ZF720                    ;F719: 27 05 
        DEX                              ;F71B: 09 
        DEX                              ;F71C: 09 
        DEX                              ;F71D: 09 
        DEX                              ;F71E: 09 
        DEX                              ;F71F: 09 
ZF720   STX     columns_config_ptr       ;F720: DF 3C 
        LDAB    $03,X                    ;F722: E6 03 
        JSR     ZF655                    ;F724: BD F6 55 
        JMP     configure_columns        ;F727: 7E F6 F8 
ZF72A   LDX     columns_config_ptr       ;F72A: DE 3C 
        CPX     columns_max              ;F72C: BC FD F7 
        BEQ     ZF720                    ;F72F: 27 EF 
        INX                              ;F731: 08 
        INX                              ;F732: 08 
        INX                              ;F733: 08 
        INX                              ;F734: 08 
        INX                              ;F735: 08 
        BRA     ZF720                    ;F736: 20 E8 
ZF738   JSR     ZF7F1                    ;F738: BD F7 F1 
        CMPB    #$FF                     ;F73B: C1 FF 
        BNE     ZF742                    ;F73D: 26 03 
        JMP     jmp_configure_stop_bits  ;F73F: 7E F5 A8 
ZF742   JMP     jmp_configure_duplexing  ;F742: 7E F5 AE 

configure_duplexing LDX     duplexing_config_ptr     ;F745: DE 3E 
        LDAB    $04,X                    ;F747: E6 04 
        CLRA                             ;F749: 4F 
        JSR     get_position             ;F74A: BD F3 D1 
        JSR     paint_cursor             ;F74D: BD F3 C8 
        JSR     get_key                  ;F750: BD F7 FA 
        TSTB                             ;F753: 5D 
        BNE     ZF759                    ;F754: 26 03 
        JMP     serial_init              ;F756: 7E F5 B4 
ZF759   BPL     ZF75E                    ;F759: 2A 03 
        JMP     ZF787                    ;F75B: 7E F7 87 
ZF75E   TSTA                             ;F75E: 4D 
        BEQ     ZF778                    ;F75F: 27 17 
        LDX     duplexing_config_ptr     ;F761: DE 3E 
        CPX     #duplexing_page          ;F763: 8C FD F9 
        BEQ     ZF76E                    ;F766: 27 06 
        DEX                              ;F768: 09 
        DEX                              ;F769: 09 
        DEX                              ;F76A: 09 
        DEX                              ;F76B: 09 
        DEX                              ;F76C: 09 
        DEX                              ;F76D: 09 
ZF76E   STX     duplexing_config_ptr     ;F76E: DF 3E 
        LDAB    $04,X                    ;F770: E6 04 
        JSR     ZF655                    ;F772: BD F6 55 
        JMP     configure_duplexing      ;F775: 7E F7 45 
ZF778   LDX     duplexing_config_ptr     ;F778: DE 3E 
        CPX     duplexing_max            ;F77A: BC FE 0B 
        BEQ     ZF76E                    ;F77D: 27 EF 
        INX                              ;F77F: 08 
        INX                              ;F780: 08 
        INX                              ;F781: 08 
        INX                              ;F782: 08 
        INX                              ;F783: 08 
        INX                              ;F784: 08 
        BRA     ZF76E                    ;F785: 20 E7 
ZF787   JSR     ZF7F1                    ;F787: BD F7 F1 
        CMPB    #$FF                     ;F78A: C1 FF 
        BNE     ZF791                    ;F78C: 26 03 
        JMP     jmp_configure_columns    ;F78E: 7E F5 AB 
ZF791   JMP     jmp_configure_tty        ;F791: 7E F5 B1 

configure_tty LDX     tty_config_ptr           ;F794: DE 63 
        LDAB    $04,X                    ;F796: E6 04 
        CLRA                             ;F798: 4F 
        JSR     get_position             ;F799: BD F3 D1 
        JSR     paint_cursor             ;F79C: BD F3 C8 
        JSR     get_key                  ;F79F: BD F7 FA 
        TSTB                             ;F7A2: 5D 
        BNE     ZF7A8                    ;F7A3: 26 03 
        JMP     serial_init              ;F7A5: 7E F5 B4 
ZF7A8   BPL     ZF7AD                    ;F7A8: 2A 03 
        JMP     ZF7D6                    ;F7AA: 7E F7 D6 
ZF7AD   TSTA                             ;F7AD: 4D 
        BEQ     ZF7C7                    ;F7AE: 27 17 
        LDX     tty_config_ptr           ;F7B0: DE 63 
        CPX     #tty_no                  ;F7B2: 8C FE 0D 
        BEQ     ZF7BD                    ;F7B5: 27 06 
        DEX                              ;F7B7: 09 
        DEX                              ;F7B8: 09 
        DEX                              ;F7B9: 09 
        DEX                              ;F7BA: 09 
        DEX                              ;F7BB: 09 
        DEX                              ;F7BC: 09 
ZF7BD   STX     tty_config_ptr           ;F7BD: DF 63 
        LDAB    $04,X                    ;F7BF: E6 04 
        JSR     ZF655                    ;F7C1: BD F6 55 
        JMP     configure_tty            ;F7C4: 7E F7 94 
ZF7C7   LDX     tty_config_ptr           ;F7C7: DE 63 
        CPX     tty_max                  ;F7C9: BC FE 19 
        BEQ     ZF7BD                    ;F7CC: 27 EF 
        INX                              ;F7CE: 08 
        INX                              ;F7CF: 08 
        INX                              ;F7D0: 08 
        INX                              ;F7D1: 08 
        INX                              ;F7D2: 08 
        INX                              ;F7D3: 08 
        BRA     ZF7BD                    ;F7D4: 20 E7 
ZF7D6   JSR     ZF7F1                    ;F7D6: BD F7 F1 
        CMPB    #$FF                     ;F7D9: C1 FF 
        BNE     ZF7E0                    ;F7DB: 26 03 
        JMP     jmp_configure_duplexing  ;F7DD: 7E F5 AE 
ZF7E0   JMP     jmp_configure_tty        ;F7E0: 7E F5 B1 

print_text LDAA    ,X                       ;F7E3: A6 00 
        BEQ     ZF7F1                    ;F7E5: 27 0A 
        INX                              ;F7E7: 08 
        STX     temp_char                ;F7E8: DF 30 
        JSR     add_character_to_screen  ;F7EA: BD F1 E7 
        LDX     temp_char                ;F7ED: DE 30 
        BRA     print_text               ;F7EF: 20 F2 
ZF7F1   LDX     cursor_position_ptr      ;F7F1: DE 2D 
        LDAA    ,X                       ;F7F3: A6 00 
        ANDA    #$7F                     ;F7F5: 84 7F 
        STAA    ,X                       ;F7F7: A7 00 
        RTS                              ;F7F9: 39 

; wait for navigation keypress.
; return in A,B:
; RET:    0,0
; DOWN:   1,1
; LEFT:   0,-1(255)
; RIGHT:  0,-2(254)
; UP:     0,1
get_key CLI                              ;F7FA: 0E 
; loop while KBTAIL==KBHEAD
        LDX     key_buffer_tail_ptr      ;F7FB: DE 49 
        CPX     key_buffer_head_ptr      ;F7FD: 9C 2B 
        BNE     ZF804                    ;F7FF: 26 03 
        JMP     get_key                  ;F801: 7E F7 FA 
ZF804   LDAA    ,X                       ;F804: A6 00 
        INX                              ;F806: 08 
        CPX     key_buffer_max           ;F807: BC FD 20 
        BNE     ZF80F                    ;F80A: 26 03 
        LDX     #key_buffer              ;F80C: CE 08 00 
ZF80F   STX     key_buffer_tail_ptr      ;F80F: DF 49 
; keep waiting if bit 7 not set
        TSTA                             ;F811: 4D 
        BPL     get_key                  ;F812: 2A E6 
        CMPA    #$8E                     ;F814: 81 8E          got command_return?
        BNE     ZF81B                    ;F816: 26 03 
        CLRA                             ;F818: 4F 
        CLRB                             ;F819: 5F 
        RTS                              ;F81A: 39 
ZF81B   CMPA    #$81                     ;F81B: 81 81          got command_down?
        BNE     ZF823                    ;F81D: 26 04 
        LDAB    #1                       ;F81F: C6 01 
        TBA                              ;F821: 17 
        RTS                              ;F822: 39 
ZF823   CMPA    #$82                     ;F823: 81 82          got command_left?
        BNE     ZF82B                    ;F825: 26 04 
        LDAB    #255                     ;F827: C6 FF 
        CLRA                             ;F829: 4F 
        RTS                              ;F82A: 39 
ZF82B   CMPA    #$83                     ;F82B: 81 83          got command_right?
        BNE     ZF833                    ;F82D: 26 04 
        LDAB    #254                     ;F82F: C6 FE 
        CLRA                             ;F831: 4F 
        RTS                              ;F832: 39 
ZF833   CMPA    #$84                     ;F833: 81 84          got command_up?
        BNE     get_key                  ;F835: 26 C3          keep waiting for keypress
        LDAB    #1                       ;F837: C6 01 
        CLRA                             ;F839: 4F 
        RTS                              ;F83A: 39 

; CTRL+ESC key pressed
do_command_edit_tabs SEI                              ;F83B: 0F 
        LDAA    max_column               ;F83C: 96 48 
        STAA    max_column_temp          ;F83E: 97 41 
        LDAA    #79                      ;F840: 86 4F 
        STAA    max_column               ;F842: 97 48 
        JSR     copy_screen_to_line_buffer ;F844: BD FC BD 
        JSR     move_home                ;F847: BD F3 63 
        LDAA    #4                       ;F84A: 86 04 
        STAA    counter                  ;F84C: 97 61 
ZF84E   LDX     #ruler_text              ;F84E: CE FD 2E 
        JSR     print_text               ;F851: BD F7 E3 
        DEC     >counter                 ;F854: 7A 00 61 
        BNE     ZF84E                    ;F857: 26 F5 
        CLRA                             ;F859: 4F 
        LDX     #tab_stop_array          ;F85A: CE 08 23 
ZF85D   LDAB    ,X                       ;F85D: E6 00 
        BEQ     ZF873                    ;F85F: 27 12 
        INX                              ;F861: 08 
        STX     M004F                    ;F862: DF 4F 
        JSR     get_position             ;F864: BD F3 D1 
        LDAA    #$7F                     ;F867: 86 7F 
        STAA    ,X                       ;F869: A7 00 
        CLRA                             ;F86B: 4F 
        LDX     M004F                    ;F86C: DE 4F 
        CPX     tab_array_end            ;F86E: BC FD 24 
        BNE     ZF85D                    ;F871: 26 EA 
ZF873   JSR     move_home                ;F873: BD F3 63 
ZF876   JSR     get_key                  ;F876: BD F7 FA 
        TSTB                             ;F879: 5D 
        BNE     ZF87F                    ;F87A: 26 03          return pressed
        JMP     ZF8ED                    ;F87C: 7E F8 ED 
ZF87F   BPL     ZF897                    ;F87F: 2A 16          up or down pressed
        LDX     cursor_position_ptr      ;F881: DE 2D 
        LDAA    ,X                       ;F883: A6 00 
        ANDA    #$7F                     ;F885: 84 7F 
        STAA    ,X                       ;F887: A7 00 
        CMPB    #$FF                     ;F889: C1 FF 
        BEQ     ZF892                    ;F88B: 27 05          left pressed
        JSR     tab_cursor_right         ;F88D: BD F9 24 
        BRA     ZF876                    ;F890: 20 E4 
ZF892   JSR     tab_cursor_left          ;F892: BD F9 18 
        BRA     ZF876                    ;F895: 20 DF 
ZF897   TSTA                             ;F897: 4D 
        BNE     ZF8B7                    ;F898: 26 1D          down pressed
        LDX     #tab_stop_array+9        ;F89A: CE 08 2C 
        LDAA    ,X                       ;F89D: A6 00 
        BEQ     ZF8A4                    ;F89F: 27 03 
        JMP     ZF876                    ;F8A1: 7E F8 76 
ZF8A4   LDAA    current_column           ;F8A4: 96 45 
        BNE     ZF8AB                    ;F8A6: 26 03 
        JMP     ZF876                    ;F8A8: 7E F8 76 
ZF8AB   JSR     add_tab_stop             ;F8AB: BD F8 FD 
        LDX     cursor_position_ptr      ;F8AE: DE 2D 
        LDAA    #$FF                     ;F8B0: 86 FF 
        STAA    ,X                       ;F8B2: A7 00 
        JMP     ZF876                    ;F8B4: 7E F8 76 
ZF8B7   LDAA    current_column           ;F8B7: 96 45 
        LDX     #tab_stop_array          ;F8B9: CE 08 23 
ZF8BC   LDAB    ,X                       ;F8BC: E6 00 
        BNE     ZF8C3                    ;F8BE: 26 03 
        JMP     ZF876                    ;F8C0: 7E F8 76 
ZF8C3   CBA                              ;F8C3: 11 
        BEQ     ZF8CF                    ;F8C4: 27 09 
        INX                              ;F8C6: 08 
        CPX     tab_array_end            ;F8C7: BC FD 24 
        BNE     ZF8BC                    ;F8CA: 26 F0 
        JMP     ZF876                    ;F8CC: 7E F8 76 
ZF8CF   JSR     delete_tab_stop          ;F8CF: BD F9 32 
        LDAB    current_column           ;F8D2: D6 45 
ZF8D4   SUBB    #10                      ;F8D4: C0 0A 
        BPL     ZF8D4                    ;F8D6: 2A FC 
        LDAA    #$B1                     ;F8D8: 86 B1 
        ADDB    #$0A                     ;F8DA: CB 0A 
        BEQ     ZF8E6                    ;F8DC: 27 08 
        LDAA    #$B6                     ;F8DE: 86 B6 
        CMPB    #$05                     ;F8E0: C1 05 
        BEQ     ZF8E6                    ;F8E2: 27 02 
        LDAA    #$AD                     ;F8E4: 86 AD 
ZF8E6   LDX     cursor_position_ptr      ;F8E6: DE 2D 
        STAA    ,X                       ;F8E8: A7 00 
        JMP     ZF876                    ;F8EA: 7E F8 76 
ZF8ED   JSR     copy_line_buffer_to_screen ;F8ED: BD FC D9 
        JSR     move_home                ;F8F0: BD F3 63 
        LDAA    max_column_temp          ;F8F3: 96 41 
        STAA    max_column               ;F8F5: 97 48 
        CLI                              ;F8F7: 0E 
        LDX     cursor_position_ptr      ;F8F8: DE 2D 
        JMP     paint_cursor             ;F8FA: 7E F3 C8 

add_tab_stop LDAB    current_column           ;F8FD: D6 45 
        LDX     #tab_stop_array          ;F8FF: CE 08 23 
ZF902   LDAA    ,X                       ;F902: A6 00 
        BEQ     ZF915                    ;F904: 27 0F 
        CBA                              ;F906: 11 
        BEQ     ZF917                    ;F907: 27 0E 
        BLT     ZF90E                    ;F909: 2D 03 
        STAB    ,X                       ;F90B: E7 00 
        TAB                              ;F90D: 16 
ZF90E   INX                              ;F90E: 08 
        CPX     tab_array_end            ;F90F: BC FD 24 
        BNE     ZF902                    ;F912: 26 EE 
        RTS                              ;F914: 39 
ZF915   STAB    ,X                       ;F915: E7 00 
ZF917   RTS                              ;F917: 39 

tab_cursor_left CLRA                             ;F918: 4F 
        LDAB    current_column           ;F919: D6 45 
        BEQ     ZF91E                    ;F91B: 27 01 
        DECB                             ;F91D: 5A 
ZF91E   JSR     get_position             ;F91E: BD F3 D1 
        JMP     paint_cursor             ;F921: 7E F3 C8 

tab_cursor_right CLRA                             ;F924: 4F 
        LDAB    current_column           ;F925: D6 45 
        CMPB    max_column               ;F927: D1 48 
        BEQ     ZF92C                    ;F929: 27 01 
        INCB                             ;F92B: 5C 
ZF92C   JSR     get_position             ;F92C: BD F3 D1 
        JMP     paint_cursor             ;F92F: 7E F3 C8 

delete_tab_stop STX     M004F                    ;F932: DF 4F 
        LDX     #tab_stop_array+9        ;F934: CE 08 2C 
        CLRB                             ;F937: 5F 
        CPX     M004F                    ;F938: 9C 4F 
        BEQ     ZF946                    ;F93A: 27 0A 
ZF93C   LDAA    ,X                       ;F93C: A6 00 
        STAB    ,X                       ;F93E: E7 00 
        TAB                              ;F940: 16 
        DEX                              ;F941: 09 
        CPX     M004F                    ;F942: 9C 4F 
        BNE     ZF93C                    ;F944: 26 F6 
ZF946   STAB    ,X                       ;F946: E7 00 
        RTS                              ;F948: 39 

do_command_horizontal_tab LDX     #tab_stop_array          ;F949: CE 08 23 
        LDAA    ,X                       ;F94C: A6 00 
        BNE     ZF955                    ;F94E: 26 05 
        LDAA    #$20                     ;F950: 86 20 
        JMP     add_character_to_screen  ;F952: 7E F1 E7 
ZF955   CMPA    max_column               ;F955: 91 48 
        BGT     ZF971                    ;F957: 2E 18 
        LDAB    current_column           ;F959: D6 45 
        CBA                              ;F95B: 11 
        BLE     ZF967                    ;F95C: 2F 09 
        TAB                              ;F95E: 16 
        LDAA    current_row              ;F95F: 96 44 
ZF961   JSR     get_position             ;F961: BD F3 D1 
        JMP     paint_cursor             ;F964: 7E F3 C8 
ZF967   INX                              ;F967: 08 
        CPX     tab_array_end            ;F968: BC FD 24 
        BEQ     ZF971                    ;F96B: 27 04 
        LDAA    ,X                       ;F96D: A6 00 
        BNE     ZF955                    ;F96F: 26 E4 
ZF971   CLRB                             ;F971: 5F 
        LDAA    current_row              ;F972: 96 44 
        INCA                             ;F974: 4C 
        CMPA    #$17                     ;F975: 81 17 
        BLE     ZF961                    ;F977: 2F E8 
        STAB    current_column           ;F979: D7 45 
        JMP     scroll_screen            ;F97B: 7E F4 3A 

; CTRL+I key pressed
do_command_tab TST     >duplexing_mode          ;F97E: 7D 00 28 
        BLE     ZF986                    ;F981: 2F 03          HDX or FDX
        JMP     do_command_horizontal_tab ;F983: 7E F9 49 
ZF986   LDAA    #$09                     ;F986: 86 09          HT - Horizontal Tab
        JSR     transmit_character       ;F988: BD F1 C8 
        TST     >duplexing_mode          ;F98B: 7D 00 28 
        BPL     ZF995                    ;F98E: 2A 05          PAG
        LDX     cursor_position_ptr      ;F990: DE 2D 
        JMP     paint_cursor             ;F992: 7E F3 C8 
ZF995   JMP     do_command_horizontal_tab ;F995: 7E F9 49 

; SHIFT+PRINT XMIT key pressed
do_command_print LDAA    preset_data              ;F998: B6 B0 0C       printer enabled?
        BMI     ZF9A0                    ;F99B: 2B 03 
        JMP     ZFA10                    ;F99D: 7E FA 10 
ZF9A0   LDAB    #$04                     ;F9A0: C6 04 
        STAB    counter                  ;F9A2: D7 61 
ZF9A4   CLRA                             ;F9A4: 4F 
        JSR     print_character          ;F9A5: BD FA 14 
ZF9A8   LDAB    printer_data_addr        ;F9A8: F6 B0 0A 
        BPL     ZF9A8                    ;F9AB: 2A FB 
        DEC     >counter                 ;F9AD: 7A 00 61 
        BNE     ZF9A4                    ;F9B0: 26 F2 
        JSR     screen_find_last_char    ;F9B2: BD F5 46 
        CPX     #null_ptr                ;F9B5: 8C 00 00 
        BNE     ZF9BB                    ;F9B8: 26 01 
        RTS                              ;F9BA: 39 
ZF9BB   STX     last_char_ptr            ;F9BB: DF 55 
        LDAA    #$00                     ;F9BD: 86 00 
        STAA    M004D                    ;F9BF: 97 4D 
        CLRB                             ;F9C1: 5F 
ZF9C2   JSR     get_position             ;F9C2: BD F3 D1 
        STX     M0057                    ;F9C5: DF 57 
        CLRA                             ;F9C7: 4F 
        LDAB    #$4F                     ;F9C8: C6 4F 
        ADDB    M0058                    ;F9CA: DB 58 
        ADCA    M0057                    ;F9CC: 99 57 
        STAA    dest_ptr                 ;F9CE: 97 5B 
        STAB    M005C                    ;F9D0: D7 5C 
        JSR     ZF52A                    ;F9D2: BD F5 2A 
        STX     source_ptr               ;F9D5: DF 59 
        LDX     M0057                    ;F9D7: DE 57 
ZF9D9   LDAA    ,X                       ;F9D9: A6 00 
        JSR     print_character          ;F9DB: BD FA 14 
        CPX     source_ptr               ;F9DE: 9C 59 
        BEQ     ZF9E5                    ;F9E0: 27 03 
        INX                              ;F9E2: 08 
        BRA     ZF9D9                    ;F9E3: 20 F4 
ZF9E5   CPX     dest_ptr                 ;F9E5: 9C 5B 
        BEQ     ZF9EE                    ;F9E7: 27 05 
        LDAA    #$0A                     ;F9E9: 86 0A 
        JSR     print_character          ;F9EB: BD FA 14 
ZF9EE   LDAB    printer_data_addr        ;F9EE: F6 B0 0A 
        BPL     ZF9EE                    ;F9F1: 2A FB 
        CPX     last_char_ptr            ;F9F3: 9C 55 
        BEQ     ZFA03                    ;F9F5: 27 0C 
        LDAA    M004D                    ;F9F7: 96 4D 
        INCA                             ;F9F9: 4C 
        STAA    M004D                    ;F9FA: 97 4D 
        CMPA    #$18                     ;F9FC: 81 18 
        BEQ     ZFA03                    ;F9FE: 27 03 
        CLRB                             ;FA00: 5F 
        BRA     ZF9C2                    ;FA01: 20 BF 
ZFA03   LDAB    #$0B                     ;FA03: C6 0B 
        STAB    counter                  ;FA05: D7 61 
ZFA07   CLRA                             ;FA07: 4F 
        JSR     print_character          ;FA08: BD FA 14 
        DEC     >counter                 ;FA0B: 7A 00 61 
        BNE     ZFA07                    ;FA0E: 26 F7 
ZFA10   JSR     move_home                ;FA10: BD F3 63 
        RTS                              ;FA13: 39 

print_character LDAB    preset_data              ;FA14: F6 B0 0C       printer enabled?
        BMI     ZFA1A                    ;FA17: 2B 01 
        RTS                              ;FA19: 39 
ZFA1A   LDAB    printer_data_addr        ;FA1A: F6 B0 0A 
        BMI     print_character          ;FA1D: 2B F5 
        TSTA                             ;FA1F: 4D 
        BEQ     ZFA32                    ;FA20: 27 10          LF - Line Feed
        CMPA    #$0A                     ;FA22: 81 0A 
        BEQ     ZFA32                    ;FA24: 27 0C 
        CMPA    #$20                     ;FA26: 81 20          SP - Space
        BGE     ZFA2C                    ;FA28: 2C 02          not a control character
        LDAA    #$20                     ;FA2A: 86 20          replace with Space
ZFA2C   CMPA    #$60                     ;FA2C: 81 60 
        BLT     ZFA32                    ;FA2E: 2D 02          not lower case
        SUBA    #$20                     ;FA30: 80 20          make upper case
ZFA32   COMA                             ;FA32: 43             invert bits
        STAA    printer_data_addr        ;FA33: B7 B0 0A       send to printer
        LDAA    #%00110100               ;FA36: 86 34          set PRCON line low
        STAA    printer_control_addr     ;FA38: B7 B0 0B 
        NOP                              ;FA3B: 01 
        NOP                              ;FA3C: 01 
        NOP                              ;FA3D: 01 
        NOP                              ;FA3E: 01 
        NOP                              ;FA3F: 01 
        NOP                              ;FA40: 01 
        NOP                              ;FA41: 01 
        LDAA    #%00111100               ;FA42: 86 3C          set PRCON line high
        STAA    printer_control_addr     ;FA44: B7 B0 0B 
ZFA47   LDAA    printer_control_addr     ;FA47: B6 B0 0B 
        BPL     ZFA47                    ;FA4A: 2A FB 
        LDAA    printer_data_addr        ;FA4C: B6 B0 0A 
        RTS                              ;FA4F: 39 

; CR received
do_command_carriage_return LDAA    current_row              ;FA50: 96 44 
        CLRB                             ;FA52: 5F 
        JSR     get_position             ;FA53: BD F3 D1 
        JMP     paint_cursor             ;FA56: 7E F3 C8 

; LF received
do_command_line_feed LDAB    current_column           ;FA59: D6 45 
        LDAA    current_row              ;FA5B: 96 44 
        INCA                             ;FA5D: 4C 
        CMPA    #$17                     ;FA5E: 81 17 
        BLE     ZFA65                    ;FA60: 2F 03 
        JMP     scroll_screen            ;FA62: 7E F4 3A 
ZFA65   JSR     get_position             ;FA65: BD F3 D1 
        JMP     paint_cursor             ;FA68: 7E F3 C8 

; DC2 received
; CTRL+1 key pressed
do_command_print_enable LDAA    preset_data              ;FA6B: B6 B0 0C       printer disabled?
        BPL     ZFA76                    ;FA6E: 2A 06 
        INC     >print_enabled           ;FA70: 7C 00 5F 
        JSR     print_nulls              ;FA73: BD FA 8B 
ZFA76   LDX     cursor_position_ptr      ;FA76: DE 2D 
        JMP     paint_cursor             ;FA78: 7E F3 C8 

; DC4 received
; CTRL+2 key pressed
do_command_print_disable LDAA    preset_data              ;FA7B: B6 B0 0C       printer disabled?
        BPL     ZFA86                    ;FA7E: 2A 06 
        CLR     >print_enabled           ;FA80: 7F 00 5F 
        JSR     print_nulls              ;FA83: BD FA 8B 
ZFA86   LDX     cursor_position_ptr      ;FA86: DE 2D 
        JMP     paint_cursor             ;FA88: 7E F3 C8 

; send 3 NULL characters to printer
print_nulls LDAB    #$03                     ;FA8B: C6 03 
        STAB    counter                  ;FA8D: D7 61 
ZFA8F   CLRA                             ;FA8F: 4F 
        JSR     print_character          ;FA90: BD FA 14 
        DEC     >counter                 ;FA93: 7A 00 61 
        BNE     ZFA8F                    ;FA96: 26 F7 
        RTS                              ;FA98: 39 

; CTRL+PRINT XMIT key pressed
do_command_print_transmit JSR     do_command_transmit      ;FA99: BD F4 D8 
        JMP     do_command_print         ;FA9C: 7E F9 98 

; CTRL+3 key pressed
do_command_97 CLRA                             ;FA9F: 4F 
        JSR     print_character          ;FAA0: BD FA 14 
        LDX     cursor_position_ptr      ;FAA3: DE 2D 
        JMP     paint_cursor             ;FAA5: 7E F3 C8 

; BEL received
do_command_bell LDAA    #$07                     ;FAA8: 86 07          BEL - Bell, Alert
        JSR     add_character_to_screen  ;FAAA: BD F1 E7 
        CLR     >beep_timer              ;FAAD: 7F 00 6A 
        RTS                              ;FAB0: 39 

; CTRL+4 key pressed
do_command_98 LDAA    misc_data                ;FAB1: 96 69 
; turn off bits for LED5 and LED6?
        ANDA    #%11111100               ;FAB3: 84 FC 
        STAA    misc_data                ;FAB5: 97 69 
        STAA    misc_port_data           ;FAB7: B7 B0 0E 
        LDX     cursor_position_ptr      ;FABA: DE 2D 
        JMP     paint_cursor             ;FABC: 7E F3 C8 

speaker_control LDAB    beep_delay               ;FABF: D6 6B 
        DECB                             ;FAC1: 5A 
        STAB    beep_delay               ;FAC2: D7 6B 
        BITB    #$03                     ;FAC4: C5 03 
        BEQ     ZFAC9                    ;FAC6: 27 01 
        RTS                              ;FAC8: 39 
ZFAC9   LDAA    beep_timer               ;FAC9: 96 6A 
        INCA                             ;FACB: 4C 
        STAA    beep_timer               ;FACC: 97 6A 
        CMPA    #150                     ;FACE: 81 96 
        BEQ     ZFAE5                    ;FAD0: 27 13 
        LDAA    misc_data                ;FAD2: 96 69 
        TAB                              ;FAD4: 16 
        ANDB    #%00001000               ;FAD5: C4 08 
        BEQ     ZFAE1                    ;FAD7: 27 08          speaker low
        ANDA    #%11110111               ;FAD9: 84 F7          set speaker low
ZFADB   STAA    misc_port_data           ;FADB: B7 B0 0E 
        STAA    misc_data                ;FADE: 97 69 
        RTS                              ;FAE0: 39 
ZFAE1   ORAA    #%00001000               ;FAE1: 8A 08          set speaker high
        BRA     ZFADB                    ;FAE3: 20 F6 
ZFAE5   LDAA    misc_data                ;FAE5: 96 69 
        ANDA    #%11110111               ;FAE7: 84 F7          set speaker low
        BRA     ZFADB                    ;FAE9: 20 F0 

; CTRL+5 key pressed
do_command_flow_control_enable INC     >flow_control_mode       ;FAEB: 7C 00 78 
        LDX     cursor_position_ptr      ;FAEE: DE 2D 
        JMP     paint_cursor             ;FAF0: 7E F3 C8 

do_command_flow_control_disable CLR     >flow_control_mode       ;FAF3: 7F 00 78 
        LDX     cursor_position_ptr      ;FAF6: DE 2D 
        JMP     paint_cursor             ;FAF8: 7E F3 C8 

handle_received_escape_sequence CLRB                             ;FAFB: 5F 
        STAB    param1                   ;FAFC: D7 6C 
        STAB    param2                   ;FAFE: D7 6D 
        STAB    param3                   ;FB00: D7 6E 
        LDX     #param1                  ;FB02: CE 00 6C 
        STX     param_ptr                ;FB05: DF 6F 
        LDX     #MFB12                   ;FB07: CE FB 12 
        STX     seq_process_ptr          ;FB0A: DF 71 
        INC     >seq_processing          ;FB0C: 7C 00 73 
        JMP     main                     ;FB0F: 7E F0 BB 
MFB12   CMPA    #$1B                     ;FB12: 81 1B          received a second escape?
        BNE     ZFB24                    ;FB14: 26 0E 
        JSR     add_character_to_screen  ;FB16: BD F1 E7 
ZFB19   CLR     >seq_processing          ;FB19: 7F 00 73 
        LDX     #handle_received_escape_sequence ;FB1C: CE FA FB 
        STX     seq_process_ptr          ;FB1F: DF 71 
        JMP     main                     ;FB21: 7E F0 BB 
ZFB24   CMPA    #$18                     ;FB24: 81 18          received CAN - Cancel sequence
        BEQ     ZFB19                    ;FB26: 27 F1 
        CMPA    #$5B                     ;FB28: 81 5B          received "[" - Control Sequence Indicator
        BEQ     ZFB60                    ;FB2A: 27 34 
        LDX     #escape_sequences        ;FB2C: CE FB 81 
ZFB2F   LDAB    ,X                       ;FB2F: E6 00 
        BEQ     ZFB19                    ;FB31: 27 E6 
        CBA                              ;FB33: 11 
        BEQ     ZFB3B                    ;FB34: 27 05 
        INX                              ;FB36: 08 
        INX                              ;FB37: 08 
        INX                              ;FB38: 08 
        BRA     ZFB2F                    ;FB39: 20 F4 
ZFB3B   LDX     $01,X                    ;FB3B: EE 01 
        JSR     ,X                       ;FB3D: AD 00 
        JMP     ZFB19                    ;FB3F: 7E FB 19 
MFB42   CMPA    #$18                     ;FB42: 81 18 
        BNE     ZFB49                    ;FB44: 26 03 
        JMP     ZFB19                    ;FB46: 7E FB 19 
ZFB49   LDX     param_ptr                ;FB49: DE 6F 
        SUBA    #$30                     ;FB4B: 80 30 
        BGE     ZFB52                    ;FB4D: 2C 03 
        JMP     ZFB19                    ;FB4F: 7E FB 19 
ZFB52   CMPA    #$09                     ;FB52: 81 09 
        BGT     ZFB68                    ;FB54: 2E 12 
        LDAB    ,X                       ;FB56: E6 00 
        ASLB                             ;FB58: 58 
        ASLB                             ;FB59: 58 
        ADDB    ,X                       ;FB5A: EB 00 
        ASLB                             ;FB5C: 58 
        ABA                              ;FB5D: 1B 
        STAA    ,X                       ;FB5E: A7 00 
ZFB60   LDX     #MFB42                   ;FB60: CE FB 42 
        STX     seq_process_ptr          ;FB63: DF 71 
        JMP     main                     ;FB65: 7E F0 BB 
ZFB68   ADDA    #$30                     ;FB68: 8B 30 
        CMPA    #$3B                     ;FB6A: 81 3B 
        BNE     ZFB7B                    ;FB6C: 26 0D 
        INX                              ;FB6E: 08 
        CPX     #param_ptr               ;FB6F: 8C 00 6F 
        BNE     ZFB77                    ;FB72: 26 03 
        JMP     ZFB19                    ;FB74: 7E FB 19 
ZFB77   STX     param_ptr                ;FB77: DF 6F 
        BRA     ZFB60                    ;FB79: 20 E5 
ZFB7B   LDX     #csi_escape_sequences    ;FB7B: CE FB 88 
        JMP     ZFB2F                    ;FB7E: 7E FB 2F 

; Array of control functions for plain escape codes (without "[")
escape_sequences FCC     "H"                      ;FB81: 48 
        FDB     cs_HTS                   ;FB82: FB A7 
        FCC     "E"                      ;FB84: 45 
        FDB     cs_NEL                   ;FB85: FB B7 
        FCB     $00                      ;FB87: 00 

; Array of control functions for CSI escape codes (with "[")
csi_escape_sequences FCC     "A"                      ;FB88: 41 
        FDB     cs_CUU                   ;FB89: FB C2 
        FCC     "B"                      ;FB8B: 42 
        FDB     cs_CUD                   ;FB8C: FB D8 
        FCC     "C"                      ;FB8E: 43 
        FDB     cs_CUF                   ;FB8F: FB EE 
        FCC     "D"                      ;FB91: 44 
        FDB     cs_CUB                   ;FB92: FC 04 
        FCC     "H"                      ;FB94: 48 
        FDB     cs_CUP                   ;FB95: FC 1A 
        FCC     "J"                      ;FB97: 4A 
        FDB     cs_ED                    ;FB98: F3 26 
        FCC     "f"                      ;FB9A: 66 
        FDB     cs_CUP                   ;FB9B: FC 1A 
        FCC     "g"                      ;FB9D: 67 
        FDB     cs_TBC                   ;FB9E: FC 3E 
        FCC     "q"                      ;FBA0: 71 
        FDB     cs_DECLL                 ;FBA1: FC 6B 
        FCC     "t"                      ;FBA3: 74 
        FDB     cs_TCEMCRM               ;FBA4: FC 97 
        FCB     $00                      ;FBA6: 00 

; Control Function - Horizontal Tabulation Set
cs_HTS  LDX     #tab_stop_array+9        ;FBA7: CE 08 2C 
        LDAA    ,X                       ;FBAA: A6 00 
        BEQ     ZFBAF                    ;FBAC: 27 01 
        RTS                              ;FBAE: 39             tabs are full
ZFBAF   LDAA    current_column           ;FBAF: 96 45 
        BNE     ZFBB4                    ;FBB1: 26 01 
        RTS                              ;FBB3: 39             no tab for column zero
ZFBB4   JMP     add_tab_stop             ;FBB4: 7E F8 FD 

; Control Function - Next Line
cs_NEL  LDX     cursor_position_ptr      ;FBB7: DE 2D 
        LDAA    ,X                       ;FBB9: A6 00 
        ANDA    #$7F                     ;FBBB: 84 7F 
        STAA    ,X                       ;FBBD: A7 00 
        JMP     do_command_line_feed     ;FBBF: 7E FA 59 

; Control Function - Cursor Up
cs_CUU  LDAB    param1                   ;FBC2: D6 6C 
        BNE     ZFBC7                    ;FBC4: 26 01 
        INCB                             ;FBC6: 5C 
ZFBC7   PSHB                             ;FBC7: 37 
        LDX     cursor_position_ptr      ;FBC8: DE 2D 
        LDAB    ,X                       ;FBCA: E6 00 
        ANDB    #$7F                     ;FBCC: C4 7F 
        STAB    ,X                       ;FBCE: E7 00 
        JSR     do_cursor_up             ;FBD0: BD F3 B7 
        PULB                             ;FBD3: 33 
        DECB                             ;FBD4: 5A 
        BNE     ZFBC7                    ;FBD5: 26 F0 
        RTS                              ;FBD7: 39 

; Control Function - Cursor Down
cs_CUD  LDAB    param1                   ;FBD8: D6 6C 
        BNE     ZFBDD                    ;FBDA: 26 01 
        INCB                             ;FBDC: 5C 
ZFBDD   PSHB                             ;FBDD: 37 
        LDX     cursor_position_ptr      ;FBDE: DE 2D 
        LDAB    ,X                       ;FBE0: E6 00 
        ANDB    #$7F                     ;FBE2: C4 7F 
        STAB    ,X                       ;FBE4: E7 00 
        JSR     do_cursor_down           ;FBE6: BD F3 89 
        PULB                             ;FBE9: 33 
        DECB                             ;FBEA: 5A 
        BNE     ZFBDD                    ;FBEB: 26 F0 
        RTS                              ;FBED: 39 

; Control Function - Cursor Forward
cs_CUF  LDAB    param1                   ;FBEE: D6 6C 
        BNE     ZFBF3                    ;FBF0: 26 01 
        INCB                             ;FBF2: 5C 
ZFBF3   PSHB                             ;FBF3: 37 
        LDX     cursor_position_ptr      ;FBF4: DE 2D 
        LDAB    ,X                       ;FBF6: E6 00 
        ANDB    #$7F                     ;FBF8: C4 7F 
        STAB    ,X                       ;FBFA: E7 00 
        JSR     do_cursor_forward        ;FBFC: BD F3 71 
        PULB                             ;FBFF: 33 
        DECB                             ;FC00: 5A 
        BNE     ZFBF3                    ;FC01: 26 F0 
        RTS                              ;FC03: 39 

; Control Function - Cursor Backward
cs_CUB  LDAB    param1                   ;FC04: D6 6C 
        BNE     ZFC09                    ;FC06: 26 01 
        INCB                             ;FC08: 5C 
ZFC09   PSHB                             ;FC09: 37 
        LDX     cursor_position_ptr      ;FC0A: DE 2D 
        LDAA    ,X                       ;FC0C: A6 00 
        ANDA    #$7F                     ;FC0E: 84 7F 
        STAA    ,X                       ;FC10: A7 00 
        JSR     do_cursor_backward       ;FC12: BD F3 A0 
        PULB                             ;FC15: 33 
        DECB                             ;FC16: 5A 
        BNE     ZFC09                    ;FC17: 26 F0 
        RTS                              ;FC19: 39 

; Control Function - Cursor Position (same as HVP – Horizontal and Vertical Position)
cs_CUP  LDAA    param1                   ;FC1A: 96 6C 
        BEQ     ZFC1F                    ;FC1C: 27 01 
        DECA                             ;FC1E: 4A 
ZFC1F   CMPA    #$17                     ;FC1F: 81 17 
        BLE     ZFC24                    ;FC21: 2F 01 
        RTS                              ;FC23: 39 
ZFC24   LDAB    param2                   ;FC24: D6 6D 
        BEQ     ZFC29                    ;FC26: 27 01 
        DECB                             ;FC28: 5A 
ZFC29   CMPB    max_column               ;FC29: D1 48 
        BLE     ZFC2E                    ;FC2B: 2F 01 
        RTS                              ;FC2D: 39 
ZFC2E   PSHA                             ;FC2E: 36 
        LDX     cursor_position_ptr      ;FC2F: DE 2D 
        LDAA    ,X                       ;FC31: A6 00 
        ANDA    #$7F                     ;FC33: 84 7F 
        STAA    ,X                       ;FC35: A7 00 
        PULA                             ;FC37: 32 
        JSR     get_position             ;FC38: BD F3 D1 
        JMP     paint_cursor             ;FC3B: 7E F3 C8 

; Control Function – Tabulation Clear
cs_TBC  LDAB    param1                   ;FC3E: D6 6C 
; 0 - clear tab at cursor
        BEQ     ZFC54                    ;FC40: 27 12 
; 3 - clear all tabs
        CMPB    #$03                     ;FC42: C1 03 
        BEQ     ZFC47                    ;FC44: 27 01 
        RTS                              ;FC46: 39 
ZFC47   LDX     #tab_stop_array          ;FC47: CE 08 23 
        CLRA                             ;FC4A: 4F 
ZFC4B   STAA    ,X                       ;FC4B: A7 00 
        INX                              ;FC4D: 08 
        CPX     tab_array_end            ;FC4E: BC FD 24 
        BNE     ZFC4B                    ;FC51: 26 F8 
        RTS                              ;FC53: 39 
ZFC54   LDAA    current_column           ;FC54: 96 45 
        LDX     #tab_stop_array          ;FC56: CE 08 23 
ZFC59   LDAB    ,X                       ;FC59: E6 00 
; abort if tab not set
        BNE     ZFC5E                    ;FC5B: 26 01 
        RTS                              ;FC5D: 39 
; is this tab at the current position?
ZFC5E   CBA                              ;FC5E: 11 
        BEQ     ZFC68                    ;FC5F: 27 07 
        INX                              ;FC61: 08 
        CPX     tab_array_end            ;FC62: BC FD 24 
        BNE     ZFC59                    ;FC65: 26 F2 
        RTS                              ;FC67: 39 
ZFC68   JMP     delete_tab_stop          ;FC68: 7E F9 32 

; Control Function - Load LEDs (DEC Private)
cs_DECLL LDX     #beep_delay              ;FC6B: CE 00 6B       start at location before param1 but then...
ZFC6E   INX                              ;FC6E: 08             increment to wanted param
        LDAA    ,X                       ;FC6F: A6 00 
; 0 - all off
        BEQ     ZFC80                    ;FC71: 27 0D 
; 1 - "num lock" on
        CMPA    #1                       ;FC73: 81 01 
        BEQ     ZFC8B                    ;FC75: 27 14 
; 2 - "caps lock" on
        CMPA    #2                       ;FC77: 81 02 
        BEQ     ZFC91                    ;FC79: 27 16 
; was this the last parameter?
ZFC7B   CPX     param_ptr                ;FC7B: 9C 6F 
; next parameter
        BNE     ZFC6E                    ;FC7D: 26 EF 
        RTS                              ;FC7F: 39 
; turn off bits for LED5 and LED6
ZFC80   LDAA    misc_data                ;FC80: 96 69 
        ANDA    #%11111100               ;FC82: 84 FC 
; save status and send to port
ZFC84   STAA    misc_data                ;FC84: 97 69 
        STAA    misc_port_data           ;FC86: B7 B0 0E 
        BRA     ZFC7B                    ;FC89: 20 F0 
ZFC8B   LDAA    misc_data                ;FC8B: 96 69 
        ORAA    #%00000001               ;FC8D: 8A 01 
        BRA     ZFC84                    ;FC8F: 20 F3 
ZFC91   LDAA    misc_data                ;FC91: 96 69 
        ORAA    #%00000010               ;FC93: 8A 02 
        BRA     ZFC84                    ;FC95: 20 ED 

; Control Function - Text Cursor Enable Mode and Show Control Character Mode
; probably Telcon-specific. Similar functions as the vt510 CRM and DECTCEM but with different sequences.
; takes 2 parameters in any order.
; 6: hide cursor, 7: show cursor, 8: hide control characters, 9: show control characters
cs_TCEMCRM LDAA    param1                   ;FC97: 96 6C 
        BSR     ZFC9D                    ;FC99: 8D 02 
        LDAA    param2                   ;FC9B: 96 6D 
ZFC9D   CMPA    #6                       ;FC9D: 81 06 
        BGT     ZFCA7                    ;FC9F: 2E 06 
        BLT     ZFCBC                    ;FCA1: 2D 19 
        CLR     >show_cursor             ;FCA3: 7F 00 7A 
        RTS                              ;FCA6: 39 
ZFCA7   CMPA    #8                       ;FCA7: 81 08 
        BGT     ZFCB5                    ;FCA9: 2E 0A 
        BLT     ZFCB0                    ;FCAB: 2D 03 
        STAA    hide_control_chars       ;FCAD: 97 79 
        RTS                              ;FCAF: 39 
ZFCB0   LDAA    #$80                     ;FCB0: 86 80 
        STAA    show_cursor              ;FCB2: 97 7A 
        RTS                              ;FCB4: 39 
ZFCB5   CMPA    #9                       ;FCB5: 81 09 
        BNE     ZFCBC                    ;FCB7: 26 03 
        CLR     >hide_control_chars      ;FCB9: 7F 00 79 
ZFCBC   RTS                              ;FCBC: 39 

; copy line from screen to LNBUF
copy_screen_to_line_buffer LDX     #line_buffer             ;FCBD: CE 0B 30 
        STX     dest_ptr                 ;FCC0: DF 5B 
        LDX     #screen_buffer           ;FCC2: CE 00 80 
        LDAB    #$50                     ;FCC5: C6 50 
; copy B chars from X to DEST 
copy_line LDAA    ,X                       ;FCC7: A6 00 
        INX                              ;FCC9: 08 
        STX     source_ptr               ;FCCA: DF 59 
        LDX     dest_ptr                 ;FCCC: DE 5B 
        STAA    ,X                       ;FCCE: A7 00 
        INX                              ;FCD0: 08 
        STX     dest_ptr                 ;FCD1: DF 5B 
        LDX     source_ptr               ;FCD3: DE 59 
        DECB                             ;FCD5: 5A 
        BNE     copy_line                ;FCD6: 26 EF 
        RTS                              ;FCD8: 39 

; copy line from line_buffer to screen
copy_line_buffer_to_screen LDX     #screen_buffer           ;FCD9: CE 00 80 
        STX     dest_ptr                 ;FCDC: DF 5B 
        LDAB    #80                      ;FCDE: C6 50 
        LDX     #line_buffer             ;FCE0: CE 0B 30 
        JMP     copy_line                ;FCE3: 7E FC C7 

; Array of command addresses used by handle_command_code (and handle_received_command_code).
; Command codes begin at $80 and are generated by the keyboard or a received command.
        FDB     do_command_nop           ;FCE6: F4 7D          $80
        FDB     do_command_down          ;FCE8: F3 83          $81
        FDB     do_command_left          ;FCEA: F3 9A          $82
        FDB     do_command_right         ;FCEC: F3 6B          $83
        FDB     do_command_up            ;FCEE: F3 B1          $84
        FDB     do_command_home          ;FCF0: F3 5D          $85
        FDB     do_command_clear         ;FCF2: F3 1E          $86
        FDB     do_command_set_mode      ;FCF4: F5 64          $87
        FDB     do_command_transmit      ;FCF6: F4 D8          $88
        FDB     do_command_print         ;FCF8: F9 98          $89
        FDB     do_command_print_transmit ;FCFA: FA 99          $8a
        FDB     do_command_nop           ;FCFC: F4 7D          $8b
        FDB     do_command_break         ;FCFE: F4 7E          $8c
        FDB     do_command_edit_tabs     ;FD00: F8 3B          $8d
        FDB     do_command_return        ;FD02: F4 97          $8e
        FDB     do_command_backspace     ;FD04: F4 B1          $8f
        FDB     do_command_carriage_return ;FD06: FA 50          $90
        FDB     do_command_line_feed     ;FD08: FA 59          $91
        FDB     do_command_horizontal_tab ;FD0A: F9 49          $92
        FDB     do_command_print_enable  ;FD0C: FA 6B          $93
        FDB     do_command_print_disable ;FD0E: FA 7B          $94
        FDB     do_command_bell          ;FD10: FA A8          $95
        FDB     do_command_nop           ;FD12: F4 7D          $96
        FDB     do_command_97            ;FD14: FA 9F          $97
        FDB     do_command_98            ;FD16: FA B1          $98
        FDB     do_command_tab           ;FD18: F9 7E          $99
        FDB     do_command_backspace2    ;FD1A: F4 C5          $9a
        FDB     do_command_flow_control_enable ;FD1C: FA EB          $9b
        FDB     do_command_flow_control_disable ;FD1E: FA F3          $9c

key_buffer_max FDB     $0822                    ;FD20: 08 22 
receive_buffer_max FDB     $0B2D                    ;FD22: 0B 2D 
tab_array_end FDB     $082D                    ;FD24: 08 2D          end of tab stop array
mem_max FDB     $0BFF                    ;FD26: 0B FF 

receive_buffer_fill_medium FDB     $029C                    ;FD28: 02 9C          668 bytes
receive_buffer_fill_low FDB     $01C2                    ;FD2A: 01 C2          450 bytes
receive_buffer_fill_high FDB     $02EE                    ;FD2C: 02 EE          750 bytes

ruler_text FCC     "1----6----1----6----"   ;FD2E: 31 2D 2D 2D 2D 36 2D 2D 2D 2D 31 2D 2D 2D 2D 36 2D 2D 2D 2D 
        FCB     $00                      ;FD42: 00 

config_text FCC     "  V1.0 XXXX-BAUD X LE"  ;FD43: 20 20 56 31 2E 30 20 58 58 58 58 2D 42 41 55 44 20 58 20 4C 45 
        FCC     "VEL X STOP  XX CHAR/L"  ;FD58: 56 45 4C 20 58 20 53 54 4F 50 20 20 58 58 20 43 48 41 52 2F 4C 
        FCC     "INE PPP TTY MODE XXX"   ;FD6D: 49 4E 45 20 50 50 50 20 54 54 59 20 4D 4F 44 45 20 58 58 58 
        FCB     $00                      ;FD81: 00 

; struct baud {
; char text[5];   // four characters, padded with leading spaces, null terminated
; char offset;    // offset into CFGTXT
; char value;     // bits to set on ABCD pins of MM5307 chip, in reverse order
; }
baud_110 FCC     " 110"                   ;FD82: 20 31 31 30 
        FCB     $00,$07,$0C              ;FD86: 00 07 0C 
baud_150 FCC     " 150"                   ;FD89: 20 31 35 30 
        FCB     $00,$07,$0A              ;FD8D: 00 07 0A 
baud_300 FCC     " 300"                   ;FD90: 20 33 30 30 
        FCB     $00,$07,$06              ;FD94: 00 07 06 
baud_600 FCC     " 600"                   ;FD97: 20 36 30 30 
        FCB     $00,$07,$0E              ;FD9B: 00 07 0E 
baud_1200 FCC     "1200"                   ;FD9E: 31 32 30 30 
        FCB     $00,$07,$09              ;FDA2: 00 07 09 
baud_2400 FCC     "2400"                   ;FDA5: 32 34 30 30 
        FCB     $00,$07,$0D              ;FDA9: 00 07 0D 
baud_4800 FCC     "4800"                   ;FDAC: 34 38 30 30 
        FCB     $00,$07,$0B              ;FDB0: 00 07 0B 
baud_9600 FCC     "9600"                   ;FDB3: 39 36 30 30 
        FCB     $00,$07,$0F              ;FDB7: 00 07 0F 
baud_max FDB     baud_9600                ;FDBA: FD B3 

; struct parity {
; char text[2];   // 1 character, null terminated
; char offset;    // offset into CFGTXT
; char value;     // bits for sending to the USART
; }
parity_even_7 FCC     "E"                      ;FDBC: 45             even parity, 7 bits, 16xBRF
        FCB     $00,$11                  ;FDBD: 00 11 
        FCC     ":"                      ;FDBF: 3A 
parity_odd_7 FCC     "O"                      ;FDC0: 4F             odd parity, 7 bits, 16xBRF
        FCB     $00,$11,$1A              ;FDC1: 00 11 1A 
parity_none_8 FCC     "8"                      ;FDC4: 38             no parity, 8 bits, 16xBRF
        FCB     $00,$11,$0E              ;FDC5: 00 11 0E 
parity_max FDB     parity_none_8            ;FDC8: FD C4 

; struct stop_bits {
; char text[2];   // 1 character, null terminated
; char offset;    // offset into CFGTXT
; char value;     // bits for sending to the USART
; }
stop_bits_1 FCC     "1"                      ;FDCA: 31             1 stop bit
        FCB     $00,$19                  ;FDCB: 00 19 
        FCC     "@"                      ;FDCD: 40 
stop_bits_2 FCC     "2"                      ;FDCE: 32             2 stop bits
        FCB     $00,$19,$C0              ;FDCF: 00 19 C0 
stop_bits_max FDB     stop_bits_2              ;FDD2: FD CE 

; struct columns {
; char text[3];   // two characters, null terminated
; char offset;    // offset into CFGTXT
; char value;     // # of columns - 1
; }
columns_40 FCC     "40"                     ;FDD4: 34 30 
        FCB     $00                      ;FDD6: 00 
        FCC     "!'"                     ;FDD7: 21 27 
columns_48 FCC     "48"                     ;FDD9: 34 38 
        FCB     $00                      ;FDDB: 00 
        FCC     "!/"                     ;FDDC: 21 2F 
columns_56 FCC     "56"                     ;FDDE: 35 36 
        FCB     $00                      ;FDE0: 00 
        FCC     "!7"                     ;FDE1: 21 37 
columns_64 FCC     "64"                     ;FDE3: 36 34 
        FCB     $00                      ;FDE5: 00 
        FCC     "!?"                     ;FDE6: 21 3F 
columns_69 FCC     "69"                     ;FDE8: 36 39 
        FCB     $00                      ;FDEA: 00 
        FCC     "!D"                     ;FDEB: 21 44 
columns_72 FCC     "72"                     ;FDED: 37 32 
        FCB     $00                      ;FDEF: 00 
        FCC     "!G"                     ;FDF0: 21 47 
columns_80 FCC     "80"                     ;FDF2: 38 30 
        FCB     $00                      ;FDF4: 00 
        FCC     "!O"                     ;FDF5: 21 4F 
columns_max FDB     columns_80               ;FDF7: FD F2 

; struct duplexing {
; char text[4];   // three characters, null terminated
; char offset;    // offset into CFGTXT
; char value;     // 1,0,-1
duplexing_page FCC     "PAG"                    ;FDF9: 50 41 47 
        FCB     $00                      ;FDFC: 00 
        FCC     "."                      ;FDFD: 2E 
        FCB     $01                      ;FDFE: 01 
duplexing_half FCC     "HDX"                    ;FDFF: 48 44 58 
        FCB     $00                      ;FE02: 00 
        FCC     "."                      ;FE03: 2E 
        FCB     $00                      ;FE04: 00 
duplexing_full FCC     "FDX"                    ;FE05: 46 44 58 
        FCB     $00                      ;FE08: 00 
        FCC     "."                      ;FE09: 2E 
        FCB     $FF                      ;FE0A: FF 
duplexing_max FDB     duplexing_full           ;FE0B: FE 05 

; struct tty {
; char text[4];   // three characters, null terminated
; char offset;    // offset into CFGTXT
; char value;     // # 0 or 1
; }
tty_no  FCC     "NO "                    ;FE0D: 4E 4F 20 
        FCB     $00                      ;FE10: 00 
        FCC     ";"                      ;FE11: 3B 
        FCB     $00                      ;FE12: 00 
tty_yes FCC     "YES"                    ;FE13: 59 45 53 
        FCB     $00                      ;FE16: 00 
        FCC     ";"                      ;FE17: 3B 
        FCB     $01                      ;FE18: 01 
tty_max FDB     tty_yes                  ;FE19: FE 13 

; escape sequences. null-terminated string.
esc_seq_home FCB     $1B                      ;FE1B: 1B 
        FCC     "[1;1H"                  ;FE1C: 5B 31 3B 31 48 
        FCB     $00                      ;FE21: 00 
esc_seq_up FCB     $1B                      ;FE22: 1B 
        FCC     "[1A"                    ;FE23: 5B 31 41 
        FCB     $00                      ;FE26: 00 
esc_seq_down FCB     $1B                      ;FE27: 1B 
        FCC     "[1B"                    ;FE28: 5B 31 42 
        FCB     $00                      ;FE2B: 00 
esc_seq_left FCB     $1B                      ;FE2C: 1B 
        FCC     "[1D"                    ;FE2D: 5B 31 44 
        FCB     $00                      ;FE30: 00 
esc_seq_right FCB     $1B                      ;FE31: 1B 
        FCC     "[1C"                    ;FE32: 5B 31 43 
        FCB     $00                      ;FE35: 00 
esc_seq_clear FCB     $1B                      ;FE36: 1B 
        FCC     "[2J"                    ;FE37: 5B 32 4A 
        FCB     $00                      ;FE3A: 00 

; unused space
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FE3B: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FE41: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FE47: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FE4D: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FE53: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FE59: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FE5F: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FE65: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FE6B: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FE71: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FE77: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FE7D: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FE83: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FE89: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FE8F: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FE95: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FE9B: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FEA1: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FEA7: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FEAD: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FEB3: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FEB9: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FEBF: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FEC5: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FECB: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FED1: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FED7: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FEDD: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FEE3: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FEE9: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FEEF: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FEF5: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FEFB: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FF01: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FF07: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FF0D: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FF13: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FF19: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FF1F: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FF25: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FF2B: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FF31: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FF37: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FF3D: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FF43: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FF49: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FF4F: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FF55: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FF5B: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FF61: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FF67: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FF6D: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FF73: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FF79: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FF7F: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FF85: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FF8B: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FF91: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FF97: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FF9D: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FFA3: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FFA9: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FFAF: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FFB5: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FFBB: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FFC1: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FFC7: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FFCD: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FFD3: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FFD9: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FFDF: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FFE5: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FFEB: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;FFF1: FF FF FF FF FF FF 
        FCB     $FF                      ;FFF7: FF 

svec_IRQ FDB     hdlr_IRQ                 ;FFF8: F2 35 
svec_SWI FDB     hdlr_RST                 ;FFFA: F0 00 
svec_NMI FDB     hdlr_RST                 ;FFFC: F0 00 
svec_RST FDB     hdlr_RST                 ;FFFE: F0 00 

        END
