# Practica 4, Actividad 4.1: explicacion de la bomba

# CONTRASEÑA: abracadabra
# 	 PIN: 7777

# MODIFICADA: anonadado
#	 PIN: 7000

# Describe el proceso logico seguido
# primero: para descubrir las claves, y
# despues: para cambiarlas 

# Pensado para ejecutar mediante "source explain.gdb"
# o desde linea de comandos con gdb -q -x explain.gdb
# Renombrar temporalmente el fichero "bomba-gdb.gdb"
# para que no se cargue automat. al hacer "file bomba"

# funciona sobre la bomba original, para recompilarla
# usar la orden gcc en la primera linea de bomba.c
# gcc -Og bomba.c -o bomba -no-pie -fno-guess-branch-probability

########################################################

### cargar el programa
    file bomba
### util para la sesion interactiva, no para source/gdb -q -x
#   layout asm
#   layout regs
### arrancar programa, notar automatizacion para teclear hola y 123
    br main
    run < <(echo -e hola\\n1234\\n)
### hicimos ni hasta call boom, antes pide contraseña y tecleamos hola
### si entramos en boom explota y hay que empezar de nuevo
### la decision se toma antes, justo antes de call boom
### hay un jg que se salta la bomba, y el cmp anterior
### activaria ZF si el retorno de cmp produjera 0,
### es decir, cmp $0x3, %eax que el contenido de %eax es mayor al de $0x3
###0x4007b1 <main+86>      test   %rax,%rax                                                            │
#   0x4007b4 <main+89>      je     0x400785 <main+42>                                                   │
#   0x4007b6 <main+91>      lea    0x30(%rsp),%rdi                                                      │
#   0x4007bb <main+96>      callq  0x40071b <funcion>                                                   │
#   0x4007c0 <main+101>     cmp    $0x3,%eax                                                            │
#   0x4007c3 <main+104>     jg     0x4007ca <main+111> 
#   0x4007c5 <main+106>     callq  0x4006e7 <boom> 
### avancemos hasta cmp
##observamos que $0x3 vale 3 por tanto ponemos en eax un valor mayor a ese
    br *main+101
    set $eax=6
    
### siguiente bomba es por tiempo
#    0x4007d4 <main+121>     callq  0x4005b0 <gettimeofday@plt>                                          │
#    0x4007d9 <main+126>     mov    0x20(%rsp),%rax                                                      │
#    0x4007de <main+131>     sub    0x10(%rsp),%rax                                                      │
#    0x4007e3 <main+136>     cmp    $0x5,%rax                                                            │
#    0x4007e7 <main+140>     jle    0x4007ee <main+147>                                                  │
#    0x4007e9 <main+142>     callq  0x4006e7 <boom> 
### avanzar hasta el cmp
    br *main+136
    cont
### falsear tiempo=0 por si acaso se ha tardado en teclear
    set $rax=0

### siguiente bomba compara resultado scanf con variable de memoria
   #│0x400836 <main+219>     mov    0x20081c(%rip),%eax        # 0x601058 <passcode>                     │
   #│0x40083c <main+225>     cmp    %eax,0xc(%rsp)                                                       │
   #│0x400840 <main+229>     je     0x400847 <main+236>                                                  │
   #│0x400842 <main+231>     callq  0x4006e7 <boom>                                                      │
   #│0x400847 <main+236>     lea    0x10(%rsp),%rdi  
### avanzar hasta cmp para consultar valores
    br *main+225
    cont
### escribir "1234" cuando pida pin, resuelto ya en run
### imprimir el pin y recordar que esta en 0x601060 tipo int
#   p*(int*)0x601058
    p (int )passcode
### corregir sobre la marcha EAX para que cmp salga bien
    set $eax=1234
    ni
    ni
### siguiente bomba es por tiempo
   #0x400851 <main+246>             callq  0x4005b0 <gettimeofday@plt>                                  │
   #0x400856 <main+251>             mov    0x10(%rsp),%rax                                              │
   #0x40085b <main+256>             sub    0x20(%rsp),%rax                                              │
   #0x400860 <main+261>             cmp    $0x5,%rax                                                    │
   #0x400864 <main+265>             jle    0x40086b <main+272>                                          │
   #0x400866 <main+267>             callq  0x4006e7 <boom>                                              │
   #0x40086b <main+272>             callq  0x400701 <defused> 
### avanzar hasta el cmp
    br *main+261
    cont
### falsear tiempo=0 por si acaso se ha tardado en teclear
    set $rax=0
    ni
    ni
### hemos llegado a defused, fin del programa
    ni

########################################################

### permitir escribir en el ejecutable
    set write on
### reabrir ejecutable con permisos r/w
    file bomba
### realizar los cambios
    set {char[13]}0x601058="anonadado\n"
    set {int     }0x601060=7000
### comprobar las instrucciones cambiadas
    p (char[0xd])password
    p (int      )passcode
### salir para desbloquear el ejecutable
    quit

########################################################

