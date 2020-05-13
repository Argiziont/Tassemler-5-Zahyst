 .MODEL SMALL
 .STACK 100H

 .DATA
    PROMPT    DB  'Array 4x6 : ',0DH,0AH,'$'
    NewLine   db      0Dh, 0Ah, '$'
    SpaceLine   db       ' $'
    ZeroOut   db      0Dh, 0Ah, 'Number of zeros $'
    MaxElMsg     db      0Dh, 0Ah, 'Max element $'
    IndexOfMax     db      0Dh, 0Ah, 'Max element Position $'
    StringSums     db      0Dh, 0Ah, 'Sums of Rows $'
    ARRAY   dw 1,3,3,8
        dw 7,5,6,7
        dw 0,9,0 ,3
        dw 10,1,17,8
        dw 1,1,16 ,0
        dw 8,9,10 ,7   
        
    M       dw 6
    N       dw 4
    zeros   dw 0
    maxEl   dw 0
    maxIndex dw 0
    tmpsum  dw 0
    curpos  dw 0
    currow  dw 0
    ARRAY1D   dw 0,0,0,0,0,0
    tmpForArr dw 0
    i         dw 0
    j         dw 0
    nsz         equ 8 ;????????? ????????? ? ??????, ??????? ? 0
    tmp dw 0 ;?????? ??? ?????? ? ???????
    
    FistRowIndx dw 0
    SecondRowIndx dw 2
    

.CODE
MAIN PROC
        MOV     AX, @DATA   
        MOV     DS, AX

        call     OutArr
        call     CountZeros
        mov      ah,     09h
        mov      ax,    zeros
        call     ShowNumb
        call     FindMax
        mov      ah,     09h
        mov      ax,    maxEl
        call     ShowNumb
        LEA     dx,IndexOfMax
        mov     ah,     09h
        int     21h
        mov      ah,     09h
        mov      ax,    maxIndex
        inc     ax
        call     ShowNumb
        LEA     dx,StringSums
        mov     ah,     09h
        int     21h
        call     Sumstring
        mov      ah,     09h
        mov      ax,    curpos
        call     ShowNumb
        call     MainSort
        call     OutArr

        
        MOV     AH, 4CH                  
        INT     21H
MAIN ENDP




OUTDEC PROC

        PUSH    BX                        
        PUSH    CX                       
        PUSH    DX                      

        XOR     CX, CX                    
        MOV     BX, 10                     

OUTPUT:                      
        XOR     DX, DX                  
        DIV     BX                       
        PUSH    DX                      
        INC     CX                      
        OR      AX, AX                   
        JNE     OUTPUT                   

        MOV     AH, 2                   

        DISPLAY:                    
        POP     DX                      
        OR      DL, 30H                  
        INT     21H                     
        LOOP    DISPLAY                 

        POP     DX                     
        POP     CX                       
        POP     BX                      
        RET                            
OUTDEC ENDP


ShowNumb proc
        push    ax
        push    bx
        push    cx
        push    dx
        push    di
 
               aam
        add     ax,     '00'
        mov     dl,     ah
        mov     dh,     al
        mov     ah,     02h
        int     21h
        mov     dl,     dh
        int     21h  
 
        pop     di
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        ret
ShowNumb endp


Sumstring proc
        push    ax
        push    bx
        push    cx
        push    dx
        push    di
 
        mov     cx,0
        xor     dx,dx
        
Lexxxxchangee:

        Mov     bx,cx 
        Shl     bx,1 
        Mov     ax,ARRAY[bx] 
            
        add     tmpsum,ax
        add     curpos,1
        cmp     curpos,3
        jle     cycleend
sumsum:
        mov     curpos,0
        mov     bx,currow
        Shl     bx,1 
        mov     ax,tmpsum
        mov     ARRAY1D[bx],ax
        add     currow,1
        mov     ah,     09h
        mov     ax,    tmpsum
        call    ShowNumb
        LEA     dx,SpaceLine
        mov     ah,     09h
        int     21h        
        mov     tmpsum,0
        
cycleend:       
        inc     cx
        cmp     cx,23
        jle     Lexxxxchangee
        
        ;mov      ah,     09h
        ;mov      ax,    curpos
        ;call     ShowNumb
        ;int     21h
 
        pop     di
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        ret
Sumstring endp

CountZeros proc
        push    ax
        push    bx
        push    cx
        push    dx
        push    di
 
        mov     cx,24
        xor     dx,dx
Lexchange:


        Mov     bx,cx 
        Shl     bx,1 
        Mov     ax,ARRAY[bx] 

        cmp     ax,0
        jne     CycleE
        inc     dx


CycleE:
        dec     cx
        jge     Lexchange

        mov     zeros, dx
        LEA     dx,ZeroOut
        mov     ah,     09h
        int     21h
 
        pop     di
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        ret
CountZeros endp



SwapLines proc
        push    ax
        push    bx
        push    cx
        push    dx
        push    di
 
        mov     cx,4
        
        mov     ax,4
        mul     FistRowIndx
        mov     FistRowIndx,ax
        mov     ax,4
        mul     SecondRowIndx
        mov     SecondRowIndx,ax
        
ChangeCcycle:        
        Mov     bx,FistRowIndx 
        Shl     bx,1 
        Mov     ax,ARRAY[bx] 
        mov     tmpForArr,ax
        Mov     bx,SecondRowIndx 
        Shl     bx,1      
        Mov     ax,ARRAY[bx]
        Mov     bx,FistRowIndx 
        Shl     bx,1 
        Mov     ARRAY[bx], ax
        Mov     bx,SecondRowIndx 
        Shl     bx,1
        mov     ax,tmpForArr
        Mov     ARRAY[bx],ax
        
        inc     FistRowIndx
        inc     SecondRowIndx
        loop    ChangeCcycle
 
        pop     di
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        ret
SwapLines endp

MainSort proc
        push    ax
        push    bx
        push    cx
        push    dx
        push    di
 
        Mov     i,0             ;????????????? i
                                ;?????????? ???? ?? j
internal:
        mov     j,6              ;????????????? j
        jmp     cycl_j          ;??????? ?? ???? ?????
exchange:
        mov     bx,i            ;bx=i
        shl     bx,1
        mov     ax,ARRAY1D[bx]  ;ax=array[i]
        mov     bx,j            ;bx=j
        shl     bx,1
        cmp     ax,ARRAY1D[bx]  ;array[i] ? array[j] - ?????????? ?????????
        jle     lesser          ;???? array[i] ?????, ?? ????? ?? ????????? ?
                                ;??????? ?? ?????????? ???? ?? ??????
                                ;?????? tmp=array[i], array[i]=array[j],
                                ;array[j]=tmp: tmp=array[i]
        Mov     bx,i                        
        Mov     FistRowIndx,bx
        Mov     bx,j                        
        Mov     SecondRowIndx,bx
        call    SwapLines        
                                
                                
        Mov     bx,i            ;bx=i
        Shl     bx,1            ;??????? ?? 2, ???????? ???????? - ?????
        Mov     tmp,ax          ;tmp=array[i]
                                ;array[i]=array[j]
        Mov     bx,j            ;bx=j
        Shl     bx,1            ;??????? ?? 2, ???????? ???????? - ?????
        Mov     ax,ARRAY1D[bx]  ;ax=array[j]
        
        Mov     bx,i            ;bx=i
        Shl     bx,1            ;??????? ?? 2, ???????? ???????? - ?????       
        Mov     ARRAY1D[bx],ax  ;array[i]=array[j]
                                ;array[j]=tmp
        Mov     bx,j            ;bx=j
        Shl     bx,1            ;??????? ?? 2, ???????? ???????? - ?????
        Mov     ax,tmp          ;ax=tmp
        Mov     ARRAY1D[bx],ax ;array[j]=tmp
        
lesser:                         ;?????????? ???? ?? ?????? ? ???????????? ?????
        dec     j               ;j--
cycl_j:                         ;???? ????? ?? j
        mov     ax,j            ;ax=j
        cmp     ax,i            ; ????????? j ? i
        jg      exchange
                                ;???? j>i, ?? ??????? ?? ?????
                                ;?????? ?? ????????? ???? ?? i
        Inc     i               ;i++
        Cmp     i,nsz             ;????????? i ? n - ??????? ?? ????? ??????
        jl      internal
 
        pop     di
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        ret
MainSort endp


FindMax proc
        push    ax
        push    bx
        push    cx
        push    dx
        push    di
 
        mov     cx,24
        xor     dx,dx
Lexxchange:


        Mov     bx,cx 
        Shl     bx,1 
        Mov     ax,ARRAY[bx] 

        cmp     ax,maxEl
        jl      CycleEE
ChangeMax:
        mov     maxEl,ax      
        mov     maxIndex,cx

CycleEE:
        dec     cx
        cmp     cx,0
        jge     Lexxchange
        
        LEA     dx,MaxElMsg
        mov     ah,     09h
        int     21h
        
        
 
        pop     di
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        ret
FindMax endp



OutArr proc
        push    ax
        push    bx
        push    cx
        push    dx
        push    di
 
        LEA     dx,NewLine
        mov     ah,     09h
        int     21h
        LEA     DX, PROMPT         
        MOV     AH, 9
        INT     21H

        LEA     SI, ARRAY          
        MOV     CX, 6             

LOOP_1:                   
        MOV     BX, 4                  

        LOOP_2:                   
            MOV     AH, 2               
            MOV     DL, 20H             
            INT     21H                  

            MOV     AX, [SI]           

            CALL    OUTDEC             

            ADD     SI, 2               
            DEC     BX                 
            JNZ     LOOP_2             

        MOV     AH, 2                
        MOV     DL, 0DH               
        INT     21H                   

        MOV     DL, 0AH               
        INT     21H                    
        LOOP    LOOP_1   
 
        pop     di
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        ret
OutArr endp


 END MAIN