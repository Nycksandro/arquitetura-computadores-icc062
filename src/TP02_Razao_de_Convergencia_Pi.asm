		.data

string_PI:	         .asciiz       "O numero aproximado de PI eh: %i."
string_PI_fracao:        .asciiz       "%i"   
num_iteracoes:           .word32       33     ;numero de iterações desejadas	
var_double:              .double       1.0    ;valor base para os registradores tipo f
precisao_fracao:         .word32       5      ;número de casas decimais desejadas na saída
params_sys5:             .space 8
num_param:               .space 8

		.code
l.d f16, var_double($zero)	 ;adiciono 1.0 ao registrador f16 -> (incremento = 1.0)

add.d f17, f0, f16               ;adiciono 1.0 ao registrador de f17 -> (somatorio_PI = 1.0)

add.d f18, f17, f17      	 ;adiciono 2.0 ao registrador de f17 -> (i = 2.0)

add.d f19, f16, f18      	 ;adiciono 3.0 ao registrador de f18 -> (j = 3.0)

add.d f20, f18, f18      	 ;adiciono 4.0 ao registrador de f19 -> (k = 4.0)

add.d f21, f0, f20               ;adiciono 4.0 ao registrador f21 -> (constante = 4.0)

add.d f17, f0, f19      	 ;adiciono 3.0 ao registrador de f20 -> (somatorio_PI = 3.0)

add.d f16, f16, f16     	 ;adiciona 2.0 ao registrador f16 -> (incremento = 2.0)

addi $s1, $zero, 0      	 ;adiciono 0 ao registrador $s1 -> (iteracao_atual = 0)

lb $s2, num_iteracoes($zero) 	 ;$s2 = num_iteracoes

addi $s5, $zero, 0               ;adiciona 0 ao registrador $s5 (servirá para o print) -> acumulador = 0

lb $s6, precisao_fracao($zero)   ;$s6 = precisao_fracao

addi $s0, $zero, 2

add.d f8, f18, f19             ;f8 = 2.0 + 3.0 = 5.0
mul.d f8, f8, f18              ;f8 = 2*5.0 = 10.0 -> (será o divisor base na seção "meio") 

j inicio_loop

inicio_loop:	      ;imediato que inicia o loop principal
sub $s3, $s1, $s2     ;($s3 = $s1-$s2)
bgez $s3, meio        ;if ($s3 > 0){pula pro imediato "meio"}

addi $s1, $s1, 1      ;atualizo o conteudo de $s1 em 1 -> (iteracao_atual += 1)

;abaixo verifico se é par ou impar
mul.d f22, f18, f19   ;multiplica i*j e coloca no f22 -> (denominador = i*j)

div $s1, $s0          ;divido $s1 por 2 -> (iteracao_atual /2)
MFHI $s3              ;movo o resto da divisão para o registrador $s2 -> ($s3 = iteracao_atual % 2)

mul.d f22, f22, f20   ;multiplica f22 (i*j) por k e coloca em f22 -> (denominador = i*j*k)

div.d f23, f21, f22   ;f23 = f21/f22 -> 4.0/(i*j*k) -> (constante/multiplica)
 
add.d f18, f18, f16   ;f18 = f18 + f16 -> (i = 2 + i)
add.d f19, f19, f16   ;f19 = f19 + f16 -> (j = 2 + j)
add.d f20, f20, f16   ;f20 = f20 + f16 -> (k = 2 + k)

beqz $s3, par         ;pula para o imediato se o resto se $s3 for igual a zero (par)
j impar               ;caso contrario pula para o imediato se o resto de $s3 for diferente de zero (impar)


par:
sub.d f17, f17, f23   ;f17 = f17-f23 -> (somatorio_PI -= 4.0/(i*j*k))
j inicio_loop	      ;pula para o imediato "inicio loop"

impar:
add.d f17, f17, f23   ;f17 = f17 + f23 -> (somatorio_PI += 4.0/(i*j*k))
j inicio_loop         ;pula para o imediato "inicio loop"

meio:                 ;imediato que realiza as instruções do meio do programa
add.d f9, f0, f17     ;copia o conteúdo de f17 para f9

cvt.w.d f10,f9        ;arredonda o contudo de f9, colocando em f10
dmfc1 $s4,f10	      ;copia f10 e coloca em $s4 de (bit a bit) -> (s4 agora tem a parte inteira de somatorio_PI, no entando está no formato de int)


mtc1 $s4, f24        ;copia os bits  
cvt.d.w f24, f24     ;converte para double
sub.d f24, f9, f24   ;parte fracionaria
;mul.d f24, f24, f8  ;parte fracionaria * 10 

;prepara a parte inteira para printar
daddi $a1, $zero, string_PI
sw $a1, params_sys5($zero) ;aloca o espaço necessário para o parâmetro
add $a2, $zero, $s4        ;colocando $s4 no registrador de argumento $a2
sw $a2, num_param($zero)
daddi r14, $zero, params_sys5
syscall 5

j printar_loop        ;pula para o imediato "printar_loop"


printar_loop:
sub $s7, $s5, $s6     ;$s7 = acumulador - precisao_fracao
bgez $s7, fim	      ;if ($s7 > 0) {pula para o imediato "fim"}

addi $s5, $S5, 1      ;acumulador += 1

;opero sobre o f10

cvt.w.d f10,f24       ;arredonda o contudo de f24, colocando em f10
dmfc1 $s4,f10	      ;copia f10 e coloca em $s4 de (bit a bit) -> (s4 agora tem a parte inteira de somatorio_PI, no entando está no formato de int)

mtc1 $s4, f9          ;copia os bits  
cvt.d.w f9, f9        ;converte para double
 
sub.d f11, f24, f9    ;f11 = f24-f9 -> (fica somente a parte fracionaria)
mul.d f12, f11, f8    ;f12 = f11 * 10 -> (a primeira casa vira o inteiro de f12)
add.d f24, f0, f12    ;f24 = f0 + f12
cvt.w.d f10,f12       ;arredonda o contudo de f9, colocando em f10
dmfc1 $s4,f10	      ;copia f10 e coloca em $s4 de (bit a bit) -> (s4 agora tem a parte inteira de somatorio_PI, no entando está no formato de int)

daddi $a1, $zero, string_PI_fracao    ;colocando $s4 no registrador de argumento $a2
sw $a1, params_sys5($zero)   ;armazena em r5 o a região do imediato "num_fracao" na posição $zero
add $a2, $zero, $s4
sw $a2, num_param($zero)
daddi r14, $zero, params_sys5
syscall 5
j printar_loop



fim:
syscall 0
