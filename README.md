# Trabalhos Práticos - Arquitetura de Computadores

Repositório destinado ao armazenamento e documentação dos trabalhos práticos desenvolvidos na disciplina de **Arquitetura de Computadores**. Os projetos abrangem desde a programação em linguagem assembly de baixo nível (MIPS64) até simulação de memórias cache, sistemas embarcados com interrupções e programação paralela/concorrente em CPU e GPU.

---

## Tecnologias e Ferramentas Utilizadas

- **EduMIPS64:** Simulador de arquitetura MIPS de 64 bits.
- **ParaCache:** Simulador para análise de desempenho e políticas de substituição de memória cache.
- **Tinkercad & Arduino:** Projetos de hardware e prototipagem de sistemas embarcados com uso de interrupções.
- **Linguagem C & OpenMP/Pthreads:** Programação de alto desempenho e paralelismo em CPU.
- **Python, Numba & CUDA:** Processamento paralelo acelerado em GPU.

---

## Lista de Trabalhos Desenvolvidos

### Trabalho 01: Busca Binária em EduMIPS64
- **Descrição:** Implementação do algoritmo de Busca Binária em Assembly MIPS64 para um array de inteiros de 32 bits (*word*) alocado na memória `.data`.
- **Destaques:** Suporte a vetores de tamanho par ou ímpar, implementação de estruturas de repetição (loops sem código sequencial) e impressão direta do resultado na interface do simulador.
- **Entregáveis:** [Código Assembly MIPS64 comentado](src\TP01_Busca_Binaria.asm).

> *![Resultado do Trabalho 01 no EduMIPS64](assets\tp01_busca_binaria.png)*
Procurando e encontrando com sucesso o valor **3** no vetor [1,3,5,7,9,11,13,14].
---

### Trabalho 02: Cálculo da Razão de Convergência (Aproximação de Pi)
- **Descrição:** Algoritmo em Assembly MIPS64 focado no cálculo aproximado da constante Pi usando séries de convergência (como a série de Leibniz) com operações de precisão dupla (`double`).
- **Destaques:** Otimização para atingir alta precisão com a menor quantidade possível de ciclos de instrução no simulador.
- **Entregáveis:** [Código Assembly MIPS64 comentado](src\TP02_Razao_de_Convergencia_Pi.asm).

> *![Resultado do Trabalho 02 no EduMIPS64](assets\tp02_convergencia_pi.png)*
Valor em 3.141599007 após 497 instruções (1803 ciclos)
---

### Trabalho 03: Simulação e Análise de Memória Cache Mapeada Diretamente
- **Descrição:** Estudo analítico e prático do funcionamento de memórias cache utilizando o simulador **ParaCache**.
- **Destaques:** 
  - Análise do mapeamento de memória física (12 bits) sobre blocos de cache.
  - Testes com políticas de escrita (*Write-Through* vs *Write-Back*, *Write-On-Allocate* vs *Write-Around*).
  - Cálculo de *Miss Rate* / *Hit Rate* com variações no tamanho do *offset bit* e reordenação de acessos à memória.
- **Entregáveis:** [Relatório técnico analítico](docs\TP03_Memoria_Cache_01.pdf).

---

### Trabalho 04: Análise de Cache Conjunto-Associativa e Políticas de Substituição
- **Descrição:** Estudo aprofundado do comportamento da memória cache ao variar o grau de associatividade (caches de 2 vias e 4 vias) e algoritmos de substituição.
- **Destaques:**
  - Comparação de desempenho entre as políticas de substituição **FIFO**, **LRU** e **Random**.
  - Estudo comparativo de taxas de erro (*miss rates*) ajustando os bits de deslocamento (*offset bits*) e associatividade.
- **Entregáveis:** [Relatório técnico](docs\TP04_Memoria_Cache_02.pdf) com tabelas comparativas.

---

### Trabalho 05: Jogo Simon com Interrupções em Arduino (Tinkercad)
- **Descrição:** Prototipagem do jogo da memória *Simon* (Genius) utilizando a plataforma Arduino no ambiente virtual **Tinkercad**.
- **Destaques:**
  - Circuito composto por 4 LEDs, 4 botões, resistores e buzzer para feedback auditivo/visual em caso de erro.
  - Uso de **Interrupções Externas** para a leitura instantânea dos botões pelo jogador.
  - Uso de **Interrupções por Timer** para temporização estrita de 3 segundos no turno do jogador.
- **Entregáveis:** Circuito funcional no Tinkercad e apresentação explicativa.
- **Links e Materiais:**
  - [Simulação no Tinkercad](https://www.tinkercad.com/things/g8i445MAbUh-simontrabacv2-?sharecode=xok0OhF-vYiuEe6_ESGukJbFjenXfsrZG5EiwTZ1M4s)
  - [Apresentação de Slides (Google Slides)](https://docs.google.com/presentation/d/1KDAyb37UxL4SCjj5W46bYOX7QWwJKAl3XxfV8wdi2sw/edit?usp=sharing)

> *![Circuito do Jogo Simon no Tinkercad](assets\tp05_jogo_simon.png)*

---

### Trabalho 06: Multiplicação de Matrizes com Paralelismo em C
- **Descrição:** Programa em C desenvolvido para realizar a multiplicação de matrizes quadradas de ordem $N$ explorando paralelismo por *threads* (variando $T$ threads).
- **Destaques:**
  - Análise experimental de escalabilidade com matrizes de tamanhos $N \in \{500, 1000, 1500, 2000, 2500\}$ e $T \in \{2, 4, 8, 16\}$ threads.
  - Execução de 15 testes por combinação para geração de médias estatísticas e gráficos de tempo x threads com margem de erro.
  - Discussão sobre ganhos de desempenho vs. *overheads* de criação/gerenciamento de threads.
- **Entregáveis:** [Código-fonte em C](src\TP06_Multithreading.c) e [Relatório em PDF](docs\TP06_Multithreading.pdf).

---

### Trabalho 07: Detecção de Bordas (Sobel) Acelerada por GPU com Numba
- **Descrição:** Aplicação do algoritmo de Sobel para detecção de bordas em imagens digitais utilizando Python acelerado via GPU (Nvidia CUDA / Numba).
- **Destaques:**
  - Implementação manual da convolução com matrizes Sobel 3x3 e aplicação de *padding* sem uso de funções prontas da OpenCV.
  - Mapeamento direto do grid de *blocks* e *threads* da GPU de acordo com as dimensões da imagem.
  - Avaliação de desempenho alterando a resolução da imagem ($600\times600$, $1500\times1500$ e $2100\times2100$ pixels).
- **Entregáveis:** [Notebook Jupyter](src\TP07_Deteccao_de_Bordas_GPU_e_Numba.ipynb) e [Relatório em PDF](docs\TP07_Deteccao_de_Bordas_GPU_e_Numba.pdf)