;boot()
        BOOT_LOAD       equ         0x7c00              ; BOOT_LOAD=0x7c00
        ORG     0x7c00                                  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; マクロ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        %include "/home/m8ku/prog/src/include/macro.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; エントリポイント
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
entry:
        jmp     IPL                                     ; IPLラベルへ移動
BPB:
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; BPB( BIOS Parameter Block )
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        times  90 - ( $ - $$ ) db 0x90                  ; BPB領域を確保
IPL:
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; IPL( Initial Program Loader )
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        cli                                             ; 割り込み禁止

        mov     ax , 0x0000                             ; AX=0x0000
        mov     ds , ax                                 ; DS=0x0000
        mov     es , ax                                 ; ES=0x0000
        mov     ss , ax                                 ; SS=0x0000
        mov     sp , BOOT_LOAD                          ; SP=0x7c00

        sti                                             ; 割り込み許可

        mov     [BOOT.DRIVE] , dl                       ;
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; 文字列を表示
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        cdecl   puts , .s0                              ; puts(.s0);

        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; 数値を表示
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        mov     si , 3939                               ;

        cdecl itoa,  si , .s1 , 8 , 10 , 0b0001         ; "    3939"
        cdecl puts, .s1                                 ;

        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; 再起動
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        cdecl reboot                                    ; //戻ってこない

        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; 処理の終了
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        jmp     $                                       ; 繰り返し

        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; データ
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.s0     db  "Booting..." , 0x0A , 0x0D , 0              ;
.s1     db  "--------"   , 0x0A , 0x0D , 0              ;

        align       2       , db 0                      ;
BOOT:
        .DRIVE:
            dw      0x0000                              ; ドライブ番号

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    %include "/home/m8ku/prog/src/modules/real/puts.asm"
    %include "/home/m8ku/prog/src/modules/real/itoa.asm"
    %include "/home/m8ku/prog/src/modules/real/reboot.asm"

        times 510 - ($ - $$) db 0x00                    ; IPL領域を浸す
        db      0x55 , 0xAA                             ; 0x55 0xAA


; 関数の概要(はじめに実行されるブートプログラムです)
; reboot関数の動作確認です、特に引数などもないのでスタック操作はしません
