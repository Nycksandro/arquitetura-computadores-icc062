//Aluno : Nycksandro Lima dos Santos

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <pthread.h>

typedef struct { // Struct para guardar os parâmetros da função "multiplica_matrizes_intervalo"
    long long int** matriz_A;
    long long int** matriz_B;
    long long int** matriz_C; 
    int ordem_matrizes; 
    int inicio; 
    int fim;
} parametros_multiplica_matrizes;

long long int** aloca_matriz(int tam){ // Função que recebe o tamanho desejado para alocar espaço para uma matriz de inteiros (long long int) 
    long long int** matriz_ponteiro; // Cria a variável da matriz
    matriz_ponteiro = (long long int**)malloc(tam*sizeof(long long int*)); // Alocando um vetor de ponteiros

    for(int i = 0; i < tam; i++){
        matriz_ponteiro[i] = (long long int*)malloc(tam*sizeof(long long int)); // Aloca um vetor de inteiros (long long int) para cada vetor de ponteiros
    }
    return matriz_ponteiro; // retorna a matriz
}

void preenche_matriz(long long int** matriz, int tam){ // Função que recebe uma matriz e seu tamanho e preenche com indíce atual da linha + 1 (fiz assim pois indice da linha + indice da coluna estava estourando muito rapido)
    for(int i = 0; i < tam; i++){ 
        for(int j = 0; j < tam; j++){
            matriz[i][j] = i+1; // Preenche com indice de linha + 1
        }
    }
}

void* multiplica_matrizes_intervalo(void* arg){ // Função/rotina da thread que recebe uma struct (multiplica_matrizes_intervalo) 
    parametros_multiplica_matrizes* parametros = (parametros_multiplica_matrizes*) arg; // Faz o cast

    //Pega os parâmetros do arg e coloca nas variáveis
    int inicio = parametros->inicio; // Coloco na váriavel o conteudo da struct
    int fim = parametros->fim; // Coloco na váriavel o conteudo da struct
    int ordem_matrizes = parametros->ordem_matrizes; // Coloco na váriavel o conteudo da struct
    long long int** matriz_A = parametros->matriz_A; // Coloco na váriavel o conteudo da struct
    long long int** matriz_B = parametros->matriz_B; // Coloco na váriavel o conteudo da struct
    long long int** matriz_C = parametros->matriz_C; // Coloco na váriavel o conteudo da struct

    long long int somatorio; // Variável para acumular a soma

    // Realiza a multiplicação matricial de forma paralelizada
    for(int i = inicio; i < fim; i++){ //Percorre as matrizes, e as linhas eu percorro apenas um invervalo de linhas
        for(int j = 0; j < ordem_matrizes; j++){
            somatorio = 0;
            for(int k = 0; k < ordem_matrizes; k++){ // Percorro todo o k
                somatorio += matriz_A[i][k] * matriz_B[k][j]; // Multiplica e soma
            }
            matriz_C[i][j] = somatorio; // Coloca na linha i, coluna j
        }
    }
    return NULL; // retorna nulo
}

void cria_threads(pthread_t* vetor_threads, int num_threads, long long int** matriz_A, long long int** matriz_B, long long int** matriz_C, int ordem_matriz){ // Função que recebe um vetor de threads, o número de threads, a matriz A, a matriz B, a matriz C e a ordem de matrizes, e seta as threads com a configuração padrão e com a função de rotina "multiplica_matrizes_intervalo" e com os parâmetros colocados nessa função
    // A ideia é quebrar em intervalos, dado por: (ordem_matriz/num_threads) * num_thread_atual
    double constante = ordem_matriz/ (double) num_threads; // Calcula a constante aqui para evitar recalcular várias vezes desnecessariamente
    for(int i = 0; i < num_threads; i++){ // Percorre o vetor de threads
        parametros_multiplica_matrizes* parametros = (parametros_multiplica_matrizes*)malloc(sizeof(parametros_multiplica_matrizes)); // Tem que alocar memoria para não ser desalocada enquanto está em execução
        parametros->matriz_A = matriz_A; // Coloca a matriz_A
        parametros->matriz_B = matriz_B; // Coloca a matriz_B
        parametros->matriz_C = matriz_C; // Coloca a matriz_C
        parametros->ordem_matrizes = ordem_matriz; // Coloca a ordem de matrizes
        int inicio_atual = constante*i; // Calcula o inicio_atual
        int fim_atual = constante*(i+1); // Calcula o fim_atual

        // Coloca os parâmetros da função "cria_threads" na struct "parametros"
        parametros->inicio = inicio_atual; // Coloca o intervalo de inicio
        parametros->fim = fim_atual; // Coloca o intervalo do fim
        pthread_create(&vetor_threads[i], NULL, multiplica_matrizes_intervalo, (void*)parametros); // Seta a thread com a função de multiplicação com seu devido intervalo
    }
}

void aguarda_threads(pthread_t* vetor_threads, int num_threads) { // Função que espera as threads terminarem de executar a função
    for (int i = 0; i < num_threads; i++) {
        (pthread_join(vetor_threads[i], NULL));
    }
}

int main(int argc, char* argv[]){ // argv[1] = N e argv[2] = T
    if(argc == 3){ // Se a quantidade de argumentos for  igual a 3 (nome do programa, ordem da matrizes e número de threads)
        long long int** matriz_A; // Matriz A
        long long int** matriz_B; // Matriz_B
        long long int** matriz_C; // Matriz resultante (long long int para suportar os números grandes)

        int ordem_matrizes = atoi(argv[1]); // Converte a string para inteiro
        int num_threads = atoi(argv[2]); // Converte a string para inteiro
        pthread_t vetor_threads[num_threads]; // Cria um vetor de threads com o número desejado de threads

        //Variáveis para obter o tempo gasto
        clock_t inicio_tempo; // Variável para guardar o inicio do tempo
        clock_t fim_tempo; // Variável para guardar o fim do tempo
        double tempo_gasto; // Variável para guardar o calculo do tempo em segundos

        if(ordem_matrizes < num_threads){ // Se T > N, então não deve paralelizar e executar o programa
            printf("O numero de Threads inserido eh maior que a ordem da Matriz\n");
        }
        else{ // Caso contrário não há problema
            matriz_A = aloca_matriz(ordem_matrizes); // Aloca espaço para matriz_A com o tamanho desejado
            matriz_B = aloca_matriz(ordem_matrizes); // Aloca espaço para matriz_B com o tamanho desejado
            matriz_C = aloca_matriz(ordem_matrizes); // Aloca espaço para matriz_C (matriz resultante)

            preenche_matriz(matriz_A,ordem_matrizes); // Preenche a matriz com linha + coluna atual
            preenche_matriz(matriz_B,ordem_matrizes); // Preenche a matriz com linha + coluna atual
            
            inicio_tempo = clock(); // Inciando a contagem de tempo

            cria_threads(vetor_threads, num_threads, matriz_A, matriz_B, matriz_C, ordem_matrizes); // Cria as threads e seta com a função de multiplicação
            
            aguarda_threads(vetor_threads, num_threads); // Aguarda todas as threads terminarem
          
            fim_tempo = clock(); // Fim da contagem de tempo

            tempo_gasto = ((double)(fim_tempo - inicio_tempo)) / CLOCKS_PER_SEC; // Calcula o tempo gasto e transforma em segundos

            printf("Tempo gasto: %f segundos\n", tempo_gasto); // Exibe o tempo de execução em segundos
            
        }   
    }
    else{
        printf("O programa deve estar no formato: ./<Nome do programa> <Ordem da matriz> <Numero de Threads>\n");  // Mensagem para caso o programa esteja no formato errado
    }
}