//sudoku 9x9
.data
k: .long 0
res: .space 4
index: .space 4
chDelim: .asciz " \n"
formatPrintf: .asciz "%d "
formatPrintfstr : .asciz "%s"
formatPrintfnot : .asciz "-%d \n"
newline: .asciz "\n"
v: .space 1000
l: .space 1000
name: .asciz "file.in"
name_out: .asciz "file.out"
str: .space 1000
fd: .long 0
fdout: .long 0
indice_output: .long 0
temporar: .space 1000
no_solution: .asciz "Nu exista solutie \n"



.text
afisare:
//fara argumente
pushl %ebp
movl %esp, %ebp
movl $0,k
xorl %ecx, %ecx
movl $81, %edx


eticheta_for_afisare:
movl $v, %edi
movl (%edi, %ecx, 4),%eax

pushl %ecx
pushl %edx

pushl %eax
pushl $formatPrintf
call printf
popl %ebx
popl %ebx

pushl $0
call fflush
popl %ebx

movl k, %ebx
cmp $8, %ebx
jne rev
movl $-1,k

pushl $newline
pushl $formatPrintfstr
call printf
popl %ebx
popl %ebx

pushl $0
call fflush
popl %ebx

rev:
popl %edx
popl %ecx

incl %ecx
addl $1, k
cmp %ecx, %edx
je final_afisare
jmp eticheta_for_afisare

final_afisare:
popl %ebp
ret

rezolva_sudoku:
pushl %ebp
movl %esp, %ebp
//ia 2 arumente rezolva_sudoku(linie,coloana)
cmp $8, 8(%ebp)
je and_if
jne second_if

and_if:
cmp $9, 12(%ebp)
je eticheta_true

second_if:
cmp $9, 12(%ebp)
je incepe_linie_noua
jne third_if

incepe_linie_noua:
addl $1, 8(%ebp)
movl $0, 12(%ebp)

third_if:
movl 8(%ebp), %eax
xorl %edx, %edx
movl $9, %ebx
mull %ebx
addl 12(%ebp), %eax
movl $v, %edi
movl (%edi, %eax,4), %ebx
cmp $0, %ebx
jle for_sudoku
jg next_sudoku

next_sudoku:
//pun din v in l si in l voi avea solutia
addl $1, 12(%ebp)
pushl 12(%ebp)
pushl 8(%ebp)
call rezolva_sudoku
popl %ebx
popl %ebx

jmp final

for_sudoku:

pushl $1
//punem num la -4(%ebp)
for_loop:

pushl -4(%ebp)
pushl 12(%ebp)
pushl 8(%ebp)
call e_corecta
popl %ebx 
popl %ebx
popl %ebx


cmp $1, %eax
je punem_valoarea
jne pune_0

punem_valoarea:
movl 8(%ebp), %eax
xorl %edx, %edx
movl $9, %ebx
mull %ebx
addl 12(%ebp), %eax
movl $v, %edi
movl -4(%ebp),%ebx
movl %ebx, (%edi, %eax,4)


verifica_urm:

movl 12(%ebp), %ebx
addl $1, %ebx
pushl %ebx
pushl 8(%ebp)
call rezolva_sudoku
popl %ebx
popl %ebx


cmp $1, %eax
je eticheta_true_pop


pune_0:
movl 8(%ebp), %eax
xorl %edx, %edx
movl $9, %ebx
mull %ebx
addl 12(%ebp), %eax
movl $v, %edi
movl $0,(%edi, %eax,4)

next:
incl -4(%ebp)
cmp $9, -4(%ebp)
jle for_loop
jg eticheta_false_pop


eticheta_true:
movl $1, %eax
jmp final

eticheta_true_pop:
popl %ebx
movl $1, %eax
jmp final

eticheta_false:
xorl %eax, %eax
jmp final

eticheta_false_pop:
popl %ebx
xorl %eax, %eax
jmp final

final:
popl %ebp
ret

e_corecta:
// ia 3 parametrii : linie, coloana, numarul intre1 si 9 pe care vrem sa il punem
pushl %ebp
movl %esp, %ebp

// 8 %ebp - linie, 12 ebp -- coloana, 16(%ebp)-- numarul de verif
// verific pt linie
xorl %ecx, %ecx
for_linie:
movl 8(%ebp), %eax
xorl %edx, %edx
movl $9, %ebx
mull %ebx
addl %ecx, %eax
movl $v, %edi
movl (%edi, %eax,4), %ebx
cmp %ebx, 16(%ebp)
je false
incl %ecx
cmp $8, %ecx
jle for_linie

// verific pt coloana 
xorl %ecx, %ecx
for_coloana:
movl %ecx, %eax
xorl %edx, %edx
movl $9, %ebx
mull %ebx
addl 12(%ebp), %eax
movl $v, %edi
movl (%edi, %eax,4), %ebx
cmp %ebx, 16(%ebp)
je false
incl %ecx
cmp $8, %ecx
jle for_coloana

//fac variabile locale
movl 8(%ebp), %eax
xorl %edx, %edx
movl $3, %ebx
divl %ebx
movl 8(%ebp), %ebx
subl %edx, %ebx
// acuma am ebx = linie-linie%3
pushl %ebx
//il pun la -4(%ebp)
movl 12(%ebp), %eax
xorl %edx, %edx
movl $3, %ebx
divl %ebx
movl 12(%ebp), %ebx
subl %edx, %ebx
pushl %ebx
//il pun la -8(%ebp)
//ecx= i, edx=j
xorl %ecx, %ecx
xorl %edx, %edx


for_casuta:

for_in_for:

movl -4(%ebp), %eax
addl %ecx, %eax

pushl %edx
xorl %edx, %edx
movl $9, %ebx
mull %ebx
popl %edx

movl -8(%ebp), %ebx
addl %edx, %ebx
addl %ebx, %eax

movl $v, %edi
movl (%edi, %eax,4), %ebx
cmp 16(%ebp), %ebx
je scoate_depe_stiva_fals

incl %edx
cmp $3, %edx
jl for_in_for
jge j_0

j_0:
xorl %edx, %edx

incl %ecx
cmp $3, %ecx
jl for_casuta
jge scoate_depe_stiva

scoate_depe_stiva:
popl %ebx
popl %ebx
jmp true

scoate_depe_stiva_fals:
popl %ebx
popl %ebx
jmp false

false:
xorl %eax, %eax
jmp final

true:
movl $1, %eax
jmp final


final_e_corecta:
popl %ebp
ret

.global main

main:
//cititre din fisier
//open file
movl $5, %eax
movl $name, %ebx
movl $0, %ecx
movl $0777, %edx
int $0x80

movl %eax, fd

//read from file
movl $3, %eax
movl fd, %ebx
movl $str, %ecx
movl $1000, %edx
int $0x80

//close file
movl $6, %eax
movl $name, %ebx
int $0x80





///tb sa pun in vector
xorl %ecx, %ecx
movl $0, index
movl $v, %esi

pushl $chDelim
pushl $str
call strtok
popl %ebx
popl %ebx

cmp $0,%eax
je incepe_rezolvare

movl %eax, res

pushl res
call atoi
popl %ebx

movl %eax, (%esi, %ecx, 4)



incl %ecx
addl $1, index

et_for:
pushl $chDelim
pushl $0
call strtok
popl %ebx
popl %ebx

cmp $0,%eax
je incepe_rezolvare

movl %eax, res

pushl res
call atoi
popl %ebx


movl index, %ecx
movl %eax, (%esi,%ecx,4)
addl $1,index
incl %ecx

cmp $81, %ecx
jl et_for
jge incepe_rezolvare



//
incepe_rezolvare:

pushl $0
pushl $0
call rezolva_sudoku
popl %ebx
popl %ebx


cmp $1, %eax
je eticheta
//inseamna ca nu avem solutie
//create file
mov  $8, %eax
mov  $name_out, %ebx
mov  $0777, %ecx        
int  $0x80 

//open file
movl $5, %eax
movl $name_out, %ebx
movl $1, %ecx
movl $0777, %edx
int $0x80

movl %eax, fdout

//write in the file
movl $4, %eax
movl fdout, %ebx
movl $no_solution, %ecx
movl $19, %edx
int $0x80


//close the file
movl $6, %eax
movl fdout, %ebx
int $0x80

pushl $no_solution
pushl $formatPrintfstr
call printf
popl %ebx
popl %ebx

jmp exit

eticheta:

//tb scris in fisier
movl $v, %edi


movl $temporar, %esi
xorl %ecx, %ecx
movl %ecx, k

for_temporar:

movl (%edi, %ecx, 4),%eax


movl indice_output, %ebx
addb $48, %al
movb %al, (%esi,%ebx,1)
addl $1, indice_output
incl %ebx
movb $32, (%esi, %ebx, 1)
addl $1, indice_output
incl %ebx
addl $1, k



cmp $9, k
jl urm_pas
movl $0, k
//tb sa pun un newline
movl indice_output, %ebx
movb $13, (%esi, %ebx, 1)
addl $1, indice_output

movl indice_output, %ebx
movb $10, (%esi, %ebx, 1)
addl $1, indice_output

urm_pas:
incl %ecx
cmp $81, %ecx
je urm
jne for_temporar





urm:



movl indice_output, %ebx
movb $10, (%esi, %ebx, 1)
addl $1, indice_output

movl indice_output, %ebx
movb $0, (%esi, %ebx, 1)
addl $1, indice_output





//create file
mov  $8, %eax
mov  $name_out, %ebx
mov  $0777, %ecx        
int  $0x80 

//open file
movl $5, %eax
movl $name_out, %ebx
movl $1, %ecx
movl $0777, %edx
int $0x80

movl %eax, fdout

//write in the file
movl $4, %eax
movl fdout, %ebx
movl $temporar, %ecx
movl $181, %edx
int $0x80


//close the file
movl $6, %eax
movl fdout, %ebx
int $0x80


call afisare



exit:
movl $1, %eax  
xorl %ebx,%ebx    
int $0x80