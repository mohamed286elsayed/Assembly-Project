.model small 
.stack 100h  ; increase stack size
.data

    entrymsg db "                   This program implements search algorithms","$"
    entry2msg db "                             ( Linear , Binary )","$"
    firstmsg db "choose operation : ","$"
    secondmsg db "1) linear search ","$"
    thirdmsg db "2) Binary search  ","$"
    firstmsgchoice db ? ;choosing linear or binary search
    arraysizemsg db "Enter the size of the array : ","$"
    size dw 0 ;receives the array size
    sizemsg  db "Enter the elements : " ,"$"
    arr db 100 dup(?) ;actual array
    targetmsg db "Enter the desired number : ","$"
    target db ? ;taking the key
    errormsg db " Number is not found ","$"
    space db " ","$"
    FOUND_INDEX db -1 
    sum db 0
    msg_found db "Number is found at the index : ","$"
    msg_not_found db "Number is not found ","$"
    seeifmsg db "See if ","$"
    isequaltomsg db " Is equal to ","$"
    isnotequaltomsg db " is not equal to ","$"
    binaryarraymsg db "Please enter a sorted numbers : ","$"
    midnummsg db "The middle entry is  : ","$"
    greaterorequalmsg db " Is >= ","$"
    notgreaterorequalmsg db " Is not >= ","$"
    sourcemsg db "first element = ","$"
    
    destinationmsg db "last element = ","$"
    
    incsimsg db "Increment source ","$"
    
    decdimsg db "Decrement destination ","$"
   
.code
    main proc far
        .startup
          lea dx,entrymsg
          mov ah,09h
          int 21h
          call newline
          
          lea dx,entry2msg
          mov ah,09h
          int 21h
          call newline
          call newline
          
          lea dx,firstmsg
          mov ah,09h
          int 21h
          call newline
          
          lea dx,secondmsg
          mov ah,09h
          int 21h
          call newline
          
          lea dx,thirdmsg
          mov ah,09h
          int 21h
          call newline
       
       
          call newline
           mov ah,01h         ;reading the choice (linear / binary) and stores it in the AL register
           int 21h
           sub al,48
           mov firstmsgchoice,al
           
           call newline
           
           cmp firstmsgchoice,1 ;the compare statement
           je l                 ;if (linear search)
           cmp firstmsgchoice,2 
           jmp far ptr b                 ;if (binary search)  
        l:
           lea dx,arraysizemsg
           mov ah,09h
           int 21h
           
           mov ah,1           ;reading the array size
           int 21h
           sub al,48
           mov ah,0
           mov size,ax          ;storing the array size in (size) variable
           call newline
           
           lea dx,sizemsg       ;asking the user to enter the array
           mov ah,09h
           int 21h
           call newline
           mov cx,size
           mov bx,0
           storingVal:         ;reading the array
                mov ah,1
                int 21h
                sub al,48
                mov arr[bx],al
                ;  push ax
                add sum,al
                inc bx
                
                lea dx,space
                mov ah,09h
                int 21h
                loop storingVal
                call newline
                
                lea dx,targetmsg  ;asking the user to enter the key
                mov ah,09h
                int 21h
                
                mov ah,1          ;taking the key from user      
                int 21h
                sub al,48
                mov target , al
                
                mov cx,size        
                lea bx,arr
                mov si,0
                mov dx,0
                call newline
                
            Lable1:
                mov al,[bx+si]     ;searching the array for the key
                
                lea dx,seeifmsg
                mov ah,09h
                int 21h
                
                mov dl,al
                add dl,48
                mov ah,02h
                int 21h
                
                lea dx,isequaltomsg
                mov ah,09h
                int 21h
                
                mov dl,target
                add dl,48
                mov ah,02h
                int 21h
                
                call newline
                mov al,[bx+si]
                
                cmp al,target 
                je found
                
                mov dl,al
                add dl,48
                mov ah,02h
                int 21h
                
                lea dx,isnotequaltomsg
                mov ah,09h
                int 21h
                
                mov dl,target
                add dl,48
                mov ah,02h
                int 21h
                
                call newline
                call newline
                inc si
                loop Lable1
                
                not_found:               ;if the key is not found
                lea dx,msg_not_found
                mov ah,09h
                int 21h
                jmp quit
                call newline
                
                found:                   ;if the key found
                
                mov dl,target
                add dl,48
                mov ah,02h
                int 21h
                
                lea dx,isequaltomsg
                mov ah,09h
                int 21h
                
                mov dl,target
                add dl,48
                mov ah,02h
                int 21h
                
                call newline
                
                lea dx,msg_found
                mov ah,09h
                int 21h
                
                mov ax,si                ;displaying the key index
                MOV FOUND_INDEX, Al
                
                mov dl,FOUND_INDEX
                add dl,48
                mov ah,02h
                int 21h

                jmp quit
                call newline
                
                
            jmp quit
        b:

            lea dx, arraysizemsg
            mov ah, 09h
            int 21h

            mov ah, 1            ; reading the array size
            int 21h
            sub al, 48
            mov ah, 0
            mov size, ax          ; storing the array size in (size) variable

            call newline

            lea dx, binaryarraymsg       ; asking the user to enter the array (sorted)
            mov ah, 09h
            int 21h

            mov cx, size
            mov bx, 0

            ; Read the array
        readArray:
                mov ah, 1
                int 21h
                sub al, 48
                cmp al, 13 ; Check if it's the enter key
                je readArrayDone
                mov arr[bx], al
                inc bx
                lea dx,space
                mov ah,09h
                int 21h
                loop readArray
            readArrayDone:

            
            call newline    
                
            lea dx, targetmsg  ; asking the user to enter the key
            mov ah, 09h
            int 21h

            mov ah, 01h          ; taking the key from the user
            int 21h
            sub al, 48
            mov target, al

            call newline
            
            mov si, 0
            sub size,1
            mov di, size
            mov al, target

    call binarySearch ; Call binary search function
               
quit:
    .exit
main endp
  
no:
    

newline proc near
    mov dl,10
    mov ah,02h
    int 21h
    ret
    newline endp
    
    binarySearch proc near
    
    cmp si,di
    jg binarySearch_not_found   ; If start index > end index, the value is not found
    
    push di
    pop ax
    add ax,48
    mov dl,al
    
    mov ah,02h
    int 21h
    
    lea dx,greaterorequalmsg
    mov ah,09h
    int 21h
    
    push si
    pop ax
    add ax,48
    mov dl,al
    
    mov ah,02h
    int 21h
    
    call newline
    call newline
    
    lea dx,sourcemsg
    mov ah,09h
    int 21h
    
    call source
    call newline
    
    lea dx,destinationmsg
    mov ah,09h
    int 21h
    
    call destination
    call newline

    mov bx, si                   ; Calculate the middle index
    add bx, di
    shr bx, 1                    ; Divide by 2
    
    mov ah, arr[bx]           ; Load the middle element in ah
    
    lea dx,midnummsg
    mov ah,09h
    int 21h
    
    mov ah,arr[bx]
    add ah,48
    mov dl,ah
    mov ah,02h
    int 21h             ;---------------->printing the mid index
    
    call newline
    
   
    
    call newline
    
    mov ah, arr[bx]
    mov al,target
    cmp al,ah
    je binarySearch_found       ; If middle element is equal to the target value, it's found
    
    jl binarySearch_left        ; If middle element > target value, search in the left half
    
    jg binarySearch_right      ; If middle element < target value, search in the right half
    
    
    binarySearch_not_found:
        
        push di
        pop ax
        add ax,48
        mov dl,al
        
        mov ah,02h
        int 21h
        
        lea dx,notgreaterorequalmsg
        mov ah,09h
        int 21h
        
        push si
        pop ax
        add ax,48
        mov dl,al
        
        mov ah,02h
        int 21h
        
        call newline
        
        lea dx,errormsg                   ; If the value is not found, 
        mov ah,09h
        int 21h
        
        jmp no
    
    
    
    binarySearch_left:
        
        
        lea dx,decdimsg
        mov ah,09h
        int 21h
        call newline
        mov di, bx                   ; Recursively search in the left half
        dec di                       ; Set end index to middle - 1
        call binarySearch
         
        jmp no
    binarySearch_right:
        lea dx,incsimsg
        mov ah,09h
        int 21h
        call newline
        mov si, bx                   ; Recursively search in the right half
        inc si                       ; Set start index to middle + 1
        call binarySearch
        
        jmp no
    binarySearch_found:
        lea dx,msg_found                   ; If the value is found, return the index 
        mov ah,09h
        int 21h
        
        mov ax,bx
        
        mov FOUND_INDEX,al
        mov dl,FOUND_INDEX
        add dl,48
        mov ah,02h
        int 21h
        
        jmp no
    
    ret
binarySearch endp

source proc near
    push si
    pop ax
    inc ax
    add ax,48
    mov dl,al
    
    mov ah,02h
    int 21h
    ret
    source endp
    
destination proc near
    push di
    pop ax
    inc ax
    add ax,48
    mov dl,al
    
    mov ah,02h
    int 21h
    
    
    ret
destination endp    

  
end main