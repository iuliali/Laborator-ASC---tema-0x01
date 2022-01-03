.data 
n: .long 0
m: .long 0
k: .long 0
q: .long 0
l: .space 1000
v: .space 1000
atoiRes: .long 0
res: .space 4
index: .space 4
str: .space 100
chDelim: .asciz " "
formatPrintf: .asciz "%d "
formatPrintfstr : .asciz "%s"
formatPrintfnot : .asciz "-%d \n"
newline: .asciz "\n"
formatScanf: .asciz "%[0 1 2 3 4 5 6 7 8 9]"

.text
afisare:
//fara argumente
pushl %ebp
movl %esp, %ebp

xorl %ecx, %ecx
movl n, %edx
addl n, %edx
addl n, %edx


xorl %ecx, %ecx
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


popl %edx
popl %ecx

incl %ecx

cmp %ecx, %edx
je final_afisare
jmp eticheta_for_afisare

final_afisare:
pushl $newline
pushl $formatPrintfstr
call printf
popl %ebx
popl %ebx

popl %ebp
ret


verificare:
//ia ca parametru k
pushl %ebp
movl %esp, %ebp
movl $v, %edi
movl 8(%ebp), %ebx 



cmp $0, %ebx
je eticheta_da

pushl $0
pushl $-1
//poz -- -8(%ebp)
//nra-- -4(%ebp)

xorl %ecx, %ecx
//4 1 1 2 0 2 1 3 4 3 4 1 3 4
for_verificare:
movl 8(%ebp), %ebx 
//v[i]
movl (%edi, %ecx,4), %eax
//v[k]
movl (%edi, %ebx,4), %edx

cmp %eax, %edx
je if_for_verif
jne revenire

revenire:
incl %ecx
cmp %ecx, 8(%ebp)
je primul_if_dinafara
jg for_verificare

if_for_verif:
movl %ecx, -8(%ebp)
addl $1, -4(%ebp)
jmp revenire


primul_if_dinafara:
//scot poz de pe stiva care era la -8(%ebp)
popl %edx
cmp $-1, %edx
je eticheta_da1
jne al_doilea_if_dinafara


al_doilea_if_dinafara:
movl 8(%ebp), %ebx
subl %edx, %ebx

// k-poz>m
cmp m, %ebx
jle eticheta_nu1
jg if_in_if


if_in_if:
//scot si nra de pe stiva
popl %ebx
cmp $3, %ebx
jge eticheta_nu
jl eticheta_da

eticheta_da1:
movl $1, %eax
popl %edx
jmp final_verificare

eticheta_da:
movl $1, %eax
jmp final_verificare

eticheta_nu:
xorl %eax, %eax
jmp final_verificare


eticheta_nu1:
xorl %eax, %eax
popl %edx

final_verificare:
popl %ebp
ret

backtracking:
//tb sa ia ca parametru k 
pushl %ebp
movl %esp, %ebp
movl $v, %edi
movl $l, %esi
movl 8(%ebp), %ebx 


movl (%esi, %ebx,4), %eax
cmp $0, %eax
jne este_diferit_de_zero
je este_zero_else

este_zero_else:
//for i=1, i<n-- de ex de la 1 pana la 5
movl $1, %ecx
movl n, %edx
movl 8(%ebp), %ebx

for_bkt:
movl 8(%ebp), %ebx
movl %ecx, (%edi, %ebx, 4)


pushl %ecx

pushl %ebx
call verificare
popl %edx

popl %ecx



cmp $1, %eax
je daca_suntem_la_capat0
jne pas_urmator_for

daca_suntem_la_capat0:
// tb sa verif daca suntem la capat si daca da : afisare + exit, daca nu bkt(k+1)

movl 8(%ebp), %ebx

movl n, %edx
addl n, %edx
addl n, %edx
subl $1, %edx
cmp %ebx, %edx
jne pas_urm_bkt0
addl $1, q
call afisare
jmp exit 

pas_urm_bkt0:
movl 8(%ebp) ,%ebx
incl %ebx

pushl %ecx

pushl %ebx
call backtracking
popl %edx

popl %ecx


pas_urmator_for:
incl %ecx
movl n, %edx
cmp %ecx, %edx
jge for_bkt
jl final_bkt

este_diferit_de_zero:
//v[k]=l[k] 
movl (%esi, %ebx,4),%eax
movl %eax, (%edi, %ebx, 4)
movl 8(%ebp), %ebx 

pushl %ecx

pushl %ebx
call verificare
popl %edx

popl %ecx

cmp $1, %eax
je daca_suntem_la_capat
jne final_bkt


daca_suntem_la_capat:
// tb sa verif daca suntem la capat si daca da : afisare + exit, daca nu bkt(k+1)
//asta trimite in backtracking de k +1 si cand se intoarce nu merge in for !! ci iese din bk 
movl 8(%ebp), %ebx

movl n, %edx
addl n, %edx
addl n, %edx
subl $1, %edx
cmp %ebx, %edx
jne pas_urm_bkt
addl $1, q
call afisare
jmp exit 

pas_urm_bkt:
movl 8(%ebp) ,%ebx
incl %ebx

pushl %ecx

pushl %ebx
call backtracking
popl %edx

popl %ecx

final_bkt:
popl %ebp
ret


.global main



main:

pushl $str
pushl $formatScanf
call scanf
popl %ebx
popl %ebx

pushl $chDelim
pushl $str
call strtok
popl %ebx
popl %ebx

movl %eax, res

pushl res
call atoi
popl %ebx

movl %eax, n



pushl $chDelim
pushl $0
call strtok
popl %ebx
popl %ebx

cmp $0,%eax
je bkt

movl %eax, res

pushl res
call atoi
popl %ebx

movl %eax, m



movl $l, %esi
movl $0, index

et_for:
pushl $chDelim
pushl $0
call strtok
popl %ebx
popl %ebx

cmp $0,%eax
je bkt

movl %eax, res

pushl res
call atoi
popl %ebx


movl index, %ecx
movl %eax, (%esi,%ecx,4)
addl $1,index
incl %ecx
movl n, %edx
addl n, %edx
addl n, %edx
cmp %ecx,%edx

je bkt


jmp et_for



bkt:

xorl %eax, %eax

pushl %eax
call backtracking
popl %ebx


exit:

movl q, %eax
cmp $0, %eax
je afiseaza_minus_unu
jne exit2

afiseaza_minus_unu:
pushl $1
pushl $formatPrintfnot
call printf
popl %ebx
popl %ebx


exit2:
pushl $0
call fflush
popl %ebx

movl $1, %eax  
xorl %ebx,%ebx    
int $0x80
