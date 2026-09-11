        .data
vetor:        .word32     1,3,5,7,9,11,13,14
tamanho:      .word       8
valor_chave:  .word       3
achou:        .asciiz     "O numero buscado foi encontrado!\n"
nao_achou:    .asciiz     "O numero buscado nao foi encontrado!\n"
params_sys5:  .space 8


        .code

addi $s0, $zero, 0          ;adiciona 0 ao registrador $s0 -> (inicio) $s0 = 0

addi $t1, $zero, 0          ;armazena no registrador $s1 a posicao da label  
lb $s1, tamanho($t1)        ;carrega em $s1 o valor da label na posicao -> ($s1 = tamanho do vetor)

addi $t1, $zero, 1          ;adiciona 1 ao registrador temporario $t1
sub $s1, $s1, $t1           ;efetua a subtracao do registrador $s1 com $t1, obtendo assim o indice que representa o fim do vetor -> (fim) $s1 = tam-1

addi $t1, $zero, 2          ;adiciona 2 ao registrador temporario $t1
div $s1, $t2                ;divide o (tamanho-1) por 2 para obter o meio do vetor ((tamanho-1)/2)

MFLO $s2                    ;adiciona ao registrador $s2 o conteudo do registrador LO -> (meio) $s2 = fim/2

addi $t1, $zero, 0          ;armazena no registrador $t1 a posicao da label
lb $s3 ,valor_chave($t1)    ;carrega em $s3 o valor da label na posicao $t1 -> ($s3 = valor_chave)

j loop			    ;entra no loop principal onde ira executar a busca binaria

loop:		            ;imediato que realiza o loop principal
addi $t1, $zero, 4	    ;adiciona 4 ao registrador temporário $t1
mult $s2, $t1 		    ;multiplico o conteúdo do registrador $t1 por $s2 (meio = 4*meio)
MFLO $t1		    ;coloco o resultado da multiplicação no registrador temporário $t1 (é a posição de onde está o elemento que quero na label "vetor")

lb $s4, vetor($t1)          ;coloca no registrador $s4 o valor do indice guardado em $t1 -> (vetor[meio])
sub $t1, $s4, $s3           ;subtraio $s3 de $s4 e coloco em $s5 ->($s5 = vetor[meio] - chave)
sub $t2, $s3, $s4           ;subtraio $s4 de $s3 e coloco em $s6 ->($s6 = chave - vetor[meio])
sub $t3, $s0, $s1           ;subtraio $s0 de $S1 e coloco em $t4 ->($t4 = inicio - fim)

beqz $t1, igual             ;vetor[meio] == chave
beqz $t3, nao_tem           ;caso o fim == inicio
bgez $t3, nao_tem           ;caso o fim < inicio
bgez $t1, maior_vet_ch      ;se vetor[meio] > chave
bgez $t2, menor_vet_ch      ;se vetor[meio] < chave


maior_vet_ch:               ;imediato para quando vetor [meio] > chave
add $s1, $zero, $s2         ;$s1 = $s2 -> (fim = meio)
addi $t1, $zero, 1          ;adiciono 1 ao registrador temporario $t1
sub $s1, $s1, $t1           ;fim = meio-1
add $s2, $s0, $s1           ;$s2 = $s0 + $s1 -> meio = (fim+inicio)
addi $t1, $zero, 2          ;adiciono 2 ao $t2
div $s2, $t1                ;divide meio por 2
MFLO $s2                    ;armazena o resultado da divisao em $s2
j loop


menor_vet_ch:               ;imediato quando vetor [meio] < chave
addi $s0, $s2, 1            ;$s0 = $s2 + 1 -> (inicio = meio + 1)
add $s2, $s0, $s1           ;$s2 = $s0 + $s1 -> (meio = inicio + fim)
addi $t1, $zero, 2          ;adiciono 2 ao registrador temporário $t1
div $s2, $t1                ;divide meio por 2
MFLO $s2                    ;armazena o resultado da divisao em $s2
j loop

igual:                      ;imediato para quando for igual eu pulo para o imediato "printar" utilizando a label "achou"
daddi $a1, $zero, achou
j printar

nao_tem: 		    ;imediato para quando nao houver o elemento ele pula para o imediato "printar" utilizando a label "nao_achou"
daddi $a1, $zero, nao_achou
j printar

printar:                    ;imediato que recebe um argumento e printa uma string
sw $a1, params_sys5($zero)  
daddi $t6, $zero, params_sys5
syscall 5
syscall 0



