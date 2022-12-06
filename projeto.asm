; Bruna Pereira Serrano da Mata
; Italo de Matos Saldanha
; Sistemas de Informaçao

jmp main

;Declarando variaveis
posNotaF: var #1
posInicialnotaF: var #1
caractereNotaF: var #1

posNotaJ: var #1 
posInicialnotaJ: var #1
caractereNotaJ: var #1

posNotaK: var #1
posInicialnotaK: var #1
caractereNotaK: var #1

scoreDezena : var #1
scoreUnidade : var #1

espaco: var #1

frase2: string "FASE 2"
hard: string "#hard"


main: 
    call printTelaInicial2Screen
    
    ;espera a pessoa apertar espaco para avancar para a proxima etapa do codigo
    loopComeco: 
        inchar r7
        loadn r6, #' '
        cmp r6, r7
        jne loopComeco
    
    call printTelaAvisoPontosScreen
    ;tambem espera a pessoa pressionar espaco
    segundoloop:
        inchar r7
        loadn r6, #' '
        cmp r6, r7
        jne segundoloop
    
    call delayF 
    call printTelaJogoScreen

    call inicializar_unidade
    call inicializar_dezena
    call ImprimePontuacao
    
    loadn r3, #600 ;contador (controla o tempo de duracao da fase 1)
    
    ;caracteristicas da nota F
    loadn r0, #'*'              ;caractere
    loadn r1, #3328             ;cor
    add r0, r0, r1              ;atribuindo cor ao caractere
    store caractereNotaF, r0    ;salvando na memoria
    
    ;caracteristicas da nota J
    loadn r0, #'&'
    loadn r1, #3072
    add r0, r0, r1
    store caractereNotaJ, r0 
    
    ;caracteristicas da nota J
    loadn r0, #'@'
    loadn r1, #2560
    add r0, r0, r1
    store caractereNotaK, r0
    
    ;Inicializando posicoes (de onde a nota vai 'surgir' na parte de cima da tela)
    loadn r2, #13
    store posInicialnotaF, r2 ; posicao atual da nota F eh 13
    store posNotaF, r2
        
    loadn r2, #19
    store posNotaJ, r2 
    store posInicialnotaJ, r2
    
    loadn r2, #25 
    store posNotaK, r2 
    store posInicialnotaK, r2
    
    loadn r6, #0 ;variavel para ser usada na comparacao com o resto das divisoes a seguir

    loop: 
        
        ; velocidade da nota: o valor de r7 determina em quais valores do contador (r3)
        ; a nota vai mover, isso provoca efeito de velocidade nelas para cada numero diferente
        ; Move se divisao do contador (r3) pelo indice da velocidade (r7) der resto zero (r6)
        
        loadn r7, #1 ; velocidade 
        mod r7, r3, r7
        cmp r7, r6
        ceq movenotaF  ; so move a nota de vez em quando pra efeito de velocidade
        
        loadn r7, #2 ; velocidade 
        mod r7, r3, r7
        cmp r7, r6
        ceq movenotaJ
        
        loadn r7, #3 ; velocidade 
        mod r7, r3, r7
        cmp r7, r6
        ceq movenotaK
        
        call verificacolisao ;pra cada movimento das notas, eh importante verificar se colide
        
        loadn r5, #2 ;decremento do r3 vai ate 2
        dec r3 
        cmp r3, r5 ; enquanto o contador nao finaliza o loop reinicia
        jgr loop
     
    ;Acabou primeira fase, verifica se jogador perdeu ou ganhou ela:   
    continua:   
        loadn r5, #50 ;#50 = 2
        load r4, scoreDezena 
        cmp r4, r5 ;se a dezena for igual ou maior a 2 (isto é, pontos >= 20), vai pra fase 2
        ceg Fase2    
        call printtelaPerdeuScreen ;se a pessoa nao atingiu a pontuacao minima para a fase 2 ela vai direto pro fim
    
    ;depois da fase 2, verifica se jogador perdeu ou ganhou o jogo    
    fim: 
        loadn r0, #49 ;#49 = 1
        load r1, scoreDezena
        cmp r1, r0
        jle fim_perdeu ;se o jogador n atingiu pelo menos 10 pontos na fase 2
        
        cmp r1, r0
        jeg fim_ganhou ;se o jogador atingiu 10 ou mais pontos na fase 2
        
        fim_ganhou:
            call printtelaVenceuScreen
            loop_fimGanhou: ;espera pressionar espaco
                inchar r7
                loadn r6, #' '
                cmp r6, r7
                jne loop_fimGanhou
            jmp main ;se a pessoa quiser jogar novamente, reinicia o jogo
            
        fim_perdeu:
            call printtelaPerdeuScreen
            loop_fimPerdeu: ;espera pressionar espaco
                inchar r7
                loadn r6, #' '
                cmp r6, r7
                jne loop_fimPerdeu
            jmp main ;se a pessoa quiser jogar novamente, reinicia o jogo      

    halt

jmp main  
   
;codigo da fase 2 
Fase2: 
    push r0 
    push r1 
    push r2 
    push r3 
    push r4 
    push r5
    
    call printTelaPraFase2Screen ;tela de inicio da fase 2
    
    loopComecoFase2: ;espera pressionar espaco pra sair do loop
        inchar r0
        loadn r1, #' '
        cmp r0, r1
        jne loopComecoFase2
        
    ;comeca o jogo
    call printTelaJogoScreen
    
    call inicializar_unidade
    call inicializar_dezena
    call ImprimePontuacao
    
    ;frases decorativas pra diferenciar o layout das fases
    loadn r0, #41
    loadn r1, #frase2
    call imprimestr
    
    loadn r0, #121
    loadn r1, #hard
    call imprimestr
    
    loadn r3, #750 ;contador da fase 2
    loadn r4, #0 ; para o modulo 
    
    jmp loopFase2
    
    loopFase2:
        ;movimenta pela velocidade que eh calculada pelo modulo com o contador (r3)
        loadn r2, #1 ; velocidade 
        mod r2, r3, r2
        cmp r2, r4
        ceq movenotaF2  ; so move a nota de vez em quando pra efeito de velocidade
        
        loadn r2, #2
        mod r2, r3, r2
        cmp r2, r4
        ceq movenotaJ2
        
        loadn r2, #3
        mod r2, r3, r2
        cmp r2, r4
        ceq movenotaK2
        
        call verificacolisao
        
        ;atualizando contador
        loadn r5, #2
        dec r3
        cmp r3, r5 ; enquanto o contador nao finaliza (chega em 2) o loop continua
        jgr loopFase2 ;if r3(contador) > 2 continua
        
        jmp fimFase2 ;else -> fim
        
    fimFase2:     
    pop r5
    pop r4
    pop r3 
    pop r2 
    pop r1 
    pop r0
    rts
            
            
;Funcao que inicializa com zero a variavel da unidade
inicializar_unidade:
    push r0
    loadn r0, #48
    store scoreUnidade, r0
    pop r0
    rts

;Funcao que inicializa com zero a variavel da dezena
inicializar_dezena:
    push r0
    loadn r0, #48
    store scoreDezena, r0
    pop r0
    rts

;Recebe os valores de unidade e dezena e imprime na tela
ImprimePontuacao:
    push r0
    push r1
    push r2
    push r3
    push r4

    loadn r0, #1084 ;posicao da tela a ser imprimida a dezena
    loadn r1, #1085 ;posicao da tela a ser imprimida a unidade
    loadn r4, #58 ; eh o caractere depois do 9

    load r2, scoreDezena
    load r3, scoreUnidade
    
    cmp r4, r3 ;se unidade ja passou do 9, chama a funcao
    jeq incrementa_dezena
    
    jmp ImprimePontuacaoSai ;senao, vai pra funcao de saida
    
    ;incrementa a dezena e zera a unidade para criar, por exemplo, o 10
    incrementa_dezena:
        load r2, scoreDezena
        load r3, scoreUnidade
        
        inc r2 
        store scoreDezena, r2
        call inicializar_unidade

        jmp ImprimePontuacaoSai
        
    ImprimePontuacaoSai:
    load r2, scoreDezena
    load r3, scoreUnidade
    
    outchar r2, r0 ;imprimindo na tela os valores atualizados
    outchar r3, r1
    
    pop r4  
    pop r3
    pop r2
    pop r1
    pop r0
    rts
    
;funcao que decresce um valor repetidamente a fim de provocar efeito de delay
delayF: 
    push r0 
    push r1 
    push r2 
    push r4
    
    loadn r2, #1
    
    loadn r0, #40
    delayF2: 
    loadn r1, #1000
    decrementadelayF:
    dec r1 
    jnz decrementadelayF
    dec r0 
    jnz delayF2
    
    
    pop r4 
    pop r2    
    pop r1 
    pop r0 
    rts
    
;Funcao que imprime uma string caractere por caractere em um loop
imprimestr: 
    push r0 ; posicao da mensagem
    push r1 ; mensagem
    push r2 ; cor da mensagem
    push r3 ; parada
    push r4 ; auxiliar
    
    loadn r3, #'\0' ; Criterio de parada

ImprimestrLoop: 
    loadi r4, r1
    cmp r4, r3
    jeq ImprimestrSai
    outchar r4, r0
    inc r0
    inc r1
    jmp ImprimestrLoop
    
ImprimestrSai:  
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts
  
;Funcao que faz a nota F se movimentar pela tela  
movenotaF:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6
    
    load r2, posNotaF
    
    call imprimeestrelaF
    call delayF
    call apagaestrelaF
    call incrementaposicaoF 
    call imprimeestrelaF
  
    loadn r5, #1093 ; ultimaposicao possivel para o F
    cmp r2, r5
    jeg reiniciaposicaoF ; if(posAtual >= 1093) reinicia a posicao do F, se nao: 
    
    jmp movenotaF_fim
    
    movenotaF_fim:
        pop r6
        pop r5
        pop r4
        pop r3 
        pop r2 
        pop r1 
        pop r0 
        rts
        
    reiniciaposicaoF:
        call apagaestrelaF 
        load r2, posInicialnotaF ;recebe o valor da posicao inicial e atribui para a variavel da posicao atual
        store posNotaF, r2
        jmp movenotaF_fim 
 
;Funcao responsavel por fazer o caractere da nota aparecer na tela    
imprimeestrelaF: 
    push r0
    push r1
    push r2 
    
    load r0, caractereNotaF
    load r2, posNotaF  ; r2 recebe o valor da posicao
    outchar r0,r2 ; imprime estrela na posicao
    
    pop r2 
    pop r1 
    pop r0
    rts

;Faz o caractere da nota 'sumir' - para dar o efeito de movimento
apagaestrelaF:
    push r0
    push r1 
    push r2
    push r3 
    push r4 

    
    loadn r1, #TelaJogo ; = ' '(espaco em branco)
    load r0, posNotaF 
    add r2, r1, r0 ; r2 = posNotaF + #TelaJogo
    loadn r4, #40
    div r3, r0, r4
    loadi r5, r2 
    
    outchar r5, r0 ; apaga estrela na posicao
    
    
    pop r4
    pop r3 
    pop r2 
    pop r1 
    pop r0
    rts

;Adiciona um novo valor na posicao para q a nota continue descendo    
incrementaposicaoF:
    push r1
    push r2 
    push r4 
    
    load r2, posNotaF
    loadn r4, #40 
    add r2, r2, r4 ; soma 40 na posicao para descer
    store posNotaF, r2 ; salva o novo valor da posicao na variavel
    
    pop r4 
    pop r2 
    pop r1 
    rts 
    

;------------------------------------------------JJJ------------------------------------------------

    ;Funcao que faz a nota J se movimentar pela tela  
    movenotaJ:
        push r0
        push r1
        push r2
        push r3
        push r4
        push r5
        push r6
        
        load r2, posNotaJ
        
        call imprimeestrelaJ
        call delayJ
        call apagaestrelaJ
        call incrementaposicaoJ 
        call imprimeestrelaJ
        
        load r2, posNotaJ
        loadn r0, #1139 ; ultimaposicao possivel para o J
        cmp r2, r0
        jeg reiniciaposicaoJ
        
        jmp movenotaJ_fim
        
        movenotaJ_fim:
            pop r6
            pop r5
            pop r4
            pop r3 
            pop r2 
            pop r1 
            pop r0 
            rts
            
        reiniciaposicaoJ:
            call apagaestrelaJ
            load r2, posInicialnotaJ ;recebe o valor da posicao inicial e atribui para a variavel da posicao atual
            store posNotaJ, r2 ;posicao atual = posicao inicial
            jmp movenotaJ_fim


    ;Funcao responsavel por fazer o caractere da nota aparecer na tela    
    imprimeestrelaJ: 
        push r0
        push r2 
        
        load r0, caractereNotaJ
        load r2, posNotaJ  ; r2 recebe o valor da posicao
        outchar r0,r2 ; imprime estrela na posicao
        
        pop r2 
        pop r0
        rts
        
    ;Faz o caractere da nota 'sumir' - para dar o efeito de movimento:
    apagaestrelaJ:
        push r0
        push r1 
        push r2
        push r3 
        push r4 

        
        loadn r1, #TelaJogo  ; = ' '(espaco em branco)
        load r0, posNotaJ
        add r2, r1, r0 ; r2 = posNotaF + #TelaJogo
        loadn r4, #40
        div r3, r0, r4
        loadi r5, r2 
        
        outchar r5, r0 ; apaga estrela na posicao
        
        
        pop r4
        pop r3 
        pop r2 
        pop r1 
        pop r0
        rts
    ;Adiciona um novo valor na posicao para q a nota continue descendo        
    incrementaposicaoJ:
        push r2 
        push r4 
        
        load r2, posNotaJ
        loadn r4, #40 
        add r2, r2, r4 ; soma 40 na posicao
        store posNotaJ, r2 ; salva o novo valor da posicao na variavel
        
        pop r4 
        pop r2 
        rts 
     
    ;funcao que decresce um valor repetidamente a fim de provocar efeito de delay  
    delayJ: 
        push r0 
        push r1 
        
        loadn r0, #50
        delayJ2: 
        loadn r1, #2000
        decrementadelayJ:
        dec r1 
        jnz decrementadelayJ 
        dec r0 
        jnz delayJ2
            
        pop r1 
        pop r0 
        rts
        
    
;------------------------------------------------KKK------------------------------------------------

;Funcao que faz a nota J se movimentar pela tela  
movenotaK:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6
    
    load r2, posNotaK
    
    call imprimeestrelaK
    call delayK
    call apagaestrelaK
    call incrementaposicaoK 
    call imprimeestrelaK
  
    load r2, posNotaK
    loadn r5, #1145 ; ultimaposicao possivel para o J
    cmp r2, r5
    jeg reiniciaposicaoK
    
    jmp movenotaK_fim
    
    movenotaK_fim:
        pop r6
        pop r5
        pop r4
        pop r3 
        pop r2 
        pop r1 
        pop r0 
        rts
        
    reiniciaposicaoK:
        call apagaestrelaK 
        load r2, posInicialnotaK ;recebe o valor da posicao inicial e atribui para a variavel da posicao atual
        store posNotaK, r2
        jmp movenotaK_fim


;Funcao responsavel por fazer o caractere da nota aparecer na tela    
imprimeestrelaK: 
    push r0
    push r2 
    
    load r0, caractereNotaK
    load r2, posNotaK  ; r2 recebe o valor da posicao
    outchar r0,r2 ; imprime estrela na posicao
    
    pop r2 
    pop r0
    rts
    
;Faz o caractere da nota 'sumir' - para dar o efeito de movimento:
apagaestrelaK:
    push r0
    push r1 
    push r2
    push r3 
    push r4 

    
    loadn r1, #TelaJogo ; = ' '(espaco em branco)
    load r0, posNotaK 
    add r2, r1, r0 ; r2 = posNotaF + #TelaJogo
    loadn r4, #40
    div r3, r0, r4
    loadi r5, r2 
    
    outchar r5, r0 ; apaga estrela na posicao
    
    
    pop r4
    pop r3 
    pop r2 
    pop r1 
    pop r0
    rts

;Adiciona um novo valor na posicao para q a nota continue descendo       
incrementaposicaoK:
    push r2 
    push r4 
    
    load r2, posNotaK
    loadn r4, #40 
    add r2, r2, r4 ; soma 40 na posicao
    store posNotaK, r2 ; salva o novo valor da posicao na variavel
    
    pop r4 
    pop r2 
    rts 
 
;Funcao que decresce um valor repetidademente e fim de provocar efeito de delay   
delayK: 
    push r0 
    push r1 
    
    loadn r0, #10
    delayK2: 
    loadn r1, #1000
    decrementadelayK:
    dec r1 
    jnz decrementadelayK
    dec r0 
    jnz delayK2
        
    pop r1 
    pop r0 
    rts
    
; -------------------------------------------------------NOTA F FASE 2 -----------------------------------------------------------

;As funcoes tem as mesmas funcionalidades das outras, so muda que essas sao para as notas da 2 fase
movenotaF2:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6
    
    load r2, posNotaF
    
    call imprimeestrelaF
    call delayFF2
    call apagaestrelaF
    call incrementaposicaoF 
    call imprimeestrelaF
  
    loadn r5, #1093 ; ultimaposicao possivel para o F
    cmp r2, r5
    jeg reiniciaposicaoF2 ; if(posAtual >= 1093) reinicia a posicao do F, se nao 
    
    jmp movenotaF2_fim
    
    movenotaF2_fim:
        pop r6
        pop r5
        pop r4
        pop r3 
        pop r2 
        pop r1 
        pop r0 
        rts
        
    reiniciaposicaoF2:
        call apagaestrelaF 
        load r2, posInicialnotaF 
        store posNotaF, r2 ;posicao atual = posicao inicial
        jmp movenotaF2_fim 
 
;delay da nota F da fase 2 (contribui com a velocidade)       
delayFF2: 
    push r0 
    push r1 
    push r2 

    loadn r0, #10
    delayyF2: 
    loadn r1, #1500
    decrementadelayyF:
    dec r1 
    jnz decrementadelayyF
    dec r0 
    jnz delayyF2
        
    pop r2    
    pop r1 
    pop r0 
    rts
    
;------------------------------------------------------NOTA J FASE 2 ------------------------------------------------------------
movenotaJ2:
        push r0
        push r1
        push r2
        push r3
        push r4
        push r5
        push r6
        
        load r2, posNotaJ
        
        call imprimeestrelaJ
        call delayJF2
        call apagaestrelaJ
        call incrementaposicaoJ 
        call imprimeestrelaJ
        
        load r2, posNotaJ
        loadn r0, #1139 ; ultimaposicao possivel para o J
        cmp r2, r0
        jeg reiniciaposicaoJ2
        
        jmp movenotaJ2_fim
        
        movenotaJ2_fim:
            pop r6
            pop r5
            pop r4
            pop r3 
            pop r2 
            pop r1 
            pop r0 
            rts
            
        reiniciaposicaoJ2:
            call apagaestrelaJ
            load r2, posInicialnotaJ
            store posNotaJ, r2 ;posicao atual = posicao inicial
            jmp movenotaJ2_fim


    delayJF2: 
        push r0 
        push r1 
        
        loadn r0, #1
        delayyJ2: 
        loadn r1, #10
        decrementadelayyJ:
        dec r1 
        jnz decrementadelayyJ 
        dec r0 
        jnz delayyJ2
            
        pop r1 
        pop r0 
        rts
        
; ----------------------------------------------------NOTA K FASE 2 ------------------------------------------------------------
movenotaK2:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6
    
    load r2, posNotaK
    
    call imprimeestrelaK
    call delayKF2
    call apagaestrelaK
    call incrementaposicaoK 
    call imprimeestrelaK
  
    load r2, posNotaK
    loadn r5, #1145 ; ultimaposicao possivel para o J
    cmp r2, r5
    jeg reiniciaposicaoK2
    
    jmp movenotaK2_fim
    
    movenotaK2_fim:
        pop r6
        pop r5
        pop r4
        pop r3 
        pop r2 
        pop r1 
        pop r0 
        rts
        
    reiniciaposicaoK2:
        call apagaestrelaK 
        load r2, posInicialnotaK
        store posNotaK, r2
        jmp movenotaK2_fim

delayKF2: 
    push r0 
    push r1 
    
    loadn r0, #30
    delayyK2: 
    loadn r1, #300
    decrementadelayyK:
    dec r1 
    jnz decrementadelayyK
    dec r0 
    jnz delayyK2
        
    pop r1 
    pop r0 
    rts
;-------------------------------------------------------VERIFICA COLISAO---------------------------------------------------------

;pra cada decrescimo do contador essa funcao eh chamada para ver se a nota coincide com a area de contato
verificacolisao: 
    push r0 
    push r1 
    push r2 
    
    inchar r0 ;compara se essa entrada equivale a alguma das letras e verifica se no momento q foi pressionada teve colisao ou nao
    
    ;switch r0
    loadn r1, #'f'
    cmp r0, r1 
    jeq verificacolisaoF
    
    loadn r1, #'j'
    cmp r0, r1 
    jeq verificacolisaoJ
    
    loadn r1, #'k'
    cmp r0, r1 
    jeq verificacolisaoK
    
    jmp verificacolisao_sai
    
    ;posicao da nota F eh igual a alguma das 3 areas de contato possiveis? Se sim, aumenta a pontuacao
    verificacolisaoF: 
        load r0, posNotaF
        
        ;swicth(posnotaF)
        loadn r1, #1013 
        cmp r0, r1 
        jeq aumentascore
        
        loadn r1, #1053 
        cmp r0, r1 
        jeq aumentascore 
        
        loadn r1, #1093 
        cmp r0, r1 
        jeq aumentascore 
        
        jmp verificacolisao_sai
        
        aumentascore: ;incrementa a unidade e imprime a pontuacao atualizada em tempo real
        load r0, scoreUnidade 
        inc r0 
        store scoreUnidade, r0
        call ImprimePontuacao 
        
        jmp verificacolisao_sai
     
    ;posicao da nota J eh igual a alguma das 3 areas de contato possiveis? Se sim, aumenta a pontuacao    
    verificacolisaoJ: 
        load r0, posNotaJ
        
        ;swicth(posnotaJ)
        loadn r1, #1019 
        cmp r0, r1 
        jeq aumentascore
        
        loadn r1, #1059 
        cmp r0, r1 
        jeq aumentascore 
        
        loadn r1, #1099 
        cmp r0, r1 
        jeq aumentascore 
        
        jmp verificacolisao_sai
        
        aumentascore:
        load r0, scoreUnidade 
        inc r0 
        store scoreUnidade, r0
        call ImprimePontuacao 
        
        jmp verificacolisao_sai
    
    ;posicao da nota K eh igual a alguma das 3 areas de contato possiveis? Se sim, aumenta a pontuacao       
    verificacolisaoK: 
        load r0, posNotaK
        
        ;swicth(posnotaK)
        loadn r1, #1025 
        cmp r0, r1 
        jeq aumentascore
        
        loadn r1, #1065 
        cmp r0, r1 
        jeq aumentascore 
        
        loadn r1, #1105 
        cmp r0, r1 
        jeq aumentascore 
        
        jmp verificacolisao_sai
        
        aumentascore: 
        load r0, scoreUnidade 
        inc r0 
        store scoreUnidade, r0
        call ImprimePontuacao 
        
        jmp verificacolisao_sai

    verificacolisao_sai:
    pop r2 
    pop r1 
    pop r0 
    rts







;-------------------------------------------------------------TELAS DO JOGO----------------------------------------------------------------

TelaJogo : var #1200
  ;Linha 0
  static TelaJogo + #0, #127
  static TelaJogo + #1, #127
  static TelaJogo + #2, #127
  static TelaJogo + #3, #127
  static TelaJogo + #4, #127
  static TelaJogo + #5, #127
  static TelaJogo + #6, #127
  static TelaJogo + #7, #127
  static TelaJogo + #8, #2591
  static TelaJogo + #9, #2834
  static TelaJogo + #10, #2849
  static TelaJogo + #11, #2591
  static TelaJogo + #12, #127
  static TelaJogo + #13, #127
  static TelaJogo + #14, #3947
  static TelaJogo + #15, #127
  static TelaJogo + #16, #2849
  static TelaJogo + #17, #127
  static TelaJogo + #18, #127
  static TelaJogo + #19, #3842
  static TelaJogo + #20, #3952
  static TelaJogo + #21, #127
  static TelaJogo + #22, #2849
  static TelaJogo + #23, #3873
  static TelaJogo + #24, #127
  static TelaJogo + #25, #3957
  static TelaJogo + #26, #3952
  static TelaJogo + #27, #3873
  static TelaJogo + #28, #2849
  static TelaJogo + #29, #127
  static TelaJogo + #30, #2846
  static TelaJogo + #31, #127
  static TelaJogo + #32, #2842
  static TelaJogo + #33, #2842
  static TelaJogo + #34, #2842
  static TelaJogo + #35, #2842
  static TelaJogo + #36, #2842
  static TelaJogo + #37, #2842
  static TelaJogo + #38, #2842
  static TelaJogo + #39, #2845

  ;Linha 1
  static TelaJogo + #40, #127
  static TelaJogo + #41, #2829
  static TelaJogo + #42, #2829
  static TelaJogo + #43, #2835
  static TelaJogo + #44, #127
  static TelaJogo + #45, #127
  static TelaJogo + #46, #127
  static TelaJogo + #47, #127
  static TelaJogo + #48, #2834
  static TelaJogo + #49, #2834
  static TelaJogo + #50, #2849
  static TelaJogo + #51, #2591
  static TelaJogo + #52, #127
  static TelaJogo + #53, #3844
  static TelaJogo + #54, #3957
  static TelaJogo + #55, #127
  static TelaJogo + #56, #2849
  static TelaJogo + #57, #127
  static TelaJogo + #58, #127
  static TelaJogo + #59, #3842
  static TelaJogo + #60, #2943
  static TelaJogo + #61, #2943
  static TelaJogo + #62, #2849
  static TelaJogo + #63, #3873
  static TelaJogo + #64, #127
  static TelaJogo + #65, #127
  static TelaJogo + #66, #3952
  static TelaJogo + #67, #3873
  static TelaJogo + #68, #2849
  static TelaJogo + #69, #127
  static TelaJogo + #70, #127
  static TelaJogo + #71, #2846
  static TelaJogo + #72, #2851
  static TelaJogo + #73, #2883
  static TelaJogo + #74, #2881
  static TelaJogo + #75, #2881
  static TelaJogo + #76, #2899
  static TelaJogo + #77, #2895
  static TelaJogo + #78, #2842
  static TelaJogo + #79, #127

  ;Linha 2
  static TelaJogo + #80, #127
  static TelaJogo + #81, #2829
  static TelaJogo + #82, #2829
  static TelaJogo + #83, #2835
  static TelaJogo + #84, #2835
  static TelaJogo + #85, #3846
  static TelaJogo + #86, #127
  static TelaJogo + #87, #2834
  static TelaJogo + #88, #2834
  static TelaJogo + #89, #2834
  static TelaJogo + #90, #2849
  static TelaJogo + #91, #2591
  static TelaJogo + #92, #127
  static TelaJogo + #93, #127
  static TelaJogo + #94, #3947
  static TelaJogo + #95, #127
  static TelaJogo + #96, #2849
  static TelaJogo + #97, #127
  static TelaJogo + #98, #127
  static TelaJogo + #99, #2943
  static TelaJogo + #100, #2943
  static TelaJogo + #101, #2943
  static TelaJogo + #102, #2849
  static TelaJogo + #103, #3873
  static TelaJogo + #104, #127
  static TelaJogo + #105, #3957
  static TelaJogo + #106, #3952
  static TelaJogo + #107, #2833
  static TelaJogo + #108, #2849
  static TelaJogo + #109, #127
  static TelaJogo + #110, #127
  static TelaJogo + #111, #2846
  static TelaJogo + #112, #2846
  static TelaJogo + #113, #2847
  static TelaJogo + #114, #2847
  static TelaJogo + #115, #2888
  static TelaJogo + #116, #2885
  static TelaJogo + #117, #2898
  static TelaJogo + #118, #2895
  static TelaJogo + #119, #127

  ;Linha 3
  static TelaJogo + #120, #127
  static TelaJogo + #121, #2847
  static TelaJogo + #122, #2829
  static TelaJogo + #123, #2835
  static TelaJogo + #124, #2834
  static TelaJogo + #125, #2834
  static TelaJogo + #126, #2834
  static TelaJogo + #127, #2834
  static TelaJogo + #128, #2834
  static TelaJogo + #129, #2591
  static TelaJogo + #130, #2849
  static TelaJogo + #131, #2591
  static TelaJogo + #132, #127
  static TelaJogo + #133, #2591
  static TelaJogo + #134, #2591
  static TelaJogo + #135, #2591
  static TelaJogo + #136, #2849
  static TelaJogo + #137, #127
  static TelaJogo + #138, #2943
  static TelaJogo + #139, #2943
  static TelaJogo + #140, #3952
  static TelaJogo + #141, #2943
  static TelaJogo + #142, #2849
  static TelaJogo + #143, #3873
  static TelaJogo + #144, #3957
  static TelaJogo + #145, #2847
  static TelaJogo + #146, #2847
  static TelaJogo + #147, #2847
  static TelaJogo + #148, #2849
  static TelaJogo + #149, #127
  static TelaJogo + #150, #127
  static TelaJogo + #151, #127
  static TelaJogo + #152, #2846
  static TelaJogo + #153, #2847
  static TelaJogo + #154, #2847
  static TelaJogo + #155, #3871
  static TelaJogo + #156, #2847
  static TelaJogo + #157, #1823
  static TelaJogo + #158, #2847
  static TelaJogo + #159, #127

  ;Linha 4
  static TelaJogo + #160, #2829
  static TelaJogo + #161, #2847
  static TelaJogo + #162, #2834
  static TelaJogo + #163, #2834
  static TelaJogo + #164, #2834
  static TelaJogo + #165, #2834
  static TelaJogo + #166, #2834
  static TelaJogo + #167, #2591
  static TelaJogo + #168, #3947
  static TelaJogo + #169, #2828
  static TelaJogo + #170, #2849
  static TelaJogo + #171, #2846
  static TelaJogo + #172, #2846
  static TelaJogo + #173, #2591
  static TelaJogo + #174, #3957
  static TelaJogo + #175, #2591
  static TelaJogo + #176, #2849
  static TelaJogo + #177, #127
  static TelaJogo + #178, #2943
  static TelaJogo + #179, #127
  static TelaJogo + #180, #3952
  static TelaJogo + #181, #2943
  static TelaJogo + #182, #2849
  static TelaJogo + #183, #3873
  static TelaJogo + #184, #3840
  static TelaJogo + #185, #3844
  static TelaJogo + #186, #2847
  static TelaJogo + #187, #2847
  static TelaJogo + #188, #2849
  static TelaJogo + #189, #2847
  static TelaJogo + #190, #127
  static TelaJogo + #191, #1823
  static TelaJogo + #192, #1823
  static TelaJogo + #193, #1823
  static TelaJogo + #194, #1823
  static TelaJogo + #195, #3871
  static TelaJogo + #196, #3871
  static TelaJogo + #197, #1823
  static TelaJogo + #198, #1823
  static TelaJogo + #199, #1823

  ;Linha 5
  static TelaJogo + #200, #2834
  static TelaJogo + #201, #2847
  static TelaJogo + #202, #2834
  static TelaJogo + #203, #2834
  static TelaJogo + #204, #2834
  static TelaJogo + #205, #3846
  static TelaJogo + #206, #3846
  static TelaJogo + #207, #2591
  static TelaJogo + #208, #2846
  static TelaJogo + #209, #2846
  static TelaJogo + #210, #2849
  static TelaJogo + #211, #2846
  static TelaJogo + #212, #2591
  static TelaJogo + #213, #2591
  static TelaJogo + #214, #3947
  static TelaJogo + #215, #2591
  static TelaJogo + #216, #2849
  static TelaJogo + #217, #127
  static TelaJogo + #218, #2943
  static TelaJogo + #219, #127
  static TelaJogo + #220, #3952
  static TelaJogo + #221, #2943
  static TelaJogo + #222, #2849
  static TelaJogo + #223, #3873
  static TelaJogo + #224, #3840
  static TelaJogo + #225, #3840
  static TelaJogo + #226, #3840
  static TelaJogo + #227, #3842
  static TelaJogo + #228, #2849
  static TelaJogo + #229, #2847
  static TelaJogo + #230, #2847
  static TelaJogo + #231, #1823
  static TelaJogo + #232, #2846
  static TelaJogo + #233, #1823
  static TelaJogo + #234, #1823
  static TelaJogo + #235, #3871
  static TelaJogo + #236, #3871
  static TelaJogo + #237, #1823
  static TelaJogo + #238, #1823
  static TelaJogo + #239, #1823

  ;Linha 6
  static TelaJogo + #240, #2834
  static TelaJogo + #241, #2834
  static TelaJogo + #242, #2834
  static TelaJogo + #243, #3846
  static TelaJogo + #244, #2835
  static TelaJogo + #245, #3846
  static TelaJogo + #246, #127
  static TelaJogo + #247, #2846
  static TelaJogo + #248, #2846
  static TelaJogo + #249, #2846
  static TelaJogo + #250, #2849
  static TelaJogo + #251, #2591
  static TelaJogo + #252, #2591
  static TelaJogo + #253, #2591
  static TelaJogo + #254, #3957
  static TelaJogo + #255, #2591
  static TelaJogo + #256, #2849
  static TelaJogo + #257, #127
  static TelaJogo + #258, #2943
  static TelaJogo + #259, #127
  static TelaJogo + #260, #3840
  static TelaJogo + #261, #2943
  static TelaJogo + #262, #2849
  static TelaJogo + #263, #3873
  static TelaJogo + #264, #3957
  static TelaJogo + #265, #3840
  static TelaJogo + #266, #3840
  static TelaJogo + #267, #3842
  static TelaJogo + #268, #2849
  static TelaJogo + #269, #2847
  static TelaJogo + #270, #1823
  static TelaJogo + #271, #1823
  static TelaJogo + #272, #1823
  static TelaJogo + #273, #1823
  static TelaJogo + #274, #1823
  static TelaJogo + #275, #1823
  static TelaJogo + #276, #1823
  static TelaJogo + #277, #1823
  static TelaJogo + #278, #1823
  static TelaJogo + #279, #1823

  ;Linha 7
  static TelaJogo + #280, #127
  static TelaJogo + #281, #2847
  static TelaJogo + #282, #127
  static TelaJogo + #283, #3846
  static TelaJogo + #284, #2835
  static TelaJogo + #285, #3846
  static TelaJogo + #286, #2846
  static TelaJogo + #287, #2846
  static TelaJogo + #288, #2828
  static TelaJogo + #289, #2828
  static TelaJogo + #290, #2849
  static TelaJogo + #291, #127
  static TelaJogo + #292, #2591
  static TelaJogo + #293, #2591
  static TelaJogo + #294, #3947
  static TelaJogo + #295, #2591
  static TelaJogo + #296, #2849
  static TelaJogo + #297, #127
  static TelaJogo + #298, #2943
  static TelaJogo + #299, #3844
  static TelaJogo + #300, #3840
  static TelaJogo + #301, #2943
  static TelaJogo + #302, #2849
  static TelaJogo + #303, #3873
  static TelaJogo + #304, #127
  static TelaJogo + #305, #127
  static TelaJogo + #306, #3952
  static TelaJogo + #307, #3842
  static TelaJogo + #308, #2849
  static TelaJogo + #309, #2836
  static TelaJogo + #310, #1823
  static TelaJogo + #311, #1823
  static TelaJogo + #312, #1823
  static TelaJogo + #313, #1823
  static TelaJogo + #314, #1823
  static TelaJogo + #315, #1823
  static TelaJogo + #316, #1823
  static TelaJogo + #317, #1823
  static TelaJogo + #318, #1823
  static TelaJogo + #319, #1823

  ;Linha 8
  static TelaJogo + #320, #127
  static TelaJogo + #321, #2847
  static TelaJogo + #322, #127
  static TelaJogo + #323, #127
  static TelaJogo + #324, #2835
  static TelaJogo + #325, #127
  static TelaJogo + #326, #2846
  static TelaJogo + #327, #2846
  static TelaJogo + #328, #2846
  static TelaJogo + #329, #2943
  static TelaJogo + #330, #2849
  static TelaJogo + #331, #127
  static TelaJogo + #332, #2591
  static TelaJogo + #333, #2591
  static TelaJogo + #334, #2591
  static TelaJogo + #335, #2591
  static TelaJogo + #336, #2849
  static TelaJogo + #337, #127
  static TelaJogo + #338, #127
  static TelaJogo + #339, #3840
  static TelaJogo + #340, #3842
  static TelaJogo + #341, #2943
  static TelaJogo + #342, #2849
  static TelaJogo + #343, #127
  static TelaJogo + #344, #127
  static TelaJogo + #345, #127
  static TelaJogo + #346, #3952
  static TelaJogo + #347, #127
  static TelaJogo + #348, #2849
  static TelaJogo + #349, #2847
  static TelaJogo + #350, #2847
  static TelaJogo + #351, #1823
  static TelaJogo + #352, #3871
  static TelaJogo + #353, #3871
  static TelaJogo + #354, #3871
  static TelaJogo + #355, #1823
  static TelaJogo + #356, #3871
  static TelaJogo + #357, #1823
  static TelaJogo + #358, #1823
  static TelaJogo + #359, #2847

  ;Linha 9
  static TelaJogo + #360, #127
  static TelaJogo + #361, #2847
  static TelaJogo + #362, #127
  static TelaJogo + #363, #127
  static TelaJogo + #364, #127
  static TelaJogo + #365, #127
  static TelaJogo + #366, #2847
  static TelaJogo + #367, #127
  static TelaJogo + #368, #3947
  static TelaJogo + #369, #2943
  static TelaJogo + #370, #2849
  static TelaJogo + #371, #127
  static TelaJogo + #372, #2591
  static TelaJogo + #373, #2591
  static TelaJogo + #374, #2591
  static TelaJogo + #375, #2591
  static TelaJogo + #376, #2849
  static TelaJogo + #377, #127
  static TelaJogo + #378, #127
  static TelaJogo + #379, #127
  static TelaJogo + #380, #3842
  static TelaJogo + #381, #2943
  static TelaJogo + #382, #2849
  static TelaJogo + #383, #3957
  static TelaJogo + #384, #127
  static TelaJogo + #385, #127
  static TelaJogo + #386, #3952
  static TelaJogo + #387, #3842
  static TelaJogo + #388, #2849
  static TelaJogo + #389, #2847
  static TelaJogo + #390, #2847
  static TelaJogo + #391, #1823
  static TelaJogo + #392, #1823
  static TelaJogo + #393, #2846
  static TelaJogo + #394, #1823
  static TelaJogo + #395, #1823
  static TelaJogo + #396, #1823
  static TelaJogo + #397, #1823
  static TelaJogo + #398, #1823
  static TelaJogo + #399, #1823

  ;Linha 10
  static TelaJogo + #400, #127
  static TelaJogo + #401, #2847
  static TelaJogo + #402, #127
  static TelaJogo + #403, #127
  static TelaJogo + #404, #2835
  static TelaJogo + #405, #2835
  static TelaJogo + #406, #2847
  static TelaJogo + #407, #127
  static TelaJogo + #408, #3947
  static TelaJogo + #409, #2943
  static TelaJogo + #410, #2849
  static TelaJogo + #411, #127
  static TelaJogo + #412, #127
  static TelaJogo + #413, #127
  static TelaJogo + #414, #3957
  static TelaJogo + #415, #3947
  static TelaJogo + #416, #2849
  static TelaJogo + #417, #127
  static TelaJogo + #418, #127
  static TelaJogo + #419, #127
  static TelaJogo + #420, #3842
  static TelaJogo + #421, #2943
  static TelaJogo + #422, #2849
  static TelaJogo + #423, #127
  static TelaJogo + #424, #127
  static TelaJogo + #425, #127
  static TelaJogo + #426, #3952
  static TelaJogo + #427, #127
  static TelaJogo + #428, #2849
  static TelaJogo + #429, #2847
  static TelaJogo + #430, #1823
  static TelaJogo + #431, #3871
  static TelaJogo + #432, #3871
  static TelaJogo + #433, #3871
  static TelaJogo + #434, #1823
  static TelaJogo + #435, #1823
  static TelaJogo + #436, #1823
  static TelaJogo + #437, #1823
  static TelaJogo + #438, #1823
  static TelaJogo + #439, #3871

  ;Linha 11
  static TelaJogo + #440, #127
  static TelaJogo + #441, #2847
  static TelaJogo + #442, #127
  static TelaJogo + #443, #2835
  static TelaJogo + #444, #2835
  static TelaJogo + #445, #2835
  static TelaJogo + #446, #2847
  static TelaJogo + #447, #127
  static TelaJogo + #448, #3947
  static TelaJogo + #449, #2943
  static TelaJogo + #450, #2849
  static TelaJogo + #451, #127
  static TelaJogo + #452, #127
  static TelaJogo + #453, #127
  static TelaJogo + #454, #3957
  static TelaJogo + #455, #3947
  static TelaJogo + #456, #2849
  static TelaJogo + #457, #127
  static TelaJogo + #458, #127
  static TelaJogo + #459, #127
  static TelaJogo + #460, #3842
  static TelaJogo + #461, #127
  static TelaJogo + #462, #2849
  static TelaJogo + #463, #127
  static TelaJogo + #464, #127
  static TelaJogo + #465, #127
  static TelaJogo + #466, #3952
  static TelaJogo + #467, #3842
  static TelaJogo + #468, #2849
  static TelaJogo + #469, #2847
  static TelaJogo + #470, #1823
  static TelaJogo + #471, #3871
  static TelaJogo + #472, #3871
  static TelaJogo + #473, #3871
  static TelaJogo + #474, #1823
  static TelaJogo + #475, #3871
  static TelaJogo + #476, #1823
  static TelaJogo + #477, #1823
  static TelaJogo + #478, #1823
  static TelaJogo + #479, #3871

  ;Linha 12
  static TelaJogo + #480, #127
  static TelaJogo + #481, #2847
  static TelaJogo + #482, #2835
  static TelaJogo + #483, #2835
  static TelaJogo + #484, #2835
  static TelaJogo + #485, #2835
  static TelaJogo + #486, #2847
  static TelaJogo + #487, #3947
  static TelaJogo + #488, #3947
  static TelaJogo + #489, #2846
  static TelaJogo + #490, #2849
  static TelaJogo + #491, #127
  static TelaJogo + #492, #127
  static TelaJogo + #493, #127
  static TelaJogo + #494, #2943
  static TelaJogo + #495, #3947
  static TelaJogo + #496, #2849
  static TelaJogo + #497, #127
  static TelaJogo + #498, #127
  static TelaJogo + #499, #127
  static TelaJogo + #500, #3842
  static TelaJogo + #501, #127
  static TelaJogo + #502, #2849
  static TelaJogo + #503, #127
  static TelaJogo + #504, #127
  static TelaJogo + #505, #127
  static TelaJogo + #506, #3952
  static TelaJogo + #507, #3842
  static TelaJogo + #508, #2849
  static TelaJogo + #509, #2847
  static TelaJogo + #510, #2847
  static TelaJogo + #511, #3871
  static TelaJogo + #512, #1823
  static TelaJogo + #513, #3871
  static TelaJogo + #514, #3871
  static TelaJogo + #515, #1823
  static TelaJogo + #516, #1823
  static TelaJogo + #517, #1823
  static TelaJogo + #518, #1823
  static TelaJogo + #519, #1823

  ;Linha 13
  static TelaJogo + #520, #127
  static TelaJogo + #521, #2847
  static TelaJogo + #522, #2835
  static TelaJogo + #523, #2835
  static TelaJogo + #524, #2835
  static TelaJogo + #525, #2835
  static TelaJogo + #526, #2847
  static TelaJogo + #527, #2847
  static TelaJogo + #528, #2835
  static TelaJogo + #529, #127
  static TelaJogo + #530, #2849
  static TelaJogo + #531, #3947
  static TelaJogo + #532, #127
  static TelaJogo + #533, #127
  static TelaJogo + #534, #2943
  static TelaJogo + #535, #2943
  static TelaJogo + #536, #2849
  static TelaJogo + #537, #127
  static TelaJogo + #538, #127
  static TelaJogo + #539, #127
  static TelaJogo + #540, #3842
  static TelaJogo + #541, #127
  static TelaJogo + #542, #2849
  static TelaJogo + #543, #3952
  static TelaJogo + #544, #127
  static TelaJogo + #545, #127
  static TelaJogo + #546, #3952
  static TelaJogo + #547, #3842
  static TelaJogo + #548, #2849
  static TelaJogo + #549, #2847
  static TelaJogo + #550, #2847
  static TelaJogo + #551, #3871
  static TelaJogo + #552, #3871
  static TelaJogo + #553, #3871
  static TelaJogo + #554, #3871
  static TelaJogo + #555, #3871
  static TelaJogo + #556, #1823
  static TelaJogo + #557, #1823
  static TelaJogo + #558, #1823
  static TelaJogo + #559, #3871

  ;Linha 14
  static TelaJogo + #560, #127
  static TelaJogo + #561, #2847
  static TelaJogo + #562, #2835
  static TelaJogo + #563, #2835
  static TelaJogo + #564, #2835
  static TelaJogo + #565, #2591
  static TelaJogo + #566, #2847
  static TelaJogo + #567, #2847
  static TelaJogo + #568, #2835
  static TelaJogo + #569, #3842
  static TelaJogo + #570, #2849
  static TelaJogo + #571, #3947
  static TelaJogo + #572, #127
  static TelaJogo + #573, #127
  static TelaJogo + #574, #3947
  static TelaJogo + #575, #2943
  static TelaJogo + #576, #2849
  static TelaJogo + #577, #127
  static TelaJogo + #578, #127
  static TelaJogo + #579, #127
  static TelaJogo + #580, #3842
  static TelaJogo + #581, #3957
  static TelaJogo + #582, #2849
  static TelaJogo + #583, #127
  static TelaJogo + #584, #3952
  static TelaJogo + #585, #127
  static TelaJogo + #586, #3952
  static TelaJogo + #587, #3842
  static TelaJogo + #588, #2849
  static TelaJogo + #589, #2847
  static TelaJogo + #590, #2847
  static TelaJogo + #591, #3871
  static TelaJogo + #592, #3871
  static TelaJogo + #593, #3871
  static TelaJogo + #594, #3871
  static TelaJogo + #595, #3871
  static TelaJogo + #596, #3871
  static TelaJogo + #597, #1823
  static TelaJogo + #598, #1823
  static TelaJogo + #599, #1823

  ;Linha 15
  static TelaJogo + #600, #2847
  static TelaJogo + #601, #2847
  static TelaJogo + #602, #127
  static TelaJogo + #603, #127
  static TelaJogo + #604, #127
  static TelaJogo + #605, #2591
  static TelaJogo + #606, #2847
  static TelaJogo + #607, #2847
  static TelaJogo + #608, #3947
  static TelaJogo + #609, #3842
  static TelaJogo + #610, #2849
  static TelaJogo + #611, #127
  static TelaJogo + #612, #3947
  static TelaJogo + #613, #127
  static TelaJogo + #614, #3947
  static TelaJogo + #615, #3842
  static TelaJogo + #616, #2849
  static TelaJogo + #617, #127
  static TelaJogo + #618, #127
  static TelaJogo + #619, #127
  static TelaJogo + #620, #3842
  static TelaJogo + #621, #127
  static TelaJogo + #622, #2849
  static TelaJogo + #623, #127
  static TelaJogo + #624, #3952
  static TelaJogo + #625, #127
  static TelaJogo + #626, #3952
  static TelaJogo + #627, #3842
  static TelaJogo + #628, #2849
  static TelaJogo + #629, #2847
  static TelaJogo + #630, #3844
  static TelaJogo + #631, #3871
  static TelaJogo + #632, #3871
  static TelaJogo + #633, #3871
  static TelaJogo + #634, #3871
  static TelaJogo + #635, #1823
  static TelaJogo + #636, #3871
  static TelaJogo + #637, #1823
  static TelaJogo + #638, #1823
  static TelaJogo + #639, #1823

  ;Linha 16
  static TelaJogo + #640, #2847
  static TelaJogo + #641, #127
  static TelaJogo + #642, #127
  static TelaJogo + #643, #127
  static TelaJogo + #644, #127
  static TelaJogo + #645, #2591
  static TelaJogo + #646, #2847
  static TelaJogo + #647, #2847
  static TelaJogo + #648, #3947
  static TelaJogo + #649, #3842
  static TelaJogo + #650, #2849
  static TelaJogo + #651, #127
  static TelaJogo + #652, #127
  static TelaJogo + #653, #3947
  static TelaJogo + #654, #3947
  static TelaJogo + #655, #127
  static TelaJogo + #656, #2849
  static TelaJogo + #657, #3947
  static TelaJogo + #658, #127
  static TelaJogo + #659, #3947
  static TelaJogo + #660, #3842
  static TelaJogo + #661, #127
  static TelaJogo + #662, #2849
  static TelaJogo + #663, #127
  static TelaJogo + #664, #3952
  static TelaJogo + #665, #127
  static TelaJogo + #666, #3952
  static TelaJogo + #667, #3842
  static TelaJogo + #668, #2849
  static TelaJogo + #669, #2847
  static TelaJogo + #670, #3844
  static TelaJogo + #671, #3871
  static TelaJogo + #672, #3871
  static TelaJogo + #673, #1823
  static TelaJogo + #674, #3871
  static TelaJogo + #675, #3871
  static TelaJogo + #676, #3871
  static TelaJogo + #677, #1823
  static TelaJogo + #678, #1823
  static TelaJogo + #679, #1823

  ;Linha 17
  static TelaJogo + #680, #2847
  static TelaJogo + #681, #127
  static TelaJogo + #682, #127
  static TelaJogo + #683, #127
  static TelaJogo + #684, #127
  static TelaJogo + #685, #2591
  static TelaJogo + #686, #2847
  static TelaJogo + #687, #127
  static TelaJogo + #688, #2847
  static TelaJogo + #689, #3842
  static TelaJogo + #690, #2849
  static TelaJogo + #691, #127
  static TelaJogo + #692, #127
  static TelaJogo + #693, #3947
  static TelaJogo + #694, #3957
  static TelaJogo + #695, #127
  static TelaJogo + #696, #2849
  static TelaJogo + #697, #127
  static TelaJogo + #698, #127
  static TelaJogo + #699, #127
  static TelaJogo + #700, #3947
  static TelaJogo + #701, #127
  static TelaJogo + #702, #2849
  static TelaJogo + #703, #3947
  static TelaJogo + #704, #3947
  static TelaJogo + #705, #3952
  static TelaJogo + #706, #3952
  static TelaJogo + #707, #3842
  static TelaJogo + #708, #2849
  static TelaJogo + #709, #2847
  static TelaJogo + #710, #3844
  static TelaJogo + #711, #3871
  static TelaJogo + #712, #3871
  static TelaJogo + #713, #3871
  static TelaJogo + #714, #3871
  static TelaJogo + #715, #3871
  static TelaJogo + #716, #3871
  static TelaJogo + #717, #1823
  static TelaJogo + #718, #1823
  static TelaJogo + #719, #1823

  ;Linha 18
  static TelaJogo + #720, #2847
  static TelaJogo + #721, #127
  static TelaJogo + #722, #127
  static TelaJogo + #723, #127
  static TelaJogo + #724, #127
  static TelaJogo + #725, #2591
  static TelaJogo + #726, #2847
  static TelaJogo + #727, #2847
  static TelaJogo + #728, #2847
  static TelaJogo + #729, #3842
  static TelaJogo + #730, #2849
  static TelaJogo + #731, #127
  static TelaJogo + #732, #3947
  static TelaJogo + #733, #127
  static TelaJogo + #734, #3957
  static TelaJogo + #735, #127
  static TelaJogo + #736, #2849
  static TelaJogo + #737, #127
  static TelaJogo + #738, #127
  static TelaJogo + #739, #3843
  static TelaJogo + #740, #3957
  static TelaJogo + #741, #127
  static TelaJogo + #742, #2849
  static TelaJogo + #743, #127
  static TelaJogo + #744, #127
  static TelaJogo + #745, #3843
  static TelaJogo + #746, #3952
  static TelaJogo + #747, #3842
  static TelaJogo + #748, #2849
  static TelaJogo + #749, #2847
  static TelaJogo + #750, #3844
  static TelaJogo + #751, #3871
  static TelaJogo + #752, #3871
  static TelaJogo + #753, #3871
  static TelaJogo + #754, #3871
  static TelaJogo + #755, #3871
  static TelaJogo + #756, #1823
  static TelaJogo + #757, #1823
  static TelaJogo + #758, #1823
  static TelaJogo + #759, #3871

  ;Linha 19
  static TelaJogo + #760, #2847
  static TelaJogo + #761, #127
  static TelaJogo + #762, #127
  static TelaJogo + #763, #127
  static TelaJogo + #764, #2591
  static TelaJogo + #765, #2847
  static TelaJogo + #766, #2847
  static TelaJogo + #767, #2847
  static TelaJogo + #768, #3947
  static TelaJogo + #769, #3842
  static TelaJogo + #770, #2849
  static TelaJogo + #771, #3842
  static TelaJogo + #772, #3843
  static TelaJogo + #773, #3843
  static TelaJogo + #774, #3843
  static TelaJogo + #775, #127
  static TelaJogo + #776, #2849
  static TelaJogo + #777, #127
  static TelaJogo + #778, #127
  static TelaJogo + #779, #3843
  static TelaJogo + #780, #3843
  static TelaJogo + #781, #127
  static TelaJogo + #782, #2849
  static TelaJogo + #783, #127
  static TelaJogo + #784, #127
  static TelaJogo + #785, #3843
  static TelaJogo + #786, #3843
  static TelaJogo + #787, #3842
  static TelaJogo + #788, #2849
  static TelaJogo + #789, #2847
  static TelaJogo + #790, #3844
  static TelaJogo + #791, #3871
  static TelaJogo + #792, #3871
  static TelaJogo + #793, #3871
  static TelaJogo + #794, #3871
  static TelaJogo + #795, #3871
  static TelaJogo + #796, #3871
  static TelaJogo + #797, #3871
  static TelaJogo + #798, #1823
  static TelaJogo + #799, #1823

  ;Linha 20
  static TelaJogo + #800, #2847
  static TelaJogo + #801, #127
  static TelaJogo + #802, #127
  static TelaJogo + #803, #2847
  static TelaJogo + #804, #2847
  static TelaJogo + #805, #127
  static TelaJogo + #806, #2847
  static TelaJogo + #807, #127
  static TelaJogo + #808, #3947
  static TelaJogo + #809, #3842
  static TelaJogo + #810, #2849
  static TelaJogo + #811, #3843
  static TelaJogo + #812, #3843
  static TelaJogo + #813, #3843
  static TelaJogo + #814, #3843
  static TelaJogo + #815, #127
  static TelaJogo + #816, #2849
  static TelaJogo + #817, #127
  static TelaJogo + #818, #3843
  static TelaJogo + #819, #3843
  static TelaJogo + #820, #3843
  static TelaJogo + #821, #3843
  static TelaJogo + #822, #2849
  static TelaJogo + #823, #3843
  static TelaJogo + #824, #3843
  static TelaJogo + #825, #3843
  static TelaJogo + #826, #3843
  static TelaJogo + #827, #3842
  static TelaJogo + #828, #2849
  static TelaJogo + #829, #2847
  static TelaJogo + #830, #3844
  static TelaJogo + #831, #1823
  static TelaJogo + #832, #3871
  static TelaJogo + #833, #3871
  static TelaJogo + #834, #3871
  static TelaJogo + #835, #3871
  static TelaJogo + #836, #3871
  static TelaJogo + #837, #1823
  static TelaJogo + #838, #3844
  static TelaJogo + #839, #1823

  ;Linha 21
  static TelaJogo + #840, #2847
  static TelaJogo + #841, #2847
  static TelaJogo + #842, #2847
  static TelaJogo + #843, #2591
  static TelaJogo + #844, #2591
  static TelaJogo + #845, #127
  static TelaJogo + #846, #127
  static TelaJogo + #847, #127
  static TelaJogo + #848, #3947
  static TelaJogo + #849, #3842
  static TelaJogo + #850, #2849
  static TelaJogo + #851, #3843
  static TelaJogo + #852, #3843
  static TelaJogo + #853, #3843
  static TelaJogo + #854, #3843
  static TelaJogo + #855, #3843
  static TelaJogo + #856, #2849
  static TelaJogo + #857, #3843
  static TelaJogo + #858, #3843
  static TelaJogo + #859, #3843
  static TelaJogo + #860, #3843
  static TelaJogo + #861, #3873
  static TelaJogo + #862, #2849
  static TelaJogo + #863, #3843
  static TelaJogo + #864, #3843
  static TelaJogo + #865, #3843
  static TelaJogo + #866, #3843
  static TelaJogo + #867, #3843
  static TelaJogo + #868, #2849
  static TelaJogo + #869, #2847
  static TelaJogo + #870, #3844
  static TelaJogo + #871, #3871
  static TelaJogo + #872, #3871
  static TelaJogo + #873, #3871
  static TelaJogo + #874, #3871
  static TelaJogo + #875, #3871
  static TelaJogo + #876, #3871
  static TelaJogo + #877, #3871
  static TelaJogo + #878, #1823
  static TelaJogo + #879, #3844

  ;Linha 22
  static TelaJogo + #880, #127
  static TelaJogo + #881, #2591
  static TelaJogo + #882, #2591
  static TelaJogo + #883, #2591
  static TelaJogo + #884, #2591
  static TelaJogo + #885, #2591
  static TelaJogo + #886, #2591
  static TelaJogo + #887, #127
  static TelaJogo + #888, #2591
  static TelaJogo + #889, #2591
  static TelaJogo + #890, #2849
  static TelaJogo + #891, #3843
  static TelaJogo + #892, #3843
  static TelaJogo + #893, #3843
  static TelaJogo + #894, #3843
  static TelaJogo + #895, #3843
  static TelaJogo + #896, #2849
  static TelaJogo + #897, #3843
  static TelaJogo + #898, #3843
  static TelaJogo + #899, #3843
  static TelaJogo + #900, #3843
  static TelaJogo + #901, #3873
  static TelaJogo + #902, #2849
  static TelaJogo + #903, #3843
  static TelaJogo + #904, #3843
  static TelaJogo + #905, #3843
  static TelaJogo + #906, #3843
  static TelaJogo + #907, #3843
  static TelaJogo + #908, #2849
  static TelaJogo + #909, #127
  static TelaJogo + #910, #3844
  static TelaJogo + #911, #3871
  static TelaJogo + #912, #3871
  static TelaJogo + #913, #3871
  static TelaJogo + #914, #3871
  static TelaJogo + #915, #3844
  static TelaJogo + #916, #1823
  static TelaJogo + #917, #3844
  static TelaJogo + #918, #3871
  static TelaJogo + #919, #3844

  ;Linha 23
  static TelaJogo + #920, #2591
  static TelaJogo + #921, #2591
  static TelaJogo + #922, #2591
  static TelaJogo + #923, #2591
  static TelaJogo + #924, #2591
  static TelaJogo + #925, #2591
  static TelaJogo + #926, #2591
  static TelaJogo + #927, #2591
  static TelaJogo + #928, #2591
  static TelaJogo + #929, #2591
  static TelaJogo + #930, #2849
  static TelaJogo + #931, #3843
  static TelaJogo + #932, #3843
  static TelaJogo + #933, #3843
  static TelaJogo + #934, #3843
  static TelaJogo + #935, #3843
  static TelaJogo + #936, #2849
  static TelaJogo + #937, #3843
  static TelaJogo + #938, #3843
  static TelaJogo + #939, #3843
  static TelaJogo + #940, #3843
  static TelaJogo + #941, #3873
  static TelaJogo + #942, #2849
  static TelaJogo + #943, #127
  static TelaJogo + #944, #3843
  static TelaJogo + #945, #3843
  static TelaJogo + #946, #3843
  static TelaJogo + #947, #127
  static TelaJogo + #948, #2849
  static TelaJogo + #949, #127
  static TelaJogo + #950, #3844
  static TelaJogo + #951, #3871
  static TelaJogo + #952, #3871
  static TelaJogo + #953, #3871
  static TelaJogo + #954, #3871
  static TelaJogo + #955, #3844
  static TelaJogo + #956, #1823
  static TelaJogo + #957, #3844
  static TelaJogo + #958, #3871
  static TelaJogo + #959, #3844

  ;Linha 24
  static TelaJogo + #960, #2591
  static TelaJogo + #961, #2591
  static TelaJogo + #962, #2591
  static TelaJogo + #963, #2591
  static TelaJogo + #964, #2591
  static TelaJogo + #965, #2591
  static TelaJogo + #966, #2591
  static TelaJogo + #967, #2591
  static TelaJogo + #968, #2591
  static TelaJogo + #969, #2591
  static TelaJogo + #970, #2849
  static TelaJogo + #971, #127
  static TelaJogo + #972, #3843
  static TelaJogo + #973, #3843
  static TelaJogo + #974, #3843
  static TelaJogo + #975, #3843
  static TelaJogo + #976, #2849
  static TelaJogo + #977, #127
  static TelaJogo + #978, #127
  static TelaJogo + #979, #3843
  static TelaJogo + #980, #3843
  static TelaJogo + #981, #3873
  static TelaJogo + #982, #2849
  static TelaJogo + #983, #127
  static TelaJogo + #984, #3843
  static TelaJogo + #985, #3843
  static TelaJogo + #986, #127
  static TelaJogo + #987, #127
  static TelaJogo + #988, #2849
  static TelaJogo + #989, #127
  static TelaJogo + #990, #3844
  static TelaJogo + #991, #1823
  static TelaJogo + #992, #3871
  static TelaJogo + #993, #3844
  static TelaJogo + #994, #3871
  static TelaJogo + #995, #3844
  static TelaJogo + #996, #3844
  static TelaJogo + #997, #1823
  static TelaJogo + #998, #1823
  static TelaJogo + #999, #3844

  ;Linha 25
  static TelaJogo + #1000, #2591
  static TelaJogo + #1001, #2591
  static TelaJogo + #1002, #2591
  static TelaJogo + #1003, #2591
  static TelaJogo + #1004, #2591
  static TelaJogo + #1005, #2591
  static TelaJogo + #1006, #2591
  static TelaJogo + #1007, #2591
  static TelaJogo + #1008, #2591
  static TelaJogo + #1009, #2591
  static TelaJogo + #1010, #2849
  static TelaJogo + #1011, #127
  static TelaJogo + #1012, #3374
  static TelaJogo + #1013, #3374
  static TelaJogo + #1014, #3374
  static TelaJogo + #1015, #3843
  static TelaJogo + #1016, #2849
  static TelaJogo + #1017, #127
  static TelaJogo + #1018, #3118
  static TelaJogo + #1019, #3118
  static TelaJogo + #1020, #3118
  static TelaJogo + #1021, #3873
  static TelaJogo + #1022, #2849
  static TelaJogo + #1023, #3843
  static TelaJogo + #1024, #2606
  static TelaJogo + #1025, #2606
  static TelaJogo + #1026, #2606
  static TelaJogo + #1027, #127
  static TelaJogo + #1028, #2849
  static TelaJogo + #1029, #127
  static TelaJogo + #1030, #3844
  static TelaJogo + #1031, #1823
  static TelaJogo + #1032, #3844
  static TelaJogo + #1033, #3844
  static TelaJogo + #1034, #3871
  static TelaJogo + #1035, #3844
  static TelaJogo + #1036, #3844
  static TelaJogo + #1037, #1823
  static TelaJogo + #1038, #1823
  static TelaJogo + #1039, #3844

  ;Linha 26
  static TelaJogo + #1040, #2591
  static TelaJogo + #1041, #2591
  static TelaJogo + #1042, #592
  static TelaJogo + #1043, #591
  static TelaJogo + #1044, #590
  static TelaJogo + #1045, #596
  static TelaJogo + #1046, #591
  static TelaJogo + #1047, #2643
  static TelaJogo + #1048, #2591
  static TelaJogo + #1049, #2591
  static TelaJogo + #1050, #2849
  static TelaJogo + #1051, #3374
  static TelaJogo + #1052, #3374
  static TelaJogo + #1053, #3374
  static TelaJogo + #1054, #3374
  static TelaJogo + #1055, #3374
  static TelaJogo + #1056, #2849
  static TelaJogo + #1057, #3118
  static TelaJogo + #1058, #3118
  static TelaJogo + #1059, #3118
  static TelaJogo + #1060, #3118
  static TelaJogo + #1061, #3118
  static TelaJogo + #1062, #2849
  static TelaJogo + #1063, #2606
  static TelaJogo + #1064, #2606
  static TelaJogo + #1065, #2606
  static TelaJogo + #1066, #2606
  static TelaJogo + #1067, #2606
  static TelaJogo + #1068, #2849
  static TelaJogo + #1069, #127
  static TelaJogo + #1070, #3844
  static TelaJogo + #1071, #3844
  static TelaJogo + #1072, #3871
  static TelaJogo + #1073, #3844
  static TelaJogo + #1074, #3844
  static TelaJogo + #1075, #3844
  static TelaJogo + #1076, #3844
  static TelaJogo + #1077, #1823
  static TelaJogo + #1078, #1823
  static TelaJogo + #1079, #2841

  ;Linha 27
  static TelaJogo + #1080, #2591
  static TelaJogo + #1081, #2591
  static TelaJogo + #1082, #2605
  static TelaJogo + #1083, #2605
  static TelaJogo + #1084, #2608
  static TelaJogo + #1085, #2608
  static TelaJogo + #1086, #2605
  static TelaJogo + #1087, #2605
  static TelaJogo + #1088, #2591
  static TelaJogo + #1089, #2591
  static TelaJogo + #1090, #2849
  static TelaJogo + #1091, #3374
  static TelaJogo + #1092, #3374
  static TelaJogo + #1093, #3374
  static TelaJogo + #1094, #3374
  static TelaJogo + #1095, #3374
  static TelaJogo + #1096, #2849
  static TelaJogo + #1097, #3118
  static TelaJogo + #1098, #3118
  static TelaJogo + #1099, #3118
  static TelaJogo + #1100, #3118
  static TelaJogo + #1101, #3118
  static TelaJogo + #1102, #2849
  static TelaJogo + #1103, #2606
  static TelaJogo + #1104, #2606
  static TelaJogo + #1105, #2606
  static TelaJogo + #1106, #2606
  static TelaJogo + #1107, #2606
  static TelaJogo + #1108, #2849
  static TelaJogo + #1109, #127
  static TelaJogo + #1110, #3844
  static TelaJogo + #1111, #3844
  static TelaJogo + #1112, #3871
  static TelaJogo + #1113, #3844
  static TelaJogo + #1114, #3844
  static TelaJogo + #1115, #3844
  static TelaJogo + #1116, #3844
  static TelaJogo + #1117, #3844
  static TelaJogo + #1118, #1823
  static TelaJogo + #1119, #3844

  ;Linha 28
  static TelaJogo + #1120, #2591
  static TelaJogo + #1121, #2591
  static TelaJogo + #1122, #2591
  static TelaJogo + #1123, #2591
  static TelaJogo + #1124, #2591
  static TelaJogo + #1125, #2591
  static TelaJogo + #1126, #2591
  static TelaJogo + #1127, #2591
  static TelaJogo + #1128, #2591
  static TelaJogo + #1129, #2591
  static TelaJogo + #1130, #2849
  static TelaJogo + #1131, #3886
  static TelaJogo + #1132, #3374
  static TelaJogo + #1133, #1862
  static TelaJogo + #1134, #3374
  static TelaJogo + #1135, #3843
  static TelaJogo + #1136, #2849
  static TelaJogo + #1137, #3842
  static TelaJogo + #1138, #3118
  static TelaJogo + #1139, #1866
  static TelaJogo + #1140, #3118
  static TelaJogo + #1141, #127
  static TelaJogo + #1142, #2849
  static TelaJogo + #1143, #3901
  static TelaJogo + #1144, #2606
  static TelaJogo + #1145, #75
  static TelaJogo + #1146, #2606
  static TelaJogo + #1147, #127
  static TelaJogo + #1148, #2849
  static TelaJogo + #1149, #127
  static TelaJogo + #1150, #3844
  static TelaJogo + #1151, #3844
  static TelaJogo + #1152, #3871
  static TelaJogo + #1153, #3844
  static TelaJogo + #1154, #3844
  static TelaJogo + #1155, #3844
  static TelaJogo + #1156, #3844
  static TelaJogo + #1157, #3844
  static TelaJogo + #1158, #1051
  static TelaJogo + #1159, #2835

  ;Linha 29
  static TelaJogo + #1160, #2591
  static TelaJogo + #1161, #2591
  static TelaJogo + #1162, #2591
  static TelaJogo + #1163, #2591
  static TelaJogo + #1164, #2591
  static TelaJogo + #1165, #2847
  static TelaJogo + #1166, #2847
  static TelaJogo + #1167, #2847
  static TelaJogo + #1168, #2591
  static TelaJogo + #1169, #2591
  static TelaJogo + #1170, #2849
  static TelaJogo + #1171, #3843
  static TelaJogo + #1172, #3843
  static TelaJogo + #1173, #3843
  static TelaJogo + #1174, #3843
  static TelaJogo + #1175, #3843
  static TelaJogo + #1176, #2849
  static TelaJogo + #1177, #127
  static TelaJogo + #1178, #127
  static TelaJogo + #1179, #127
  static TelaJogo + #1180, #127
  static TelaJogo + #1181, #127
  static TelaJogo + #1182, #2849
  static TelaJogo + #1183, #127
  static TelaJogo + #1184, #127
  static TelaJogo + #1185, #127
  static TelaJogo + #1186, #127
  static TelaJogo + #1187, #2836
  static TelaJogo + #1188, #2849
  static TelaJogo + #1189, #127
  static TelaJogo + #1190, #2847
  static TelaJogo + #1191, #3844
  static TelaJogo + #1192, #3871
  static TelaJogo + #1193, #3844
  static TelaJogo + #1194, #3844
  static TelaJogo + #1195, #3844
  static TelaJogo + #1196, #3844
  static TelaJogo + #1197, #3844
  static TelaJogo + #1198, #2835
  static TelaJogo + #1199, #127

printTelaJogoScreen:
  push R0
  push R1
  push R2
  push R3

  loadn R0, #TelaJogo
  loadn R1, #0
  loadn R2, #1200

  printTelaJogoScreenLoop:

    add R3,R0,R1
    loadi R3, R3
    outchar R3, R1
    inc R1
    cmp R1, R2

    jne printTelaJogoScreenLoop

  pop R3
  pop R2
  pop R1
  pop R0
  rts
  
  ; ------------------------------------------------------------TELA INICIAL------------------------------------------------------------
  
  TelaInicial : var #1200
  ;Linha 0
  static TelaInicial + #0, #127
  static TelaInicial + #1, #127
  static TelaInicial + #2, #127
  static TelaInicial + #3, #127
  static TelaInicial + #4, #127
  static TelaInicial + #5, #127
  static TelaInicial + #6, #127
  static TelaInicial + #7, #127
  static TelaInicial + #8, #2591
  static TelaInicial + #9, #2834
  static TelaInicial + #10, #3885
  static TelaInicial + #11, #2591
  static TelaInicial + #12, #127
  static TelaInicial + #13, #127
  static TelaInicial + #14, #3947
  static TelaInicial + #15, #127
  static TelaInicial + #16, #3885
  static TelaInicial + #17, #3885
  static TelaInicial + #18, #3885
  static TelaInicial + #19, #3885
  static TelaInicial + #20, #3885
  static TelaInicial + #21, #3885
  static TelaInicial + #22, #3885
  static TelaInicial + #23, #3873
  static TelaInicial + #24, #127
  static TelaInicial + #25, #3957
  static TelaInicial + #26, #3952
  static TelaInicial + #27, #3873
  static TelaInicial + #28, #3885
  static TelaInicial + #29, #3885
  static TelaInicial + #30, #2846
  static TelaInicial + #31, #127
  static TelaInicial + #32, #2842
  static TelaInicial + #33, #2842
  static TelaInicial + #34, #2842
  static TelaInicial + #35, #2842
  static TelaInicial + #36, #2842
  static TelaInicial + #37, #2842
  static TelaInicial + #38, #3875
  static TelaInicial + #39, #3875

  ;Linha 1
  static TelaInicial + #40, #127
  static TelaInicial + #41, #2829
  static TelaInicial + #42, #2829
  static TelaInicial + #43, #2835
  static TelaInicial + #44, #127
  static TelaInicial + #45, #127
  static TelaInicial + #46, #127
  static TelaInicial + #47, #127
  static TelaInicial + #48, #2834
  static TelaInicial + #49, #2834
  static TelaInicial + #50, #3885
  static TelaInicial + #51, #2591
  static TelaInicial + #52, #127
  static TelaInicial + #53, #3844
  static TelaInicial + #54, #3957
  static TelaInicial + #55, #3885
  static TelaInicial + #56, #3885
  static TelaInicial + #57, #127
  static TelaInicial + #58, #127
  static TelaInicial + #59, #3842
  static TelaInicial + #60, #2943
  static TelaInicial + #61, #2943
  static TelaInicial + #62, #3885
  static TelaInicial + #63, #3873
  static TelaInicial + #64, #127
  static TelaInicial + #65, #127
  static TelaInicial + #66, #3952
  static TelaInicial + #67, #3885
  static TelaInicial + #68, #3885
  static TelaInicial + #69, #3885
  static TelaInicial + #70, #127
  static TelaInicial + #71, #2846
  static TelaInicial + #72, #3885
  static TelaInicial + #73, #3885
  static TelaInicial + #74, #3885
  static TelaInicial + #75, #3885
  static TelaInicial + #76, #3875
  static TelaInicial + #77, #3875
  static TelaInicial + #78, #3875
  static TelaInicial + #79, #127

  ;Linha 2
  static TelaInicial + #80, #127
  static TelaInicial + #81, #2829
  static TelaInicial + #82, #2829
  static TelaInicial + #83, #2835
  static TelaInicial + #84, #3875
  static TelaInicial + #85, #35
  static TelaInicial + #86, #35
  static TelaInicial + #87, #35
  static TelaInicial + #88, #2834
  static TelaInicial + #89, #2834
  static TelaInicial + #90, #3885
  static TelaInicial + #91, #2591
  static TelaInicial + #92, #127
  static TelaInicial + #93, #127
  static TelaInicial + #94, #3947
  static TelaInicial + #95, #127
  static TelaInicial + #96, #3885
  static TelaInicial + #97, #127
  static TelaInicial + #98, #127
  static TelaInicial + #99, #2943
  static TelaInicial + #100, #2943
  static TelaInicial + #101, #2943
  static TelaInicial + #102, #3885
  static TelaInicial + #103, #3873
  static TelaInicial + #104, #127
  static TelaInicial + #105, #3957
  static TelaInicial + #106, #3952
  static TelaInicial + #107, #3885
  static TelaInicial + #108, #3885
  static TelaInicial + #109, #3885
  static TelaInicial + #110, #3875
  static TelaInicial + #111, #3875
  static TelaInicial + #112, #3875
  static TelaInicial + #113, #3875
  static TelaInicial + #114, #3875
  static TelaInicial + #115, #3875
  static TelaInicial + #116, #3875
  static TelaInicial + #117, #3885
  static TelaInicial + #118, #3885
  static TelaInicial + #119, #127

  ;Linha 3
  static TelaInicial + #120, #127
  static TelaInicial + #121, #2847
  static TelaInicial + #122, #2829
  static TelaInicial + #123, #2835
  static TelaInicial + #124, #3875
  static TelaInicial + #125, #35
  static TelaInicial + #126, #35
  static TelaInicial + #127, #35
  static TelaInicial + #128, #2834
  static TelaInicial + #129, #2591
  static TelaInicial + #130, #3885
  static TelaInicial + #131, #2591
  static TelaInicial + #132, #2851
  static TelaInicial + #133, #2851
  static TelaInicial + #134, #2851
  static TelaInicial + #135, #2591
  static TelaInicial + #136, #2851
  static TelaInicial + #137, #2851
  static TelaInicial + #138, #2851
  static TelaInicial + #139, #2851
  static TelaInicial + #140, #3952
  static TelaInicial + #141, #2851
  static TelaInicial + #142, #2851
  static TelaInicial + #143, #2851
  static TelaInicial + #144, #2851
  static TelaInicial + #145, #3875
  static TelaInicial + #146, #2851
  static TelaInicial + #147, #2851
  static TelaInicial + #148, #2851
  static TelaInicial + #149, #2851
  static TelaInicial + #150, #3875
  static TelaInicial + #151, #2851
  static TelaInicial + #152, #2851
  static TelaInicial + #153, #2851
  static TelaInicial + #154, #2851
  static TelaInicial + #155, #3871
  static TelaInicial + #156, #2847
  static TelaInicial + #157, #1823
  static TelaInicial + #158, #2847
  static TelaInicial + #159, #127

  ;Linha 4
  static TelaInicial + #160, #2829
  static TelaInicial + #161, #2847
  static TelaInicial + #162, #2834
  static TelaInicial + #163, #2834
  static TelaInicial + #164, #2834
  static TelaInicial + #165, #35
  static TelaInicial + #166, #35
  static TelaInicial + #167, #35
  static TelaInicial + #168, #3199
  static TelaInicial + #169, #3199
  static TelaInicial + #170, #3885
  static TelaInicial + #171, #2851
  static TelaInicial + #172, #3875
  static TelaInicial + #173, #3875
  static TelaInicial + #174, #3875
  static TelaInicial + #175, #3875
  static TelaInicial + #176, #2851
  static TelaInicial + #177, #3875
  static TelaInicial + #178, #3875
  static TelaInicial + #179, #2851
  static TelaInicial + #180, #3875
  static TelaInicial + #181, #2851
  static TelaInicial + #182, #3885
  static TelaInicial + #183, #3873
  static TelaInicial + #184, #2851
  static TelaInicial + #185, #3875
  static TelaInicial + #186, #2851
  static TelaInicial + #187, #3875
  static TelaInicial + #188, #3885
  static TelaInicial + #189, #3885
  static TelaInicial + #190, #127
  static TelaInicial + #191, #2851
  static TelaInicial + #192, #3875
  static TelaInicial + #193, #3875
  static TelaInicial + #194, #2851
  static TelaInicial + #195, #3871
  static TelaInicial + #196, #3871
  static TelaInicial + #197, #1823
  static TelaInicial + #198, #1823
  static TelaInicial + #199, #1823

  ;Linha 5
  static TelaInicial + #200, #2834
  static TelaInicial + #201, #2847
  static TelaInicial + #202, #2834
  static TelaInicial + #203, #2834
  static TelaInicial + #204, #2834
  static TelaInicial + #205, #3199
  static TelaInicial + #206, #35
  static TelaInicial + #207, #35
  static TelaInicial + #208, #2846
  static TelaInicial + #209, #3199
  static TelaInicial + #210, #3199
  static TelaInicial + #211, #2851
  static TelaInicial + #212, #3875
  static TelaInicial + #213, #3875
  static TelaInicial + #214, #3199
  static TelaInicial + #215, #2591
  static TelaInicial + #216, #2851
  static TelaInicial + #217, #3875
  static TelaInicial + #218, #3875
  static TelaInicial + #219, #2851
  static TelaInicial + #220, #3875
  static TelaInicial + #221, #2851
  static TelaInicial + #222, #3875
  static TelaInicial + #223, #3873
  static TelaInicial + #224, #2851
  static TelaInicial + #225, #3875
  static TelaInicial + #226, #2851
  static TelaInicial + #227, #3875
  static TelaInicial + #228, #3875
  static TelaInicial + #229, #3875
  static TelaInicial + #230, #3875
  static TelaInicial + #231, #2851
  static TelaInicial + #232, #3875
  static TelaInicial + #233, #1823
  static TelaInicial + #234, #2851
  static TelaInicial + #235, #3871
  static TelaInicial + #236, #3871
  static TelaInicial + #237, #1823
  static TelaInicial + #238, #1823
  static TelaInicial + #239, #1823

  ;Linha 6
  static TelaInicial + #240, #2834
  static TelaInicial + #241, #2834
  static TelaInicial + #242, #2834
  static TelaInicial + #243, #3846
  static TelaInicial + #244, #3199
  static TelaInicial + #245, #3964
  static TelaInicial + #246, #2339
  static TelaInicial + #247, #2339
  static TelaInicial + #248, #2846
  static TelaInicial + #249, #2846
  static TelaInicial + #250, #3199
  static TelaInicial + #251, #2851
  static TelaInicial + #252, #3875
  static TelaInicial + #253, #3875
  static TelaInicial + #254, #3875
  static TelaInicial + #255, #2591
  static TelaInicial + #256, #2851
  static TelaInicial + #257, #2851
  static TelaInicial + #258, #2851
  static TelaInicial + #259, #2851
  static TelaInicial + #260, #3875
  static TelaInicial + #261, #2851
  static TelaInicial + #262, #2851
  static TelaInicial + #263, #2851
  static TelaInicial + #264, #2851
  static TelaInicial + #265, #3875
  static TelaInicial + #266, #2851
  static TelaInicial + #267, #2851
  static TelaInicial + #268, #2851
  static TelaInicial + #269, #2851
  static TelaInicial + #270, #3875
  static TelaInicial + #271, #2851
  static TelaInicial + #272, #1823
  static TelaInicial + #273, #1823
  static TelaInicial + #274, #2851
  static TelaInicial + #275, #1823
  static TelaInicial + #276, #1823
  static TelaInicial + #277, #1823
  static TelaInicial + #278, #1823
  static TelaInicial + #279, #1823

  ;Linha 7
  static TelaInicial + #280, #127
  static TelaInicial + #281, #2847
  static TelaInicial + #282, #3964
  static TelaInicial + #283, #3199
  static TelaInicial + #284, #3199
  static TelaInicial + #285, #3964
  static TelaInicial + #286, #2595
  static TelaInicial + #287, #2595
  static TelaInicial + #288, #3964
  static TelaInicial + #289, #3964
  static TelaInicial + #290, #3199
  static TelaInicial + #291, #2851
  static TelaInicial + #292, #3875
  static TelaInicial + #293, #3875
  static TelaInicial + #294, #3875
  static TelaInicial + #295, #2591
  static TelaInicial + #296, #2851
  static TelaInicial + #297, #3199
  static TelaInicial + #298, #2943
  static TelaInicial + #299, #2851
  static TelaInicial + #300, #3875
  static TelaInicial + #301, #2851
  static TelaInicial + #302, #3885
  static TelaInicial + #303, #3873
  static TelaInicial + #304, #2851
  static TelaInicial + #305, #3875
  static TelaInicial + #306, #3952
  static TelaInicial + #307, #3875
  static TelaInicial + #308, #3875
  static TelaInicial + #309, #2851
  static TelaInicial + #310, #3875
  static TelaInicial + #311, #2851
  static TelaInicial + #312, #1823
  static TelaInicial + #313, #1823
  static TelaInicial + #314, #2851
  static TelaInicial + #315, #1823
  static TelaInicial + #316, #1823
  static TelaInicial + #317, #1823
  static TelaInicial + #318, #1823
  static TelaInicial + #319, #1823

  ;Linha 8
  static TelaInicial + #320, #127
  static TelaInicial + #321, #2847
  static TelaInicial + #322, #127
  static TelaInicial + #323, #3199
  static TelaInicial + #324, #3199
  static TelaInicial + #325, #3964
  static TelaInicial + #326, #2851
  static TelaInicial + #327, #2851
  static TelaInicial + #328, #2846
  static TelaInicial + #329, #3199
  static TelaInicial + #330, #3199
  static TelaInicial + #331, #3199
  static TelaInicial + #332, #2851
  static TelaInicial + #333, #2851
  static TelaInicial + #334, #2851
  static TelaInicial + #335, #2591
  static TelaInicial + #336, #2851
  static TelaInicial + #337, #3199
  static TelaInicial + #338, #127
  static TelaInicial + #339, #2851
  static TelaInicial + #340, #3875
  static TelaInicial + #341, #2851
  static TelaInicial + #342, #3885
  static TelaInicial + #343, #127
  static TelaInicial + #344, #2851
  static TelaInicial + #345, #3875
  static TelaInicial + #346, #2851
  static TelaInicial + #347, #2851
  static TelaInicial + #348, #2851
  static TelaInicial + #349, #2851
  static TelaInicial + #350, #3875
  static TelaInicial + #351, #2851
  static TelaInicial + #352, #2851
  static TelaInicial + #353, #2851
  static TelaInicial + #354, #2851
  static TelaInicial + #355, #1823
  static TelaInicial + #356, #3871
  static TelaInicial + #357, #1823
  static TelaInicial + #358, #1823
  static TelaInicial + #359, #2847

  ;Linha 9
  static TelaInicial + #360, #127
  static TelaInicial + #361, #2847
  static TelaInicial + #362, #127
  static TelaInicial + #363, #127
  static TelaInicial + #364, #3199
  static TelaInicial + #365, #3199
  static TelaInicial + #366, #3363
  static TelaInicial + #367, #3363
  static TelaInicial + #368, #3199
  static TelaInicial + #369, #3885
  static TelaInicial + #370, #3199
  static TelaInicial + #371, #3964
  static TelaInicial + #372, #3964
  static TelaInicial + #373, #3964
  static TelaInicial + #374, #3199
  static TelaInicial + #375, #2591
  static TelaInicial + #376, #3199
  static TelaInicial + #377, #3199
  static TelaInicial + #378, #127
  static TelaInicial + #379, #127
  static TelaInicial + #380, #3842
  static TelaInicial + #381, #3885
  static TelaInicial + #382, #3885
  static TelaInicial + #383, #3957
  static TelaInicial + #384, #127
  static TelaInicial + #385, #127
  static TelaInicial + #386, #3952
  static TelaInicial + #387, #3842
  static TelaInicial + #388, #3885
  static TelaInicial + #389, #2847
  static TelaInicial + #390, #2847
  static TelaInicial + #391, #1823
  static TelaInicial + #392, #1823
  static TelaInicial + #393, #2846
  static TelaInicial + #394, #1823
  static TelaInicial + #395, #1823
  static TelaInicial + #396, #1823
  static TelaInicial + #397, #1823
  static TelaInicial + #398, #1823
  static TelaInicial + #399, #1823

  ;Linha 10
  static TelaInicial + #400, #127
  static TelaInicial + #401, #2847
  static TelaInicial + #402, #127
  static TelaInicial + #403, #127
  static TelaInicial + #404, #2835
  static TelaInicial + #405, #2835
  static TelaInicial + #406, #35
  static TelaInicial + #407, #35
  static TelaInicial + #408, #3947
  static TelaInicial + #409, #3885
  static TelaInicial + #410, #3199
  static TelaInicial + #411, #127
  static TelaInicial + #412, #127
  static TelaInicial + #413, #127
  static TelaInicial + #414, #3199
  static TelaInicial + #415, #3964
  static TelaInicial + #416, #3199
  static TelaInicial + #417, #3199
  static TelaInicial + #418, #3199
  static TelaInicial + #419, #3875
  static TelaInicial + #420, #3842
  static TelaInicial + #421, #3960
  static TelaInicial + #422, #3885
  static TelaInicial + #423, #127
  static TelaInicial + #424, #127
  static TelaInicial + #425, #127
  static TelaInicial + #426, #3952
  static TelaInicial + #427, #127
  static TelaInicial + #428, #3885
  static TelaInicial + #429, #2847
  static TelaInicial + #430, #1823
  static TelaInicial + #431, #3871
  static TelaInicial + #432, #3871
  static TelaInicial + #433, #3871
  static TelaInicial + #434, #1823
  static TelaInicial + #435, #1823
  static TelaInicial + #436, #1823
  static TelaInicial + #437, #3964
  static TelaInicial + #438, #3964
  static TelaInicial + #439, #3871

  ;Linha 11
  static TelaInicial + #440, #127
  static TelaInicial + #441, #2847
  static TelaInicial + #442, #127
  static TelaInicial + #443, #2835
  static TelaInicial + #444, #2835
  static TelaInicial + #445, #2835
  static TelaInicial + #446, #35
  static TelaInicial + #447, #35
  static TelaInicial + #448, #3947
  static TelaInicial + #449, #3885
  static TelaInicial + #450, #3885
  static TelaInicial + #451, #127
  static TelaInicial + #452, #127
  static TelaInicial + #453, #127
  static TelaInicial + #454, #3199
  static TelaInicial + #455, #3947
  static TelaInicial + #456, #2851
  static TelaInicial + #457, #3199
  static TelaInicial + #458, #3199
  static TelaInicial + #459, #2851
  static TelaInicial + #460, #3964
  static TelaInicial + #461, #2851
  static TelaInicial + #462, #2851
  static TelaInicial + #463, #2851
  static TelaInicial + #464, #2851
  static TelaInicial + #465, #3964
  static TelaInicial + #466, #2851
  static TelaInicial + #467, #2851
  static TelaInicial + #468, #2851
  static TelaInicial + #469, #3875
  static TelaInicial + #470, #1823
  static TelaInicial + #471, #2851
  static TelaInicial + #472, #2851
  static TelaInicial + #473, #2851
  static TelaInicial + #474, #2851
  static TelaInicial + #475, #3964
  static TelaInicial + #476, #3964
  static TelaInicial + #477, #1823
  static TelaInicial + #478, #1823
  static TelaInicial + #479, #3871

  ;Linha 12
  static TelaInicial + #480, #127
  static TelaInicial + #481, #2847
  static TelaInicial + #482, #2835
  static TelaInicial + #483, #2835
  static TelaInicial + #484, #2835
  static TelaInicial + #485, #2835
  static TelaInicial + #486, #35
  static TelaInicial + #487, #35
  static TelaInicial + #488, #3947
  static TelaInicial + #489, #3885
  static TelaInicial + #490, #3885
  static TelaInicial + #491, #3885
  static TelaInicial + #492, #127
  static TelaInicial + #493, #127
  static TelaInicial + #494, #3199
  static TelaInicial + #495, #3947
  static TelaInicial + #496, #2851
  static TelaInicial + #497, #3199
  static TelaInicial + #498, #3199
  static TelaInicial + #499, #2851
  static TelaInicial + #500, #3960
  static TelaInicial + #501, #2851
  static TelaInicial + #502, #3964
  static TelaInicial + #503, #3964
  static TelaInicial + #504, #3964
  static TelaInicial + #505, #3964
  static TelaInicial + #506, #2851
  static TelaInicial + #507, #3964
  static TelaInicial + #508, #3885
  static TelaInicial + #509, #2851
  static TelaInicial + #510, #2847
  static TelaInicial + #511, #2851
  static TelaInicial + #512, #3964
  static TelaInicial + #513, #3964
  static TelaInicial + #514, #2851
  static TelaInicial + #515, #3964
  static TelaInicial + #516, #1823
  static TelaInicial + #517, #1823
  static TelaInicial + #518, #1823
  static TelaInicial + #519, #2687

  ;Linha 13
  static TelaInicial + #520, #127
  static TelaInicial + #521, #2847
  static TelaInicial + #522, #2835
  static TelaInicial + #523, #2835
  static TelaInicial + #524, #2835
  static TelaInicial + #525, #2835
  static TelaInicial + #526, #35
  static TelaInicial + #527, #35
  static TelaInicial + #528, #2835
  static TelaInicial + #529, #3885
  static TelaInicial + #530, #3885
  static TelaInicial + #531, #3885
  static TelaInicial + #532, #127
  static TelaInicial + #533, #127
  static TelaInicial + #534, #2943
  static TelaInicial + #535, #2943
  static TelaInicial + #536, #2851
  static TelaInicial + #537, #2851
  static TelaInicial + #538, #2851
  static TelaInicial + #539, #2851
  static TelaInicial + #540, #3960
  static TelaInicial + #541, #2851
  static TelaInicial + #542, #2851
  static TelaInicial + #543, #2851
  static TelaInicial + #544, #127
  static TelaInicial + #545, #3964
  static TelaInicial + #546, #2851
  static TelaInicial + #547, #2851
  static TelaInicial + #548, #2851
  static TelaInicial + #549, #3964
  static TelaInicial + #550, #3964
  static TelaInicial + #551, #2851
  static TelaInicial + #552, #3964
  static TelaInicial + #553, #3964
  static TelaInicial + #554, #2851
  static TelaInicial + #555, #3871
  static TelaInicial + #556, #1823
  static TelaInicial + #557, #1823
  static TelaInicial + #558, #2687
  static TelaInicial + #559, #3871

  ;Linha 14
  static TelaInicial + #560, #127
  static TelaInicial + #561, #2847
  static TelaInicial + #562, #2835
  static TelaInicial + #563, #2835
  static TelaInicial + #564, #2835
  static TelaInicial + #565, #2591
  static TelaInicial + #566, #35
  static TelaInicial + #567, #35
  static TelaInicial + #568, #2835
  static TelaInicial + #569, #3842
  static TelaInicial + #570, #3885
  static TelaInicial + #571, #3885
  static TelaInicial + #572, #127
  static TelaInicial + #573, #127
  static TelaInicial + #574, #3947
  static TelaInicial + #575, #2943
  static TelaInicial + #576, #2851
  static TelaInicial + #577, #3199
  static TelaInicial + #578, #127
  static TelaInicial + #579, #2851
  static TelaInicial + #580, #3960
  static TelaInicial + #581, #2851
  static TelaInicial + #582, #3885
  static TelaInicial + #583, #3885
  static TelaInicial + #584, #3885
  static TelaInicial + #585, #127
  static TelaInicial + #586, #2851
  static TelaInicial + #587, #3842
  static TelaInicial + #588, #3885
  static TelaInicial + #589, #2851
  static TelaInicial + #590, #2847
  static TelaInicial + #591, #2851
  static TelaInicial + #592, #3964
  static TelaInicial + #593, #3871
  static TelaInicial + #594, #2851
  static TelaInicial + #595, #3871
  static TelaInicial + #596, #3871
  static TelaInicial + #597, #1823
  static TelaInicial + #598, #1823
  static TelaInicial + #599, #1823

  ;Linha 15
  static TelaInicial + #600, #2847
  static TelaInicial + #601, #2847
  static TelaInicial + #602, #127
  static TelaInicial + #603, #127
  static TelaInicial + #604, #127
  static TelaInicial + #605, #2591
  static TelaInicial + #606, #35
  static TelaInicial + #607, #35
  static TelaInicial + #608, #3947
  static TelaInicial + #609, #3842
  static TelaInicial + #610, #3885
  static TelaInicial + #611, #127
  static TelaInicial + #612, #3947
  static TelaInicial + #613, #127
  static TelaInicial + #614, #3947
  static TelaInicial + #615, #3842
  static TelaInicial + #616, #2851
  static TelaInicial + #617, #127
  static TelaInicial + #618, #127
  static TelaInicial + #619, #2851
  static TelaInicial + #620, #3960
  static TelaInicial + #621, #2851
  static TelaInicial + #622, #3885
  static TelaInicial + #623, #127
  static TelaInicial + #624, #3885
  static TelaInicial + #625, #3885
  static TelaInicial + #626, #2851
  static TelaInicial + #627, #3885
  static TelaInicial + #628, #3885
  static TelaInicial + #629, #2851
  static TelaInicial + #630, #3844
  static TelaInicial + #631, #2851
  static TelaInicial + #632, #3871
  static TelaInicial + #633, #3871
  static TelaInicial + #634, #2851
  static TelaInicial + #635, #1823
  static TelaInicial + #636, #3871
  static TelaInicial + #637, #2687
  static TelaInicial + #638, #1823
  static TelaInicial + #639, #1823

  ;Linha 16
  static TelaInicial + #640, #2847
  static TelaInicial + #641, #127
  static TelaInicial + #642, #127
  static TelaInicial + #643, #127
  static TelaInicial + #644, #127
  static TelaInicial + #645, #2591
  static TelaInicial + #646, #35
  static TelaInicial + #647, #35
  static TelaInicial + #648, #3947
  static TelaInicial + #649, #3842
  static TelaInicial + #650, #3885
  static TelaInicial + #651, #127
  static TelaInicial + #652, #127
  static TelaInicial + #653, #3947
  static TelaInicial + #654, #3947
  static TelaInicial + #655, #127
  static TelaInicial + #656, #2851
  static TelaInicial + #657, #3947
  static TelaInicial + #658, #127
  static TelaInicial + #659, #2851
  static TelaInicial + #660, #3960
  static TelaInicial + #661, #2851
  static TelaInicial + #662, #2851
  static TelaInicial + #663, #2851
  static TelaInicial + #664, #2851
  static TelaInicial + #665, #3875
  static TelaInicial + #666, #2851
  static TelaInicial + #667, #3885
  static TelaInicial + #668, #3885
  static TelaInicial + #669, #2851
  static TelaInicial + #670, #3844
  static TelaInicial + #671, #2851
  static TelaInicial + #672, #2851
  static TelaInicial + #673, #2851
  static TelaInicial + #674, #2851
  static TelaInicial + #675, #3871
  static TelaInicial + #676, #3871
  static TelaInicial + #677, #1823
  static TelaInicial + #678, #1823
  static TelaInicial + #679, #1823

  ;Linha 17
  static TelaInicial + #680, #2847
  static TelaInicial + #681, #127
  static TelaInicial + #682, #127
  static TelaInicial + #683, #127
  static TelaInicial + #684, #127
  static TelaInicial + #685, #2591
  static TelaInicial + #686, #35
  static TelaInicial + #687, #35
  static TelaInicial + #688, #2847
  static TelaInicial + #689, #3842
  static TelaInicial + #690, #3885
  static TelaInicial + #691, #127
  static TelaInicial + #692, #127
  static TelaInicial + #693, #3947
  static TelaInicial + #694, #3957
  static TelaInicial + #695, #127
  static TelaInicial + #696, #3885
  static TelaInicial + #697, #127
  static TelaInicial + #698, #127
  static TelaInicial + #699, #3960
  static TelaInicial + #700, #3960
  static TelaInicial + #701, #3885
  static TelaInicial + #702, #3885
  static TelaInicial + #703, #3947
  static TelaInicial + #704, #3947
  static TelaInicial + #705, #3952
  static TelaInicial + #706, #3952
  static TelaInicial + #707, #3885
  static TelaInicial + #708, #3885
  static TelaInicial + #709, #2847
  static TelaInicial + #710, #3844
  static TelaInicial + #711, #3871
  static TelaInicial + #712, #3871
  static TelaInicial + #713, #3871
  static TelaInicial + #714, #2687
  static TelaInicial + #715, #2687
  static TelaInicial + #716, #3871
  static TelaInicial + #717, #1823
  static TelaInicial + #718, #1823
  static TelaInicial + #719, #1823

  ;Linha 18
  static TelaInicial + #720, #2847
  static TelaInicial + #721, #127
  static TelaInicial + #722, #127
  static TelaInicial + #723, #3107
  static TelaInicial + #724, #127
  static TelaInicial + #725, #2591
  static TelaInicial + #726, #35
  static TelaInicial + #727, #35
  static TelaInicial + #728, #2847
  static TelaInicial + #729, #3842
  static TelaInicial + #730, #3107
  static TelaInicial + #731, #127
  static TelaInicial + #732, #3947
  static TelaInicial + #733, #127
  static TelaInicial + #734, #3957
  static TelaInicial + #735, #127
  static TelaInicial + #736, #3885
  static TelaInicial + #737, #127
  static TelaInicial + #738, #127
  static TelaInicial + #739, #3960
  static TelaInicial + #740, #3960
  static TelaInicial + #741, #3885
  static TelaInicial + #742, #3885
  static TelaInicial + #743, #127
  static TelaInicial + #744, #127
  static TelaInicial + #745, #3843
  static TelaInicial + #746, #3952
  static TelaInicial + #747, #3885
  static TelaInicial + #748, #3885
  static TelaInicial + #749, #2847
  static TelaInicial + #750, #3844
  static TelaInicial + #751, #3871
  static TelaInicial + #752, #2687
  static TelaInicial + #753, #3871
  static TelaInicial + #754, #3871
  static TelaInicial + #755, #3871
  static TelaInicial + #756, #1823
  static TelaInicial + #757, #1823
  static TelaInicial + #758, #1823
  static TelaInicial + #759, #3871

  ;Linha 19
  static TelaInicial + #760, #2847
  static TelaInicial + #761, #127
  static TelaInicial + #762, #3107
  static TelaInicial + #763, #3107
  static TelaInicial + #764, #3107
  static TelaInicial + #765, #2847
  static TelaInicial + #766, #35
  static TelaInicial + #767, #35
  static TelaInicial + #768, #3947
  static TelaInicial + #769, #3107
  static TelaInicial + #770, #3107
  static TelaInicial + #771, #3107
  static TelaInicial + #772, #3843
  static TelaInicial + #773, #3843
  static TelaInicial + #774, #3843
  static TelaInicial + #775, #127
  static TelaInicial + #776, #3885
  static TelaInicial + #777, #3960
  static TelaInicial + #778, #3960
  static TelaInicial + #779, #2388
  static TelaInicial + #780, #2405
  static TelaInicial + #781, #2403
  static TelaInicial + #782, #2412
  static TelaInicial + #783, #2401
  static TelaInicial + #784, #2419
  static TelaInicial + #785, #2687
  static TelaInicial + #786, #2374
  static TelaInicial + #787, #2687
  static TelaInicial + #788, #2378
  static TelaInicial + #789, #2687
  static TelaInicial + #790, #2379
  static TelaInicial + #791, #2687
  static TelaInicial + #792, #2591
  static TelaInicial + #793, #3871
  static TelaInicial + #794, #3871
  static TelaInicial + #795, #3871
  static TelaInicial + #796, #3871
  static TelaInicial + #797, #3871
  static TelaInicial + #798, #1823
  static TelaInicial + #799, #1823

  ;Linha 20
  static TelaInicial + #800, #2847
  static TelaInicial + #801, #127
  static TelaInicial + #802, #3107
  static TelaInicial + #803, #3107
  static TelaInicial + #804, #35
  static TelaInicial + #805, #35
  static TelaInicial + #806, #35
  static TelaInicial + #807, #35
  static TelaInicial + #808, #35
  static TelaInicial + #809, #35
  static TelaInicial + #810, #35
  static TelaInicial + #811, #3107
  static TelaInicial + #812, #3843
  static TelaInicial + #813, #3843
  static TelaInicial + #814, #3843
  static TelaInicial + #815, #127
  static TelaInicial + #816, #3885
  static TelaInicial + #817, #3960
  static TelaInicial + #818, #3960
  static TelaInicial + #819, #2687
  static TelaInicial + #820, #2687
  static TelaInicial + #821, #2687
  static TelaInicial + #822, #2687
  static TelaInicial + #823, #2687
  static TelaInicial + #824, #2687
  static TelaInicial + #825, #2687
  static TelaInicial + #826, #2687
  static TelaInicial + #827, #2687
  static TelaInicial + #828, #2687
  static TelaInicial + #829, #2687
  static TelaInicial + #830, #2687
  static TelaInicial + #831, #2687
  static TelaInicial + #832, #2687
  static TelaInicial + #833, #2687
  static TelaInicial + #834, #3871
  static TelaInicial + #835, #3871
  static TelaInicial + #836, #3871
  static TelaInicial + #837, #1823
  static TelaInicial + #838, #3844
  static TelaInicial + #839, #1823

  ;Linha 21
  static TelaInicial + #840, #2847
  static TelaInicial + #841, #2847
  static TelaInicial + #842, #2847
  static TelaInicial + #843, #3107
  static TelaInicial + #844, #3107
  static TelaInicial + #845, #35
  static TelaInicial + #846, #35
  static TelaInicial + #847, #3960
  static TelaInicial + #848, #35
  static TelaInicial + #849, #35
  static TelaInicial + #850, #3107
  static TelaInicial + #851, #3107
  static TelaInicial + #852, #3843
  static TelaInicial + #853, #3843
  static TelaInicial + #854, #3843
  static TelaInicial + #855, #3843
  static TelaInicial + #856, #3885
  static TelaInicial + #857, #2431
  static TelaInicial + #858, #2431
  static TelaInicial + #859, #2431
  static TelaInicial + #860, #2431
  static TelaInicial + #861, #2431
  static TelaInicial + #862, #2431
  static TelaInicial + #863, #2431
  static TelaInicial + #864, #2431
  static TelaInicial + #865, #2431
  static TelaInicial + #866, #2431
  static TelaInicial + #867, #2431
  static TelaInicial + #868, #2431
  static TelaInicial + #869, #2431
  static TelaInicial + #870, #2431
  static TelaInicial + #871, #2431
  static TelaInicial + #872, #3871
  static TelaInicial + #873, #3871
  static TelaInicial + #874, #3885
  static TelaInicial + #875, #3871
  static TelaInicial + #876, #3871
  static TelaInicial + #877, #3871
  static TelaInicial + #878, #1823
  static TelaInicial + #879, #3844

  ;Linha 22
  static TelaInicial + #880, #127
  static TelaInicial + #881, #2591
  static TelaInicial + #882, #2591
  static TelaInicial + #883, #3107
  static TelaInicial + #884, #3107
  static TelaInicial + #885, #35
  static TelaInicial + #886, #35
  static TelaInicial + #887, #3960
  static TelaInicial + #888, #35
  static TelaInicial + #889, #35
  static TelaInicial + #890, #3107
  static TelaInicial + #891, #3885
  static TelaInicial + #892, #3960
  static TelaInicial + #893, #3960
  static TelaInicial + #894, #3960
  static TelaInicial + #895, #3960
  static TelaInicial + #896, #3960
  static TelaInicial + #897, #3960
  static TelaInicial + #898, #3960
  static TelaInicial + #899, #2687
  static TelaInicial + #900, #2687
  static TelaInicial + #901, #2687
  static TelaInicial + #902, #2687
  static TelaInicial + #903, #2687
  static TelaInicial + #904, #2687
  static TelaInicial + #905, #2687
  static TelaInicial + #906, #2687
  static TelaInicial + #907, #2687
  static TelaInicial + #908, #2687
  static TelaInicial + #909, #2687
  static TelaInicial + #910, #2687
  static TelaInicial + #911, #2687
  static TelaInicial + #912, #3871
  static TelaInicial + #913, #3871
  static TelaInicial + #914, #3885
  static TelaInicial + #915, #3844
  static TelaInicial + #916, #1823
  static TelaInicial + #917, #3844
  static TelaInicial + #918, #3871
  static TelaInicial + #919, #3844

  ;Linha 23
  static TelaInicial + #920, #3960
  static TelaInicial + #921, #3960
  static TelaInicial + #922, #2591
  static TelaInicial + #923, #3107
  static TelaInicial + #924, #3107
  static TelaInicial + #925, #35
  static TelaInicial + #926, #35
  static TelaInicial + #927, #3960
  static TelaInicial + #928, #35
  static TelaInicial + #929, #35
  static TelaInicial + #930, #3107
  static TelaInicial + #931, #3885
  static TelaInicial + #932, #3960
  static TelaInicial + #933, #3960
  static TelaInicial + #934, #3843
  static TelaInicial + #935, #3843
  static TelaInicial + #936, #3885
  static TelaInicial + #937, #3960
  static TelaInicial + #938, #3960
  static TelaInicial + #939, #3960
  static TelaInicial + #940, #3960
  static TelaInicial + #941, #2687
  static TelaInicial + #942, #2687
  static TelaInicial + #943, #2687
  static TelaInicial + #944, #2687
  static TelaInicial + #945, #2687
  static TelaInicial + #946, #2431
  static TelaInicial + #947, #2431
  static TelaInicial + #948, #2687
  static TelaInicial + #949, #2687
  static TelaInicial + #950, #2687
  static TelaInicial + #951, #2687
  static TelaInicial + #952, #3871
  static TelaInicial + #953, #3871
  static TelaInicial + #954, #3871
  static TelaInicial + #955, #3844
  static TelaInicial + #956, #1823
  static TelaInicial + #957, #3844
  static TelaInicial + #958, #3871
  static TelaInicial + #959, #3844

  ;Linha 24
  static TelaInicial + #960, #3960
  static TelaInicial + #961, #3960
  static TelaInicial + #962, #3107
  static TelaInicial + #963, #3107
  static TelaInicial + #964, #3107
  static TelaInicial + #965, #35
  static TelaInicial + #966, #35
  static TelaInicial + #967, #35
  static TelaInicial + #968, #35
  static TelaInicial + #969, #35
  static TelaInicial + #970, #3107
  static TelaInicial + #971, #3960
  static TelaInicial + #972, #3960
  static TelaInicial + #973, #3960
  static TelaInicial + #974, #3960
  static TelaInicial + #975, #3960
  static TelaInicial + #976, #3960
  static TelaInicial + #977, #2431
  static TelaInicial + #978, #2687
  static TelaInicial + #979, #2687
  static TelaInicial + #980, #2640
  static TelaInicial + #981, #2657
  static TelaInicial + #982, #2674
  static TelaInicial + #983, #2657
  static TelaInicial + #984, #2687
  static TelaInicial + #985, #2634
  static TelaInicial + #986, #2671
  static TelaInicial + #987, #2663
  static TelaInicial + #988, #2657
  static TelaInicial + #989, #2674
  static TelaInicial + #990, #2687
  static TelaInicial + #991, #2431
  static TelaInicial + #992, #3871
  static TelaInicial + #993, #3885
  static TelaInicial + #994, #3871
  static TelaInicial + #995, #3844
  static TelaInicial + #996, #3844
  static TelaInicial + #997, #1823
  static TelaInicial + #998, #1823
  static TelaInicial + #999, #3844

  ;Linha 25
  static TelaInicial + #1000, #3885
  static TelaInicial + #1001, #3885
  static TelaInicial + #1002, #3107
  static TelaInicial + #1003, #3107
  static TelaInicial + #1004, #35
  static TelaInicial + #1005, #35
  static TelaInicial + #1006, #3107
  static TelaInicial + #1007, #3107
  static TelaInicial + #1008, #3107
  static TelaInicial + #1009, #35
  static TelaInicial + #1010, #35
  static TelaInicial + #1011, #3107
  static TelaInicial + #1012, #3960
  static TelaInicial + #1013, #3885
  static TelaInicial + #1014, #3885
  static TelaInicial + #1015, #3885
  static TelaInicial + #1016, #3885
  static TelaInicial + #1017, #3960
  static TelaInicial + #1018, #2687
  static TelaInicial + #1019, #2685
  static TelaInicial + #1020, #2685
  static TelaInicial + #1021, #3885
  static TelaInicial + #1022, #2629
  static TelaInicial + #1023, #2675
  static TelaInicial + #1024, #2672
  static TelaInicial + #1025, #2657
  static TelaInicial + #1026, #2659
  static TelaInicial + #1027, #2671
  static TelaInicial + #1028, #3885
  static TelaInicial + #1029, #2683
  static TelaInicial + #1030, #2683
  static TelaInicial + #1031, #2687
  static TelaInicial + #1032, #3885
  static TelaInicial + #1033, #3844
  static TelaInicial + #1034, #3871
  static TelaInicial + #1035, #3844
  static TelaInicial + #1036, #3844
  static TelaInicial + #1037, #1823
  static TelaInicial + #1038, #1823
  static TelaInicial + #1039, #3844

  ;Linha 26
  static TelaInicial + #1040, #2591
  static TelaInicial + #1041, #3885
  static TelaInicial + #1042, #3107
  static TelaInicial + #1043, #3107
  static TelaInicial + #1044, #3107
  static TelaInicial + #1045, #3107
  static TelaInicial + #1046, #3107
  static TelaInicial + #1047, #3885
  static TelaInicial + #1048, #3107
  static TelaInicial + #1049, #3107
  static TelaInicial + #1050, #3107
  static TelaInicial + #1051, #3107
  static TelaInicial + #1052, #3885
  static TelaInicial + #1053, #3885
  static TelaInicial + #1054, #3885
  static TelaInicial + #1055, #3885
  static TelaInicial + #1056, #3885
  static TelaInicial + #1057, #3885
  static TelaInicial + #1058, #3885
  static TelaInicial + #1059, #3885
  static TelaInicial + #1060, #3885
  static TelaInicial + #1061, #3885
  static TelaInicial + #1062, #3885
  static TelaInicial + #1063, #3885
  static TelaInicial + #1064, #3885
  static TelaInicial + #1065, #3885
  static TelaInicial + #1066, #3885
  static TelaInicial + #1067, #3885
  static TelaInicial + #1068, #3885
  static TelaInicial + #1069, #3885
  static TelaInicial + #1070, #3885
  static TelaInicial + #1071, #3885
  static TelaInicial + #1072, #3885
  static TelaInicial + #1073, #3885
  static TelaInicial + #1074, #3885
  static TelaInicial + #1075, #3844
  static TelaInicial + #1076, #3844
  static TelaInicial + #1077, #1823
  static TelaInicial + #1078, #1823
  static TelaInicial + #1079, #2841

  ;Linha 27
  static TelaInicial + #1080, #2591
  static TelaInicial + #1081, #2591
  static TelaInicial + #1082, #3885
  static TelaInicial + #1083, #3107
  static TelaInicial + #1084, #3107
  static TelaInicial + #1085, #3107
  static TelaInicial + #1086, #3107
  static TelaInicial + #1087, #3107
  static TelaInicial + #1088, #3885
  static TelaInicial + #1089, #3107
  static TelaInicial + #1090, #3960
  static TelaInicial + #1091, #3107
  static TelaInicial + #1092, #3885
  static TelaInicial + #1093, #3885
  static TelaInicial + #1094, #3885
  static TelaInicial + #1095, #3885
  static TelaInicial + #1096, #3885
  static TelaInicial + #1097, #3885
  static TelaInicial + #1098, #3885
  static TelaInicial + #1099, #1407
  static TelaInicial + #1100, #1407
  static TelaInicial + #1101, #1407
  static TelaInicial + #1102, #1407
  static TelaInicial + #1103, #1407
  static TelaInicial + #1104, #1407
  static TelaInicial + #1105, #1407
  static TelaInicial + #1106, #1407
  static TelaInicial + #1107, #1407
  static TelaInicial + #1108, #1407
  static TelaInicial + #1109, #1407
  static TelaInicial + #1110, #1407
  static TelaInicial + #1111, #1407
  static TelaInicial + #1112, #3871
  static TelaInicial + #1113, #3844
  static TelaInicial + #1114, #3844
  static TelaInicial + #1115, #3844
  static TelaInicial + #1116, #3844
  static TelaInicial + #1117, #3844
  static TelaInicial + #1118, #1823
  static TelaInicial + #1119, #3844

  ;Linha 28
  static TelaInicial + #1120, #2591
  static TelaInicial + #1121, #2591
  static TelaInicial + #1122, #3885
  static TelaInicial + #1123, #3885
  static TelaInicial + #1124, #3107
  static TelaInicial + #1125, #3107
  static TelaInicial + #1126, #3107
  static TelaInicial + #1127, #3107
  static TelaInicial + #1128, #3107
  static TelaInicial + #1129, #3107
  static TelaInicial + #1130, #3107
  static TelaInicial + #1131, #3885
  static TelaInicial + #1132, #3885
  static TelaInicial + #1133, #3885
  static TelaInicial + #1134, #3885
  static TelaInicial + #1135, #3885
  static TelaInicial + #1136, #3885
  static TelaInicial + #1137, #3885
  static TelaInicial + #1138, #3885
  static TelaInicial + #1139, #3885
  static TelaInicial + #1140, #3885
  static TelaInicial + #1141, #3885
  static TelaInicial + #1142, #3885
  static TelaInicial + #1143, #3885
  static TelaInicial + #1144, #3885
  static TelaInicial + #1145, #3885
  static TelaInicial + #1146, #3885
  static TelaInicial + #1147, #3885
  static TelaInicial + #1148, #3885
  static TelaInicial + #1149, #3885
  static TelaInicial + #1150, #3885
  static TelaInicial + #1151, #3844
  static TelaInicial + #1152, #3871
  static TelaInicial + #1153, #3844
  static TelaInicial + #1154, #3844
  static TelaInicial + #1155, #3844
  static TelaInicial + #1156, #3844
  static TelaInicial + #1157, #3844
  static TelaInicial + #1158, #1051
  static TelaInicial + #1159, #2835

  ;Linha 29
  static TelaInicial + #1160, #2591
  static TelaInicial + #1161, #2591
  static TelaInicial + #1162, #2591
  static TelaInicial + #1163, #2591
  static TelaInicial + #1164, #2591
  static TelaInicial + #1165, #2847
  static TelaInicial + #1166, #2847
  static TelaInicial + #1167, #2847
  static TelaInicial + #1168, #3885
  static TelaInicial + #1169, #3885
  static TelaInicial + #1170, #3885
  static TelaInicial + #1171, #3885
  static TelaInicial + #1172, #3885
  static TelaInicial + #1173, #3843
  static TelaInicial + #1174, #3885
  static TelaInicial + #1175, #3843
  static TelaInicial + #1176, #3885
  static TelaInicial + #1177, #3885
  static TelaInicial + #1178, #127
  static TelaInicial + #1179, #3885
  static TelaInicial + #1180, #3885
  static TelaInicial + #1181, #127
  static TelaInicial + #1182, #3885
  static TelaInicial + #1183, #127
  static TelaInicial + #1184, #127
  static TelaInicial + #1185, #3885
  static TelaInicial + #1186, #3885
  static TelaInicial + #1187, #3885
  static TelaInicial + #1188, #3885
  static TelaInicial + #1189, #3885
  static TelaInicial + #1190, #3885
  static TelaInicial + #1191, #3844
  static TelaInicial + #1192, #3871
  static TelaInicial + #1193, #3844
  static TelaInicial + #1194, #3844
  static TelaInicial + #1195, #3844
  static TelaInicial + #1196, #3844
  static TelaInicial + #1197, #3844
  static TelaInicial + #1198, #2835
  static TelaInicial + #1199, #127

printTelaInicialScreen:
  push R0
  push R1
  push R2
  push R3

  loadn R0, #TelaInicial
  loadn R1, #0
  loadn R2, #1200

  printTelaInicialScreenLoop:

    add R3,R0,R1
    loadi R3, R3
    outchar R3, R1
    inc R1
    cmp R1, R2

    jne printTelaInicialScreenLoop

  pop R3
  pop R2
  pop R1
  pop R0
  rts
  
  ApagaTela:
    push r0
    push r1
    
    loadn r0, #1200     ; apaga as 1200 posicoes da Tela
    loadn r1, #' '      ; com "espaco"
    
       ApagaTela_Loop:  ; label for(r0=1200;r3>0;r3--)
        dec r0
        outchar r1, r0
        jnz ApagaTela_Loop
 
    pop r1
    pop r0
    rts 
    
    
TelaInicial2 : var #1200
  ;Linha 0
  static TelaInicial2 + #0, #127
  static TelaInicial2 + #1, #127
  static TelaInicial2 + #2, #127
  static TelaInicial2 + #3, #127
  static TelaInicial2 + #4, #127
  static TelaInicial2 + #5, #127
  static TelaInicial2 + #6, #127
  static TelaInicial2 + #7, #127
  static TelaInicial2 + #8, #2591
  static TelaInicial2 + #9, #2834
  static TelaInicial2 + #10, #3885
  static TelaInicial2 + #11, #2591
  static TelaInicial2 + #12, #127
  static TelaInicial2 + #13, #127
  static TelaInicial2 + #14, #3947
  static TelaInicial2 + #15, #127
  static TelaInicial2 + #16, #3885
  static TelaInicial2 + #17, #3885
  static TelaInicial2 + #18, #3885
  static TelaInicial2 + #19, #3885
  static TelaInicial2 + #20, #3885
  static TelaInicial2 + #21, #3885
  static TelaInicial2 + #22, #3885
  static TelaInicial2 + #23, #3873
  static TelaInicial2 + #24, #127
  static TelaInicial2 + #25, #3957
  static TelaInicial2 + #26, #3952
  static TelaInicial2 + #27, #3873
  static TelaInicial2 + #28, #3885
  static TelaInicial2 + #29, #3885
  static TelaInicial2 + #30, #2846
  static TelaInicial2 + #31, #127
  static TelaInicial2 + #32, #2842
  static TelaInicial2 + #33, #2842
  static TelaInicial2 + #34, #2842
  static TelaInicial2 + #35, #2842
  static TelaInicial2 + #36, #2842
  static TelaInicial2 + #37, #2842
  static TelaInicial2 + #38, #3875
  static TelaInicial2 + #39, #3875

  ;Linha 1
  static TelaInicial2 + #40, #127
  static TelaInicial2 + #41, #2829
  static TelaInicial2 + #42, #2829
  static TelaInicial2 + #43, #2835
  static TelaInicial2 + #44, #127
  static TelaInicial2 + #45, #127
  static TelaInicial2 + #46, #127
  static TelaInicial2 + #47, #127
  static TelaInicial2 + #48, #2834
  static TelaInicial2 + #49, #2834
  static TelaInicial2 + #50, #3885
  static TelaInicial2 + #51, #2591
  static TelaInicial2 + #52, #127
  static TelaInicial2 + #53, #3844
  static TelaInicial2 + #54, #3957
  static TelaInicial2 + #55, #3885
  static TelaInicial2 + #56, #3885
  static TelaInicial2 + #57, #127
  static TelaInicial2 + #58, #127
  static TelaInicial2 + #59, #3842
  static TelaInicial2 + #60, #2943
  static TelaInicial2 + #61, #2943
  static TelaInicial2 + #62, #3885
  static TelaInicial2 + #63, #3873
  static TelaInicial2 + #64, #127
  static TelaInicial2 + #65, #127
  static TelaInicial2 + #66, #3952
  static TelaInicial2 + #67, #3885
  static TelaInicial2 + #68, #3885
  static TelaInicial2 + #69, #3885
  static TelaInicial2 + #70, #127
  static TelaInicial2 + #71, #2846
  static TelaInicial2 + #72, #3885
  static TelaInicial2 + #73, #3885
  static TelaInicial2 + #74, #3885
  static TelaInicial2 + #75, #3885
  static TelaInicial2 + #76, #3875
  static TelaInicial2 + #77, #3875
  static TelaInicial2 + #78, #3875
  static TelaInicial2 + #79, #127

  ;Linha 2
  static TelaInicial2 + #80, #127
  static TelaInicial2 + #81, #2829
  static TelaInicial2 + #82, #2829
  static TelaInicial2 + #83, #2835
  static TelaInicial2 + #84, #3875
  static TelaInicial2 + #85, #125
  static TelaInicial2 + #86, #125
  static TelaInicial2 + #87, #125
  static TelaInicial2 + #88, #2834
  static TelaInicial2 + #89, #2834
  static TelaInicial2 + #90, #3885
  static TelaInicial2 + #91, #2591
  static TelaInicial2 + #92, #127
  static TelaInicial2 + #93, #127
  static TelaInicial2 + #94, #3947
  static TelaInicial2 + #95, #127
  static TelaInicial2 + #96, #3885
  static TelaInicial2 + #97, #127
  static TelaInicial2 + #98, #127
  static TelaInicial2 + #99, #2943
  static TelaInicial2 + #100, #2943
  static TelaInicial2 + #101, #2943
  static TelaInicial2 + #102, #3885
  static TelaInicial2 + #103, #3873
  static TelaInicial2 + #104, #127
  static TelaInicial2 + #105, #3957
  static TelaInicial2 + #106, #3952
  static TelaInicial2 + #107, #3885
  static TelaInicial2 + #108, #3885
  static TelaInicial2 + #109, #3885
  static TelaInicial2 + #110, #3875
  static TelaInicial2 + #111, #3875
  static TelaInicial2 + #112, #3875
  static TelaInicial2 + #113, #3875
  static TelaInicial2 + #114, #3875
  static TelaInicial2 + #115, #3875
  static TelaInicial2 + #116, #3875
  static TelaInicial2 + #117, #3885
  static TelaInicial2 + #118, #3885
  static TelaInicial2 + #119, #127

  ;Linha 3
  static TelaInicial2 + #120, #127
  static TelaInicial2 + #121, #2847
  static TelaInicial2 + #122, #2829
  static TelaInicial2 + #123, #2835
  static TelaInicial2 + #124, #3875
  static TelaInicial2 + #125, #125
  static TelaInicial2 + #126, #125
  static TelaInicial2 + #127, #125
  static TelaInicial2 + #128, #2834
  static TelaInicial2 + #129, #2591
  static TelaInicial2 + #130, #3885
  static TelaInicial2 + #131, #2591
  static TelaInicial2 + #132, #2851
  static TelaInicial2 + #133, #2851
  static TelaInicial2 + #134, #2851
  static TelaInicial2 + #135, #2591
  static TelaInicial2 + #136, #2851
  static TelaInicial2 + #137, #2851
  static TelaInicial2 + #138, #2851
  static TelaInicial2 + #139, #2851
  static TelaInicial2 + #140, #3952
  static TelaInicial2 + #141, #2851
  static TelaInicial2 + #142, #2851
  static TelaInicial2 + #143, #2851
  static TelaInicial2 + #144, #2851
  static TelaInicial2 + #145, #3875
  static TelaInicial2 + #146, #2851
  static TelaInicial2 + #147, #2851
  static TelaInicial2 + #148, #2851
  static TelaInicial2 + #149, #2851
  static TelaInicial2 + #150, #3875
  static TelaInicial2 + #151, #2851
  static TelaInicial2 + #152, #2851
  static TelaInicial2 + #153, #2851
  static TelaInicial2 + #154, #2851
  static TelaInicial2 + #155, #3871
  static TelaInicial2 + #156, #2847
  static TelaInicial2 + #157, #1823
  static TelaInicial2 + #158, #2847
  static TelaInicial2 + #159, #127

  ;Linha 4
  static TelaInicial2 + #160, #2829
  static TelaInicial2 + #161, #2847
  static TelaInicial2 + #162, #2834
  static TelaInicial2 + #163, #2834
  static TelaInicial2 + #164, #2834
  static TelaInicial2 + #165, #125
  static TelaInicial2 + #166, #125
  static TelaInicial2 + #167, #125
  static TelaInicial2 + #168, #3199
  static TelaInicial2 + #169, #3199
  static TelaInicial2 + #170, #3885
  static TelaInicial2 + #171, #2851
  static TelaInicial2 + #172, #3875
  static TelaInicial2 + #173, #3875
  static TelaInicial2 + #174, #3875
  static TelaInicial2 + #175, #3875
  static TelaInicial2 + #176, #2851
  static TelaInicial2 + #177, #3875
  static TelaInicial2 + #178, #3875
  static TelaInicial2 + #179, #2851
  static TelaInicial2 + #180, #3875
  static TelaInicial2 + #181, #2851
  static TelaInicial2 + #182, #3885
  static TelaInicial2 + #183, #3873
  static TelaInicial2 + #184, #2851
  static TelaInicial2 + #185, #3875
  static TelaInicial2 + #186, #2851
  static TelaInicial2 + #187, #3875
  static TelaInicial2 + #188, #3885
  static TelaInicial2 + #189, #3885
  static TelaInicial2 + #190, #127
  static TelaInicial2 + #191, #2851
  static TelaInicial2 + #192, #3875
  static TelaInicial2 + #193, #3875
  static TelaInicial2 + #194, #2851
  static TelaInicial2 + #195, #3871
  static TelaInicial2 + #196, #3871
  static TelaInicial2 + #197, #1823
  static TelaInicial2 + #198, #1823
  static TelaInicial2 + #199, #1823

  ;Linha 5
  static TelaInicial2 + #200, #2834
  static TelaInicial2 + #201, #2847
  static TelaInicial2 + #202, #2834
  static TelaInicial2 + #203, #2834
  static TelaInicial2 + #204, #2834
  static TelaInicial2 + #205, #3199
  static TelaInicial2 + #206, #125
  static TelaInicial2 + #207, #125
  static TelaInicial2 + #208, #2846
  static TelaInicial2 + #209, #3199
  static TelaInicial2 + #210, #3199
  static TelaInicial2 + #211, #2851
  static TelaInicial2 + #212, #3875
  static TelaInicial2 + #213, #3875
  static TelaInicial2 + #214, #3199
  static TelaInicial2 + #215, #2591
  static TelaInicial2 + #216, #2851
  static TelaInicial2 + #217, #3875
  static TelaInicial2 + #218, #3875
  static TelaInicial2 + #219, #2851
  static TelaInicial2 + #220, #3875
  static TelaInicial2 + #221, #2851
  static TelaInicial2 + #222, #3875
  static TelaInicial2 + #223, #3873
  static TelaInicial2 + #224, #2851
  static TelaInicial2 + #225, #3875
  static TelaInicial2 + #226, #2851
  static TelaInicial2 + #227, #3875
  static TelaInicial2 + #228, #3875
  static TelaInicial2 + #229, #3875
  static TelaInicial2 + #230, #3875
  static TelaInicial2 + #231, #2851
  static TelaInicial2 + #232, #3875
  static TelaInicial2 + #233, #1823
  static TelaInicial2 + #234, #2851
  static TelaInicial2 + #235, #3871
  static TelaInicial2 + #236, #3871
  static TelaInicial2 + #237, #1823
  static TelaInicial2 + #238, #1823
  static TelaInicial2 + #239, #1823

  ;Linha 6
  static TelaInicial2 + #240, #2834
  static TelaInicial2 + #241, #2834
  static TelaInicial2 + #242, #2834
  static TelaInicial2 + #243, #3846
  static TelaInicial2 + #244, #3199
  static TelaInicial2 + #245, #3964
  static TelaInicial2 + #246, #2429
  static TelaInicial2 + #247, #2429
  static TelaInicial2 + #248, #2846
  static TelaInicial2 + #249, #2846
  static TelaInicial2 + #250, #3199
  static TelaInicial2 + #251, #2851
  static TelaInicial2 + #252, #3875
  static TelaInicial2 + #253, #3875
  static TelaInicial2 + #254, #3875
  static TelaInicial2 + #255, #2591
  static TelaInicial2 + #256, #2851
  static TelaInicial2 + #257, #2851
  static TelaInicial2 + #258, #2851
  static TelaInicial2 + #259, #2851
  static TelaInicial2 + #260, #3875
  static TelaInicial2 + #261, #2851
  static TelaInicial2 + #262, #2851
  static TelaInicial2 + #263, #2851
  static TelaInicial2 + #264, #2851
  static TelaInicial2 + #265, #3875
  static TelaInicial2 + #266, #2851
  static TelaInicial2 + #267, #2851
  static TelaInicial2 + #268, #2851
  static TelaInicial2 + #269, #2851
  static TelaInicial2 + #270, #3875
  static TelaInicial2 + #271, #2851
  static TelaInicial2 + #272, #1823
  static TelaInicial2 + #273, #1823
  static TelaInicial2 + #274, #2851
  static TelaInicial2 + #275, #1823
  static TelaInicial2 + #276, #1823
  static TelaInicial2 + #277, #1823
  static TelaInicial2 + #278, #1823
  static TelaInicial2 + #279, #1823

  ;Linha 7
  static TelaInicial2 + #280, #127
  static TelaInicial2 + #281, #2847
  static TelaInicial2 + #282, #3964
  static TelaInicial2 + #283, #3199
  static TelaInicial2 + #284, #3199
  static TelaInicial2 + #285, #3964
  static TelaInicial2 + #286, #2685
  static TelaInicial2 + #287, #2685
  static TelaInicial2 + #288, #3964
  static TelaInicial2 + #289, #3964
  static TelaInicial2 + #290, #3199
  static TelaInicial2 + #291, #2851
  static TelaInicial2 + #292, #3875
  static TelaInicial2 + #293, #3875
  static TelaInicial2 + #294, #3875
  static TelaInicial2 + #295, #2591
  static TelaInicial2 + #296, #2851
  static TelaInicial2 + #297, #3199
  static TelaInicial2 + #298, #2943
  static TelaInicial2 + #299, #2851
  static TelaInicial2 + #300, #3875
  static TelaInicial2 + #301, #2851
  static TelaInicial2 + #302, #3885
  static TelaInicial2 + #303, #3873
  static TelaInicial2 + #304, #2851
  static TelaInicial2 + #305, #3875
  static TelaInicial2 + #306, #3952
  static TelaInicial2 + #307, #3875
  static TelaInicial2 + #308, #3875
  static TelaInicial2 + #309, #2851
  static TelaInicial2 + #310, #3875
  static TelaInicial2 + #311, #2851
  static TelaInicial2 + #312, #1823
  static TelaInicial2 + #313, #1823
  static TelaInicial2 + #314, #2851
  static TelaInicial2 + #315, #1823
  static TelaInicial2 + #316, #1823
  static TelaInicial2 + #317, #1823
  static TelaInicial2 + #318, #1823
  static TelaInicial2 + #319, #1823

  ;Linha 8
  static TelaInicial2 + #320, #127
  static TelaInicial2 + #321, #2847
  static TelaInicial2 + #322, #127
  static TelaInicial2 + #323, #3199
  static TelaInicial2 + #324, #3199
  static TelaInicial2 + #325, #3964
  static TelaInicial2 + #326, #2941
  static TelaInicial2 + #327, #2941
  static TelaInicial2 + #328, #2846
  static TelaInicial2 + #329, #3199
  static TelaInicial2 + #330, #3199
  static TelaInicial2 + #331, #3199
  static TelaInicial2 + #332, #2851
  static TelaInicial2 + #333, #2851
  static TelaInicial2 + #334, #2851
  static TelaInicial2 + #335, #2591
  static TelaInicial2 + #336, #2851
  static TelaInicial2 + #337, #3199
  static TelaInicial2 + #338, #127
  static TelaInicial2 + #339, #2851
  static TelaInicial2 + #340, #3875
  static TelaInicial2 + #341, #2851
  static TelaInicial2 + #342, #3885
  static TelaInicial2 + #343, #127
  static TelaInicial2 + #344, #2851
  static TelaInicial2 + #345, #3875
  static TelaInicial2 + #346, #2851
  static TelaInicial2 + #347, #2851
  static TelaInicial2 + #348, #2851
  static TelaInicial2 + #349, #2851
  static TelaInicial2 + #350, #3875
  static TelaInicial2 + #351, #2851
  static TelaInicial2 + #352, #2851
  static TelaInicial2 + #353, #2851
  static TelaInicial2 + #354, #2851
  static TelaInicial2 + #355, #1823
  static TelaInicial2 + #356, #3871
  static TelaInicial2 + #357, #1823
  static TelaInicial2 + #358, #1823
  static TelaInicial2 + #359, #2847

  ;Linha 9
  static TelaInicial2 + #360, #127
  static TelaInicial2 + #361, #2847
  static TelaInicial2 + #362, #127
  static TelaInicial2 + #363, #127
  static TelaInicial2 + #364, #3199
  static TelaInicial2 + #365, #3199
  static TelaInicial2 + #366, #3453
  static TelaInicial2 + #367, #3453
  static TelaInicial2 + #368, #3199
  static TelaInicial2 + #369, #3885
  static TelaInicial2 + #370, #3199
  static TelaInicial2 + #371, #3964
  static TelaInicial2 + #372, #3964
  static TelaInicial2 + #373, #3964
  static TelaInicial2 + #374, #3199
  static TelaInicial2 + #375, #2591
  static TelaInicial2 + #376, #3199
  static TelaInicial2 + #377, #3199
  static TelaInicial2 + #378, #127
  static TelaInicial2 + #379, #127
  static TelaInicial2 + #380, #3842
  static TelaInicial2 + #381, #3885
  static TelaInicial2 + #382, #3885
  static TelaInicial2 + #383, #3957
  static TelaInicial2 + #384, #127
  static TelaInicial2 + #385, #127
  static TelaInicial2 + #386, #3952
  static TelaInicial2 + #387, #3842
  static TelaInicial2 + #388, #3885
  static TelaInicial2 + #389, #2847
  static TelaInicial2 + #390, #2847
  static TelaInicial2 + #391, #1823
  static TelaInicial2 + #392, #1823
  static TelaInicial2 + #393, #2846
  static TelaInicial2 + #394, #1823
  static TelaInicial2 + #395, #1823
  static TelaInicial2 + #396, #1823
  static TelaInicial2 + #397, #1823
  static TelaInicial2 + #398, #1823
  static TelaInicial2 + #399, #1823

  ;Linha 10
  static TelaInicial2 + #400, #127
  static TelaInicial2 + #401, #2847
  static TelaInicial2 + #402, #127
  static TelaInicial2 + #403, #127
  static TelaInicial2 + #404, #2835
  static TelaInicial2 + #405, #2835
  static TelaInicial2 + #406, #125
  static TelaInicial2 + #407, #125
  static TelaInicial2 + #408, #3947
  static TelaInicial2 + #409, #3885
  static TelaInicial2 + #410, #3199
  static TelaInicial2 + #411, #127
  static TelaInicial2 + #412, #127
  static TelaInicial2 + #413, #127
  static TelaInicial2 + #414, #3199
  static TelaInicial2 + #415, #3964
  static TelaInicial2 + #416, #3199
  static TelaInicial2 + #417, #3199
  static TelaInicial2 + #418, #3199
  static TelaInicial2 + #419, #3875
  static TelaInicial2 + #420, #3842
  static TelaInicial2 + #421, #3960
  static TelaInicial2 + #422, #3885
  static TelaInicial2 + #423, #127
  static TelaInicial2 + #424, #127
  static TelaInicial2 + #425, #127
  static TelaInicial2 + #426, #3952
  static TelaInicial2 + #427, #127
  static TelaInicial2 + #428, #3885
  static TelaInicial2 + #429, #2847
  static TelaInicial2 + #430, #1823
  static TelaInicial2 + #431, #3871
  static TelaInicial2 + #432, #3871
  static TelaInicial2 + #433, #3871
  static TelaInicial2 + #434, #1823
  static TelaInicial2 + #435, #1823
  static TelaInicial2 + #436, #1823
  static TelaInicial2 + #437, #3964
  static TelaInicial2 + #438, #3964
  static TelaInicial2 + #439, #3871

  ;Linha 11
  static TelaInicial2 + #440, #127
  static TelaInicial2 + #441, #2847
  static TelaInicial2 + #442, #127
  static TelaInicial2 + #443, #2835
  static TelaInicial2 + #444, #2835
  static TelaInicial2 + #445, #2835
  static TelaInicial2 + #446, #125
  static TelaInicial2 + #447, #125
  static TelaInicial2 + #448, #3947
  static TelaInicial2 + #449, #3885
  static TelaInicial2 + #450, #3885
  static TelaInicial2 + #451, #127
  static TelaInicial2 + #452, #127
  static TelaInicial2 + #453, #127
  static TelaInicial2 + #454, #3199
  static TelaInicial2 + #455, #3947
  static TelaInicial2 + #456, #2851
  static TelaInicial2 + #457, #3199
  static TelaInicial2 + #458, #3199
  static TelaInicial2 + #459, #2851
  static TelaInicial2 + #460, #3964
  static TelaInicial2 + #461, #2851
  static TelaInicial2 + #462, #2851
  static TelaInicial2 + #463, #2851
  static TelaInicial2 + #464, #2851
  static TelaInicial2 + #465, #3964
  static TelaInicial2 + #466, #2851
  static TelaInicial2 + #467, #2851
  static TelaInicial2 + #468, #2851
  static TelaInicial2 + #469, #3875
  static TelaInicial2 + #470, #1823
  static TelaInicial2 + #471, #2851
  static TelaInicial2 + #472, #2851
  static TelaInicial2 + #473, #2851
  static TelaInicial2 + #474, #2851
  static TelaInicial2 + #475, #3964
  static TelaInicial2 + #476, #3964
  static TelaInicial2 + #477, #1823
  static TelaInicial2 + #478, #1823
  static TelaInicial2 + #479, #3871

  ;Linha 12
  static TelaInicial2 + #480, #127
  static TelaInicial2 + #481, #2847
  static TelaInicial2 + #482, #2835
  static TelaInicial2 + #483, #2835
  static TelaInicial2 + #484, #2835
  static TelaInicial2 + #485, #2835
  static TelaInicial2 + #486, #125
  static TelaInicial2 + #487, #125
  static TelaInicial2 + #488, #3947
  static TelaInicial2 + #489, #3885
  static TelaInicial2 + #490, #3885
  static TelaInicial2 + #491, #3885
  static TelaInicial2 + #492, #127
  static TelaInicial2 + #493, #127
  static TelaInicial2 + #494, #3199
  static TelaInicial2 + #495, #3947
  static TelaInicial2 + #496, #2851
  static TelaInicial2 + #497, #3199
  static TelaInicial2 + #498, #3199
  static TelaInicial2 + #499, #2851
  static TelaInicial2 + #500, #3960
  static TelaInicial2 + #501, #2851
  static TelaInicial2 + #502, #3964
  static TelaInicial2 + #503, #3964
  static TelaInicial2 + #504, #3964
  static TelaInicial2 + #505, #3964
  static TelaInicial2 + #506, #2851
  static TelaInicial2 + #507, #3964
  static TelaInicial2 + #508, #3885
  static TelaInicial2 + #509, #2851
  static TelaInicial2 + #510, #2847
  static TelaInicial2 + #511, #2851
  static TelaInicial2 + #512, #3964
  static TelaInicial2 + #513, #3964
  static TelaInicial2 + #514, #2851
  static TelaInicial2 + #515, #3964
  static TelaInicial2 + #516, #1823
  static TelaInicial2 + #517, #1823
  static TelaInicial2 + #518, #1823
  static TelaInicial2 + #519, #2687

  ;Linha 13
  static TelaInicial2 + #520, #127
  static TelaInicial2 + #521, #2847
  static TelaInicial2 + #522, #2835
  static TelaInicial2 + #523, #2835
  static TelaInicial2 + #524, #2835
  static TelaInicial2 + #525, #2835
  static TelaInicial2 + #526, #125
  static TelaInicial2 + #527, #125
  static TelaInicial2 + #528, #2835
  static TelaInicial2 + #529, #3885
  static TelaInicial2 + #530, #3885
  static TelaInicial2 + #531, #3885
  static TelaInicial2 + #532, #127
  static TelaInicial2 + #533, #127
  static TelaInicial2 + #534, #2943
  static TelaInicial2 + #535, #2943
  static TelaInicial2 + #536, #2851
  static TelaInicial2 + #537, #2851
  static TelaInicial2 + #538, #2851
  static TelaInicial2 + #539, #2851
  static TelaInicial2 + #540, #3960
  static TelaInicial2 + #541, #2851
  static TelaInicial2 + #542, #2851
  static TelaInicial2 + #543, #2851
  static TelaInicial2 + #544, #127
  static TelaInicial2 + #545, #3964
  static TelaInicial2 + #546, #2851
  static TelaInicial2 + #547, #2851
  static TelaInicial2 + #548, #2851
  static TelaInicial2 + #549, #3964
  static TelaInicial2 + #550, #3964
  static TelaInicial2 + #551, #2851
  static TelaInicial2 + #552, #3964
  static TelaInicial2 + #553, #3964
  static TelaInicial2 + #554, #2851
  static TelaInicial2 + #555, #3871
  static TelaInicial2 + #556, #1823
  static TelaInicial2 + #557, #1823
  static TelaInicial2 + #558, #2687
  static TelaInicial2 + #559, #3871

  ;Linha 14
  static TelaInicial2 + #560, #127
  static TelaInicial2 + #561, #2847
  static TelaInicial2 + #562, #2835
  static TelaInicial2 + #563, #2835
  static TelaInicial2 + #564, #2835
  static TelaInicial2 + #565, #2591
  static TelaInicial2 + #566, #125
  static TelaInicial2 + #567, #125
  static TelaInicial2 + #568, #2835
  static TelaInicial2 + #569, #3842
  static TelaInicial2 + #570, #3885
  static TelaInicial2 + #571, #3885
  static TelaInicial2 + #572, #127
  static TelaInicial2 + #573, #127
  static TelaInicial2 + #574, #3947
  static TelaInicial2 + #575, #2943
  static TelaInicial2 + #576, #2851
  static TelaInicial2 + #577, #3199
  static TelaInicial2 + #578, #127
  static TelaInicial2 + #579, #2851
  static TelaInicial2 + #580, #3960
  static TelaInicial2 + #581, #2851
  static TelaInicial2 + #582, #3885
  static TelaInicial2 + #583, #3885
  static TelaInicial2 + #584, #3885
  static TelaInicial2 + #585, #127
  static TelaInicial2 + #586, #2851
  static TelaInicial2 + #587, #3842
  static TelaInicial2 + #588, #3885
  static TelaInicial2 + #589, #2851
  static TelaInicial2 + #590, #2847
  static TelaInicial2 + #591, #2851
  static TelaInicial2 + #592, #3964
  static TelaInicial2 + #593, #3871
  static TelaInicial2 + #594, #2851
  static TelaInicial2 + #595, #3871
  static TelaInicial2 + #596, #3871
  static TelaInicial2 + #597, #1823
  static TelaInicial2 + #598, #1823
  static TelaInicial2 + #599, #1823

  ;Linha 15
  static TelaInicial2 + #600, #2847
  static TelaInicial2 + #601, #2847
  static TelaInicial2 + #602, #127
  static TelaInicial2 + #603, #127
  static TelaInicial2 + #604, #127
  static TelaInicial2 + #605, #2591
  static TelaInicial2 + #606, #125
  static TelaInicial2 + #607, #125
  static TelaInicial2 + #608, #3947
  static TelaInicial2 + #609, #3842
  static TelaInicial2 + #610, #3885
  static TelaInicial2 + #611, #127
  static TelaInicial2 + #612, #3947
  static TelaInicial2 + #613, #127
  static TelaInicial2 + #614, #3947
  static TelaInicial2 + #615, #3842
  static TelaInicial2 + #616, #2851
  static TelaInicial2 + #617, #127
  static TelaInicial2 + #618, #127
  static TelaInicial2 + #619, #2851
  static TelaInicial2 + #620, #3960
  static TelaInicial2 + #621, #2851
  static TelaInicial2 + #622, #3885
  static TelaInicial2 + #623, #127
  static TelaInicial2 + #624, #3885
  static TelaInicial2 + #625, #3885
  static TelaInicial2 + #626, #2851
  static TelaInicial2 + #627, #3885
  static TelaInicial2 + #628, #3885
  static TelaInicial2 + #629, #2851
  static TelaInicial2 + #630, #3844
  static TelaInicial2 + #631, #2851
  static TelaInicial2 + #632, #3871
  static TelaInicial2 + #633, #3871
  static TelaInicial2 + #634, #2851
  static TelaInicial2 + #635, #1823
  static TelaInicial2 + #636, #3871
  static TelaInicial2 + #637, #2687
  static TelaInicial2 + #638, #1823
  static TelaInicial2 + #639, #1823

  ;Linha 16
  static TelaInicial2 + #640, #2847
  static TelaInicial2 + #641, #127
  static TelaInicial2 + #642, #127
  static TelaInicial2 + #643, #127
  static TelaInicial2 + #644, #127
  static TelaInicial2 + #645, #2591
  static TelaInicial2 + #646, #125
  static TelaInicial2 + #647, #125
  static TelaInicial2 + #648, #3947
  static TelaInicial2 + #649, #3842
  static TelaInicial2 + #650, #3885
  static TelaInicial2 + #651, #127
  static TelaInicial2 + #652, #127
  static TelaInicial2 + #653, #3947
  static TelaInicial2 + #654, #3947
  static TelaInicial2 + #655, #127
  static TelaInicial2 + #656, #2851
  static TelaInicial2 + #657, #3947
  static TelaInicial2 + #658, #127
  static TelaInicial2 + #659, #2851
  static TelaInicial2 + #660, #3960
  static TelaInicial2 + #661, #2851
  static TelaInicial2 + #662, #2851
  static TelaInicial2 + #663, #2851
  static TelaInicial2 + #664, #2851
  static TelaInicial2 + #665, #3875
  static TelaInicial2 + #666, #2851
  static TelaInicial2 + #667, #3885
  static TelaInicial2 + #668, #3885
  static TelaInicial2 + #669, #2851
  static TelaInicial2 + #670, #3844
  static TelaInicial2 + #671, #2851
  static TelaInicial2 + #672, #2851
  static TelaInicial2 + #673, #2851
  static TelaInicial2 + #674, #2851
  static TelaInicial2 + #675, #3871
  static TelaInicial2 + #676, #3871
  static TelaInicial2 + #677, #1823
  static TelaInicial2 + #678, #1823
  static TelaInicial2 + #679, #1823

  ;Linha 17
  static TelaInicial2 + #680, #2847
  static TelaInicial2 + #681, #127
  static TelaInicial2 + #682, #127
  static TelaInicial2 + #683, #127
  static TelaInicial2 + #684, #127
  static TelaInicial2 + #685, #2591
  static TelaInicial2 + #686, #125
  static TelaInicial2 + #687, #125
  static TelaInicial2 + #688, #2847
  static TelaInicial2 + #689, #3842
  static TelaInicial2 + #690, #3885
  static TelaInicial2 + #691, #127
  static TelaInicial2 + #692, #127
  static TelaInicial2 + #693, #3947
  static TelaInicial2 + #694, #3957
  static TelaInicial2 + #695, #127
  static TelaInicial2 + #696, #3885
  static TelaInicial2 + #697, #127
  static TelaInicial2 + #698, #127
  static TelaInicial2 + #699, #3960
  static TelaInicial2 + #700, #3960
  static TelaInicial2 + #701, #3885
  static TelaInicial2 + #702, #3885
  static TelaInicial2 + #703, #3947
  static TelaInicial2 + #704, #3947
  static TelaInicial2 + #705, #3952
  static TelaInicial2 + #706, #3952
  static TelaInicial2 + #707, #3885
  static TelaInicial2 + #708, #3885
  static TelaInicial2 + #709, #2847
  static TelaInicial2 + #710, #3844
  static TelaInicial2 + #711, #3871
  static TelaInicial2 + #712, #3871
  static TelaInicial2 + #713, #3871
  static TelaInicial2 + #714, #2687
  static TelaInicial2 + #715, #2687
  static TelaInicial2 + #716, #3871
  static TelaInicial2 + #717, #1823
  static TelaInicial2 + #718, #1823
  static TelaInicial2 + #719, #1823

  ;Linha 18
  static TelaInicial2 + #720, #2847
  static TelaInicial2 + #721, #127
  static TelaInicial2 + #722, #127
  static TelaInicial2 + #723, #3197
  static TelaInicial2 + #724, #127
  static TelaInicial2 + #725, #2591
  static TelaInicial2 + #726, #125
  static TelaInicial2 + #727, #125
  static TelaInicial2 + #728, #2847
  static TelaInicial2 + #729, #3842
  static TelaInicial2 + #730, #3197
  static TelaInicial2 + #731, #127
  static TelaInicial2 + #732, #3947
  static TelaInicial2 + #733, #127
  static TelaInicial2 + #734, #3957
  static TelaInicial2 + #735, #127
  static TelaInicial2 + #736, #3885
  static TelaInicial2 + #737, #127
  static TelaInicial2 + #738, #127
  static TelaInicial2 + #739, #3960
  static TelaInicial2 + #740, #3960
  static TelaInicial2 + #741, #3885
  static TelaInicial2 + #742, #3885
  static TelaInicial2 + #743, #127
  static TelaInicial2 + #744, #127
  static TelaInicial2 + #745, #3843
  static TelaInicial2 + #746, #3952
  static TelaInicial2 + #747, #3885
  static TelaInicial2 + #748, #3885
  static TelaInicial2 + #749, #2847
  static TelaInicial2 + #750, #3844
  static TelaInicial2 + #751, #3871
  static TelaInicial2 + #752, #2687
  static TelaInicial2 + #753, #3871
  static TelaInicial2 + #754, #3871
  static TelaInicial2 + #755, #3871
  static TelaInicial2 + #756, #1823
  static TelaInicial2 + #757, #1823
  static TelaInicial2 + #758, #1823
  static TelaInicial2 + #759, #3871

  ;Linha 19
  static TelaInicial2 + #760, #2847
  static TelaInicial2 + #761, #127
  static TelaInicial2 + #762, #3197
  static TelaInicial2 + #763, #3197
  static TelaInicial2 + #764, #3197
  static TelaInicial2 + #765, #2847
  static TelaInicial2 + #766, #125
  static TelaInicial2 + #767, #125
  static TelaInicial2 + #768, #3947
  static TelaInicial2 + #769, #3197
  static TelaInicial2 + #770, #3197
  static TelaInicial2 + #771, #3197
  static TelaInicial2 + #772, #3843
  static TelaInicial2 + #773, #3843
  static TelaInicial2 + #774, #3843
  static TelaInicial2 + #775, #127
  static TelaInicial2 + #776, #3885
  static TelaInicial2 + #777, #3960
  static TelaInicial2 + #778, #3960
  static TelaInicial2 + #779, #2388
  static TelaInicial2 + #780, #2405
  static TelaInicial2 + #781, #2403
  static TelaInicial2 + #782, #2412
  static TelaInicial2 + #783, #2401
  static TelaInicial2 + #784, #2419
  static TelaInicial2 + #785, #2687
  static TelaInicial2 + #786, #2374
  static TelaInicial2 + #787, #2687
  static TelaInicial2 + #788, #2378
  static TelaInicial2 + #789, #2687
  static TelaInicial2 + #790, #2379
  static TelaInicial2 + #791, #2687
  static TelaInicial2 + #792, #2591
  static TelaInicial2 + #793, #3871
  static TelaInicial2 + #794, #3871
  static TelaInicial2 + #795, #3871
  static TelaInicial2 + #796, #3871
  static TelaInicial2 + #797, #3871
  static TelaInicial2 + #798, #1823
  static TelaInicial2 + #799, #1823

  ;Linha 20
  static TelaInicial2 + #800, #2847
  static TelaInicial2 + #801, #127
  static TelaInicial2 + #802, #3197
  static TelaInicial2 + #803, #3197
  static TelaInicial2 + #804, #125
  static TelaInicial2 + #805, #125
  static TelaInicial2 + #806, #125
  static TelaInicial2 + #807, #125
  static TelaInicial2 + #808, #125
  static TelaInicial2 + #809, #125
  static TelaInicial2 + #810, #125
  static TelaInicial2 + #811, #3197
  static TelaInicial2 + #812, #3843
  static TelaInicial2 + #813, #3843
  static TelaInicial2 + #814, #3843
  static TelaInicial2 + #815, #127
  static TelaInicial2 + #816, #3885
  static TelaInicial2 + #817, #3960
  static TelaInicial2 + #818, #3960
  static TelaInicial2 + #819, #2687
  static TelaInicial2 + #820, #2687
  static TelaInicial2 + #821, #2687
  static TelaInicial2 + #822, #2687
  static TelaInicial2 + #823, #2687
  static TelaInicial2 + #824, #2687
  static TelaInicial2 + #825, #2687
  static TelaInicial2 + #826, #2687
  static TelaInicial2 + #827, #2687
  static TelaInicial2 + #828, #2687
  static TelaInicial2 + #829, #2687
  static TelaInicial2 + #830, #2687
  static TelaInicial2 + #831, #2687
  static TelaInicial2 + #832, #2687
  static TelaInicial2 + #833, #2687
  static TelaInicial2 + #834, #3871
  static TelaInicial2 + #835, #3871
  static TelaInicial2 + #836, #3871
  static TelaInicial2 + #837, #1823
  static TelaInicial2 + #838, #3844
  static TelaInicial2 + #839, #1823

  ;Linha 21
  static TelaInicial2 + #840, #2847
  static TelaInicial2 + #841, #2847
  static TelaInicial2 + #842, #3965
  static TelaInicial2 + #843, #3197
  static TelaInicial2 + #844, #3197
  static TelaInicial2 + #845, #125
  static TelaInicial2 + #846, #125
  static TelaInicial2 + #847, #3960
  static TelaInicial2 + #848, #125
  static TelaInicial2 + #849, #125
  static TelaInicial2 + #850, #3197
  static TelaInicial2 + #851, #3197
  static TelaInicial2 + #852, #3843
  static TelaInicial2 + #853, #3843
  static TelaInicial2 + #854, #3843
  static TelaInicial2 + #855, #3843
  static TelaInicial2 + #856, #3885
  static TelaInicial2 + #857, #2431
  static TelaInicial2 + #858, #2431
  static TelaInicial2 + #859, #2431
  static TelaInicial2 + #860, #2431
  static TelaInicial2 + #861, #2431
  static TelaInicial2 + #862, #2431
  static TelaInicial2 + #863, #2431
  static TelaInicial2 + #864, #2431
  static TelaInicial2 + #865, #2431
  static TelaInicial2 + #866, #2431
  static TelaInicial2 + #867, #2431
  static TelaInicial2 + #868, #2431
  static TelaInicial2 + #869, #2431
  static TelaInicial2 + #870, #2431
  static TelaInicial2 + #871, #2431
  static TelaInicial2 + #872, #3871
  static TelaInicial2 + #873, #3871
  static TelaInicial2 + #874, #3885
  static TelaInicial2 + #875, #3871
  static TelaInicial2 + #876, #3871
  static TelaInicial2 + #877, #3871
  static TelaInicial2 + #878, #1823
  static TelaInicial2 + #879, #3844

  ;Linha 22
  static TelaInicial2 + #880, #127
  static TelaInicial2 + #881, #2591
  static TelaInicial2 + #882, #2591
  static TelaInicial2 + #883, #3197
  static TelaInicial2 + #884, #3197
  static TelaInicial2 + #885, #125
  static TelaInicial2 + #886, #125
  static TelaInicial2 + #887, #3960
  static TelaInicial2 + #888, #125
  static TelaInicial2 + #889, #125
  static TelaInicial2 + #890, #3197
  static TelaInicial2 + #891, #3885
  static TelaInicial2 + #892, #3960
  static TelaInicial2 + #893, #3960
  static TelaInicial2 + #894, #3960
  static TelaInicial2 + #895, #3960
  static TelaInicial2 + #896, #3960
  static TelaInicial2 + #897, #3960
  static TelaInicial2 + #898, #3960
  static TelaInicial2 + #899, #2687
  static TelaInicial2 + #900, #2687
  static TelaInicial2 + #901, #2687
  static TelaInicial2 + #902, #2687
  static TelaInicial2 + #903, #2687
  static TelaInicial2 + #904, #2687
  static TelaInicial2 + #905, #2687
  static TelaInicial2 + #906, #2687
  static TelaInicial2 + #907, #2687
  static TelaInicial2 + #908, #2687
  static TelaInicial2 + #909, #2687
  static TelaInicial2 + #910, #2687
  static TelaInicial2 + #911, #2687
  static TelaInicial2 + #912, #3871
  static TelaInicial2 + #913, #3871
  static TelaInicial2 + #914, #3885
  static TelaInicial2 + #915, #3844
  static TelaInicial2 + #916, #1823
  static TelaInicial2 + #917, #3844
  static TelaInicial2 + #918, #3871
  static TelaInicial2 + #919, #3844

  ;Linha 23
  static TelaInicial2 + #920, #3960
  static TelaInicial2 + #921, #3960
  static TelaInicial2 + #922, #2591
  static TelaInicial2 + #923, #3197
  static TelaInicial2 + #924, #3197
  static TelaInicial2 + #925, #125
  static TelaInicial2 + #926, #125
  static TelaInicial2 + #927, #3960
  static TelaInicial2 + #928, #125
  static TelaInicial2 + #929, #125
  static TelaInicial2 + #930, #3197
  static TelaInicial2 + #931, #3885
  static TelaInicial2 + #932, #3960
  static TelaInicial2 + #933, #3960
  static TelaInicial2 + #934, #3843
  static TelaInicial2 + #935, #3843
  static TelaInicial2 + #936, #3885
  static TelaInicial2 + #937, #3960
  static TelaInicial2 + #938, #3960
  static TelaInicial2 + #939, #3960
  static TelaInicial2 + #940, #3960
  static TelaInicial2 + #941, #2687
  static TelaInicial2 + #942, #2687
  static TelaInicial2 + #943, #2687
  static TelaInicial2 + #944, #2687
  static TelaInicial2 + #945, #2687
  static TelaInicial2 + #946, #2431
  static TelaInicial2 + #947, #2431
  static TelaInicial2 + #948, #2687
  static TelaInicial2 + #949, #2687
  static TelaInicial2 + #950, #2687
  static TelaInicial2 + #951, #2687
  static TelaInicial2 + #952, #3871
  static TelaInicial2 + #953, #3871
  static TelaInicial2 + #954, #3871
  static TelaInicial2 + #955, #3844
  static TelaInicial2 + #956, #1823
  static TelaInicial2 + #957, #3844
  static TelaInicial2 + #958, #3871
  static TelaInicial2 + #959, #3844

  ;Linha 24
  static TelaInicial2 + #960, #3960
  static TelaInicial2 + #961, #3960
  static TelaInicial2 + #962, #3197
  static TelaInicial2 + #963, #3197
  static TelaInicial2 + #964, #3197
  static TelaInicial2 + #965, #125
  static TelaInicial2 + #966, #125
  static TelaInicial2 + #967, #125
  static TelaInicial2 + #968, #125
  static TelaInicial2 + #969, #125
  static TelaInicial2 + #970, #3197
  static TelaInicial2 + #971, #3960
  static TelaInicial2 + #972, #3960
  static TelaInicial2 + #973, #3960
  static TelaInicial2 + #974, #3960
  static TelaInicial2 + #975, #3960
  static TelaInicial2 + #976, #3960
  static TelaInicial2 + #977, #2431
  static TelaInicial2 + #978, #2687
  static TelaInicial2 + #979, #2687
  static TelaInicial2 + #980, #2640
  static TelaInicial2 + #981, #2657
  static TelaInicial2 + #982, #2674
  static TelaInicial2 + #983, #2657
  static TelaInicial2 + #984, #2687
  static TelaInicial2 + #985, #2634
  static TelaInicial2 + #986, #2671
  static TelaInicial2 + #987, #2663
  static TelaInicial2 + #988, #2657
  static TelaInicial2 + #989, #2674
  static TelaInicial2 + #990, #2687
  static TelaInicial2 + #991, #2431
  static TelaInicial2 + #992, #3871
  static TelaInicial2 + #993, #3885
  static TelaInicial2 + #994, #3871
  static TelaInicial2 + #995, #3844
  static TelaInicial2 + #996, #3844
  static TelaInicial2 + #997, #1823
  static TelaInicial2 + #998, #1823
  static TelaInicial2 + #999, #3844

  ;Linha 25
  static TelaInicial2 + #1000, #3885
  static TelaInicial2 + #1001, #3885
  static TelaInicial2 + #1002, #3197
  static TelaInicial2 + #1003, #3197
  static TelaInicial2 + #1004, #125
  static TelaInicial2 + #1005, #125
  static TelaInicial2 + #1006, #3197
  static TelaInicial2 + #1007, #3197
  static TelaInicial2 + #1008, #3197
  static TelaInicial2 + #1009, #125
  static TelaInicial2 + #1010, #125
  static TelaInicial2 + #1011, #3197
  static TelaInicial2 + #1012, #3960
  static TelaInicial2 + #1013, #3885
  static TelaInicial2 + #1014, #3885
  static TelaInicial2 + #1015, #3885
  static TelaInicial2 + #1016, #3885
  static TelaInicial2 + #1017, #3960
  static TelaInicial2 + #1018, #2687
  static TelaInicial2 + #1019, #2622
  static TelaInicial2 + #1020, #2622
  static TelaInicial2 + #1021, #3885
  static TelaInicial2 + #1022, #2629
  static TelaInicial2 + #1023, #2675
  static TelaInicial2 + #1024, #2672
  static TelaInicial2 + #1025, #2657
  static TelaInicial2 + #1026, #2659
  static TelaInicial2 + #1027, #2671
  static TelaInicial2 + #1028, #3885
  static TelaInicial2 + #1029, #2620
  static TelaInicial2 + #1030, #2620
  static TelaInicial2 + #1031, #2687
  static TelaInicial2 + #1032, #3885
  static TelaInicial2 + #1033, #3844
  static TelaInicial2 + #1034, #3871
  static TelaInicial2 + #1035, #3844
  static TelaInicial2 + #1036, #3844
  static TelaInicial2 + #1037, #1823
  static TelaInicial2 + #1038, #1823
  static TelaInicial2 + #1039, #3844

  ;Linha 26
  static TelaInicial2 + #1040, #2591
  static TelaInicial2 + #1041, #3885
  static TelaInicial2 + #1042, #3197
  static TelaInicial2 + #1043, #3197
  static TelaInicial2 + #1044, #3197
  static TelaInicial2 + #1045, #3197
  static TelaInicial2 + #1046, #3197
  static TelaInicial2 + #1047, #3885
  static TelaInicial2 + #1048, #3197
  static TelaInicial2 + #1049, #3197
  static TelaInicial2 + #1050, #3197
  static TelaInicial2 + #1051, #3197
  static TelaInicial2 + #1052, #3885
  static TelaInicial2 + #1053, #3885
  static TelaInicial2 + #1054, #3885
  static TelaInicial2 + #1055, #3885
  static TelaInicial2 + #1056, #3885
  static TelaInicial2 + #1057, #3885
  static TelaInicial2 + #1058, #3885
  static TelaInicial2 + #1059, #3885
  static TelaInicial2 + #1060, #3885
  static TelaInicial2 + #1061, #3885
  static TelaInicial2 + #1062, #3885
  static TelaInicial2 + #1063, #3885
  static TelaInicial2 + #1064, #3885
  static TelaInicial2 + #1065, #3885
  static TelaInicial2 + #1066, #3885
  static TelaInicial2 + #1067, #3885
  static TelaInicial2 + #1068, #3885
  static TelaInicial2 + #1069, #3885
  static TelaInicial2 + #1070, #3885
  static TelaInicial2 + #1071, #3885
  static TelaInicial2 + #1072, #3885
  static TelaInicial2 + #1073, #3885
  static TelaInicial2 + #1074, #3885
  static TelaInicial2 + #1075, #3844
  static TelaInicial2 + #1076, #3844
  static TelaInicial2 + #1077, #1823
  static TelaInicial2 + #1078, #1823
  static TelaInicial2 + #1079, #2841

  ;Linha 27
  static TelaInicial2 + #1080, #2591
  static TelaInicial2 + #1081, #2591
  static TelaInicial2 + #1082, #3885
  static TelaInicial2 + #1083, #3197
  static TelaInicial2 + #1084, #3197
  static TelaInicial2 + #1085, #3197
  static TelaInicial2 + #1086, #3197
  static TelaInicial2 + #1087, #3197
  static TelaInicial2 + #1088, #3885
  static TelaInicial2 + #1089, #3197
  static TelaInicial2 + #1090, #3960
  static TelaInicial2 + #1091, #3197
  static TelaInicial2 + #1092, #3885
  static TelaInicial2 + #1093, #3885
  static TelaInicial2 + #1094, #3885
  static TelaInicial2 + #1095, #3885
  static TelaInicial2 + #1096, #3885
  static TelaInicial2 + #1097, #3885
  static TelaInicial2 + #1098, #3885
  static TelaInicial2 + #1099, #1407
  static TelaInicial2 + #1100, #1407
  static TelaInicial2 + #1101, #1407
  static TelaInicial2 + #1102, #1407
  static TelaInicial2 + #1103, #1407
  static TelaInicial2 + #1104, #1407
  static TelaInicial2 + #1105, #1407
  static TelaInicial2 + #1106, #1407
  static TelaInicial2 + #1107, #1407
  static TelaInicial2 + #1108, #1407
  static TelaInicial2 + #1109, #1407
  static TelaInicial2 + #1110, #1407
  static TelaInicial2 + #1111, #1407
  static TelaInicial2 + #1112, #3871
  static TelaInicial2 + #1113, #3844
  static TelaInicial2 + #1114, #3844
  static TelaInicial2 + #1115, #3844
  static TelaInicial2 + #1116, #3844
  static TelaInicial2 + #1117, #3844
  static TelaInicial2 + #1118, #1823
  static TelaInicial2 + #1119, #3844

  ;Linha 28
  static TelaInicial2 + #1120, #2591
  static TelaInicial2 + #1121, #2591
  static TelaInicial2 + #1122, #3885
  static TelaInicial2 + #1123, #3885
  static TelaInicial2 + #1124, #3197
  static TelaInicial2 + #1125, #3197
  static TelaInicial2 + #1126, #3197
  static TelaInicial2 + #1127, #3197
  static TelaInicial2 + #1128, #3197
  static TelaInicial2 + #1129, #3197
  static TelaInicial2 + #1130, #3197
  static TelaInicial2 + #1131, #3885
  static TelaInicial2 + #1132, #3885
  static TelaInicial2 + #1133, #3885
  static TelaInicial2 + #1134, #3885
  static TelaInicial2 + #1135, #3885
  static TelaInicial2 + #1136, #3885
  static TelaInicial2 + #1137, #3885
  static TelaInicial2 + #1138, #3885
  static TelaInicial2 + #1139, #3885
  static TelaInicial2 + #1140, #3885
  static TelaInicial2 + #1141, #3885
  static TelaInicial2 + #1142, #3885
  static TelaInicial2 + #1143, #3885
  static TelaInicial2 + #1144, #3885
  static TelaInicial2 + #1145, #3885
  static TelaInicial2 + #1146, #3885
  static TelaInicial2 + #1147, #3885
  static TelaInicial2 + #1148, #3885
  static TelaInicial2 + #1149, #3885
  static TelaInicial2 + #1150, #3885
  static TelaInicial2 + #1151, #3844
  static TelaInicial2 + #1152, #3871
  static TelaInicial2 + #1153, #3844
  static TelaInicial2 + #1154, #3844
  static TelaInicial2 + #1155, #3844
  static TelaInicial2 + #1156, #3844
  static TelaInicial2 + #1157, #3844
  static TelaInicial2 + #1158, #1051
  static TelaInicial2 + #1159, #2835

  ;Linha 29
  static TelaInicial2 + #1160, #2591
  static TelaInicial2 + #1161, #2591
  static TelaInicial2 + #1162, #2591
  static TelaInicial2 + #1163, #2591
  static TelaInicial2 + #1164, #2591
  static TelaInicial2 + #1165, #2847
  static TelaInicial2 + #1166, #2847
  static TelaInicial2 + #1167, #2847
  static TelaInicial2 + #1168, #3885
  static TelaInicial2 + #1169, #3885
  static TelaInicial2 + #1170, #3885
  static TelaInicial2 + #1171, #3885
  static TelaInicial2 + #1172, #3885
  static TelaInicial2 + #1173, #3843
  static TelaInicial2 + #1174, #3885
  static TelaInicial2 + #1175, #3843
  static TelaInicial2 + #1176, #3885
  static TelaInicial2 + #1177, #3885
  static TelaInicial2 + #1178, #127
  static TelaInicial2 + #1179, #3885
  static TelaInicial2 + #1180, #3885
  static TelaInicial2 + #1181, #127
  static TelaInicial2 + #1182, #3885
  static TelaInicial2 + #1183, #127
  static TelaInicial2 + #1184, #127
  static TelaInicial2 + #1185, #3885
  static TelaInicial2 + #1186, #3885
  static TelaInicial2 + #1187, #3885
  static TelaInicial2 + #1188, #3885
  static TelaInicial2 + #1189, #3885
  static TelaInicial2 + #1190, #3885
  static TelaInicial2 + #1191, #3844
  static TelaInicial2 + #1192, #3871
  static TelaInicial2 + #1193, #3844
  static TelaInicial2 + #1194, #3844
  static TelaInicial2 + #1195, #3844
  static TelaInicial2 + #1196, #3844
  static TelaInicial2 + #1197, #3844
  static TelaInicial2 + #1198, #2835
  static TelaInicial2 + #1199, #127

printTelaInicial2Screen:
  push R0
  push R1
  push R2
  push R3

  loadn R0, #TelaInicial2
  loadn R1, #0
  loadn R2, #1200

  printTelaInicial2ScreenLoop:

    add R3,R0,R1
    loadi R3, R3
    outchar R3, R1
    inc R1
    cmp R1, R2

    jne printTelaInicial2ScreenLoop

  pop R3
  pop R2
  pop R1
  pop R0
  rts
  
  ;-------------------------------------------------TELA DE AVISO MINIMO PONTOS---------------------------------------------
  TelaAvisoPontos : var #1200
  ;Linha 0
  static TelaAvisoPontos + #0, #127
  static TelaAvisoPontos + #1, #127
  static TelaAvisoPontos + #2, #127
  static TelaAvisoPontos + #3, #127
  static TelaAvisoPontos + #4, #127
  static TelaAvisoPontos + #5, #127
  static TelaAvisoPontos + #6, #127
  static TelaAvisoPontos + #7, #127
  static TelaAvisoPontos + #8, #127
  static TelaAvisoPontos + #9, #3875
  static TelaAvisoPontos + #10, #3875
  static TelaAvisoPontos + #11, #3875
  static TelaAvisoPontos + #12, #3875
  static TelaAvisoPontos + #13, #127
  static TelaAvisoPontos + #14, #127
  static TelaAvisoPontos + #15, #3875
  static TelaAvisoPontos + #16, #3875
  static TelaAvisoPontos + #17, #127
  static TelaAvisoPontos + #18, #3875
  static TelaAvisoPontos + #19, #3875
  static TelaAvisoPontos + #20, #3875
  static TelaAvisoPontos + #21, #3875
  static TelaAvisoPontos + #22, #3875
  static TelaAvisoPontos + #23, #3875
  static TelaAvisoPontos + #24, #127
  static TelaAvisoPontos + #25, #127
  static TelaAvisoPontos + #26, #127
  static TelaAvisoPontos + #27, #127
  static TelaAvisoPontos + #28, #127
  static TelaAvisoPontos + #29, #127
  static TelaAvisoPontos + #30, #127
  static TelaAvisoPontos + #31, #127
  static TelaAvisoPontos + #32, #127
  static TelaAvisoPontos + #33, #127
  static TelaAvisoPontos + #34, #127
  static TelaAvisoPontos + #35, #127
  static TelaAvisoPontos + #36, #127
  static TelaAvisoPontos + #37, #127
  static TelaAvisoPontos + #38, #127
  static TelaAvisoPontos + #39, #127

  ;Linha 1
  static TelaAvisoPontos + #40, #127
  static TelaAvisoPontos + #41, #127
  static TelaAvisoPontos + #42, #127
  static TelaAvisoPontos + #43, #127
  static TelaAvisoPontos + #44, #127
  static TelaAvisoPontos + #45, #127
  static TelaAvisoPontos + #46, #127
  static TelaAvisoPontos + #47, #127
  static TelaAvisoPontos + #48, #3875
  static TelaAvisoPontos + #49, #3875
  static TelaAvisoPontos + #50, #127
  static TelaAvisoPontos + #51, #127
  static TelaAvisoPontos + #52, #3875
  static TelaAvisoPontos + #53, #127
  static TelaAvisoPontos + #54, #127
  static TelaAvisoPontos + #55, #3875
  static TelaAvisoPontos + #56, #3875
  static TelaAvisoPontos + #57, #3875
  static TelaAvisoPontos + #58, #3875
  static TelaAvisoPontos + #59, #3875
  static TelaAvisoPontos + #60, #3875
  static TelaAvisoPontos + #61, #3875
  static TelaAvisoPontos + #62, #127
  static TelaAvisoPontos + #63, #3875
  static TelaAvisoPontos + #64, #3875
  static TelaAvisoPontos + #65, #127
  static TelaAvisoPontos + #66, #127
  static TelaAvisoPontos + #67, #127
  static TelaAvisoPontos + #68, #127
  static TelaAvisoPontos + #69, #127
  static TelaAvisoPontos + #70, #127
  static TelaAvisoPontos + #71, #127
  static TelaAvisoPontos + #72, #2851
  static TelaAvisoPontos + #73, #2883
  static TelaAvisoPontos + #74, #2881
  static TelaAvisoPontos + #75, #2881
  static TelaAvisoPontos + #76, #2899
  static TelaAvisoPontos + #77, #2895
  static TelaAvisoPontos + #78, #127
  static TelaAvisoPontos + #79, #127

  ;Linha 2
  static TelaAvisoPontos + #80, #127
  static TelaAvisoPontos + #81, #127
  static TelaAvisoPontos + #82, #127
  static TelaAvisoPontos + #83, #127
  static TelaAvisoPontos + #84, #127
  static TelaAvisoPontos + #85, #127
  static TelaAvisoPontos + #86, #127
  static TelaAvisoPontos + #87, #127
  static TelaAvisoPontos + #88, #127
  static TelaAvisoPontos + #89, #127
  static TelaAvisoPontos + #90, #127
  static TelaAvisoPontos + #91, #127
  static TelaAvisoPontos + #92, #3875
  static TelaAvisoPontos + #93, #127
  static TelaAvisoPontos + #94, #3875
  static TelaAvisoPontos + #95, #3875
  static TelaAvisoPontos + #96, #3875
  static TelaAvisoPontos + #97, #127
  static TelaAvisoPontos + #98, #3615
  static TelaAvisoPontos + #99, #3615
  static TelaAvisoPontos + #100, #127
  static TelaAvisoPontos + #101, #127
  static TelaAvisoPontos + #102, #3875
  static TelaAvisoPontos + #103, #3875
  static TelaAvisoPontos + #104, #3875
  static TelaAvisoPontos + #105, #3875
  static TelaAvisoPontos + #106, #127
  static TelaAvisoPontos + #107, #127
  static TelaAvisoPontos + #108, #127
  static TelaAvisoPontos + #109, #127
  static TelaAvisoPontos + #110, #127
  static TelaAvisoPontos + #111, #127
  static TelaAvisoPontos + #112, #127
  static TelaAvisoPontos + #113, #127
  static TelaAvisoPontos + #114, #3919
  static TelaAvisoPontos + #115, #2888
  static TelaAvisoPontos + #116, #2885
  static TelaAvisoPontos + #117, #2898
  static TelaAvisoPontos + #118, #2895
  static TelaAvisoPontos + #119, #127

  ;Linha 3
  static TelaAvisoPontos + #120, #127
  static TelaAvisoPontos + #121, #127
  static TelaAvisoPontos + #122, #127
  static TelaAvisoPontos + #123, #127
  static TelaAvisoPontos + #124, #127
  static TelaAvisoPontos + #125, #127
  static TelaAvisoPontos + #126, #127
  static TelaAvisoPontos + #127, #127
  static TelaAvisoPontos + #128, #127
  static TelaAvisoPontos + #129, #127
  static TelaAvisoPontos + #130, #127
  static TelaAvisoPontos + #131, #127
  static TelaAvisoPontos + #132, #3875
  static TelaAvisoPontos + #133, #127
  static TelaAvisoPontos + #134, #3875
  static TelaAvisoPontos + #135, #3875
  static TelaAvisoPontos + #136, #127
  static TelaAvisoPontos + #137, #127
  static TelaAvisoPontos + #138, #3615
  static TelaAvisoPontos + #139, #3615
  static TelaAvisoPontos + #140, #127
  static TelaAvisoPontos + #141, #127
  static TelaAvisoPontos + #142, #127
  static TelaAvisoPontos + #143, #3875
  static TelaAvisoPontos + #144, #3875
  static TelaAvisoPontos + #145, #3875
  static TelaAvisoPontos + #146, #127
  static TelaAvisoPontos + #147, #127
  static TelaAvisoPontos + #148, #127
  static TelaAvisoPontos + #149, #127
  static TelaAvisoPontos + #150, #127
  static TelaAvisoPontos + #151, #127
  static TelaAvisoPontos + #152, #127
  static TelaAvisoPontos + #153, #127
  static TelaAvisoPontos + #154, #127
  static TelaAvisoPontos + #155, #127
  static TelaAvisoPontos + #156, #127
  static TelaAvisoPontos + #157, #127
  static TelaAvisoPontos + #158, #127
  static TelaAvisoPontos + #159, #127

  ;Linha 4
  static TelaAvisoPontos + #160, #127
  static TelaAvisoPontos + #161, #127
  static TelaAvisoPontos + #162, #127
  static TelaAvisoPontos + #163, #127
  static TelaAvisoPontos + #164, #127
  static TelaAvisoPontos + #165, #127
  static TelaAvisoPontos + #166, #127
  static TelaAvisoPontos + #167, #127
  static TelaAvisoPontos + #168, #127
  static TelaAvisoPontos + #169, #127
  static TelaAvisoPontos + #170, #127
  static TelaAvisoPontos + #171, #3875
  static TelaAvisoPontos + #172, #3875
  static TelaAvisoPontos + #173, #127
  static TelaAvisoPontos + #174, #3875
  static TelaAvisoPontos + #175, #3875
  static TelaAvisoPontos + #176, #127
  static TelaAvisoPontos + #177, #127
  static TelaAvisoPontos + #178, #127
  static TelaAvisoPontos + #179, #3615
  static TelaAvisoPontos + #180, #127
  static TelaAvisoPontos + #181, #127
  static TelaAvisoPontos + #182, #127
  static TelaAvisoPontos + #183, #3875
  static TelaAvisoPontos + #184, #3875
  static TelaAvisoPontos + #185, #3875
  static TelaAvisoPontos + #186, #127
  static TelaAvisoPontos + #187, #127
  static TelaAvisoPontos + #188, #127
  static TelaAvisoPontos + #189, #127
  static TelaAvisoPontos + #190, #127
  static TelaAvisoPontos + #191, #127
  static TelaAvisoPontos + #192, #127
  static TelaAvisoPontos + #193, #127
  static TelaAvisoPontos + #194, #127
  static TelaAvisoPontos + #195, #127
  static TelaAvisoPontos + #196, #127
  static TelaAvisoPontos + #197, #127
  static TelaAvisoPontos + #198, #127
  static TelaAvisoPontos + #199, #127

  ;Linha 5
  static TelaAvisoPontos + #200, #127
  static TelaAvisoPontos + #201, #127
  static TelaAvisoPontos + #202, #127
  static TelaAvisoPontos + #203, #127
  static TelaAvisoPontos + #204, #127
  static TelaAvisoPontos + #205, #127
  static TelaAvisoPontos + #206, #127
  static TelaAvisoPontos + #207, #127
  static TelaAvisoPontos + #208, #127
  static TelaAvisoPontos + #209, #3875
  static TelaAvisoPontos + #210, #3875
  static TelaAvisoPontos + #211, #3875
  static TelaAvisoPontos + #212, #127
  static TelaAvisoPontos + #213, #127
  static TelaAvisoPontos + #214, #3875
  static TelaAvisoPontos + #215, #127
  static TelaAvisoPontos + #216, #127
  static TelaAvisoPontos + #217, #127
  static TelaAvisoPontos + #218, #127
  static TelaAvisoPontos + #219, #3615
  static TelaAvisoPontos + #220, #127
  static TelaAvisoPontos + #221, #127
  static TelaAvisoPontos + #222, #127
  static TelaAvisoPontos + #223, #3875
  static TelaAvisoPontos + #224, #3875
  static TelaAvisoPontos + #225, #3875
  static TelaAvisoPontos + #226, #127
  static TelaAvisoPontos + #227, #127
  static TelaAvisoPontos + #228, #127
  static TelaAvisoPontos + #229, #127
  static TelaAvisoPontos + #230, #127
  static TelaAvisoPontos + #231, #127
  static TelaAvisoPontos + #232, #127
  static TelaAvisoPontos + #233, #127
  static TelaAvisoPontos + #234, #127
  static TelaAvisoPontos + #235, #127
  static TelaAvisoPontos + #236, #127
  static TelaAvisoPontos + #237, #127
  static TelaAvisoPontos + #238, #127
  static TelaAvisoPontos + #239, #127

  ;Linha 6
  static TelaAvisoPontos + #240, #127
  static TelaAvisoPontos + #241, #127
  static TelaAvisoPontos + #242, #127
  static TelaAvisoPontos + #243, #127
  static TelaAvisoPontos + #244, #127
  static TelaAvisoPontos + #245, #3875
  static TelaAvisoPontos + #246, #3875
  static TelaAvisoPontos + #247, #3875
  static TelaAvisoPontos + #248, #3875
  static TelaAvisoPontos + #249, #3875
  static TelaAvisoPontos + #250, #3875
  static TelaAvisoPontos + #251, #3875
  static TelaAvisoPontos + #252, #3875
  static TelaAvisoPontos + #253, #3875
  static TelaAvisoPontos + #254, #3875
  static TelaAvisoPontos + #255, #3875
  static TelaAvisoPontos + #256, #3875
  static TelaAvisoPontos + #257, #3875
  static TelaAvisoPontos + #258, #3875
  static TelaAvisoPontos + #259, #127
  static TelaAvisoPontos + #260, #3875
  static TelaAvisoPontos + #261, #3875
  static TelaAvisoPontos + #262, #3875
  static TelaAvisoPontos + #263, #3875
  static TelaAvisoPontos + #264, #3875
  static TelaAvisoPontos + #265, #3875
  static TelaAvisoPontos + #266, #127
  static TelaAvisoPontos + #267, #127
  static TelaAvisoPontos + #268, #127
  static TelaAvisoPontos + #269, #127
  static TelaAvisoPontos + #270, #127
  static TelaAvisoPontos + #271, #127
  static TelaAvisoPontos + #272, #127
  static TelaAvisoPontos + #273, #127
  static TelaAvisoPontos + #274, #127
  static TelaAvisoPontos + #275, #127
  static TelaAvisoPontos + #276, #127
  static TelaAvisoPontos + #277, #127
  static TelaAvisoPontos + #278, #127
  static TelaAvisoPontos + #279, #127

  ;Linha 7
  static TelaAvisoPontos + #280, #127
  static TelaAvisoPontos + #281, #127
  static TelaAvisoPontos + #282, #127
  static TelaAvisoPontos + #283, #127
  static TelaAvisoPontos + #284, #127
  static TelaAvisoPontos + #285, #127
  static TelaAvisoPontos + #286, #127
  static TelaAvisoPontos + #287, #127
  static TelaAvisoPontos + #288, #127
  static TelaAvisoPontos + #289, #127
  static TelaAvisoPontos + #290, #127
  static TelaAvisoPontos + #291, #127
  static TelaAvisoPontos + #292, #127
  static TelaAvisoPontos + #293, #127
  static TelaAvisoPontos + #294, #3875
  static TelaAvisoPontos + #295, #3875
  static TelaAvisoPontos + #296, #127
  static TelaAvisoPontos + #297, #127
  static TelaAvisoPontos + #298, #127
  static TelaAvisoPontos + #299, #3875
  static TelaAvisoPontos + #300, #3875
  static TelaAvisoPontos + #301, #3875
  static TelaAvisoPontos + #302, #3875
  static TelaAvisoPontos + #303, #127
  static TelaAvisoPontos + #304, #127
  static TelaAvisoPontos + #305, #127
  static TelaAvisoPontos + #306, #127
  static TelaAvisoPontos + #307, #127
  static TelaAvisoPontos + #308, #127
  static TelaAvisoPontos + #309, #127
  static TelaAvisoPontos + #310, #127
  static TelaAvisoPontos + #311, #127
  static TelaAvisoPontos + #312, #127
  static TelaAvisoPontos + #313, #127
  static TelaAvisoPontos + #314, #127
  static TelaAvisoPontos + #315, #127
  static TelaAvisoPontos + #316, #127
  static TelaAvisoPontos + #317, #127
  static TelaAvisoPontos + #318, #127
  static TelaAvisoPontos + #319, #127

  ;Linha 8
  static TelaAvisoPontos + #320, #127
  static TelaAvisoPontos + #321, #127
  static TelaAvisoPontos + #322, #127
  static TelaAvisoPontos + #323, #127
  static TelaAvisoPontos + #324, #127
  static TelaAvisoPontos + #325, #127
  static TelaAvisoPontos + #326, #127
  static TelaAvisoPontos + #327, #127
  static TelaAvisoPontos + #328, #127
  static TelaAvisoPontos + #329, #127
  static TelaAvisoPontos + #330, #127
  static TelaAvisoPontos + #331, #127
  static TelaAvisoPontos + #332, #127
  static TelaAvisoPontos + #333, #127
  static TelaAvisoPontos + #334, #127
  static TelaAvisoPontos + #335, #127
  static TelaAvisoPontos + #336, #3875
  static TelaAvisoPontos + #337, #3875
  static TelaAvisoPontos + #338, #3875
  static TelaAvisoPontos + #339, #3875
  static TelaAvisoPontos + #340, #3875
  static TelaAvisoPontos + #341, #3875
  static TelaAvisoPontos + #342, #3875
  static TelaAvisoPontos + #343, #3615
  static TelaAvisoPontos + #344, #3615
  static TelaAvisoPontos + #345, #3615
  static TelaAvisoPontos + #346, #127
  static TelaAvisoPontos + #347, #127
  static TelaAvisoPontos + #348, #127
  static TelaAvisoPontos + #349, #127
  static TelaAvisoPontos + #350, #127
  static TelaAvisoPontos + #351, #127
  static TelaAvisoPontos + #352, #127
  static TelaAvisoPontos + #353, #127
  static TelaAvisoPontos + #354, #127
  static TelaAvisoPontos + #355, #127
  static TelaAvisoPontos + #356, #127
  static TelaAvisoPontos + #357, #127
  static TelaAvisoPontos + #358, #127
  static TelaAvisoPontos + #359, #127

  ;Linha 9
  static TelaAvisoPontos + #360, #127
  static TelaAvisoPontos + #361, #127
  static TelaAvisoPontos + #362, #127
  static TelaAvisoPontos + #363, #127
  static TelaAvisoPontos + #364, #127
  static TelaAvisoPontos + #365, #127
  static TelaAvisoPontos + #366, #127
  static TelaAvisoPontos + #367, #127
  static TelaAvisoPontos + #368, #3615
  static TelaAvisoPontos + #369, #3615
  static TelaAvisoPontos + #370, #3615
  static TelaAvisoPontos + #371, #3615
  static TelaAvisoPontos + #372, #127
  static TelaAvisoPontos + #373, #3615
  static TelaAvisoPontos + #374, #127
  static TelaAvisoPontos + #375, #3615
  static TelaAvisoPontos + #376, #3615
  static TelaAvisoPontos + #377, #3615
  static TelaAvisoPontos + #378, #127
  static TelaAvisoPontos + #379, #3615
  static TelaAvisoPontos + #380, #127
  static TelaAvisoPontos + #381, #3615
  static TelaAvisoPontos + #382, #127
  static TelaAvisoPontos + #383, #3615
  static TelaAvisoPontos + #384, #127
  static TelaAvisoPontos + #385, #127
  static TelaAvisoPontos + #386, #127
  static TelaAvisoPontos + #387, #127
  static TelaAvisoPontos + #388, #127
  static TelaAvisoPontos + #389, #127
  static TelaAvisoPontos + #390, #127
  static TelaAvisoPontos + #391, #127
  static TelaAvisoPontos + #392, #127
  static TelaAvisoPontos + #393, #127
  static TelaAvisoPontos + #394, #127
  static TelaAvisoPontos + #395, #127
  static TelaAvisoPontos + #396, #127
  static TelaAvisoPontos + #397, #127
  static TelaAvisoPontos + #398, #127
  static TelaAvisoPontos + #399, #127

  ;Linha 10
  static TelaAvisoPontos + #400, #127
  static TelaAvisoPontos + #401, #127
  static TelaAvisoPontos + #402, #127
  static TelaAvisoPontos + #403, #127
  static TelaAvisoPontos + #404, #127
  static TelaAvisoPontos + #405, #127
  static TelaAvisoPontos + #406, #3615
  static TelaAvisoPontos + #407, #3615
  static TelaAvisoPontos + #408, #3615
  static TelaAvisoPontos + #409, #3615
  static TelaAvisoPontos + #410, #3615
  static TelaAvisoPontos + #411, #3615
  static TelaAvisoPontos + #412, #3615
  static TelaAvisoPontos + #413, #3615
  static TelaAvisoPontos + #414, #3615
  static TelaAvisoPontos + #415, #3615
  static TelaAvisoPontos + #416, #3615
  static TelaAvisoPontos + #417, #3615
  static TelaAvisoPontos + #418, #3615
  static TelaAvisoPontos + #419, #3615
  static TelaAvisoPontos + #420, #3615
  static TelaAvisoPontos + #421, #3615
  static TelaAvisoPontos + #422, #3615
  static TelaAvisoPontos + #423, #3615
  static TelaAvisoPontos + #424, #3615
  static TelaAvisoPontos + #425, #3615
  static TelaAvisoPontos + #426, #127
  static TelaAvisoPontos + #427, #127
  static TelaAvisoPontos + #428, #127
  static TelaAvisoPontos + #429, #127
  static TelaAvisoPontos + #430, #127
  static TelaAvisoPontos + #431, #127
  static TelaAvisoPontos + #432, #127
  static TelaAvisoPontos + #433, #127
  static TelaAvisoPontos + #434, #127
  static TelaAvisoPontos + #435, #127
  static TelaAvisoPontos + #436, #127
  static TelaAvisoPontos + #437, #127
  static TelaAvisoPontos + #438, #127
  static TelaAvisoPontos + #439, #127

  ;Linha 11
  static TelaAvisoPontos + #440, #127
  static TelaAvisoPontos + #441, #127
  static TelaAvisoPontos + #442, #127
  static TelaAvisoPontos + #443, #127
  static TelaAvisoPontos + #444, #127
  static TelaAvisoPontos + #445, #127
  static TelaAvisoPontos + #446, #127
  static TelaAvisoPontos + #447, #3615
  static TelaAvisoPontos + #448, #127
  static TelaAvisoPontos + #449, #3615
  static TelaAvisoPontos + #450, #3615
  static TelaAvisoPontos + #451, #3615
  static TelaAvisoPontos + #452, #3615
  static TelaAvisoPontos + #453, #3615
  static TelaAvisoPontos + #454, #3615
  static TelaAvisoPontos + #455, #3615
  static TelaAvisoPontos + #456, #3615
  static TelaAvisoPontos + #457, #3615
  static TelaAvisoPontos + #458, #3615
  static TelaAvisoPontos + #459, #3615
  static TelaAvisoPontos + #460, #3615
  static TelaAvisoPontos + #461, #3615
  static TelaAvisoPontos + #462, #3615
  static TelaAvisoPontos + #463, #3615
  static TelaAvisoPontos + #464, #127
  static TelaAvisoPontos + #465, #3615
  static TelaAvisoPontos + #466, #127
  static TelaAvisoPontos + #467, #127
  static TelaAvisoPontos + #468, #127
  static TelaAvisoPontos + #469, #127
  static TelaAvisoPontos + #470, #127
  static TelaAvisoPontos + #471, #127
  static TelaAvisoPontos + #472, #127
  static TelaAvisoPontos + #473, #127
  static TelaAvisoPontos + #474, #127
  static TelaAvisoPontos + #475, #127
  static TelaAvisoPontos + #476, #127
  static TelaAvisoPontos + #477, #127
  static TelaAvisoPontos + #478, #127
  static TelaAvisoPontos + #479, #127

  ;Linha 12
  static TelaAvisoPontos + #480, #127
  static TelaAvisoPontos + #481, #127
  static TelaAvisoPontos + #482, #127
  static TelaAvisoPontos + #483, #127
  static TelaAvisoPontos + #484, #127
  static TelaAvisoPontos + #485, #127
  static TelaAvisoPontos + #486, #127
  static TelaAvisoPontos + #487, #127
  static TelaAvisoPontos + #488, #127
  static TelaAvisoPontos + #489, #127
  static TelaAvisoPontos + #490, #127
  static TelaAvisoPontos + #491, #127
  static TelaAvisoPontos + #492, #127
  static TelaAvisoPontos + #493, #3950
  static TelaAvisoPontos + #494, #127
  static TelaAvisoPontos + #495, #127
  static TelaAvisoPontos + #496, #127
  static TelaAvisoPontos + #497, #127
  static TelaAvisoPontos + #498, #127
  static TelaAvisoPontos + #499, #3615
  static TelaAvisoPontos + #500, #127
  static TelaAvisoPontos + #501, #127
  static TelaAvisoPontos + #502, #127
  static TelaAvisoPontos + #503, #127
  static TelaAvisoPontos + #504, #127
  static TelaAvisoPontos + #505, #127
  static TelaAvisoPontos + #506, #127
  static TelaAvisoPontos + #507, #127
  static TelaAvisoPontos + #508, #127
  static TelaAvisoPontos + #509, #127
  static TelaAvisoPontos + #510, #127
  static TelaAvisoPontos + #511, #127
  static TelaAvisoPontos + #512, #127
  static TelaAvisoPontos + #513, #127
  static TelaAvisoPontos + #514, #127
  static TelaAvisoPontos + #515, #127
  static TelaAvisoPontos + #516, #127
  static TelaAvisoPontos + #517, #127
  static TelaAvisoPontos + #518, #127
  static TelaAvisoPontos + #519, #127

  ;Linha 13
  static TelaAvisoPontos + #520, #127
  static TelaAvisoPontos + #521, #127
  static TelaAvisoPontos + #522, #127
  static TelaAvisoPontos + #523, #127
  static TelaAvisoPontos + #524, #127
  static TelaAvisoPontos + #525, #127
  static TelaAvisoPontos + #526, #127
  static TelaAvisoPontos + #527, #127
  static TelaAvisoPontos + #528, #127
  static TelaAvisoPontos + #529, #127
  static TelaAvisoPontos + #530, #127
  static TelaAvisoPontos + #531, #127
  static TelaAvisoPontos + #532, #3661
  static TelaAvisoPontos + #533, #3689
  static TelaAvisoPontos + #534, #3694
  static TelaAvisoPontos + #535, #3689
  static TelaAvisoPontos + #536, #3693
  static TelaAvisoPontos + #537, #3695
  static TelaAvisoPontos + #538, #3888
  static TelaAvisoPontos + #539, #2866
  static TelaAvisoPontos + #540, #2864
  static TelaAvisoPontos + #541, #127
  static TelaAvisoPontos + #542, #3696
  static TelaAvisoPontos + #543, #3695
  static TelaAvisoPontos + #544, #3694
  static TelaAvisoPontos + #545, #3700
  static TelaAvisoPontos + #546, #3695
  static TelaAvisoPontos + #547, #3699
  static TelaAvisoPontos + #548, #127
  static TelaAvisoPontos + #549, #127
  static TelaAvisoPontos + #550, #127
  static TelaAvisoPontos + #551, #127
  static TelaAvisoPontos + #552, #127
  static TelaAvisoPontos + #553, #127
  static TelaAvisoPontos + #554, #127
  static TelaAvisoPontos + #555, #127
  static TelaAvisoPontos + #556, #127
  static TelaAvisoPontos + #557, #127
  static TelaAvisoPontos + #558, #127
  static TelaAvisoPontos + #559, #127

  ;Linha 14
  static TelaAvisoPontos + #560, #127
  static TelaAvisoPontos + #561, #127
  static TelaAvisoPontos + #562, #127
  static TelaAvisoPontos + #563, #127
  static TelaAvisoPontos + #564, #127
  static TelaAvisoPontos + #565, #127
  static TelaAvisoPontos + #566, #127
  static TelaAvisoPontos + #567, #127
  static TelaAvisoPontos + #568, #127
  static TelaAvisoPontos + #569, #127
  static TelaAvisoPontos + #570, #127
  static TelaAvisoPontos + #571, #3951
  static TelaAvisoPontos + #572, #3951
  static TelaAvisoPontos + #573, #3951
  static TelaAvisoPontos + #574, #3696
  static TelaAvisoPontos + #575, #3681
  static TelaAvisoPontos + #576, #3698
  static TelaAvisoPontos + #577, #3681
  static TelaAvisoPontos + #578, #3951
  static TelaAvisoPontos + #579, #3686
  static TelaAvisoPontos + #580, #3681
  static TelaAvisoPontos + #581, #3699
  static TelaAvisoPontos + #582, #3685
  static TelaAvisoPontos + #583, #3615
  static TelaAvisoPontos + #584, #3634
  static TelaAvisoPontos + #585, #127
  static TelaAvisoPontos + #586, #127
  static TelaAvisoPontos + #587, #127
  static TelaAvisoPontos + #588, #127
  static TelaAvisoPontos + #589, #127
  static TelaAvisoPontos + #590, #127
  static TelaAvisoPontos + #591, #127
  static TelaAvisoPontos + #592, #127
  static TelaAvisoPontos + #593, #127
  static TelaAvisoPontos + #594, #127
  static TelaAvisoPontos + #595, #127
  static TelaAvisoPontos + #596, #127
  static TelaAvisoPontos + #597, #127
  static TelaAvisoPontos + #598, #127
  static TelaAvisoPontos + #599, #127

  ;Linha 15
  static TelaAvisoPontos + #600, #127
  static TelaAvisoPontos + #601, #127
  static TelaAvisoPontos + #602, #127
  static TelaAvisoPontos + #603, #127
  static TelaAvisoPontos + #604, #127
  static TelaAvisoPontos + #605, #127
  static TelaAvisoPontos + #606, #127
  static TelaAvisoPontos + #607, #127
  static TelaAvisoPontos + #608, #127
  static TelaAvisoPontos + #609, #127
  static TelaAvisoPontos + #610, #127
  static TelaAvisoPontos + #611, #127
  static TelaAvisoPontos + #612, #127
  static TelaAvisoPontos + #613, #127
  static TelaAvisoPontos + #614, #127
  static TelaAvisoPontos + #615, #127
  static TelaAvisoPontos + #616, #127
  static TelaAvisoPontos + #617, #127
  static TelaAvisoPontos + #618, #3615
  static TelaAvisoPontos + #619, #127
  static TelaAvisoPontos + #620, #127
  static TelaAvisoPontos + #621, #127
  static TelaAvisoPontos + #622, #127
  static TelaAvisoPontos + #623, #127
  static TelaAvisoPontos + #624, #127
  static TelaAvisoPontos + #625, #127
  static TelaAvisoPontos + #626, #127
  static TelaAvisoPontos + #627, #127
  static TelaAvisoPontos + #628, #127
  static TelaAvisoPontos + #629, #127
  static TelaAvisoPontos + #630, #127
  static TelaAvisoPontos + #631, #127
  static TelaAvisoPontos + #632, #127
  static TelaAvisoPontos + #633, #127
  static TelaAvisoPontos + #634, #127
  static TelaAvisoPontos + #635, #127
  static TelaAvisoPontos + #636, #127
  static TelaAvisoPontos + #637, #127
  static TelaAvisoPontos + #638, #127
  static TelaAvisoPontos + #639, #127

  ;Linha 16
  static TelaAvisoPontos + #640, #127
  static TelaAvisoPontos + #641, #127
  static TelaAvisoPontos + #642, #127
  static TelaAvisoPontos + #643, #127
  static TelaAvisoPontos + #644, #127
  static TelaAvisoPontos + #645, #127
  static TelaAvisoPontos + #646, #127
  static TelaAvisoPontos + #647, #127
  static TelaAvisoPontos + #648, #127
  static TelaAvisoPontos + #649, #127
  static TelaAvisoPontos + #650, #127
  static TelaAvisoPontos + #651, #127
  static TelaAvisoPontos + #652, #127
  static TelaAvisoPontos + #653, #127
  static TelaAvisoPontos + #654, #127
  static TelaAvisoPontos + #655, #127
  static TelaAvisoPontos + #656, #127
  static TelaAvisoPontos + #657, #127
  static TelaAvisoPontos + #658, #127
  static TelaAvisoPontos + #659, #127
  static TelaAvisoPontos + #660, #127
  static TelaAvisoPontos + #661, #127
  static TelaAvisoPontos + #662, #127
  static TelaAvisoPontos + #663, #127
  static TelaAvisoPontos + #664, #127
  static TelaAvisoPontos + #665, #127
  static TelaAvisoPontos + #666, #127
  static TelaAvisoPontos + #667, #127
  static TelaAvisoPontos + #668, #127
  static TelaAvisoPontos + #669, #127
  static TelaAvisoPontos + #670, #127
  static TelaAvisoPontos + #671, #127
  static TelaAvisoPontos + #672, #127
  static TelaAvisoPontos + #673, #127
  static TelaAvisoPontos + #674, #127
  static TelaAvisoPontos + #675, #127
  static TelaAvisoPontos + #676, #127
  static TelaAvisoPontos + #677, #127
  static TelaAvisoPontos + #678, #127
  static TelaAvisoPontos + #679, #127

  ;Linha 17
  static TelaAvisoPontos + #680, #127
  static TelaAvisoPontos + #681, #127
  static TelaAvisoPontos + #682, #127
  static TelaAvisoPontos + #683, #127
  static TelaAvisoPontos + #684, #127
  static TelaAvisoPontos + #685, #127
  static TelaAvisoPontos + #686, #127
  static TelaAvisoPontos + #687, #127
  static TelaAvisoPontos + #688, #127
  static TelaAvisoPontos + #689, #127
  static TelaAvisoPontos + #690, #127
  static TelaAvisoPontos + #691, #127
  static TelaAvisoPontos + #692, #127
  static TelaAvisoPontos + #693, #127
  static TelaAvisoPontos + #694, #127
  static TelaAvisoPontos + #695, #127
  static TelaAvisoPontos + #696, #127
  static TelaAvisoPontos + #697, #127
  static TelaAvisoPontos + #698, #127
  static TelaAvisoPontos + #699, #127
  static TelaAvisoPontos + #700, #127
  static TelaAvisoPontos + #701, #127
  static TelaAvisoPontos + #702, #127
  static TelaAvisoPontos + #703, #127
  static TelaAvisoPontos + #704, #127
  static TelaAvisoPontos + #705, #127
  static TelaAvisoPontos + #706, #127
  static TelaAvisoPontos + #707, #127
  static TelaAvisoPontos + #708, #127
  static TelaAvisoPontos + #709, #127
  static TelaAvisoPontos + #710, #127
  static TelaAvisoPontos + #711, #127
  static TelaAvisoPontos + #712, #127
  static TelaAvisoPontos + #713, #127
  static TelaAvisoPontos + #714, #127
  static TelaAvisoPontos + #715, #127
  static TelaAvisoPontos + #716, #127
  static TelaAvisoPontos + #717, #127
  static TelaAvisoPontos + #718, #127
  static TelaAvisoPontos + #719, #127

  ;Linha 18
  static TelaAvisoPontos + #720, #127
  static TelaAvisoPontos + #721, #127
  static TelaAvisoPontos + #722, #127
  static TelaAvisoPontos + #723, #127
  static TelaAvisoPontos + #724, #127
  static TelaAvisoPontos + #725, #127
  static TelaAvisoPontos + #726, #127
  static TelaAvisoPontos + #727, #127
  static TelaAvisoPontos + #728, #127
  static TelaAvisoPontos + #729, #127
  static TelaAvisoPontos + #730, #127
  static TelaAvisoPontos + #731, #127
  static TelaAvisoPontos + #732, #127
  static TelaAvisoPontos + #733, #127
  static TelaAvisoPontos + #734, #127
  static TelaAvisoPontos + #735, #127
  static TelaAvisoPontos + #736, #127
  static TelaAvisoPontos + #737, #127
  static TelaAvisoPontos + #738, #127
  static TelaAvisoPontos + #739, #127
  static TelaAvisoPontos + #740, #127
  static TelaAvisoPontos + #741, #127
  static TelaAvisoPontos + #742, #127
  static TelaAvisoPontos + #743, #127
  static TelaAvisoPontos + #744, #127
  static TelaAvisoPontos + #745, #127
  static TelaAvisoPontos + #746, #127
  static TelaAvisoPontos + #747, #127
  static TelaAvisoPontos + #748, #127
  static TelaAvisoPontos + #749, #127
  static TelaAvisoPontos + #750, #127
  static TelaAvisoPontos + #751, #127
  static TelaAvisoPontos + #752, #127
  static TelaAvisoPontos + #753, #127
  static TelaAvisoPontos + #754, #127
  static TelaAvisoPontos + #755, #127
  static TelaAvisoPontos + #756, #127
  static TelaAvisoPontos + #757, #127
  static TelaAvisoPontos + #758, #127
  static TelaAvisoPontos + #759, #127

  ;Linha 19
  static TelaAvisoPontos + #760, #127
  static TelaAvisoPontos + #761, #127
  static TelaAvisoPontos + #762, #127
  static TelaAvisoPontos + #763, #127
  static TelaAvisoPontos + #764, #127
  static TelaAvisoPontos + #765, #127
  static TelaAvisoPontos + #766, #127
  static TelaAvisoPontos + #767, #127
  static TelaAvisoPontos + #768, #127
  static TelaAvisoPontos + #769, #127
  static TelaAvisoPontos + #770, #127
  static TelaAvisoPontos + #771, #127
  static TelaAvisoPontos + #772, #127
  static TelaAvisoPontos + #773, #127
  static TelaAvisoPontos + #774, #127
  static TelaAvisoPontos + #775, #127
  static TelaAvisoPontos + #776, #127
  static TelaAvisoPontos + #777, #127
  static TelaAvisoPontos + #778, #127
  static TelaAvisoPontos + #779, #127
  static TelaAvisoPontos + #780, #127
  static TelaAvisoPontos + #781, #127
  static TelaAvisoPontos + #782, #127
  static TelaAvisoPontos + #783, #127
  static TelaAvisoPontos + #784, #127
  static TelaAvisoPontos + #785, #127
  static TelaAvisoPontos + #786, #127
  static TelaAvisoPontos + #787, #127
  static TelaAvisoPontos + #788, #127
  static TelaAvisoPontos + #789, #127
  static TelaAvisoPontos + #790, #127
  static TelaAvisoPontos + #791, #127
  static TelaAvisoPontos + #792, #127
  static TelaAvisoPontos + #793, #127
  static TelaAvisoPontos + #794, #127
  static TelaAvisoPontos + #795, #127
  static TelaAvisoPontos + #796, #127
  static TelaAvisoPontos + #797, #127
  static TelaAvisoPontos + #798, #127
  static TelaAvisoPontos + #799, #127

  ;Linha 20
  static TelaAvisoPontos + #800, #127
  static TelaAvisoPontos + #801, #127
  static TelaAvisoPontos + #802, #127
  static TelaAvisoPontos + #803, #127
  static TelaAvisoPontos + #804, #127
  static TelaAvisoPontos + #805, #127
  static TelaAvisoPontos + #806, #127
  static TelaAvisoPontos + #807, #127
  static TelaAvisoPontos + #808, #127
  static TelaAvisoPontos + #809, #127
  static TelaAvisoPontos + #810, #127
  static TelaAvisoPontos + #811, #127
  static TelaAvisoPontos + #812, #127
  static TelaAvisoPontos + #813, #127
  static TelaAvisoPontos + #814, #127
  static TelaAvisoPontos + #815, #127
  static TelaAvisoPontos + #816, #127
  static TelaAvisoPontos + #817, #127
  static TelaAvisoPontos + #818, #127
  static TelaAvisoPontos + #819, #127
  static TelaAvisoPontos + #820, #127
  static TelaAvisoPontos + #821, #127
  static TelaAvisoPontos + #822, #127
  static TelaAvisoPontos + #823, #127
  static TelaAvisoPontos + #824, #127
  static TelaAvisoPontos + #825, #127
  static TelaAvisoPontos + #826, #127
  static TelaAvisoPontos + #827, #127
  static TelaAvisoPontos + #828, #127
  static TelaAvisoPontos + #829, #127
  static TelaAvisoPontos + #830, #127
  static TelaAvisoPontos + #831, #127
  static TelaAvisoPontos + #832, #127
  static TelaAvisoPontos + #833, #127
  static TelaAvisoPontos + #834, #127
  static TelaAvisoPontos + #835, #127
  static TelaAvisoPontos + #836, #127
  static TelaAvisoPontos + #837, #127
  static TelaAvisoPontos + #838, #127
  static TelaAvisoPontos + #839, #127

  ;Linha 21
  static TelaAvisoPontos + #840, #127
  static TelaAvisoPontos + #841, #127
  static TelaAvisoPontos + #842, #127
  static TelaAvisoPontos + #843, #127
  static TelaAvisoPontos + #844, #127
  static TelaAvisoPontos + #845, #127
  static TelaAvisoPontos + #846, #127
  static TelaAvisoPontos + #847, #127
  static TelaAvisoPontos + #848, #127
  static TelaAvisoPontos + #849, #127
  static TelaAvisoPontos + #850, #127
  static TelaAvisoPontos + #851, #127
  static TelaAvisoPontos + #852, #127
  static TelaAvisoPontos + #853, #127
  static TelaAvisoPontos + #854, #127
  static TelaAvisoPontos + #855, #127
  static TelaAvisoPontos + #856, #127
  static TelaAvisoPontos + #857, #127
  static TelaAvisoPontos + #858, #127
  static TelaAvisoPontos + #859, #127
  static TelaAvisoPontos + #860, #127
  static TelaAvisoPontos + #861, #127
  static TelaAvisoPontos + #862, #127
  static TelaAvisoPontos + #863, #127
  static TelaAvisoPontos + #864, #127
  static TelaAvisoPontos + #865, #127
  static TelaAvisoPontos + #866, #127
  static TelaAvisoPontos + #867, #127
  static TelaAvisoPontos + #868, #127
  static TelaAvisoPontos + #869, #127
  static TelaAvisoPontos + #870, #127
  static TelaAvisoPontos + #871, #127
  static TelaAvisoPontos + #872, #127
  static TelaAvisoPontos + #873, #127
  static TelaAvisoPontos + #874, #127
  static TelaAvisoPontos + #875, #127
  static TelaAvisoPontos + #876, #127
  static TelaAvisoPontos + #877, #127
  static TelaAvisoPontos + #878, #127
  static TelaAvisoPontos + #879, #127

  ;Linha 22
  static TelaAvisoPontos + #880, #127
  static TelaAvisoPontos + #881, #127
  static TelaAvisoPontos + #882, #127
  static TelaAvisoPontos + #883, #127
  static TelaAvisoPontos + #884, #127
  static TelaAvisoPontos + #885, #127
  static TelaAvisoPontos + #886, #127
  static TelaAvisoPontos + #887, #127
  static TelaAvisoPontos + #888, #127
  static TelaAvisoPontos + #889, #127
  static TelaAvisoPontos + #890, #127
  static TelaAvisoPontos + #891, #127
  static TelaAvisoPontos + #892, #127
  static TelaAvisoPontos + #893, #127
  static TelaAvisoPontos + #894, #127
  static TelaAvisoPontos + #895, #127
  static TelaAvisoPontos + #896, #127
  static TelaAvisoPontos + #897, #127
  static TelaAvisoPontos + #898, #127
  static TelaAvisoPontos + #899, #127
  static TelaAvisoPontos + #900, #127
  static TelaAvisoPontos + #901, #127
  static TelaAvisoPontos + #902, #127
  static TelaAvisoPontos + #903, #127
  static TelaAvisoPontos + #904, #127
  static TelaAvisoPontos + #905, #127
  static TelaAvisoPontos + #906, #127
  static TelaAvisoPontos + #907, #127
  static TelaAvisoPontos + #908, #127
  static TelaAvisoPontos + #909, #127
  static TelaAvisoPontos + #910, #127
  static TelaAvisoPontos + #911, #127
  static TelaAvisoPontos + #912, #127
  static TelaAvisoPontos + #913, #127
  static TelaAvisoPontos + #914, #127
  static TelaAvisoPontos + #915, #127
  static TelaAvisoPontos + #916, #127
  static TelaAvisoPontos + #917, #127
  static TelaAvisoPontos + #918, #127
  static TelaAvisoPontos + #919, #127

  ;Linha 23
  static TelaAvisoPontos + #920, #127
  static TelaAvisoPontos + #921, #127
  static TelaAvisoPontos + #922, #127
  static TelaAvisoPontos + #923, #127
  static TelaAvisoPontos + #924, #127
  static TelaAvisoPontos + #925, #127
  static TelaAvisoPontos + #926, #127
  static TelaAvisoPontos + #927, #127
  static TelaAvisoPontos + #928, #127
  static TelaAvisoPontos + #929, #127
  static TelaAvisoPontos + #930, #127
  static TelaAvisoPontos + #931, #127
  static TelaAvisoPontos + #932, #127
  static TelaAvisoPontos + #933, #127
  static TelaAvisoPontos + #934, #127
  static TelaAvisoPontos + #935, #127
  static TelaAvisoPontos + #936, #127
  static TelaAvisoPontos + #937, #127
  static TelaAvisoPontos + #938, #127
  static TelaAvisoPontos + #939, #127
  static TelaAvisoPontos + #940, #127
  static TelaAvisoPontos + #941, #127
  static TelaAvisoPontos + #942, #127
  static TelaAvisoPontos + #943, #127
  static TelaAvisoPontos + #944, #127
  static TelaAvisoPontos + #945, #127
  static TelaAvisoPontos + #946, #127
  static TelaAvisoPontos + #947, #127
  static TelaAvisoPontos + #948, #127
  static TelaAvisoPontos + #949, #127
  static TelaAvisoPontos + #950, #127
  static TelaAvisoPontos + #951, #127
  static TelaAvisoPontos + #952, #127
  static TelaAvisoPontos + #953, #127
  static TelaAvisoPontos + #954, #127
  static TelaAvisoPontos + #955, #127
  static TelaAvisoPontos + #956, #127
  static TelaAvisoPontos + #957, #127
  static TelaAvisoPontos + #958, #127
  static TelaAvisoPontos + #959, #127

  ;Linha 24
  static TelaAvisoPontos + #960, #127
  static TelaAvisoPontos + #961, #127
  static TelaAvisoPontos + #962, #127
  static TelaAvisoPontos + #963, #127
  static TelaAvisoPontos + #964, #127
  static TelaAvisoPontos + #965, #127
  static TelaAvisoPontos + #966, #127
  static TelaAvisoPontos + #967, #127
  static TelaAvisoPontos + #968, #127
  static TelaAvisoPontos + #969, #127
  static TelaAvisoPontos + #970, #127
  static TelaAvisoPontos + #971, #127
  static TelaAvisoPontos + #972, #127
  static TelaAvisoPontos + #973, #127
  static TelaAvisoPontos + #974, #127
  static TelaAvisoPontos + #975, #127
  static TelaAvisoPontos + #976, #127
  static TelaAvisoPontos + #977, #127
  static TelaAvisoPontos + #978, #127
  static TelaAvisoPontos + #979, #127
  static TelaAvisoPontos + #980, #127
  static TelaAvisoPontos + #981, #127
  static TelaAvisoPontos + #982, #127
  static TelaAvisoPontos + #983, #127
  static TelaAvisoPontos + #984, #127
  static TelaAvisoPontos + #985, #127
  static TelaAvisoPontos + #986, #127
  static TelaAvisoPontos + #987, #127
  static TelaAvisoPontos + #988, #127
  static TelaAvisoPontos + #989, #127
  static TelaAvisoPontos + #990, #127
  static TelaAvisoPontos + #991, #127
  static TelaAvisoPontos + #992, #127
  static TelaAvisoPontos + #993, #127
  static TelaAvisoPontos + #994, #127
  static TelaAvisoPontos + #995, #127
  static TelaAvisoPontos + #996, #127
  static TelaAvisoPontos + #997, #127
  static TelaAvisoPontos + #998, #127
  static TelaAvisoPontos + #999, #127

  ;Linha 25
  static TelaAvisoPontos + #1000, #127
  static TelaAvisoPontos + #1001, #127
  static TelaAvisoPontos + #1002, #127
  static TelaAvisoPontos + #1003, #127
  static TelaAvisoPontos + #1004, #127
  static TelaAvisoPontos + #1005, #127
  static TelaAvisoPontos + #1006, #127
  static TelaAvisoPontos + #1007, #127
  static TelaAvisoPontos + #1008, #127
  static TelaAvisoPontos + #1009, #127
  static TelaAvisoPontos + #1010, #127
  static TelaAvisoPontos + #1011, #127
  static TelaAvisoPontos + #1012, #127
  static TelaAvisoPontos + #1013, #127
  static TelaAvisoPontos + #1014, #127
  static TelaAvisoPontos + #1015, #127
  static TelaAvisoPontos + #1016, #127
  static TelaAvisoPontos + #1017, #127
  static TelaAvisoPontos + #1018, #127
  static TelaAvisoPontos + #1019, #127
  static TelaAvisoPontos + #1020, #127
  static TelaAvisoPontos + #1021, #127
  static TelaAvisoPontos + #1022, #127
  static TelaAvisoPontos + #1023, #127
  static TelaAvisoPontos + #1024, #127
  static TelaAvisoPontos + #1025, #127
  static TelaAvisoPontos + #1026, #127
  static TelaAvisoPontos + #1027, #127
  static TelaAvisoPontos + #1028, #127
  static TelaAvisoPontos + #1029, #127
  static TelaAvisoPontos + #1030, #127
  static TelaAvisoPontos + #1031, #127
  static TelaAvisoPontos + #1032, #127
  static TelaAvisoPontos + #1033, #127
  static TelaAvisoPontos + #1034, #127
  static TelaAvisoPontos + #1035, #127
  static TelaAvisoPontos + #1036, #127
  static TelaAvisoPontos + #1037, #127
  static TelaAvisoPontos + #1038, #127
  static TelaAvisoPontos + #1039, #127

  ;Linha 26
  static TelaAvisoPontos + #1040, #127
  static TelaAvisoPontos + #1041, #127
  static TelaAvisoPontos + #1042, #127
  static TelaAvisoPontos + #1043, #127
  static TelaAvisoPontos + #1044, #127
  static TelaAvisoPontos + #1045, #127
  static TelaAvisoPontos + #1046, #127
  static TelaAvisoPontos + #1047, #127
  static TelaAvisoPontos + #1048, #127
  static TelaAvisoPontos + #1049, #127
  static TelaAvisoPontos + #1050, #127
  static TelaAvisoPontos + #1051, #127
  static TelaAvisoPontos + #1052, #127
  static TelaAvisoPontos + #1053, #127
  static TelaAvisoPontos + #1054, #127
  static TelaAvisoPontos + #1055, #127
  static TelaAvisoPontos + #1056, #127
  static TelaAvisoPontos + #1057, #127
  static TelaAvisoPontos + #1058, #127
  static TelaAvisoPontos + #1059, #127
  static TelaAvisoPontos + #1060, #127
  static TelaAvisoPontos + #1061, #127
  static TelaAvisoPontos + #1062, #127
  static TelaAvisoPontos + #1063, #127
  static TelaAvisoPontos + #1064, #127
  static TelaAvisoPontos + #1065, #127
  static TelaAvisoPontos + #1066, #127
  static TelaAvisoPontos + #1067, #127
  static TelaAvisoPontos + #1068, #127
  static TelaAvisoPontos + #1069, #127
  static TelaAvisoPontos + #1070, #127
  static TelaAvisoPontos + #1071, #127
  static TelaAvisoPontos + #1072, #127
  static TelaAvisoPontos + #1073, #127
  static TelaAvisoPontos + #1074, #127
  static TelaAvisoPontos + #1075, #127
  static TelaAvisoPontos + #1076, #127
  static TelaAvisoPontos + #1077, #127
  static TelaAvisoPontos + #1078, #127
  static TelaAvisoPontos + #1079, #127

  ;Linha 27
  static TelaAvisoPontos + #1080, #127
  static TelaAvisoPontos + #1081, #127
  static TelaAvisoPontos + #1082, #127
  static TelaAvisoPontos + #1083, #127
  static TelaAvisoPontos + #1084, #127
  static TelaAvisoPontos + #1085, #127
  static TelaAvisoPontos + #1086, #127
  static TelaAvisoPontos + #1087, #127
  static TelaAvisoPontos + #1088, #127
  static TelaAvisoPontos + #1089, #127
  static TelaAvisoPontos + #1090, #127
  static TelaAvisoPontos + #1091, #127
  static TelaAvisoPontos + #1092, #127
  static TelaAvisoPontos + #1093, #127
  static TelaAvisoPontos + #1094, #127
  static TelaAvisoPontos + #1095, #127
  static TelaAvisoPontos + #1096, #127
  static TelaAvisoPontos + #1097, #127
  static TelaAvisoPontos + #1098, #127
  static TelaAvisoPontos + #1099, #127
  static TelaAvisoPontos + #1100, #127
  static TelaAvisoPontos + #1101, #127
  static TelaAvisoPontos + #1102, #127
  static TelaAvisoPontos + #1103, #127
  static TelaAvisoPontos + #1104, #127
  static TelaAvisoPontos + #1105, #127
  static TelaAvisoPontos + #1106, #127
  static TelaAvisoPontos + #1107, #127
  static TelaAvisoPontos + #1108, #127
  static TelaAvisoPontos + #1109, #127
  static TelaAvisoPontos + #1110, #127
  static TelaAvisoPontos + #1111, #127
  static TelaAvisoPontos + #1112, #127
  static TelaAvisoPontos + #1113, #127
  static TelaAvisoPontos + #1114, #127
  static TelaAvisoPontos + #1115, #127
  static TelaAvisoPontos + #1116, #127
  static TelaAvisoPontos + #1117, #127
  static TelaAvisoPontos + #1118, #127
  static TelaAvisoPontos + #1119, #127

  ;Linha 28
  static TelaAvisoPontos + #1120, #127
  static TelaAvisoPontos + #1121, #127
  static TelaAvisoPontos + #1122, #127
  static TelaAvisoPontos + #1123, #3664
  static TelaAvisoPontos + #1124, #3698
  static TelaAvisoPontos + #1125, #3685
  static TelaAvisoPontos + #1126, #3699
  static TelaAvisoPontos + #1127, #3699
  static TelaAvisoPontos + #1128, #3689
  static TelaAvisoPontos + #1129, #3695
  static TelaAvisoPontos + #1130, #3694
  static TelaAvisoPontos + #1131, #3685
  static TelaAvisoPontos + #1132, #127
  static TelaAvisoPontos + #1133, #3646
  static TelaAvisoPontos + #1134, #127
  static TelaAvisoPontos + #1135, #3653
  static TelaAvisoPontos + #1136, #3699
  static TelaAvisoPontos + #1137, #3696
  static TelaAvisoPontos + #1138, #3681
  static TelaAvisoPontos + #1139, #3683
  static TelaAvisoPontos + #1140, #3695
  static TelaAvisoPontos + #1141, #127
  static TelaAvisoPontos + #1142, #3644
  static TelaAvisoPontos + #1143, #127
  static TelaAvisoPontos + #1144, #3696
  static TelaAvisoPontos + #1145, #3681
  static TelaAvisoPontos + #1146, #3698
  static TelaAvisoPontos + #1147, #3681
  static TelaAvisoPontos + #1148, #127
  static TelaAvisoPontos + #1149, #3684
  static TelaAvisoPontos + #1150, #3681
  static TelaAvisoPontos + #1151, #3698
  static TelaAvisoPontos + #1152, #3937
  static TelaAvisoPontos + #1153, #3699
  static TelaAvisoPontos + #1154, #3700
  static TelaAvisoPontos + #1155, #3681
  static TelaAvisoPontos + #1156, #3698
  static TelaAvisoPontos + #1157, #3700
  static TelaAvisoPontos + #1158, #127
  static TelaAvisoPontos + #1159, #127

  ;Linha 29
  static TelaAvisoPontos + #1160, #127
  static TelaAvisoPontos + #1161, #127
  static TelaAvisoPontos + #1162, #127
  static TelaAvisoPontos + #1163, #127
  static TelaAvisoPontos + #1164, #127
  static TelaAvisoPontos + #1165, #127
  static TelaAvisoPontos + #1166, #127
  static TelaAvisoPontos + #1167, #127
  static TelaAvisoPontos + #1168, #127
  static TelaAvisoPontos + #1169, #127
  static TelaAvisoPontos + #1170, #127
  static TelaAvisoPontos + #1171, #127
  static TelaAvisoPontos + #1172, #127
  static TelaAvisoPontos + #1173, #127
  static TelaAvisoPontos + #1174, #127
  static TelaAvisoPontos + #1175, #127
  static TelaAvisoPontos + #1176, #127
  static TelaAvisoPontos + #1177, #127
  static TelaAvisoPontos + #1178, #127
  static TelaAvisoPontos + #1179, #127
  static TelaAvisoPontos + #1180, #127
  static TelaAvisoPontos + #1181, #127
  static TelaAvisoPontos + #1182, #127
  static TelaAvisoPontos + #1183, #127
  static TelaAvisoPontos + #1184, #127
  static TelaAvisoPontos + #1185, #127
  static TelaAvisoPontos + #1186, #127
  static TelaAvisoPontos + #1187, #127
  static TelaAvisoPontos + #1188, #127
  static TelaAvisoPontos + #1189, #127
  static TelaAvisoPontos + #1190, #3937
  static TelaAvisoPontos + #1191, #127
  static TelaAvisoPontos + #1192, #127
  static TelaAvisoPontos + #1193, #127
  static TelaAvisoPontos + #1194, #127
  static TelaAvisoPontos + #1195, #127
  static TelaAvisoPontos + #1196, #127
  static TelaAvisoPontos + #1197, #127
  static TelaAvisoPontos + #1198, #127
  static TelaAvisoPontos + #1199, #127

printTelaAvisoPontosScreen:
  push R0
  push R1
  push R2
  push R3

  loadn R0, #TelaAvisoPontos
  loadn R1, #0
  loadn R2, #1200

  printTelaAvisoPontosScreenLoop:

    add R3,R0,R1
    loadi R3, R3
    outchar R3, R1
    inc R1
    cmp R1, R2

    jne printTelaAvisoPontosScreenLoop

  pop R3
  pop R2
  pop R1
  pop R0
  rts
  
  ;-------------------------------------------------------TELA PRA FASE 2-------------------------------------------------------------------
  
  TelaPraFase2 : var #1200
  ;Linha 0
  static TelaPraFase2 + #0, #127
  static TelaPraFase2 + #1, #127
  static TelaPraFase2 + #2, #127
  static TelaPraFase2 + #3, #127
  static TelaPraFase2 + #4, #127
  static TelaPraFase2 + #5, #127
  static TelaPraFase2 + #6, #127
  static TelaPraFase2 + #7, #127
  static TelaPraFase2 + #8, #127
  static TelaPraFase2 + #9, #3875
  static TelaPraFase2 + #10, #3875
  static TelaPraFase2 + #11, #3875
  static TelaPraFase2 + #12, #3875
  static TelaPraFase2 + #13, #127
  static TelaPraFase2 + #14, #127
  static TelaPraFase2 + #15, #3875
  static TelaPraFase2 + #16, #3875
  static TelaPraFase2 + #17, #127
  static TelaPraFase2 + #18, #3875
  static TelaPraFase2 + #19, #3875
  static TelaPraFase2 + #20, #3875
  static TelaPraFase2 + #21, #3875
  static TelaPraFase2 + #22, #3875
  static TelaPraFase2 + #23, #3875
  static TelaPraFase2 + #24, #127
  static TelaPraFase2 + #25, #127
  static TelaPraFase2 + #26, #127
  static TelaPraFase2 + #27, #127
  static TelaPraFase2 + #28, #127
  static TelaPraFase2 + #29, #127
  static TelaPraFase2 + #30, #127
  static TelaPraFase2 + #31, #127
  static TelaPraFase2 + #32, #127
  static TelaPraFase2 + #33, #127
  static TelaPraFase2 + #34, #127
  static TelaPraFase2 + #35, #127
  static TelaPraFase2 + #36, #127
  static TelaPraFase2 + #37, #127
  static TelaPraFase2 + #38, #127
  static TelaPraFase2 + #39, #127

  ;Linha 1
  static TelaPraFase2 + #40, #127
  static TelaPraFase2 + #41, #127
  static TelaPraFase2 + #42, #127
  static TelaPraFase2 + #43, #127
  static TelaPraFase2 + #44, #127
  static TelaPraFase2 + #45, #127
  static TelaPraFase2 + #46, #127
  static TelaPraFase2 + #47, #127
  static TelaPraFase2 + #48, #3875
  static TelaPraFase2 + #49, #3875
  static TelaPraFase2 + #50, #127
  static TelaPraFase2 + #51, #127
  static TelaPraFase2 + #52, #3875
  static TelaPraFase2 + #53, #127
  static TelaPraFase2 + #54, #127
  static TelaPraFase2 + #55, #3875
  static TelaPraFase2 + #56, #3875
  static TelaPraFase2 + #57, #3875
  static TelaPraFase2 + #58, #3875
  static TelaPraFase2 + #59, #3875
  static TelaPraFase2 + #60, #3875
  static TelaPraFase2 + #61, #3875
  static TelaPraFase2 + #62, #127
  static TelaPraFase2 + #63, #3875
  static TelaPraFase2 + #64, #3875
  static TelaPraFase2 + #65, #127
  static TelaPraFase2 + #66, #127
  static TelaPraFase2 + #67, #127
  static TelaPraFase2 + #68, #127
  static TelaPraFase2 + #69, #127
  static TelaPraFase2 + #70, #127
  static TelaPraFase2 + #71, #127
  static TelaPraFase2 + #72, #2851
  static TelaPraFase2 + #73, #2883
  static TelaPraFase2 + #74, #2881
  static TelaPraFase2 + #75, #2881
  static TelaPraFase2 + #76, #2899
  static TelaPraFase2 + #77, #2895
  static TelaPraFase2 + #78, #127
  static TelaPraFase2 + #79, #127

  ;Linha 2
  static TelaPraFase2 + #80, #127
  static TelaPraFase2 + #81, #127
  static TelaPraFase2 + #82, #127
  static TelaPraFase2 + #83, #127
  static TelaPraFase2 + #84, #127
  static TelaPraFase2 + #85, #127
  static TelaPraFase2 + #86, #127
  static TelaPraFase2 + #87, #127
  static TelaPraFase2 + #88, #127
  static TelaPraFase2 + #89, #127
  static TelaPraFase2 + #90, #127
  static TelaPraFase2 + #91, #127
  static TelaPraFase2 + #92, #3875
  static TelaPraFase2 + #93, #127
  static TelaPraFase2 + #94, #3875
  static TelaPraFase2 + #95, #3875
  static TelaPraFase2 + #96, #3875
  static TelaPraFase2 + #97, #127
  static TelaPraFase2 + #98, #3615
  static TelaPraFase2 + #99, #3615
  static TelaPraFase2 + #100, #127
  static TelaPraFase2 + #101, #127
  static TelaPraFase2 + #102, #3875
  static TelaPraFase2 + #103, #3875
  static TelaPraFase2 + #104, #3875
  static TelaPraFase2 + #105, #3875
  static TelaPraFase2 + #106, #127
  static TelaPraFase2 + #107, #127
  static TelaPraFase2 + #108, #127
  static TelaPraFase2 + #109, #127
  static TelaPraFase2 + #110, #127
  static TelaPraFase2 + #111, #127
  static TelaPraFase2 + #112, #127
  static TelaPraFase2 + #113, #127
  static TelaPraFase2 + #114, #3919
  static TelaPraFase2 + #115, #2888
  static TelaPraFase2 + #116, #2885
  static TelaPraFase2 + #117, #2898
  static TelaPraFase2 + #118, #2895
  static TelaPraFase2 + #119, #127

  ;Linha 3
  static TelaPraFase2 + #120, #127
  static TelaPraFase2 + #121, #127
  static TelaPraFase2 + #122, #127
  static TelaPraFase2 + #123, #127
  static TelaPraFase2 + #124, #127
  static TelaPraFase2 + #125, #127
  static TelaPraFase2 + #126, #127
  static TelaPraFase2 + #127, #127
  static TelaPraFase2 + #128, #127
  static TelaPraFase2 + #129, #127
  static TelaPraFase2 + #130, #127
  static TelaPraFase2 + #131, #127
  static TelaPraFase2 + #132, #3875
  static TelaPraFase2 + #133, #127
  static TelaPraFase2 + #134, #3875
  static TelaPraFase2 + #135, #3875
  static TelaPraFase2 + #136, #127
  static TelaPraFase2 + #137, #127
  static TelaPraFase2 + #138, #3615
  static TelaPraFase2 + #139, #3615
  static TelaPraFase2 + #140, #127
  static TelaPraFase2 + #141, #127
  static TelaPraFase2 + #142, #127
  static TelaPraFase2 + #143, #3875
  static TelaPraFase2 + #144, #3875
  static TelaPraFase2 + #145, #3875
  static TelaPraFase2 + #146, #127
  static TelaPraFase2 + #147, #127
  static TelaPraFase2 + #148, #127
  static TelaPraFase2 + #149, #127
  static TelaPraFase2 + #150, #127
  static TelaPraFase2 + #151, #127
  static TelaPraFase2 + #152, #127
  static TelaPraFase2 + #153, #127
  static TelaPraFase2 + #154, #127
  static TelaPraFase2 + #155, #127
  static TelaPraFase2 + #156, #127
  static TelaPraFase2 + #157, #3875
  static TelaPraFase2 + #158, #127
  static TelaPraFase2 + #159, #127

  ;Linha 4
  static TelaPraFase2 + #160, #127
  static TelaPraFase2 + #161, #127
  static TelaPraFase2 + #162, #127
  static TelaPraFase2 + #163, #127
  static TelaPraFase2 + #164, #127
  static TelaPraFase2 + #165, #127
  static TelaPraFase2 + #166, #127
  static TelaPraFase2 + #167, #127
  static TelaPraFase2 + #168, #127
  static TelaPraFase2 + #169, #127
  static TelaPraFase2 + #170, #127
  static TelaPraFase2 + #171, #3875
  static TelaPraFase2 + #172, #3875
  static TelaPraFase2 + #173, #127
  static TelaPraFase2 + #174, #3875
  static TelaPraFase2 + #175, #3875
  static TelaPraFase2 + #176, #127
  static TelaPraFase2 + #177, #127
  static TelaPraFase2 + #178, #127
  static TelaPraFase2 + #179, #3615
  static TelaPraFase2 + #180, #127
  static TelaPraFase2 + #181, #127
  static TelaPraFase2 + #182, #127
  static TelaPraFase2 + #183, #3875
  static TelaPraFase2 + #184, #3875
  static TelaPraFase2 + #185, #3875
  static TelaPraFase2 + #186, #127
  static TelaPraFase2 + #187, #127
  static TelaPraFase2 + #188, #127
  static TelaPraFase2 + #189, #127
  static TelaPraFase2 + #190, #127
  static TelaPraFase2 + #191, #127
  static TelaPraFase2 + #192, #127
  static TelaPraFase2 + #193, #127
  static TelaPraFase2 + #194, #127
  static TelaPraFase2 + #195, #127
  static TelaPraFase2 + #196, #127
  static TelaPraFase2 + #197, #127
  static TelaPraFase2 + #198, #127
  static TelaPraFase2 + #199, #127

  ;Linha 5
  static TelaPraFase2 + #200, #127
  static TelaPraFase2 + #201, #127
  static TelaPraFase2 + #202, #127
  static TelaPraFase2 + #203, #127
  static TelaPraFase2 + #204, #127
  static TelaPraFase2 + #205, #127
  static TelaPraFase2 + #206, #127
  static TelaPraFase2 + #207, #127
  static TelaPraFase2 + #208, #127
  static TelaPraFase2 + #209, #3875
  static TelaPraFase2 + #210, #3875
  static TelaPraFase2 + #211, #3875
  static TelaPraFase2 + #212, #127
  static TelaPraFase2 + #213, #127
  static TelaPraFase2 + #214, #3875
  static TelaPraFase2 + #215, #127
  static TelaPraFase2 + #216, #127
  static TelaPraFase2 + #217, #127
  static TelaPraFase2 + #218, #127
  static TelaPraFase2 + #219, #3615
  static TelaPraFase2 + #220, #127
  static TelaPraFase2 + #221, #127
  static TelaPraFase2 + #222, #127
  static TelaPraFase2 + #223, #3875
  static TelaPraFase2 + #224, #3875
  static TelaPraFase2 + #225, #3875
  static TelaPraFase2 + #226, #127
  static TelaPraFase2 + #227, #127
  static TelaPraFase2 + #228, #127
  static TelaPraFase2 + #229, #127
  static TelaPraFase2 + #230, #3875
  static TelaPraFase2 + #231, #3875
  static TelaPraFase2 + #232, #3875
  static TelaPraFase2 + #233, #3875
  static TelaPraFase2 + #234, #3875
  static TelaPraFase2 + #235, #127
  static TelaPraFase2 + #236, #127
  static TelaPraFase2 + #237, #127
  static TelaPraFase2 + #238, #127
  static TelaPraFase2 + #239, #127

  ;Linha 6
  static TelaPraFase2 + #240, #127
  static TelaPraFase2 + #241, #127
  static TelaPraFase2 + #242, #127
  static TelaPraFase2 + #243, #127
  static TelaPraFase2 + #244, #127
  static TelaPraFase2 + #245, #3875
  static TelaPraFase2 + #246, #3875
  static TelaPraFase2 + #247, #3875
  static TelaPraFase2 + #248, #3875
  static TelaPraFase2 + #249, #3875
  static TelaPraFase2 + #250, #3875
  static TelaPraFase2 + #251, #3875
  static TelaPraFase2 + #252, #3875
  static TelaPraFase2 + #253, #3875
  static TelaPraFase2 + #254, #3875
  static TelaPraFase2 + #255, #3875
  static TelaPraFase2 + #256, #3875
  static TelaPraFase2 + #257, #3875
  static TelaPraFase2 + #258, #3875
  static TelaPraFase2 + #259, #127
  static TelaPraFase2 + #260, #3875
  static TelaPraFase2 + #261, #3875
  static TelaPraFase2 + #262, #3875
  static TelaPraFase2 + #263, #3875
  static TelaPraFase2 + #264, #3875
  static TelaPraFase2 + #265, #3875
  static TelaPraFase2 + #266, #127
  static TelaPraFase2 + #267, #127
  static TelaPraFase2 + #268, #3875
  static TelaPraFase2 + #269, #3875
  static TelaPraFase2 + #270, #3875
  static TelaPraFase2 + #271, #127
  static TelaPraFase2 + #272, #127
  static TelaPraFase2 + #273, #127
  static TelaPraFase2 + #274, #127
  static TelaPraFase2 + #275, #127
  static TelaPraFase2 + #276, #127
  static TelaPraFase2 + #277, #127
  static TelaPraFase2 + #278, #127
  static TelaPraFase2 + #279, #3875

  ;Linha 7
  static TelaPraFase2 + #280, #127
  static TelaPraFase2 + #281, #127
  static TelaPraFase2 + #282, #127
  static TelaPraFase2 + #283, #127
  static TelaPraFase2 + #284, #127
  static TelaPraFase2 + #285, #127
  static TelaPraFase2 + #286, #127
  static TelaPraFase2 + #287, #127
  static TelaPraFase2 + #288, #127
  static TelaPraFase2 + #289, #127
  static TelaPraFase2 + #290, #127
  static TelaPraFase2 + #291, #127
  static TelaPraFase2 + #292, #127
  static TelaPraFase2 + #293, #127
  static TelaPraFase2 + #294, #3875
  static TelaPraFase2 + #295, #3875
  static TelaPraFase2 + #296, #127
  static TelaPraFase2 + #297, #127
  static TelaPraFase2 + #298, #127
  static TelaPraFase2 + #299, #3875
  static TelaPraFase2 + #300, #3875
  static TelaPraFase2 + #301, #3875
  static TelaPraFase2 + #302, #3875
  static TelaPraFase2 + #303, #127
  static TelaPraFase2 + #304, #127
  static TelaPraFase2 + #305, #127
  static TelaPraFase2 + #306, #3875
  static TelaPraFase2 + #307, #3875
  static TelaPraFase2 + #308, #3875
  static TelaPraFase2 + #309, #127
  static TelaPraFase2 + #310, #127
  static TelaPraFase2 + #311, #127
  static TelaPraFase2 + #312, #127
  static TelaPraFase2 + #313, #127
  static TelaPraFase2 + #314, #127
  static TelaPraFase2 + #315, #127
  static TelaPraFase2 + #316, #127
  static TelaPraFase2 + #317, #127
  static TelaPraFase2 + #318, #127
  static TelaPraFase2 + #319, #3875

  ;Linha 8
  static TelaPraFase2 + #320, #127
  static TelaPraFase2 + #321, #127
  static TelaPraFase2 + #322, #127
  static TelaPraFase2 + #323, #127
  static TelaPraFase2 + #324, #127
  static TelaPraFase2 + #325, #127
  static TelaPraFase2 + #326, #127
  static TelaPraFase2 + #327, #2339
  static TelaPraFase2 + #328, #2339
  static TelaPraFase2 + #329, #2339
  static TelaPraFase2 + #330, #127
  static TelaPraFase2 + #331, #127
  static TelaPraFase2 + #332, #2339
  static TelaPraFase2 + #333, #2339
  static TelaPraFase2 + #334, #127
  static TelaPraFase2 + #335, #127
  static TelaPraFase2 + #336, #3875
  static TelaPraFase2 + #337, #2339
  static TelaPraFase2 + #338, #2339
  static TelaPraFase2 + #339, #2339
  static TelaPraFase2 + #340, #3875
  static TelaPraFase2 + #341, #2339
  static TelaPraFase2 + #342, #2339
  static TelaPraFase2 + #343, #2339
  static TelaPraFase2 + #344, #3875
  static TelaPraFase2 + #345, #3875
  static TelaPraFase2 + #346, #3875
  static TelaPraFase2 + #347, #2339
  static TelaPraFase2 + #348, #2339
  static TelaPraFase2 + #349, #2339
  static TelaPraFase2 + #350, #127
  static TelaPraFase2 + #351, #127
  static TelaPraFase2 + #352, #127
  static TelaPraFase2 + #353, #127
  static TelaPraFase2 + #354, #127
  static TelaPraFase2 + #355, #127
  static TelaPraFase2 + #356, #3875
  static TelaPraFase2 + #357, #127
  static TelaPraFase2 + #358, #3875
  static TelaPraFase2 + #359, #127

  ;Linha 9
  static TelaPraFase2 + #360, #127
  static TelaPraFase2 + #361, #127
  static TelaPraFase2 + #362, #127
  static TelaPraFase2 + #363, #127
  static TelaPraFase2 + #364, #127
  static TelaPraFase2 + #365, #127
  static TelaPraFase2 + #366, #127
  static TelaPraFase2 + #367, #2339
  static TelaPraFase2 + #368, #3615
  static TelaPraFase2 + #369, #3615
  static TelaPraFase2 + #370, #3615
  static TelaPraFase2 + #371, #2339
  static TelaPraFase2 + #372, #127
  static TelaPraFase2 + #373, #3615
  static TelaPraFase2 + #374, #2339
  static TelaPraFase2 + #375, #3615
  static TelaPraFase2 + #376, #2339
  static TelaPraFase2 + #377, #3875
  static TelaPraFase2 + #378, #127
  static TelaPraFase2 + #379, #3615
  static TelaPraFase2 + #380, #127
  static TelaPraFase2 + #381, #2339
  static TelaPraFase2 + #382, #127
  static TelaPraFase2 + #383, #3875
  static TelaPraFase2 + #384, #3875
  static TelaPraFase2 + #385, #127
  static TelaPraFase2 + #386, #3875
  static TelaPraFase2 + #387, #3875
  static TelaPraFase2 + #388, #3875
  static TelaPraFase2 + #389, #3875
  static TelaPraFase2 + #390, #2339
  static TelaPraFase2 + #391, #127
  static TelaPraFase2 + #392, #127
  static TelaPraFase2 + #393, #3875
  static TelaPraFase2 + #394, #127
  static TelaPraFase2 + #395, #127
  static TelaPraFase2 + #396, #127
  static TelaPraFase2 + #397, #127
  static TelaPraFase2 + #398, #3875
  static TelaPraFase2 + #399, #127

  ;Linha 10
  static TelaPraFase2 + #400, #127
  static TelaPraFase2 + #401, #127
  static TelaPraFase2 + #402, #127
  static TelaPraFase2 + #403, #127
  static TelaPraFase2 + #404, #127
  static TelaPraFase2 + #405, #127
  static TelaPraFase2 + #406, #3615
  static TelaPraFase2 + #407, #2339
  static TelaPraFase2 + #408, #2339
  static TelaPraFase2 + #409, #2339
  static TelaPraFase2 + #410, #3615
  static TelaPraFase2 + #411, #2339
  static TelaPraFase2 + #412, #3615
  static TelaPraFase2 + #413, #3875
  static TelaPraFase2 + #414, #2339
  static TelaPraFase2 + #415, #3615
  static TelaPraFase2 + #416, #2339
  static TelaPraFase2 + #417, #3875
  static TelaPraFase2 + #418, #3875
  static TelaPraFase2 + #419, #3875
  static TelaPraFase2 + #420, #3615
  static TelaPraFase2 + #421, #2339
  static TelaPraFase2 + #422, #2339
  static TelaPraFase2 + #423, #2339
  static TelaPraFase2 + #424, #3615
  static TelaPraFase2 + #425, #3615
  static TelaPraFase2 + #426, #127
  static TelaPraFase2 + #427, #127
  static TelaPraFase2 + #428, #3875
  static TelaPraFase2 + #429, #3875
  static TelaPraFase2 + #430, #2339
  static TelaPraFase2 + #431, #127
  static TelaPraFase2 + #432, #127
  static TelaPraFase2 + #433, #127
  static TelaPraFase2 + #434, #127
  static TelaPraFase2 + #435, #127
  static TelaPraFase2 + #436, #127
  static TelaPraFase2 + #437, #127
  static TelaPraFase2 + #438, #127
  static TelaPraFase2 + #439, #127

  ;Linha 11
  static TelaPraFase2 + #440, #127
  static TelaPraFase2 + #441, #127
  static TelaPraFase2 + #442, #127
  static TelaPraFase2 + #443, #127
  static TelaPraFase2 + #444, #127
  static TelaPraFase2 + #445, #127
  static TelaPraFase2 + #446, #127
  static TelaPraFase2 + #447, #2339
  static TelaPraFase2 + #448, #127
  static TelaPraFase2 + #449, #3615
  static TelaPraFase2 + #450, #3615
  static TelaPraFase2 + #451, #2339
  static TelaPraFase2 + #452, #2339
  static TelaPraFase2 + #453, #2339
  static TelaPraFase2 + #454, #2339
  static TelaPraFase2 + #455, #3615
  static TelaPraFase2 + #456, #3875
  static TelaPraFase2 + #457, #2339
  static TelaPraFase2 + #458, #2339
  static TelaPraFase2 + #459, #3875
  static TelaPraFase2 + #460, #3615
  static TelaPraFase2 + #461, #2339
  static TelaPraFase2 + #462, #3615
  static TelaPraFase2 + #463, #3615
  static TelaPraFase2 + #464, #127
  static TelaPraFase2 + #465, #3615
  static TelaPraFase2 + #466, #127
  static TelaPraFase2 + #467, #127
  static TelaPraFase2 + #468, #3875
  static TelaPraFase2 + #469, #2339
  static TelaPraFase2 + #470, #3875
  static TelaPraFase2 + #471, #127
  static TelaPraFase2 + #472, #127
  static TelaPraFase2 + #473, #127
  static TelaPraFase2 + #474, #127
  static TelaPraFase2 + #475, #127
  static TelaPraFase2 + #476, #127
  static TelaPraFase2 + #477, #3875
  static TelaPraFase2 + #478, #127
  static TelaPraFase2 + #479, #127

  ;Linha 12
  static TelaPraFase2 + #480, #127
  static TelaPraFase2 + #481, #127
  static TelaPraFase2 + #482, #127
  static TelaPraFase2 + #483, #127
  static TelaPraFase2 + #484, #127
  static TelaPraFase2 + #485, #127
  static TelaPraFase2 + #486, #127
  static TelaPraFase2 + #487, #2339
  static TelaPraFase2 + #488, #127
  static TelaPraFase2 + #489, #127
  static TelaPraFase2 + #490, #127
  static TelaPraFase2 + #491, #2339
  static TelaPraFase2 + #492, #127
  static TelaPraFase2 + #493, #3950
  static TelaPraFase2 + #494, #2339
  static TelaPraFase2 + #495, #3875
  static TelaPraFase2 + #496, #127
  static TelaPraFase2 + #497, #127
  static TelaPraFase2 + #498, #127
  static TelaPraFase2 + #499, #2339
  static TelaPraFase2 + #500, #127
  static TelaPraFase2 + #501, #2339
  static TelaPraFase2 + #502, #127
  static TelaPraFase2 + #503, #127
  static TelaPraFase2 + #504, #127
  static TelaPraFase2 + #505, #3875
  static TelaPraFase2 + #506, #3875
  static TelaPraFase2 + #507, #3875
  static TelaPraFase2 + #508, #2339
  static TelaPraFase2 + #509, #127
  static TelaPraFase2 + #510, #127
  static TelaPraFase2 + #511, #127
  static TelaPraFase2 + #512, #127
  static TelaPraFase2 + #513, #127
  static TelaPraFase2 + #514, #127
  static TelaPraFase2 + #515, #127
  static TelaPraFase2 + #516, #127
  static TelaPraFase2 + #517, #127
  static TelaPraFase2 + #518, #127
  static TelaPraFase2 + #519, #127

  ;Linha 13
  static TelaPraFase2 + #520, #127
  static TelaPraFase2 + #521, #127
  static TelaPraFase2 + #522, #127
  static TelaPraFase2 + #523, #127
  static TelaPraFase2 + #524, #127
  static TelaPraFase2 + #525, #127
  static TelaPraFase2 + #526, #127
  static TelaPraFase2 + #527, #2339
  static TelaPraFase2 + #528, #127
  static TelaPraFase2 + #529, #127
  static TelaPraFase2 + #530, #127
  static TelaPraFase2 + #531, #2339
  static TelaPraFase2 + #532, #3875
  static TelaPraFase2 + #533, #3875
  static TelaPraFase2 + #534, #2339
  static TelaPraFase2 + #535, #3875
  static TelaPraFase2 + #536, #2339
  static TelaPraFase2 + #537, #2339
  static TelaPraFase2 + #538, #2339
  static TelaPraFase2 + #539, #3875
  static TelaPraFase2 + #540, #3875
  static TelaPraFase2 + #541, #2339
  static TelaPraFase2 + #542, #2339
  static TelaPraFase2 + #543, #2339
  static TelaPraFase2 + #544, #3875
  static TelaPraFase2 + #545, #3875
  static TelaPraFase2 + #546, #3875
  static TelaPraFase2 + #547, #2339
  static TelaPraFase2 + #548, #2339
  static TelaPraFase2 + #549, #2339
  static TelaPraFase2 + #550, #2339
  static TelaPraFase2 + #551, #3875
  static TelaPraFase2 + #552, #127
  static TelaPraFase2 + #553, #127
  static TelaPraFase2 + #554, #127
  static TelaPraFase2 + #555, #3875
  static TelaPraFase2 + #556, #127
  static TelaPraFase2 + #557, #127
  static TelaPraFase2 + #558, #127
  static TelaPraFase2 + #559, #127

  ;Linha 14
  static TelaPraFase2 + #560, #127
  static TelaPraFase2 + #561, #127
  static TelaPraFase2 + #562, #127
  static TelaPraFase2 + #563, #127
  static TelaPraFase2 + #564, #127
  static TelaPraFase2 + #565, #127
  static TelaPraFase2 + #566, #127
  static TelaPraFase2 + #567, #127
  static TelaPraFase2 + #568, #127
  static TelaPraFase2 + #569, #127
  static TelaPraFase2 + #570, #127
  static TelaPraFase2 + #571, #3951
  static TelaPraFase2 + #572, #3951
  static TelaPraFase2 + #573, #3875
  static TelaPraFase2 + #574, #3875
  static TelaPraFase2 + #575, #3875
  static TelaPraFase2 + #576, #3875
  static TelaPraFase2 + #577, #3875
  static TelaPraFase2 + #578, #3875
  static TelaPraFase2 + #579, #3875
  static TelaPraFase2 + #580, #3875
  static TelaPraFase2 + #581, #3875
  static TelaPraFase2 + #582, #3875
  static TelaPraFase2 + #583, #3875
  static TelaPraFase2 + #584, #3875
  static TelaPraFase2 + #585, #3875
  static TelaPraFase2 + #586, #127
  static TelaPraFase2 + #587, #127
  static TelaPraFase2 + #588, #127
  static TelaPraFase2 + #589, #127
  static TelaPraFase2 + #590, #127
  static TelaPraFase2 + #591, #127
  static TelaPraFase2 + #592, #127
  static TelaPraFase2 + #593, #127
  static TelaPraFase2 + #594, #3875
  static TelaPraFase2 + #595, #127
  static TelaPraFase2 + #596, #127
  static TelaPraFase2 + #597, #127
  static TelaPraFase2 + #598, #127
  static TelaPraFase2 + #599, #127

  ;Linha 15
  static TelaPraFase2 + #600, #127
  static TelaPraFase2 + #601, #127
  static TelaPraFase2 + #602, #127
  static TelaPraFase2 + #603, #127
  static TelaPraFase2 + #604, #127
  static TelaPraFase2 + #605, #127
  static TelaPraFase2 + #606, #127
  static TelaPraFase2 + #607, #127
  static TelaPraFase2 + #608, #127
  static TelaPraFase2 + #609, #127
  static TelaPraFase2 + #610, #127
  static TelaPraFase2 + #611, #127
  static TelaPraFase2 + #612, #127
  static TelaPraFase2 + #613, #127
  static TelaPraFase2 + #614, #127
  static TelaPraFase2 + #615, #127
  static TelaPraFase2 + #616, #127
  static TelaPraFase2 + #617, #127
  static TelaPraFase2 + #618, #3615
  static TelaPraFase2 + #619, #127
  static TelaPraFase2 + #620, #127
  static TelaPraFase2 + #621, #127
  static TelaPraFase2 + #622, #127
  static TelaPraFase2 + #623, #127
  static TelaPraFase2 + #624, #127
  static TelaPraFase2 + #625, #127
  static TelaPraFase2 + #626, #3875
  static TelaPraFase2 + #627, #127
  static TelaPraFase2 + #628, #127
  static TelaPraFase2 + #629, #127
  static TelaPraFase2 + #630, #3875
  static TelaPraFase2 + #631, #127
  static TelaPraFase2 + #632, #127
  static TelaPraFase2 + #633, #3875
  static TelaPraFase2 + #634, #3875
  static TelaPraFase2 + #635, #127
  static TelaPraFase2 + #636, #127
  static TelaPraFase2 + #637, #127
  static TelaPraFase2 + #638, #127
  static TelaPraFase2 + #639, #127

  ;Linha 16
  static TelaPraFase2 + #640, #127
  static TelaPraFase2 + #641, #127
  static TelaPraFase2 + #642, #127
  static TelaPraFase2 + #643, #127
  static TelaPraFase2 + #644, #127
  static TelaPraFase2 + #645, #127
  static TelaPraFase2 + #646, #127
  static TelaPraFase2 + #647, #127
  static TelaPraFase2 + #648, #127
  static TelaPraFase2 + #649, #127
  static TelaPraFase2 + #650, #127
  static TelaPraFase2 + #651, #127
  static TelaPraFase2 + #652, #127
  static TelaPraFase2 + #653, #127
  static TelaPraFase2 + #654, #127
  static TelaPraFase2 + #655, #127
  static TelaPraFase2 + #656, #127
  static TelaPraFase2 + #657, #127
  static TelaPraFase2 + #658, #127
  static TelaPraFase2 + #659, #127
  static TelaPraFase2 + #660, #127
  static TelaPraFase2 + #661, #127
  static TelaPraFase2 + #662, #127
  static TelaPraFase2 + #663, #127
  static TelaPraFase2 + #664, #127
  static TelaPraFase2 + #665, #127
  static TelaPraFase2 + #666, #127
  static TelaPraFase2 + #667, #127
  static TelaPraFase2 + #668, #127
  static TelaPraFase2 + #669, #127
  static TelaPraFase2 + #670, #127
  static TelaPraFase2 + #671, #3875
  static TelaPraFase2 + #672, #127
  static TelaPraFase2 + #673, #3875
  static TelaPraFase2 + #674, #3875
  static TelaPraFase2 + #675, #127
  static TelaPraFase2 + #676, #127
  static TelaPraFase2 + #677, #127
  static TelaPraFase2 + #678, #127
  static TelaPraFase2 + #679, #127

  ;Linha 17
  static TelaPraFase2 + #680, #127
  static TelaPraFase2 + #681, #127
  static TelaPraFase2 + #682, #127
  static TelaPraFase2 + #683, #127
  static TelaPraFase2 + #684, #127
  static TelaPraFase2 + #685, #127
  static TelaPraFase2 + #686, #127
  static TelaPraFase2 + #687, #127
  static TelaPraFase2 + #688, #127
  static TelaPraFase2 + #689, #127
  static TelaPraFase2 + #690, #127
  static TelaPraFase2 + #691, #3661
  static TelaPraFase2 + #692, #3689
  static TelaPraFase2 + #693, #3694
  static TelaPraFase2 + #694, #3689
  static TelaPraFase2 + #695, #3693
  static TelaPraFase2 + #696, #3695
  static TelaPraFase2 + #697, #127
  static TelaPraFase2 + #698, #3633
  static TelaPraFase2 + #699, #3632
  static TelaPraFase2 + #700, #127
  static TelaPraFase2 + #701, #3696
  static TelaPraFase2 + #702, #3695
  static TelaPraFase2 + #703, #3694
  static TelaPraFase2 + #704, #3700
  static TelaPraFase2 + #705, #3695
  static TelaPraFase2 + #706, #3699
  static TelaPraFase2 + #707, #3875
  static TelaPraFase2 + #708, #127
  static TelaPraFase2 + #709, #127
  static TelaPraFase2 + #710, #127
  static TelaPraFase2 + #711, #127
  static TelaPraFase2 + #712, #127
  static TelaPraFase2 + #713, #127
  static TelaPraFase2 + #714, #3875
  static TelaPraFase2 + #715, #127
  static TelaPraFase2 + #716, #127
  static TelaPraFase2 + #717, #127
  static TelaPraFase2 + #718, #127
  static TelaPraFase2 + #719, #127

  ;Linha 18
  static TelaPraFase2 + #720, #127
  static TelaPraFase2 + #721, #127
  static TelaPraFase2 + #722, #127
  static TelaPraFase2 + #723, #127
  static TelaPraFase2 + #724, #127
  static TelaPraFase2 + #725, #127
  static TelaPraFase2 + #726, #127
  static TelaPraFase2 + #727, #127
  static TelaPraFase2 + #728, #127
  static TelaPraFase2 + #729, #3951
  static TelaPraFase2 + #730, #3951
  static TelaPraFase2 + #731, #3951
  static TelaPraFase2 + #732, #3951
  static TelaPraFase2 + #733, #3696
  static TelaPraFase2 + #734, #3681
  static TelaPraFase2 + #735, #3698
  static TelaPraFase2 + #736, #3681
  static TelaPraFase2 + #737, #3888
  static TelaPraFase2 + #738, #3702
  static TelaPraFase2 + #739, #3685
  static TelaPraFase2 + #740, #3694
  static TelaPraFase2 + #741, #3683
  static TelaPraFase2 + #742, #3685
  static TelaPraFase2 + #743, #3698
  static TelaPraFase2 + #744, #3617
  static TelaPraFase2 + #745, #127
  static TelaPraFase2 + #746, #127
  static TelaPraFase2 + #747, #127
  static TelaPraFase2 + #748, #3875
  static TelaPraFase2 + #749, #127
  static TelaPraFase2 + #750, #127
  static TelaPraFase2 + #751, #3875
  static TelaPraFase2 + #752, #127
  static TelaPraFase2 + #753, #127
  static TelaPraFase2 + #754, #3875
  static TelaPraFase2 + #755, #127
  static TelaPraFase2 + #756, #127
  static TelaPraFase2 + #757, #127
  static TelaPraFase2 + #758, #127
  static TelaPraFase2 + #759, #127

  ;Linha 19
  static TelaPraFase2 + #760, #127
  static TelaPraFase2 + #761, #127
  static TelaPraFase2 + #762, #127
  static TelaPraFase2 + #763, #127
  static TelaPraFase2 + #764, #127
  static TelaPraFase2 + #765, #127
  static TelaPraFase2 + #766, #127
  static TelaPraFase2 + #767, #127
  static TelaPraFase2 + #768, #127
  static TelaPraFase2 + #769, #127
  static TelaPraFase2 + #770, #127
  static TelaPraFase2 + #771, #127
  static TelaPraFase2 + #772, #127
  static TelaPraFase2 + #773, #127
  static TelaPraFase2 + #774, #127
  static TelaPraFase2 + #775, #127
  static TelaPraFase2 + #776, #3888
  static TelaPraFase2 + #777, #3888
  static TelaPraFase2 + #778, #3888
  static TelaPraFase2 + #779, #3888
  static TelaPraFase2 + #780, #127
  static TelaPraFase2 + #781, #127
  static TelaPraFase2 + #782, #127
  static TelaPraFase2 + #783, #127
  static TelaPraFase2 + #784, #127
  static TelaPraFase2 + #785, #127
  static TelaPraFase2 + #786, #127
  static TelaPraFase2 + #787, #127
  static TelaPraFase2 + #788, #3875
  static TelaPraFase2 + #789, #127
  static TelaPraFase2 + #790, #127
  static TelaPraFase2 + #791, #127
  static TelaPraFase2 + #792, #127
  static TelaPraFase2 + #793, #3875
  static TelaPraFase2 + #794, #3875
  static TelaPraFase2 + #795, #127
  static TelaPraFase2 + #796, #127
  static TelaPraFase2 + #797, #127
  static TelaPraFase2 + #798, #127
  static TelaPraFase2 + #799, #127

  ;Linha 20
  static TelaPraFase2 + #800, #127
  static TelaPraFase2 + #801, #127
  static TelaPraFase2 + #802, #127
  static TelaPraFase2 + #803, #127
  static TelaPraFase2 + #804, #127
  static TelaPraFase2 + #805, #127
  static TelaPraFase2 + #806, #127
  static TelaPraFase2 + #807, #127
  static TelaPraFase2 + #808, #127
  static TelaPraFase2 + #809, #127
  static TelaPraFase2 + #810, #127
  static TelaPraFase2 + #811, #127
  static TelaPraFase2 + #812, #127
  static TelaPraFase2 + #813, #127
  static TelaPraFase2 + #814, #127
  static TelaPraFase2 + #815, #127
  static TelaPraFase2 + #816, #127
  static TelaPraFase2 + #817, #127
  static TelaPraFase2 + #818, #127
  static TelaPraFase2 + #819, #127
  static TelaPraFase2 + #820, #127
  static TelaPraFase2 + #821, #127
  static TelaPraFase2 + #822, #127
  static TelaPraFase2 + #823, #127
  static TelaPraFase2 + #824, #127
  static TelaPraFase2 + #825, #127
  static TelaPraFase2 + #826, #127
  static TelaPraFase2 + #827, #127
  static TelaPraFase2 + #828, #127
  static TelaPraFase2 + #829, #3875
  static TelaPraFase2 + #830, #127
  static TelaPraFase2 + #831, #127
  static TelaPraFase2 + #832, #127
  static TelaPraFase2 + #833, #3875
  static TelaPraFase2 + #834, #3875
  static TelaPraFase2 + #835, #127
  static TelaPraFase2 + #836, #127
  static TelaPraFase2 + #837, #127
  static TelaPraFase2 + #838, #127
  static TelaPraFase2 + #839, #127

  ;Linha 21
  static TelaPraFase2 + #840, #127
  static TelaPraFase2 + #841, #127
  static TelaPraFase2 + #842, #127
  static TelaPraFase2 + #843, #127
  static TelaPraFase2 + #844, #127
  static TelaPraFase2 + #845, #127
  static TelaPraFase2 + #846, #127
  static TelaPraFase2 + #847, #127
  static TelaPraFase2 + #848, #127
  static TelaPraFase2 + #849, #127
  static TelaPraFase2 + #850, #127
  static TelaPraFase2 + #851, #127
  static TelaPraFase2 + #852, #127
  static TelaPraFase2 + #853, #127
  static TelaPraFase2 + #854, #127
  static TelaPraFase2 + #855, #127
  static TelaPraFase2 + #856, #127
  static TelaPraFase2 + #857, #127
  static TelaPraFase2 + #858, #127
  static TelaPraFase2 + #859, #127
  static TelaPraFase2 + #860, #127
  static TelaPraFase2 + #861, #127
  static TelaPraFase2 + #862, #127
  static TelaPraFase2 + #863, #127
  static TelaPraFase2 + #864, #127
  static TelaPraFase2 + #865, #127
  static TelaPraFase2 + #866, #127
  static TelaPraFase2 + #867, #127
  static TelaPraFase2 + #868, #127
  static TelaPraFase2 + #869, #127
  static TelaPraFase2 + #870, #3875
  static TelaPraFase2 + #871, #127
  static TelaPraFase2 + #872, #127
  static TelaPraFase2 + #873, #127
  static TelaPraFase2 + #874, #3875
  static TelaPraFase2 + #875, #127
  static TelaPraFase2 + #876, #127
  static TelaPraFase2 + #877, #127
  static TelaPraFase2 + #878, #127
  static TelaPraFase2 + #879, #127

  ;Linha 22
  static TelaPraFase2 + #880, #127
  static TelaPraFase2 + #881, #127
  static TelaPraFase2 + #882, #3951
  static TelaPraFase2 + #883, #127
  static TelaPraFase2 + #884, #127
  static TelaPraFase2 + #885, #127
  static TelaPraFase2 + #886, #127
  static TelaPraFase2 + #887, #127
  static TelaPraFase2 + #888, #127
  static TelaPraFase2 + #889, #127
  static TelaPraFase2 + #890, #127
  static TelaPraFase2 + #891, #127
  static TelaPraFase2 + #892, #127
  static TelaPraFase2 + #893, #127
  static TelaPraFase2 + #894, #127
  static TelaPraFase2 + #895, #127
  static TelaPraFase2 + #896, #127
  static TelaPraFase2 + #897, #127
  static TelaPraFase2 + #898, #127
  static TelaPraFase2 + #899, #127
  static TelaPraFase2 + #900, #127
  static TelaPraFase2 + #901, #127
  static TelaPraFase2 + #902, #127
  static TelaPraFase2 + #903, #127
  static TelaPraFase2 + #904, #127
  static TelaPraFase2 + #905, #127
  static TelaPraFase2 + #906, #127
  static TelaPraFase2 + #907, #127
  static TelaPraFase2 + #908, #127
  static TelaPraFase2 + #909, #127
  static TelaPraFase2 + #910, #3875
  static TelaPraFase2 + #911, #127
  static TelaPraFase2 + #912, #127
  static TelaPraFase2 + #913, #127
  static TelaPraFase2 + #914, #127
  static TelaPraFase2 + #915, #127
  static TelaPraFase2 + #916, #127
  static TelaPraFase2 + #917, #127
  static TelaPraFase2 + #918, #127
  static TelaPraFase2 + #919, #127

  ;Linha 23
  static TelaPraFase2 + #920, #127
  static TelaPraFase2 + #921, #3951
  static TelaPraFase2 + #922, #3951
  static TelaPraFase2 + #923, #127
  static TelaPraFase2 + #924, #127
  static TelaPraFase2 + #925, #127
  static TelaPraFase2 + #926, #127
  static TelaPraFase2 + #927, #127
  static TelaPraFase2 + #928, #127
  static TelaPraFase2 + #929, #127
  static TelaPraFase2 + #930, #127
  static TelaPraFase2 + #931, #127
  static TelaPraFase2 + #932, #127
  static TelaPraFase2 + #933, #2622
  static TelaPraFase2 + #934, #2622
  static TelaPraFase2 + #935, #3900
  static TelaPraFase2 + #936, #2629
  static TelaPraFase2 + #937, #2675
  static TelaPraFase2 + #938, #2672
  static TelaPraFase2 + #939, #2657
  static TelaPraFase2 + #940, #2659
  static TelaPraFase2 + #941, #2671
  static TelaPraFase2 + #942, #127
  static TelaPraFase2 + #943, #2620
  static TelaPraFase2 + #944, #2620
  static TelaPraFase2 + #945, #127
  static TelaPraFase2 + #946, #127
  static TelaPraFase2 + #947, #127
  static TelaPraFase2 + #948, #127
  static TelaPraFase2 + #949, #127
  static TelaPraFase2 + #950, #127
  static TelaPraFase2 + #951, #3875
  static TelaPraFase2 + #952, #127
  static TelaPraFase2 + #953, #127
  static TelaPraFase2 + #954, #127
  static TelaPraFase2 + #955, #127
  static TelaPraFase2 + #956, #127
  static TelaPraFase2 + #957, #127
  static TelaPraFase2 + #958, #127
  static TelaPraFase2 + #959, #127

  ;Linha 24
  static TelaPraFase2 + #960, #127
  static TelaPraFase2 + #961, #3951
  static TelaPraFase2 + #962, #3951
  static TelaPraFase2 + #963, #3951
  static TelaPraFase2 + #964, #127
  static TelaPraFase2 + #965, #127
  static TelaPraFase2 + #966, #127
  static TelaPraFase2 + #967, #127
  static TelaPraFase2 + #968, #127
  static TelaPraFase2 + #969, #127
  static TelaPraFase2 + #970, #127
  static TelaPraFase2 + #971, #127
  static TelaPraFase2 + #972, #127
  static TelaPraFase2 + #973, #127
  static TelaPraFase2 + #974, #127
  static TelaPraFase2 + #975, #3900
  static TelaPraFase2 + #976, #127
  static TelaPraFase2 + #977, #127
  static TelaPraFase2 + #978, #127
  static TelaPraFase2 + #979, #127
  static TelaPraFase2 + #980, #127
  static TelaPraFase2 + #981, #127
  static TelaPraFase2 + #982, #127
  static TelaPraFase2 + #983, #127
  static TelaPraFase2 + #984, #127
  static TelaPraFase2 + #985, #127
  static TelaPraFase2 + #986, #127
  static TelaPraFase2 + #987, #127
  static TelaPraFase2 + #988, #127
  static TelaPraFase2 + #989, #127
  static TelaPraFase2 + #990, #127
  static TelaPraFase2 + #991, #3875
  static TelaPraFase2 + #992, #3875
  static TelaPraFase2 + #993, #127
  static TelaPraFase2 + #994, #127
  static TelaPraFase2 + #995, #127
  static TelaPraFase2 + #996, #127
  static TelaPraFase2 + #997, #127
  static TelaPraFase2 + #998, #127
  static TelaPraFase2 + #999, #127

  ;Linha 25
  static TelaPraFase2 + #1000, #127
  static TelaPraFase2 + #1001, #3951
  static TelaPraFase2 + #1002, #3951
  static TelaPraFase2 + #1003, #3951
  static TelaPraFase2 + #1004, #127
  static TelaPraFase2 + #1005, #127
  static TelaPraFase2 + #1006, #127
  static TelaPraFase2 + #1007, #127
  static TelaPraFase2 + #1008, #127
  static TelaPraFase2 + #1009, #127
  static TelaPraFase2 + #1010, #127
  static TelaPraFase2 + #1011, #127
  static TelaPraFase2 + #1012, #127
  static TelaPraFase2 + #1013, #127
  static TelaPraFase2 + #1014, #127
  static TelaPraFase2 + #1015, #127
  static TelaPraFase2 + #1016, #127
  static TelaPraFase2 + #1017, #127
  static TelaPraFase2 + #1018, #127
  static TelaPraFase2 + #1019, #127
  static TelaPraFase2 + #1020, #127
  static TelaPraFase2 + #1021, #127
  static TelaPraFase2 + #1022, #127
  static TelaPraFase2 + #1023, #127
  static TelaPraFase2 + #1024, #127
  static TelaPraFase2 + #1025, #127
  static TelaPraFase2 + #1026, #127
  static TelaPraFase2 + #1027, #127
  static TelaPraFase2 + #1028, #127
  static TelaPraFase2 + #1029, #127
  static TelaPraFase2 + #1030, #127
  static TelaPraFase2 + #1031, #127
  static TelaPraFase2 + #1032, #3875
  static TelaPraFase2 + #1033, #3875
  static TelaPraFase2 + #1034, #127
  static TelaPraFase2 + #1035, #127
  static TelaPraFase2 + #1036, #127
  static TelaPraFase2 + #1037, #127
  static TelaPraFase2 + #1038, #127
  static TelaPraFase2 + #1039, #127

  ;Linha 26
  static TelaPraFase2 + #1040, #127
  static TelaPraFase2 + #1041, #3951
  static TelaPraFase2 + #1042, #3951
  static TelaPraFase2 + #1043, #3951
  static TelaPraFase2 + #1044, #127
  static TelaPraFase2 + #1045, #127
  static TelaPraFase2 + #1046, #127
  static TelaPraFase2 + #1047, #127
  static TelaPraFase2 + #1048, #127
  static TelaPraFase2 + #1049, #127
  static TelaPraFase2 + #1050, #127
  static TelaPraFase2 + #1051, #127
  static TelaPraFase2 + #1052, #127
  static TelaPraFase2 + #1053, #127
  static TelaPraFase2 + #1054, #127
  static TelaPraFase2 + #1055, #127
  static TelaPraFase2 + #1056, #127
  static TelaPraFase2 + #1057, #127
  static TelaPraFase2 + #1058, #127
  static TelaPraFase2 + #1059, #127
  static TelaPraFase2 + #1060, #127
  static TelaPraFase2 + #1061, #127
  static TelaPraFase2 + #1062, #127
  static TelaPraFase2 + #1063, #127
  static TelaPraFase2 + #1064, #127
  static TelaPraFase2 + #1065, #127
  static TelaPraFase2 + #1066, #127
  static TelaPraFase2 + #1067, #127
  static TelaPraFase2 + #1068, #127
  static TelaPraFase2 + #1069, #127
  static TelaPraFase2 + #1070, #127
  static TelaPraFase2 + #1071, #127
  static TelaPraFase2 + #1072, #127
  static TelaPraFase2 + #1073, #3875
  static TelaPraFase2 + #1074, #3875
  static TelaPraFase2 + #1075, #3875
  static TelaPraFase2 + #1076, #127
  static TelaPraFase2 + #1077, #127
  static TelaPraFase2 + #1078, #127
  static TelaPraFase2 + #1079, #127

  ;Linha 27
  static TelaPraFase2 + #1080, #127
  static TelaPraFase2 + #1081, #127
  static TelaPraFase2 + #1082, #3951
  static TelaPraFase2 + #1083, #127
  static TelaPraFase2 + #1084, #127
  static TelaPraFase2 + #1085, #127
  static TelaPraFase2 + #1086, #127
  static TelaPraFase2 + #1087, #3875
  static TelaPraFase2 + #1088, #3875
  static TelaPraFase2 + #1089, #3875
  static TelaPraFase2 + #1090, #3875
  static TelaPraFase2 + #1091, #3875
  static TelaPraFase2 + #1092, #3875
  static TelaPraFase2 + #1093, #3875
  static TelaPraFase2 + #1094, #3875
  static TelaPraFase2 + #1095, #3875
  static TelaPraFase2 + #1096, #3875
  static TelaPraFase2 + #1097, #3875
  static TelaPraFase2 + #1098, #3875
  static TelaPraFase2 + #1099, #3875
  static TelaPraFase2 + #1100, #3875
  static TelaPraFase2 + #1101, #3875
  static TelaPraFase2 + #1102, #3875
  static TelaPraFase2 + #1103, #127
  static TelaPraFase2 + #1104, #127
  static TelaPraFase2 + #1105, #127
  static TelaPraFase2 + #1106, #127
  static TelaPraFase2 + #1107, #127
  static TelaPraFase2 + #1108, #127
  static TelaPraFase2 + #1109, #127
  static TelaPraFase2 + #1110, #127
  static TelaPraFase2 + #1111, #127
  static TelaPraFase2 + #1112, #127
  static TelaPraFase2 + #1113, #127
  static TelaPraFase2 + #1114, #127
  static TelaPraFase2 + #1115, #127
  static TelaPraFase2 + #1116, #3875
  static TelaPraFase2 + #1117, #3875
  static TelaPraFase2 + #1118, #127
  static TelaPraFase2 + #1119, #127

  ;Linha 28
  static TelaPraFase2 + #1120, #127
  static TelaPraFase2 + #1121, #127
  static TelaPraFase2 + #1122, #127
  static TelaPraFase2 + #1123, #3875
  static TelaPraFase2 + #1124, #3875
  static TelaPraFase2 + #1125, #3875
  static TelaPraFase2 + #1126, #3875
  static TelaPraFase2 + #1127, #3875
  static TelaPraFase2 + #1128, #3875
  static TelaPraFase2 + #1129, #3875
  static TelaPraFase2 + #1130, #3875
  static TelaPraFase2 + #1131, #3875
  static TelaPraFase2 + #1132, #3875
  static TelaPraFase2 + #1133, #3875
  static TelaPraFase2 + #1134, #3875
  static TelaPraFase2 + #1135, #3875
  static TelaPraFase2 + #1136, #3875
  static TelaPraFase2 + #1137, #3875
  static TelaPraFase2 + #1138, #3875
  static TelaPraFase2 + #1139, #3875
  static TelaPraFase2 + #1140, #3875
  static TelaPraFase2 + #1141, #3875
  static TelaPraFase2 + #1142, #3875
  static TelaPraFase2 + #1143, #3875
  static TelaPraFase2 + #1144, #3875
  static TelaPraFase2 + #1145, #3875
  static TelaPraFase2 + #1146, #3875
  static TelaPraFase2 + #1147, #3875
  static TelaPraFase2 + #1148, #3875
  static TelaPraFase2 + #1149, #3875
  static TelaPraFase2 + #1150, #3875
  static TelaPraFase2 + #1151, #3875
  static TelaPraFase2 + #1152, #3875
  static TelaPraFase2 + #1153, #3875
  static TelaPraFase2 + #1154, #3875
  static TelaPraFase2 + #1155, #3875
  static TelaPraFase2 + #1156, #3875
  static TelaPraFase2 + #1157, #3875
  static TelaPraFase2 + #1158, #127
  static TelaPraFase2 + #1159, #127

  ;Linha 29
  static TelaPraFase2 + #1160, #127
  static TelaPraFase2 + #1161, #127
  static TelaPraFase2 + #1162, #127
  static TelaPraFase2 + #1163, #127
  static TelaPraFase2 + #1164, #127
  static TelaPraFase2 + #1165, #127
  static TelaPraFase2 + #1166, #127
  static TelaPraFase2 + #1167, #127
  static TelaPraFase2 + #1168, #127
  static TelaPraFase2 + #1169, #127
  static TelaPraFase2 + #1170, #127
  static TelaPraFase2 + #1171, #127
  static TelaPraFase2 + #1172, #127
  static TelaPraFase2 + #1173, #127
  static TelaPraFase2 + #1174, #127
  static TelaPraFase2 + #1175, #3875
  static TelaPraFase2 + #1176, #3875
  static TelaPraFase2 + #1177, #3875
  static TelaPraFase2 + #1178, #3875
  static TelaPraFase2 + #1179, #3875
  static TelaPraFase2 + #1180, #3875
  static TelaPraFase2 + #1181, #127
  static TelaPraFase2 + #1182, #127
  static TelaPraFase2 + #1183, #127
  static TelaPraFase2 + #1184, #127
  static TelaPraFase2 + #1185, #127
  static TelaPraFase2 + #1186, #127
  static TelaPraFase2 + #1187, #127
  static TelaPraFase2 + #1188, #127
  static TelaPraFase2 + #1189, #127
  static TelaPraFase2 + #1190, #3937
  static TelaPraFase2 + #1191, #127
  static TelaPraFase2 + #1192, #127
  static TelaPraFase2 + #1193, #127
  static TelaPraFase2 + #1194, #127
  static TelaPraFase2 + #1195, #127
  static TelaPraFase2 + #1196, #127
  static TelaPraFase2 + #1197, #3875
  static TelaPraFase2 + #1198, #127
  static TelaPraFase2 + #1199, #127

printTelaPraFase2Screen:
  push R0
  push R1
  push R2
  push R3

  loadn R0, #TelaPraFase2
  loadn R1, #0
  loadn R2, #1200

  printTelaPraFase2ScreenLoop:

    add R3,R0,R1
    loadi R3, R3
    outchar R3, R1
    inc R1
    cmp R1, R2

    jne printTelaPraFase2ScreenLoop

  pop R3
  pop R2
  pop R1
  pop R0
  rts

;--------------------------------------------------Tela Fim de Jogo (PERDEU)----------------------------------------------
telaPerdeu : var #1200
  ;Linha 0
  static telaPerdeu + #0, #127
  static telaPerdeu + #1, #127
  static telaPerdeu + #2, #127
  static telaPerdeu + #3, #127
  static telaPerdeu + #4, #127
  static telaPerdeu + #5, #127
  static telaPerdeu + #6, #127
  static telaPerdeu + #7, #127
  static telaPerdeu + #8, #127
  static telaPerdeu + #9, #127
  static telaPerdeu + #10, #127
  static telaPerdeu + #11, #127
  static telaPerdeu + #12, #127
  static telaPerdeu + #13, #127
  static telaPerdeu + #14, #127
  static telaPerdeu + #15, #3875
  static telaPerdeu + #16, #127
  static telaPerdeu + #17, #127
  static telaPerdeu + #18, #127
  static telaPerdeu + #19, #127
  static telaPerdeu + #20, #127
  static telaPerdeu + #21, #127
  static telaPerdeu + #22, #127
  static telaPerdeu + #23, #127
  static telaPerdeu + #24, #127
  static telaPerdeu + #25, #127
  static telaPerdeu + #26, #127
  static telaPerdeu + #27, #127
  static telaPerdeu + #28, #3875
  static telaPerdeu + #29, #3875
  static telaPerdeu + #30, #127
  static telaPerdeu + #31, #127
  static telaPerdeu + #32, #127
  static telaPerdeu + #33, #127
  static telaPerdeu + #34, #127
  static telaPerdeu + #35, #127
  static telaPerdeu + #36, #127
  static telaPerdeu + #37, #127
  static telaPerdeu + #38, #127
  static telaPerdeu + #39, #127

  ;Linha 1
  static telaPerdeu + #40, #127
  static telaPerdeu + #41, #127
  static telaPerdeu + #42, #127
  static telaPerdeu + #43, #127
  static telaPerdeu + #44, #127
  static telaPerdeu + #45, #127
  static telaPerdeu + #46, #127
  static telaPerdeu + #47, #3963
  static telaPerdeu + #48, #127
  static telaPerdeu + #49, #127
  static telaPerdeu + #50, #127
  static telaPerdeu + #51, #127
  static telaPerdeu + #52, #127
  static telaPerdeu + #53, #127
  static telaPerdeu + #54, #127
  static telaPerdeu + #55, #3875
  static telaPerdeu + #56, #127
  static telaPerdeu + #57, #127
  static telaPerdeu + #58, #3875
  static telaPerdeu + #59, #3875
  static telaPerdeu + #60, #127
  static telaPerdeu + #61, #127
  static telaPerdeu + #62, #127
  static telaPerdeu + #63, #127
  static telaPerdeu + #64, #127
  static telaPerdeu + #65, #127
  static telaPerdeu + #66, #127
  static telaPerdeu + #67, #127
  static telaPerdeu + #68, #3875
  static telaPerdeu + #69, #3875
  static telaPerdeu + #70, #127
  static telaPerdeu + #71, #127
  static telaPerdeu + #72, #127
  static telaPerdeu + #73, #127
  static telaPerdeu + #74, #127
  static telaPerdeu + #75, #127
  static telaPerdeu + #76, #127
  static telaPerdeu + #77, #127
  static telaPerdeu + #78, #127
  static telaPerdeu + #79, #127

  ;Linha 2
  static telaPerdeu + #80, #127
  static telaPerdeu + #81, #127
  static telaPerdeu + #82, #127
  static telaPerdeu + #83, #127
  static telaPerdeu + #84, #127
  static telaPerdeu + #85, #123
  static telaPerdeu + #86, #123
  static telaPerdeu + #87, #123
  static telaPerdeu + #88, #127
  static telaPerdeu + #89, #127
  static telaPerdeu + #90, #127
  static telaPerdeu + #91, #127
  static telaPerdeu + #92, #127
  static telaPerdeu + #93, #127
  static telaPerdeu + #94, #127
  static telaPerdeu + #95, #3875
  static telaPerdeu + #96, #127
  static telaPerdeu + #97, #3875
  static telaPerdeu + #98, #3875
  static telaPerdeu + #99, #3875
  static telaPerdeu + #100, #3875
  static telaPerdeu + #101, #127
  static telaPerdeu + #102, #127
  static telaPerdeu + #103, #127
  static telaPerdeu + #104, #127
  static telaPerdeu + #105, #127
  static telaPerdeu + #106, #127
  static telaPerdeu + #107, #3875
  static telaPerdeu + #108, #3875
  static telaPerdeu + #109, #3875
  static telaPerdeu + #110, #3875
  static telaPerdeu + #111, #127
  static telaPerdeu + #112, #127
  static telaPerdeu + #113, #127
  static telaPerdeu + #114, #127
  static telaPerdeu + #115, #127
  static telaPerdeu + #116, #127
  static telaPerdeu + #117, #127
  static telaPerdeu + #118, #127
  static telaPerdeu + #119, #127

  ;Linha 3
  static telaPerdeu + #120, #127
  static telaPerdeu + #121, #127
  static telaPerdeu + #122, #127
  static telaPerdeu + #123, #127
  static telaPerdeu + #124, #127
  static telaPerdeu + #125, #123
  static telaPerdeu + #126, #123
  static telaPerdeu + #127, #123
  static telaPerdeu + #128, #127
  static telaPerdeu + #129, #127
  static telaPerdeu + #130, #127
  static telaPerdeu + #131, #3875
  static telaPerdeu + #132, #3875
  static telaPerdeu + #133, #3875
  static telaPerdeu + #134, #2339
  static telaPerdeu + #135, #3875
  static telaPerdeu + #136, #3875
  static telaPerdeu + #137, #2339
  static telaPerdeu + #138, #3875
  static telaPerdeu + #139, #3875
  static telaPerdeu + #140, #2339
  static telaPerdeu + #141, #2339
  static telaPerdeu + #142, #3875
  static telaPerdeu + #143, #3875
  static telaPerdeu + #144, #3875
  static telaPerdeu + #145, #2339
  static telaPerdeu + #146, #2339
  static telaPerdeu + #147, #2339
  static telaPerdeu + #148, #3875
  static telaPerdeu + #149, #2339
  static telaPerdeu + #150, #2339
  static telaPerdeu + #151, #2339
  static telaPerdeu + #152, #127
  static telaPerdeu + #153, #127
  static telaPerdeu + #154, #127
  static telaPerdeu + #155, #127
  static telaPerdeu + #156, #127
  static telaPerdeu + #157, #127
  static telaPerdeu + #158, #127
  static telaPerdeu + #159, #127

  ;Linha 4
  static telaPerdeu + #160, #127
  static telaPerdeu + #161, #127
  static telaPerdeu + #162, #127
  static telaPerdeu + #163, #127
  static telaPerdeu + #164, #127
  static telaPerdeu + #165, #123
  static telaPerdeu + #166, #123
  static telaPerdeu + #167, #123
  static telaPerdeu + #168, #127
  static telaPerdeu + #169, #127
  static telaPerdeu + #170, #127
  static telaPerdeu + #171, #3875
  static telaPerdeu + #172, #3875
  static telaPerdeu + #173, #3875
  static telaPerdeu + #174, #2339
  static telaPerdeu + #175, #3875
  static telaPerdeu + #176, #127
  static telaPerdeu + #177, #2339
  static telaPerdeu + #178, #3875
  static telaPerdeu + #179, #2339
  static telaPerdeu + #180, #3875
  static telaPerdeu + #181, #3875
  static telaPerdeu + #182, #2339
  static telaPerdeu + #183, #3875
  static telaPerdeu + #184, #2339
  static telaPerdeu + #185, #3875
  static telaPerdeu + #186, #3875
  static telaPerdeu + #187, #3875
  static telaPerdeu + #188, #3875
  static telaPerdeu + #189, #2339
  static telaPerdeu + #190, #3875
  static telaPerdeu + #191, #127
  static telaPerdeu + #192, #127
  static telaPerdeu + #193, #127
  static telaPerdeu + #194, #127
  static telaPerdeu + #195, #127
  static telaPerdeu + #196, #127
  static telaPerdeu + #197, #127
  static telaPerdeu + #198, #127
  static telaPerdeu + #199, #127

  ;Linha 5
  static telaPerdeu + #200, #127
  static telaPerdeu + #201, #127
  static telaPerdeu + #202, #127
  static telaPerdeu + #203, #127
  static telaPerdeu + #204, #127
  static telaPerdeu + #205, #127
  static telaPerdeu + #206, #123
  static telaPerdeu + #207, #123
  static telaPerdeu + #208, #127
  static telaPerdeu + #209, #127
  static telaPerdeu + #210, #127
  static telaPerdeu + #211, #3875
  static telaPerdeu + #212, #3875
  static telaPerdeu + #213, #3875
  static telaPerdeu + #214, #2339
  static telaPerdeu + #215, #3875
  static telaPerdeu + #216, #3875
  static telaPerdeu + #217, #2339
  static telaPerdeu + #218, #3875
  static telaPerdeu + #219, #2339
  static telaPerdeu + #220, #3875
  static telaPerdeu + #221, #3875
  static telaPerdeu + #222, #2339
  static telaPerdeu + #223, #3875
  static telaPerdeu + #224, #2339
  static telaPerdeu + #225, #3875
  static telaPerdeu + #226, #3875
  static telaPerdeu + #227, #3875
  static telaPerdeu + #228, #3875
  static telaPerdeu + #229, #2339
  static telaPerdeu + #230, #2339
  static telaPerdeu + #231, #2339
  static telaPerdeu + #232, #127
  static telaPerdeu + #233, #127
  static telaPerdeu + #234, #2362
  static telaPerdeu + #235, #2344
  static telaPerdeu + #236, #127
  static telaPerdeu + #237, #127
  static telaPerdeu + #238, #127
  static telaPerdeu + #239, #127

  ;Linha 6
  static telaPerdeu + #240, #127
  static telaPerdeu + #241, #127
  static telaPerdeu + #242, #127
  static telaPerdeu + #243, #127
  static telaPerdeu + #244, #127
  static telaPerdeu + #245, #127
  static telaPerdeu + #246, #2427
  static telaPerdeu + #247, #2427
  static telaPerdeu + #248, #127
  static telaPerdeu + #249, #127
  static telaPerdeu + #250, #127
  static telaPerdeu + #251, #3875
  static telaPerdeu + #252, #3875
  static telaPerdeu + #253, #3875
  static telaPerdeu + #254, #2339
  static telaPerdeu + #255, #3875
  static telaPerdeu + #256, #3875
  static telaPerdeu + #257, #2339
  static telaPerdeu + #258, #3875
  static telaPerdeu + #259, #2339
  static telaPerdeu + #260, #3875
  static telaPerdeu + #261, #3875
  static telaPerdeu + #262, #2339
  static telaPerdeu + #263, #3875
  static telaPerdeu + #264, #2339
  static telaPerdeu + #265, #3875
  static telaPerdeu + #266, #3875
  static telaPerdeu + #267, #3875
  static telaPerdeu + #268, #3875
  static telaPerdeu + #269, #2339
  static telaPerdeu + #270, #3875
  static telaPerdeu + #271, #127
  static telaPerdeu + #272, #127
  static telaPerdeu + #273, #127
  static telaPerdeu + #274, #127
  static telaPerdeu + #275, #127
  static telaPerdeu + #276, #127
  static telaPerdeu + #277, #127
  static telaPerdeu + #278, #127
  static telaPerdeu + #279, #127

  ;Linha 7
  static telaPerdeu + #280, #127
  static telaPerdeu + #281, #127
  static telaPerdeu + #282, #127
  static telaPerdeu + #283, #127
  static telaPerdeu + #284, #127
  static telaPerdeu + #285, #127
  static telaPerdeu + #286, #635
  static telaPerdeu + #287, #635
  static telaPerdeu + #288, #127
  static telaPerdeu + #289, #127
  static telaPerdeu + #290, #127
  static telaPerdeu + #291, #3875
  static telaPerdeu + #292, #3875
  static telaPerdeu + #293, #3875
  static telaPerdeu + #294, #2339
  static telaPerdeu + #295, #3875
  static telaPerdeu + #296, #3875
  static telaPerdeu + #297, #2339
  static telaPerdeu + #298, #3875
  static telaPerdeu + #299, #2339
  static telaPerdeu + #300, #3875
  static telaPerdeu + #301, #3875
  static telaPerdeu + #302, #2339
  static telaPerdeu + #303, #3875
  static telaPerdeu + #304, #2339
  static telaPerdeu + #305, #3875
  static telaPerdeu + #306, #3875
  static telaPerdeu + #307, #3875
  static telaPerdeu + #308, #3875
  static telaPerdeu + #309, #2339
  static telaPerdeu + #310, #3875
  static telaPerdeu + #311, #127
  static telaPerdeu + #312, #127
  static telaPerdeu + #313, #127
  static telaPerdeu + #314, #127
  static telaPerdeu + #315, #127
  static telaPerdeu + #316, #127
  static telaPerdeu + #317, #127
  static telaPerdeu + #318, #127
  static telaPerdeu + #319, #127

  ;Linha 8
  static telaPerdeu + #320, #127
  static telaPerdeu + #321, #127
  static telaPerdeu + #322, #127
  static telaPerdeu + #323, #127
  static telaPerdeu + #324, #127
  static telaPerdeu + #325, #127
  static telaPerdeu + #326, #2939
  static telaPerdeu + #327, #2939
  static telaPerdeu + #328, #127
  static telaPerdeu + #329, #127
  static telaPerdeu + #330, #127
  static telaPerdeu + #331, #127
  static telaPerdeu + #332, #3875
  static telaPerdeu + #333, #3875
  static telaPerdeu + #334, #3875
  static telaPerdeu + #335, #2339
  static telaPerdeu + #336, #2339
  static telaPerdeu + #337, #3875
  static telaPerdeu + #338, #3875
  static telaPerdeu + #339, #3875
  static telaPerdeu + #340, #2339
  static telaPerdeu + #341, #2339
  static telaPerdeu + #342, #3875
  static telaPerdeu + #343, #3875
  static telaPerdeu + #344, #3875
  static telaPerdeu + #345, #2339
  static telaPerdeu + #346, #2339
  static telaPerdeu + #347, #2339
  static telaPerdeu + #348, #3875
  static telaPerdeu + #349, #2339
  static telaPerdeu + #350, #2339
  static telaPerdeu + #351, #2339
  static telaPerdeu + #352, #127
  static telaPerdeu + #353, #127
  static telaPerdeu + #354, #127
  static telaPerdeu + #355, #127
  static telaPerdeu + #356, #127
  static telaPerdeu + #357, #127
  static telaPerdeu + #358, #127
  static telaPerdeu + #359, #127

  ;Linha 9
  static telaPerdeu + #360, #127
  static telaPerdeu + #361, #127
  static telaPerdeu + #362, #127
  static telaPerdeu + #363, #127
  static telaPerdeu + #364, #127
  static telaPerdeu + #365, #127
  static telaPerdeu + #366, #3451
  static telaPerdeu + #367, #3451
  static telaPerdeu + #368, #127
  static telaPerdeu + #369, #127
  static telaPerdeu + #370, #127
  static telaPerdeu + #371, #127
  static telaPerdeu + #372, #3875
  static telaPerdeu + #373, #3875
  static telaPerdeu + #374, #3875
  static telaPerdeu + #375, #3875
  static telaPerdeu + #376, #127
  static telaPerdeu + #377, #3875
  static telaPerdeu + #378, #127
  static telaPerdeu + #379, #127
  static telaPerdeu + #380, #127
  static telaPerdeu + #381, #127
  static telaPerdeu + #382, #3875
  static telaPerdeu + #383, #127
  static telaPerdeu + #384, #127
  static telaPerdeu + #385, #127
  static telaPerdeu + #386, #127
  static telaPerdeu + #387, #127
  static telaPerdeu + #388, #127
  static telaPerdeu + #389, #127
  static telaPerdeu + #390, #3875
  static telaPerdeu + #391, #127
  static telaPerdeu + #392, #3875
  static telaPerdeu + #393, #3875
  static telaPerdeu + #394, #127
  static telaPerdeu + #395, #127
  static telaPerdeu + #396, #127
  static telaPerdeu + #397, #127
  static telaPerdeu + #398, #127
  static telaPerdeu + #399, #3875

  ;Linha 10
  static telaPerdeu + #400, #127
  static telaPerdeu + #401, #127
  static telaPerdeu + #402, #127
  static telaPerdeu + #403, #127
  static telaPerdeu + #404, #127
  static telaPerdeu + #405, #127
  static telaPerdeu + #406, #123
  static telaPerdeu + #407, #123
  static telaPerdeu + #408, #127
  static telaPerdeu + #409, #127
  static telaPerdeu + #410, #2339
  static telaPerdeu + #411, #2339
  static telaPerdeu + #412, #2339
  static telaPerdeu + #413, #3875
  static telaPerdeu + #414, #3875
  static telaPerdeu + #415, #2339
  static telaPerdeu + #416, #2339
  static telaPerdeu + #417, #2339
  static telaPerdeu + #418, #3875
  static telaPerdeu + #419, #2339
  static telaPerdeu + #420, #2339
  static telaPerdeu + #421, #2339
  static telaPerdeu + #422, #3875
  static telaPerdeu + #423, #3875
  static telaPerdeu + #424, #2339
  static telaPerdeu + #425, #2339
  static telaPerdeu + #426, #2339
  static telaPerdeu + #427, #3875
  static telaPerdeu + #428, #3875
  static telaPerdeu + #429, #2339
  static telaPerdeu + #430, #2339
  static telaPerdeu + #431, #2339
  static telaPerdeu + #432, #3875
  static telaPerdeu + #433, #2339
  static telaPerdeu + #434, #3875
  static telaPerdeu + #435, #3875
  static telaPerdeu + #436, #2339
  static telaPerdeu + #437, #127
  static telaPerdeu + #438, #127
  static telaPerdeu + #439, #3875

  ;Linha 11
  static telaPerdeu + #440, #127
  static telaPerdeu + #441, #127
  static telaPerdeu + #442, #127
  static telaPerdeu + #443, #127
  static telaPerdeu + #444, #127
  static telaPerdeu + #445, #127
  static telaPerdeu + #446, #123
  static telaPerdeu + #447, #123
  static telaPerdeu + #448, #127
  static telaPerdeu + #449, #3875
  static telaPerdeu + #450, #2339
  static telaPerdeu + #451, #3875
  static telaPerdeu + #452, #3875
  static telaPerdeu + #453, #2339
  static telaPerdeu + #454, #3875
  static telaPerdeu + #455, #2339
  static telaPerdeu + #456, #3875
  static telaPerdeu + #457, #3875
  static telaPerdeu + #458, #3875
  static telaPerdeu + #459, #2339
  static telaPerdeu + #460, #127
  static telaPerdeu + #461, #3875
  static telaPerdeu + #462, #2339
  static telaPerdeu + #463, #3875
  static telaPerdeu + #464, #2339
  static telaPerdeu + #465, #127
  static telaPerdeu + #466, #2339
  static telaPerdeu + #467, #3875
  static telaPerdeu + #468, #3875
  static telaPerdeu + #469, #2339
  static telaPerdeu + #470, #127
  static telaPerdeu + #471, #3875
  static telaPerdeu + #472, #3875
  static telaPerdeu + #473, #2339
  static telaPerdeu + #474, #3875
  static telaPerdeu + #475, #3875
  static telaPerdeu + #476, #2339
  static telaPerdeu + #477, #127
  static telaPerdeu + #478, #127
  static telaPerdeu + #479, #3875

  ;Linha 12
  static telaPerdeu + #480, #127
  static telaPerdeu + #481, #127
  static telaPerdeu + #482, #127
  static telaPerdeu + #483, #127
  static telaPerdeu + #484, #127
  static telaPerdeu + #485, #127
  static telaPerdeu + #486, #123
  static telaPerdeu + #487, #123
  static telaPerdeu + #488, #127
  static telaPerdeu + #489, #3875
  static telaPerdeu + #490, #2339
  static telaPerdeu + #491, #2339
  static telaPerdeu + #492, #2339
  static telaPerdeu + #493, #3875
  static telaPerdeu + #494, #3875
  static telaPerdeu + #495, #2339
  static telaPerdeu + #496, #2339
  static telaPerdeu + #497, #2339
  static telaPerdeu + #498, #3875
  static telaPerdeu + #499, #2339
  static telaPerdeu + #500, #127
  static telaPerdeu + #501, #3875
  static telaPerdeu + #502, #2339
  static telaPerdeu + #503, #3875
  static telaPerdeu + #504, #2339
  static telaPerdeu + #505, #127
  static telaPerdeu + #506, #3875
  static telaPerdeu + #507, #2339
  static telaPerdeu + #508, #127
  static telaPerdeu + #509, #2339
  static telaPerdeu + #510, #2339
  static telaPerdeu + #511, #2339
  static telaPerdeu + #512, #3875
  static telaPerdeu + #513, #2339
  static telaPerdeu + #514, #3875
  static telaPerdeu + #515, #127
  static telaPerdeu + #516, #2339
  static telaPerdeu + #517, #127
  static telaPerdeu + #518, #127
  static telaPerdeu + #519, #3875

  ;Linha 13
  static telaPerdeu + #520, #127
  static telaPerdeu + #521, #127
  static telaPerdeu + #522, #127
  static telaPerdeu + #523, #127
  static telaPerdeu + #524, #127
  static telaPerdeu + #525, #127
  static telaPerdeu + #526, #123
  static telaPerdeu + #527, #123
  static telaPerdeu + #528, #127
  static telaPerdeu + #529, #3875
  static telaPerdeu + #530, #2339
  static telaPerdeu + #531, #3875
  static telaPerdeu + #532, #127
  static telaPerdeu + #533, #127
  static telaPerdeu + #534, #3875
  static telaPerdeu + #535, #2339
  static telaPerdeu + #536, #3875
  static telaPerdeu + #537, #3875
  static telaPerdeu + #538, #3875
  static telaPerdeu + #539, #2339
  static telaPerdeu + #540, #2339
  static telaPerdeu + #541, #2339
  static telaPerdeu + #542, #3875
  static telaPerdeu + #543, #3875
  static telaPerdeu + #544, #2339
  static telaPerdeu + #545, #127
  static telaPerdeu + #546, #3875
  static telaPerdeu + #547, #2339
  static telaPerdeu + #548, #127
  static telaPerdeu + #549, #2339
  static telaPerdeu + #550, #127
  static telaPerdeu + #551, #3875
  static telaPerdeu + #552, #3875
  static telaPerdeu + #553, #2339
  static telaPerdeu + #554, #127
  static telaPerdeu + #555, #127
  static telaPerdeu + #556, #2339
  static telaPerdeu + #557, #127
  static telaPerdeu + #558, #127
  static telaPerdeu + #559, #3875

  ;Linha 14
  static telaPerdeu + #560, #127
  static telaPerdeu + #561, #127
  static telaPerdeu + #562, #127
  static telaPerdeu + #563, #127
  static telaPerdeu + #564, #127
  static telaPerdeu + #565, #127
  static telaPerdeu + #566, #123
  static telaPerdeu + #567, #123
  static telaPerdeu + #568, #127
  static telaPerdeu + #569, #3875
  static telaPerdeu + #570, #2339
  static telaPerdeu + #571, #3875
  static telaPerdeu + #572, #127
  static telaPerdeu + #573, #127
  static telaPerdeu + #574, #3875
  static telaPerdeu + #575, #2339
  static telaPerdeu + #576, #3875
  static telaPerdeu + #577, #3875
  static telaPerdeu + #578, #127
  static telaPerdeu + #579, #2339
  static telaPerdeu + #580, #127
  static telaPerdeu + #581, #2339
  static telaPerdeu + #582, #2339
  static telaPerdeu + #583, #3875
  static telaPerdeu + #584, #2339
  static telaPerdeu + #585, #127
  static telaPerdeu + #586, #2339
  static telaPerdeu + #587, #3875
  static telaPerdeu + #588, #3875
  static telaPerdeu + #589, #2339
  static telaPerdeu + #590, #127
  static telaPerdeu + #591, #3875
  static telaPerdeu + #592, #3875
  static telaPerdeu + #593, #2339
  static telaPerdeu + #594, #3875
  static telaPerdeu + #595, #3875
  static telaPerdeu + #596, #2339
  static telaPerdeu + #597, #3875
  static telaPerdeu + #598, #3875
  static telaPerdeu + #599, #3875

  ;Linha 15
  static telaPerdeu + #600, #127
  static telaPerdeu + #601, #127
  static telaPerdeu + #602, #127
  static telaPerdeu + #603, #127
  static telaPerdeu + #604, #127
  static telaPerdeu + #605, #127
  static telaPerdeu + #606, #123
  static telaPerdeu + #607, #123
  static telaPerdeu + #608, #127
  static telaPerdeu + #609, #3875
  static telaPerdeu + #610, #2339
  static telaPerdeu + #611, #3875
  static telaPerdeu + #612, #127
  static telaPerdeu + #613, #127
  static telaPerdeu + #614, #3875
  static telaPerdeu + #615, #2339
  static telaPerdeu + #616, #2339
  static telaPerdeu + #617, #2339
  static telaPerdeu + #618, #3875
  static telaPerdeu + #619, #2339
  static telaPerdeu + #620, #3875
  static telaPerdeu + #621, #3875
  static telaPerdeu + #622, #2339
  static telaPerdeu + #623, #127
  static telaPerdeu + #624, #2339
  static telaPerdeu + #625, #2339
  static telaPerdeu + #626, #2339
  static telaPerdeu + #627, #3875
  static telaPerdeu + #628, #3875
  static telaPerdeu + #629, #2339
  static telaPerdeu + #630, #2339
  static telaPerdeu + #631, #2339
  static telaPerdeu + #632, #3875
  static telaPerdeu + #633, #3875
  static telaPerdeu + #634, #2339
  static telaPerdeu + #635, #2339
  static telaPerdeu + #636, #127
  static telaPerdeu + #637, #3875
  static telaPerdeu + #638, #3875
  static telaPerdeu + #639, #127

  ;Linha 16
  static telaPerdeu + #640, #127
  static telaPerdeu + #641, #127
  static telaPerdeu + #642, #127
  static telaPerdeu + #643, #127
  static telaPerdeu + #644, #127
  static telaPerdeu + #645, #127
  static telaPerdeu + #646, #123
  static telaPerdeu + #647, #123
  static telaPerdeu + #648, #127
  static telaPerdeu + #649, #3875
  static telaPerdeu + #650, #3875
  static telaPerdeu + #651, #127
  static telaPerdeu + #652, #127
  static telaPerdeu + #653, #127
  static telaPerdeu + #654, #127
  static telaPerdeu + #655, #127
  static telaPerdeu + #656, #127
  static telaPerdeu + #657, #127
  static telaPerdeu + #658, #127
  static telaPerdeu + #659, #127
  static telaPerdeu + #660, #127
  static telaPerdeu + #661, #127
  static telaPerdeu + #662, #127
  static telaPerdeu + #663, #127
  static telaPerdeu + #664, #127
  static telaPerdeu + #665, #127
  static telaPerdeu + #666, #127
  static telaPerdeu + #667, #127
  static telaPerdeu + #668, #127
  static telaPerdeu + #669, #127
  static telaPerdeu + #670, #127
  static telaPerdeu + #671, #127
  static telaPerdeu + #672, #127
  static telaPerdeu + #673, #127
  static telaPerdeu + #674, #127
  static telaPerdeu + #675, #127
  static telaPerdeu + #676, #127
  static telaPerdeu + #677, #3875
  static telaPerdeu + #678, #3875
  static telaPerdeu + #679, #127

  ;Linha 17
  static telaPerdeu + #680, #127
  static telaPerdeu + #681, #127
  static telaPerdeu + #682, #127
  static telaPerdeu + #683, #127
  static telaPerdeu + #684, #127
  static telaPerdeu + #685, #127
  static telaPerdeu + #686, #123
  static telaPerdeu + #687, #123
  static telaPerdeu + #688, #127
  static telaPerdeu + #689, #127
  static telaPerdeu + #690, #127
  static telaPerdeu + #691, #127
  static telaPerdeu + #692, #127
  static telaPerdeu + #693, #127
  static telaPerdeu + #694, #127
  static telaPerdeu + #695, #127
  static telaPerdeu + #696, #127
  static telaPerdeu + #697, #127
  static telaPerdeu + #698, #127
  static telaPerdeu + #699, #127
  static telaPerdeu + #700, #127
  static telaPerdeu + #701, #127
  static telaPerdeu + #702, #127
  static telaPerdeu + #703, #127
  static telaPerdeu + #704, #127
  static telaPerdeu + #705, #127
  static telaPerdeu + #706, #127
  static telaPerdeu + #707, #127
  static telaPerdeu + #708, #127
  static telaPerdeu + #709, #127
  static telaPerdeu + #710, #127
  static telaPerdeu + #711, #127
  static telaPerdeu + #712, #127
  static telaPerdeu + #713, #127
  static telaPerdeu + #714, #127
  static telaPerdeu + #715, #127
  static telaPerdeu + #716, #127
  static telaPerdeu + #717, #127
  static telaPerdeu + #718, #127
  static telaPerdeu + #719, #127

  ;Linha 18
  static telaPerdeu + #720, #127
  static telaPerdeu + #721, #127
  static telaPerdeu + #722, #127
  static telaPerdeu + #723, #3195
  static telaPerdeu + #724, #127
  static telaPerdeu + #725, #127
  static telaPerdeu + #726, #123
  static telaPerdeu + #727, #123
  static telaPerdeu + #728, #127
  static telaPerdeu + #729, #127
  static telaPerdeu + #730, #3195
  static telaPerdeu + #731, #127
  static telaPerdeu + #732, #127
  static telaPerdeu + #733, #127
  static telaPerdeu + #734, #127
  static telaPerdeu + #735, #127
  static telaPerdeu + #736, #127
  static telaPerdeu + #737, #127
  static telaPerdeu + #738, #127
  static telaPerdeu + #739, #127
  static telaPerdeu + #740, #127
  static telaPerdeu + #741, #127
  static telaPerdeu + #742, #127
  static telaPerdeu + #743, #127
  static telaPerdeu + #744, #127
  static telaPerdeu + #745, #127
  static telaPerdeu + #746, #127
  static telaPerdeu + #747, #127
  static telaPerdeu + #748, #127
  static telaPerdeu + #749, #127
  static telaPerdeu + #750, #127
  static telaPerdeu + #751, #127
  static telaPerdeu + #752, #127
  static telaPerdeu + #753, #127
  static telaPerdeu + #754, #127
  static telaPerdeu + #755, #127
  static telaPerdeu + #756, #127
  static telaPerdeu + #757, #127
  static telaPerdeu + #758, #127
  static telaPerdeu + #759, #127

  ;Linha 19
  static telaPerdeu + #760, #127
  static telaPerdeu + #761, #127
  static telaPerdeu + #762, #3195
  static telaPerdeu + #763, #3195
  static telaPerdeu + #764, #3195
  static telaPerdeu + #765, #127
  static telaPerdeu + #766, #123
  static telaPerdeu + #767, #123
  static telaPerdeu + #768, #127
  static telaPerdeu + #769, #3195
  static telaPerdeu + #770, #3195
  static telaPerdeu + #771, #3195
  static telaPerdeu + #772, #127
  static telaPerdeu + #773, #127
  static telaPerdeu + #774, #127
  static telaPerdeu + #775, #127
  static telaPerdeu + #776, #127
  static telaPerdeu + #777, #127
  static telaPerdeu + #778, #127
  static telaPerdeu + #779, #127
  static telaPerdeu + #780, #127
  static telaPerdeu + #781, #127
  static telaPerdeu + #782, #127
  static telaPerdeu + #783, #127
  static telaPerdeu + #784, #127
  static telaPerdeu + #785, #127
  static telaPerdeu + #786, #127
  static telaPerdeu + #787, #127
  static telaPerdeu + #788, #127
  static telaPerdeu + #789, #127
  static telaPerdeu + #790, #127
  static telaPerdeu + #791, #127
  static telaPerdeu + #792, #127
  static telaPerdeu + #793, #127
  static telaPerdeu + #794, #127
  static telaPerdeu + #795, #127
  static telaPerdeu + #796, #127
  static telaPerdeu + #797, #127
  static telaPerdeu + #798, #127
  static telaPerdeu + #799, #127

  ;Linha 20
  static telaPerdeu + #800, #127
  static telaPerdeu + #801, #127
  static telaPerdeu + #802, #3195
  static telaPerdeu + #803, #3195
  static telaPerdeu + #804, #123
  static telaPerdeu + #805, #123
  static telaPerdeu + #806, #123
  static telaPerdeu + #807, #123
  static telaPerdeu + #808, #123
  static telaPerdeu + #809, #123
  static telaPerdeu + #810, #123
  static telaPerdeu + #811, #3195
  static telaPerdeu + #812, #127
  static telaPerdeu + #813, #127
  static telaPerdeu + #814, #127
  static telaPerdeu + #815, #127
  static telaPerdeu + #816, #127
  static telaPerdeu + #817, #127
  static telaPerdeu + #818, #127
  static telaPerdeu + #819, #127
  static telaPerdeu + #820, #3933
  static telaPerdeu + #821, #3933
  static telaPerdeu + #822, #127
  static telaPerdeu + #823, #127
  static telaPerdeu + #824, #3933
  static telaPerdeu + #825, #3933
  static telaPerdeu + #826, #3933
  static telaPerdeu + #827, #3933
  static telaPerdeu + #828, #3933
  static telaPerdeu + #829, #3933
  static telaPerdeu + #830, #3933
  static telaPerdeu + #831, #3933
  static telaPerdeu + #832, #127
  static telaPerdeu + #833, #127
  static telaPerdeu + #834, #127
  static telaPerdeu + #835, #127
  static telaPerdeu + #836, #127
  static telaPerdeu + #837, #127
  static telaPerdeu + #838, #127
  static telaPerdeu + #839, #127

  ;Linha 21
  static telaPerdeu + #840, #127
  static telaPerdeu + #841, #127
  static telaPerdeu + #842, #127
  static telaPerdeu + #843, #3195
  static telaPerdeu + #844, #3195
  static telaPerdeu + #845, #123
  static telaPerdeu + #846, #123
  static telaPerdeu + #847, #127
  static telaPerdeu + #848, #123
  static telaPerdeu + #849, #123
  static telaPerdeu + #850, #3195
  static telaPerdeu + #851, #3195
  static telaPerdeu + #852, #127
  static telaPerdeu + #853, #127
  static telaPerdeu + #854, #127
  static telaPerdeu + #855, #127
  static telaPerdeu + #856, #127
  static telaPerdeu + #857, #127
  static telaPerdeu + #858, #127
  static telaPerdeu + #859, #2384
  static telaPerdeu + #860, #2401
  static telaPerdeu + #861, #2418
  static telaPerdeu + #862, #2401
  static telaPerdeu + #863, #3933
  static telaPerdeu + #864, #2386
  static telaPerdeu + #865, #2405
  static telaPerdeu + #866, #2409
  static telaPerdeu + #867, #2414
  static telaPerdeu + #868, #2409
  static telaPerdeu + #869, #2403
  static telaPerdeu + #870, #2409
  static telaPerdeu + #871, #2401
  static telaPerdeu + #872, #2418
  static telaPerdeu + #873, #127
  static telaPerdeu + #874, #127
  static telaPerdeu + #875, #127
  static telaPerdeu + #876, #127
  static telaPerdeu + #877, #127
  static telaPerdeu + #878, #127
  static telaPerdeu + #879, #127

  ;Linha 22
  static telaPerdeu + #880, #127
  static telaPerdeu + #881, #127
  static telaPerdeu + #882, #127
  static telaPerdeu + #883, #3195
  static telaPerdeu + #884, #3195
  static telaPerdeu + #885, #123
  static telaPerdeu + #886, #123
  static telaPerdeu + #887, #127
  static telaPerdeu + #888, #123
  static telaPerdeu + #889, #123
  static telaPerdeu + #890, #3195
  static telaPerdeu + #891, #127
  static telaPerdeu + #892, #127
  static telaPerdeu + #893, #127
  static telaPerdeu + #894, #127
  static telaPerdeu + #895, #127
  static telaPerdeu + #896, #127
  static telaPerdeu + #897, #127
  static telaPerdeu + #898, #2366
  static telaPerdeu + #899, #2366
  static telaPerdeu + #900, #127
  static telaPerdeu + #901, #3967
  static telaPerdeu + #902, #3967
  static telaPerdeu + #903, #2373
  static telaPerdeu + #904, #2419
  static telaPerdeu + #905, #2416
  static telaPerdeu + #906, #2401
  static telaPerdeu + #907, #2403
  static telaPerdeu + #908, #2415
  static telaPerdeu + #909, #127
  static telaPerdeu + #910, #127
  static telaPerdeu + #911, #127
  static telaPerdeu + #912, #2364
  static telaPerdeu + #913, #2364
  static telaPerdeu + #914, #127
  static telaPerdeu + #915, #127
  static telaPerdeu + #916, #127
  static telaPerdeu + #917, #127
  static telaPerdeu + #918, #127
  static telaPerdeu + #919, #127

  ;Linha 23
  static telaPerdeu + #920, #127
  static telaPerdeu + #921, #127
  static telaPerdeu + #922, #127
  static telaPerdeu + #923, #3195
  static telaPerdeu + #924, #3195
  static telaPerdeu + #925, #123
  static telaPerdeu + #926, #123
  static telaPerdeu + #927, #127
  static telaPerdeu + #928, #123
  static telaPerdeu + #929, #123
  static telaPerdeu + #930, #3195
  static telaPerdeu + #931, #127
  static telaPerdeu + #932, #127
  static telaPerdeu + #933, #127
  static telaPerdeu + #934, #127
  static telaPerdeu + #935, #127
  static telaPerdeu + #936, #127
  static telaPerdeu + #937, #127
  static telaPerdeu + #938, #127
  static telaPerdeu + #939, #127
  static telaPerdeu + #940, #127
  static telaPerdeu + #941, #127
  static telaPerdeu + #942, #127
  static telaPerdeu + #943, #3967
  static telaPerdeu + #944, #3967
  static telaPerdeu + #945, #3967
  static telaPerdeu + #946, #3967
  static telaPerdeu + #947, #127
  static telaPerdeu + #948, #127
  static telaPerdeu + #949, #127
  static telaPerdeu + #950, #127
  static telaPerdeu + #951, #127
  static telaPerdeu + #952, #2431
  static telaPerdeu + #953, #127
  static telaPerdeu + #954, #127
  static telaPerdeu + #955, #127
  static telaPerdeu + #956, #127
  static telaPerdeu + #957, #127
  static telaPerdeu + #958, #127
  static telaPerdeu + #959, #127

  ;Linha 24
  static telaPerdeu + #960, #127
  static telaPerdeu + #961, #127
  static telaPerdeu + #962, #3195
  static telaPerdeu + #963, #3195
  static telaPerdeu + #964, #3195
  static telaPerdeu + #965, #123
  static telaPerdeu + #966, #123
  static telaPerdeu + #967, #123
  static telaPerdeu + #968, #123
  static telaPerdeu + #969, #123
  static telaPerdeu + #970, #3195
  static telaPerdeu + #971, #3195
  static telaPerdeu + #972, #127
  static telaPerdeu + #973, #127
  static telaPerdeu + #974, #127
  static telaPerdeu + #975, #127
  static telaPerdeu + #976, #127
  static telaPerdeu + #977, #127
  static telaPerdeu + #978, #127
  static telaPerdeu + #979, #127
  static telaPerdeu + #980, #127
  static telaPerdeu + #981, #127
  static telaPerdeu + #982, #127
  static telaPerdeu + #983, #127
  static telaPerdeu + #984, #127
  static telaPerdeu + #985, #127
  static telaPerdeu + #986, #127
  static telaPerdeu + #987, #127
  static telaPerdeu + #988, #127
  static telaPerdeu + #989, #127
  static telaPerdeu + #990, #127
  static telaPerdeu + #991, #127
  static telaPerdeu + #992, #127
  static telaPerdeu + #993, #127
  static telaPerdeu + #994, #127
  static telaPerdeu + #995, #127
  static telaPerdeu + #996, #127
  static telaPerdeu + #997, #127
  static telaPerdeu + #998, #127
  static telaPerdeu + #999, #127

  ;Linha 25
  static telaPerdeu + #1000, #127
  static telaPerdeu + #1001, #127
  static telaPerdeu + #1002, #3195
  static telaPerdeu + #1003, #3195
  static telaPerdeu + #1004, #123
  static telaPerdeu + #1005, #123
  static telaPerdeu + #1006, #3195
  static telaPerdeu + #1007, #3195
  static telaPerdeu + #1008, #3195
  static telaPerdeu + #1009, #123
  static telaPerdeu + #1010, #123
  static telaPerdeu + #1011, #3195
  static telaPerdeu + #1012, #127
  static telaPerdeu + #1013, #127
  static telaPerdeu + #1014, #127
  static telaPerdeu + #1015, #127
  static telaPerdeu + #1016, #127
  static telaPerdeu + #1017, #127
  static telaPerdeu + #1018, #127
  static telaPerdeu + #1019, #127
  static telaPerdeu + #1020, #127
  static telaPerdeu + #1021, #127
  static telaPerdeu + #1022, #127
  static telaPerdeu + #1023, #127
  static telaPerdeu + #1024, #127
  static telaPerdeu + #1025, #127
  static telaPerdeu + #1026, #127
  static telaPerdeu + #1027, #127
  static telaPerdeu + #1028, #127
  static telaPerdeu + #1029, #127
  static telaPerdeu + #1030, #127
  static telaPerdeu + #1031, #127
  static telaPerdeu + #1032, #127
  static telaPerdeu + #1033, #127
  static telaPerdeu + #1034, #127
  static telaPerdeu + #1035, #127
  static telaPerdeu + #1036, #127
  static telaPerdeu + #1037, #127
  static telaPerdeu + #1038, #127
  static telaPerdeu + #1039, #127

  ;Linha 26
  static telaPerdeu + #1040, #127
  static telaPerdeu + #1041, #127
  static telaPerdeu + #1042, #3195
  static telaPerdeu + #1043, #3195
  static telaPerdeu + #1044, #3195
  static telaPerdeu + #1045, #3195
  static telaPerdeu + #1046, #3195
  static telaPerdeu + #1047, #3963
  static telaPerdeu + #1048, #3195
  static telaPerdeu + #1049, #3195
  static telaPerdeu + #1050, #3195
  static telaPerdeu + #1051, #3195
  static telaPerdeu + #1052, #127
  static telaPerdeu + #1053, #127
  static telaPerdeu + #1054, #127
  static telaPerdeu + #1055, #127
  static telaPerdeu + #1056, #127
  static telaPerdeu + #1057, #127
  static telaPerdeu + #1058, #127
  static telaPerdeu + #1059, #127
  static telaPerdeu + #1060, #127
  static telaPerdeu + #1061, #127
  static telaPerdeu + #1062, #127
  static telaPerdeu + #1063, #127
  static telaPerdeu + #1064, #127
  static telaPerdeu + #1065, #127
  static telaPerdeu + #1066, #127
  static telaPerdeu + #1067, #127
  static telaPerdeu + #1068, #127
  static telaPerdeu + #1069, #127
  static telaPerdeu + #1070, #127
  static telaPerdeu + #1071, #127
  static telaPerdeu + #1072, #127
  static telaPerdeu + #1073, #127
  static telaPerdeu + #1074, #127
  static telaPerdeu + #1075, #127
  static telaPerdeu + #1076, #127
  static telaPerdeu + #1077, #127
  static telaPerdeu + #1078, #127
  static telaPerdeu + #1079, #127

  ;Linha 27
  static telaPerdeu + #1080, #127
  static telaPerdeu + #1081, #127
  static telaPerdeu + #1082, #127
  static telaPerdeu + #1083, #3195
  static telaPerdeu + #1084, #3195
  static telaPerdeu + #1085, #3195
  static telaPerdeu + #1086, #3195
  static telaPerdeu + #1087, #3195
  static telaPerdeu + #1088, #127
  static telaPerdeu + #1089, #3195
  static telaPerdeu + #1090, #127
  static telaPerdeu + #1091, #3195
  static telaPerdeu + #1092, #127
  static telaPerdeu + #1093, #127
  static telaPerdeu + #1094, #127
  static telaPerdeu + #1095, #127
  static telaPerdeu + #1096, #127
  static telaPerdeu + #1097, #127
  static telaPerdeu + #1098, #127
  static telaPerdeu + #1099, #127
  static telaPerdeu + #1100, #127
  static telaPerdeu + #1101, #127
  static telaPerdeu + #1102, #127
  static telaPerdeu + #1103, #127
  static telaPerdeu + #1104, #127
  static telaPerdeu + #1105, #127
  static telaPerdeu + #1106, #127
  static telaPerdeu + #1107, #127
  static telaPerdeu + #1108, #127
  static telaPerdeu + #1109, #127
  static telaPerdeu + #1110, #127
  static telaPerdeu + #1111, #127
  static telaPerdeu + #1112, #127
  static telaPerdeu + #1113, #127
  static telaPerdeu + #1114, #127
  static telaPerdeu + #1115, #127
  static telaPerdeu + #1116, #127
  static telaPerdeu + #1117, #127
  static telaPerdeu + #1118, #127
  static telaPerdeu + #1119, #127

  ;Linha 28
  static telaPerdeu + #1120, #127
  static telaPerdeu + #1121, #127
  static telaPerdeu + #1122, #127
  static telaPerdeu + #1123, #127
  static telaPerdeu + #1124, #3195
  static telaPerdeu + #1125, #3195
  static telaPerdeu + #1126, #3195
  static telaPerdeu + #1127, #3195
  static telaPerdeu + #1128, #3195
  static telaPerdeu + #1129, #3195
  static telaPerdeu + #1130, #3195
  static telaPerdeu + #1131, #127
  static telaPerdeu + #1132, #127
  static telaPerdeu + #1133, #127
  static telaPerdeu + #1134, #127
  static telaPerdeu + #1135, #127
  static telaPerdeu + #1136, #127
  static telaPerdeu + #1137, #127
  static telaPerdeu + #1138, #127
  static telaPerdeu + #1139, #127
  static telaPerdeu + #1140, #127
  static telaPerdeu + #1141, #127
  static telaPerdeu + #1142, #127
  static telaPerdeu + #1143, #127
  static telaPerdeu + #1144, #127
  static telaPerdeu + #1145, #127
  static telaPerdeu + #1146, #127
  static telaPerdeu + #1147, #127
  static telaPerdeu + #1148, #127
  static telaPerdeu + #1149, #127
  static telaPerdeu + #1150, #127
  static telaPerdeu + #1151, #127
  static telaPerdeu + #1152, #127
  static telaPerdeu + #1153, #127
  static telaPerdeu + #1154, #127
  static telaPerdeu + #1155, #127
  static telaPerdeu + #1156, #127
  static telaPerdeu + #1157, #127
  static telaPerdeu + #1158, #127
  static telaPerdeu + #1159, #127

  ;Linha 29
  static telaPerdeu + #1160, #127
  static telaPerdeu + #1161, #127
  static telaPerdeu + #1162, #127
  static telaPerdeu + #1163, #127
  static telaPerdeu + #1164, #127
  static telaPerdeu + #1165, #127
  static telaPerdeu + #1166, #127
  static telaPerdeu + #1167, #127
  static telaPerdeu + #1168, #127
  static telaPerdeu + #1169, #127
  static telaPerdeu + #1170, #127
  static telaPerdeu + #1171, #127
  static telaPerdeu + #1172, #127
  static telaPerdeu + #1173, #127
  static telaPerdeu + #1174, #127
  static telaPerdeu + #1175, #127
  static telaPerdeu + #1176, #127
  static telaPerdeu + #1177, #127
  static telaPerdeu + #1178, #127
  static telaPerdeu + #1179, #127
  static telaPerdeu + #1180, #127
  static telaPerdeu + #1181, #127
  static telaPerdeu + #1182, #127
  static telaPerdeu + #1183, #127
  static telaPerdeu + #1184, #127
  static telaPerdeu + #1185, #127
  static telaPerdeu + #1186, #127
  static telaPerdeu + #1187, #127
  static telaPerdeu + #1188, #127
  static telaPerdeu + #1189, #127
  static telaPerdeu + #1190, #127
  static telaPerdeu + #1191, #127
  static telaPerdeu + #1192, #127
  static telaPerdeu + #1193, #127
  static telaPerdeu + #1194, #127
  static telaPerdeu + #1195, #127
  static telaPerdeu + #1196, #127
  static telaPerdeu + #1197, #127
  static telaPerdeu + #1198, #127
  static telaPerdeu + #1199, #127

printtelaPerdeuScreen:
  push R0
  push R1
  push R2
  push R3

  loadn R0, #telaPerdeu
  loadn R1, #0
  loadn R2, #1200

  printtelaPerdeuScreenLoop:

    add R3,R0,R1
    loadi R3, R3
    outchar R3, R1
    inc R1
    cmp R1, R2

    jne printtelaPerdeuScreenLoop

  pop R3
  pop R2
  pop R1
  pop R0
  rts
  
  ;--------------------------------------------------Tela Fim de Jogo (VENCEU)----------------------------------------------
  telaVenceu : var #1200
  ;Linha 0
  static telaVenceu + #0, #127
  static telaVenceu + #1, #127
  static telaVenceu + #2, #127
  static telaVenceu + #3, #127
  static telaVenceu + #4, #127
  static telaVenceu + #5, #127
  static telaVenceu + #6, #127
  static telaVenceu + #7, #127
  static telaVenceu + #8, #127
  static telaVenceu + #9, #127
  static telaVenceu + #10, #127
  static telaVenceu + #11, #127
  static telaVenceu + #12, #127
  static telaVenceu + #13, #127
  static telaVenceu + #14, #127
  static telaVenceu + #15, #3875
  static telaVenceu + #16, #127
  static telaVenceu + #17, #127
  static telaVenceu + #18, #127
  static telaVenceu + #19, #2862
  static telaVenceu + #20, #127
  static telaVenceu + #21, #127
  static telaVenceu + #22, #127
  static telaVenceu + #23, #127
  static telaVenceu + #24, #127
  static telaVenceu + #25, #127
  static telaVenceu + #26, #127
  static telaVenceu + #27, #127
  static telaVenceu + #28, #3875
  static telaVenceu + #29, #3875
  static telaVenceu + #30, #127
  static telaVenceu + #31, #127
  static telaVenceu + #32, #3374
  static telaVenceu + #33, #127
  static telaVenceu + #34, #127
  static telaVenceu + #35, #127
  static telaVenceu + #36, #127
  static telaVenceu + #37, #127
  static telaVenceu + #38, #127
  static telaVenceu + #39, #127

  ;Linha 1
  static telaVenceu + #40, #127
  static telaVenceu + #41, #127
  static telaVenceu + #42, #127
  static telaVenceu + #43, #127
  static telaVenceu + #44, #127
  static telaVenceu + #45, #127
  static telaVenceu + #46, #127
  static telaVenceu + #47, #3963
  static telaVenceu + #48, #127
  static telaVenceu + #49, #127
  static telaVenceu + #50, #127
  static telaVenceu + #51, #127
  static telaVenceu + #52, #558
  static telaVenceu + #53, #127
  static telaVenceu + #54, #127
  static telaVenceu + #55, #3875
  static telaVenceu + #56, #3374
  static telaVenceu + #57, #127
  static telaVenceu + #58, #3875
  static telaVenceu + #59, #3875
  static telaVenceu + #60, #127
  static telaVenceu + #61, #127
  static telaVenceu + #62, #127
  static telaVenceu + #63, #2350
  static telaVenceu + #64, #127
  static telaVenceu + #65, #127
  static telaVenceu + #66, #127
  static telaVenceu + #67, #2862
  static telaVenceu + #68, #3875
  static telaVenceu + #69, #3875
  static telaVenceu + #70, #127
  static telaVenceu + #71, #127
  static telaVenceu + #72, #127
  static telaVenceu + #73, #127
  static telaVenceu + #74, #127
  static telaVenceu + #75, #127
  static telaVenceu + #76, #127
  static telaVenceu + #77, #127
  static telaVenceu + #78, #127
  static telaVenceu + #79, #127

  ;Linha 2
  static telaVenceu + #80, #127
  static telaVenceu + #81, #127
  static telaVenceu + #82, #127
  static telaVenceu + #83, #127
  static telaVenceu + #84, #127
  static telaVenceu + #85, #123
  static telaVenceu + #86, #123
  static telaVenceu + #87, #123
  static telaVenceu + #88, #127
  static telaVenceu + #89, #2350
  static telaVenceu + #90, #127
  static telaVenceu + #91, #127
  static telaVenceu + #92, #127
  static telaVenceu + #93, #127
  static telaVenceu + #94, #127
  static telaVenceu + #95, #3875
  static telaVenceu + #96, #127
  static telaVenceu + #97, #3875
  static telaVenceu + #98, #3875
  static telaVenceu + #99, #3875
  static telaVenceu + #100, #3875
  static telaVenceu + #101, #3875
  static telaVenceu + #102, #127
  static telaVenceu + #103, #127
  static telaVenceu + #104, #127
  static telaVenceu + #105, #127
  static telaVenceu + #106, #127
  static telaVenceu + #107, #3875
  static telaVenceu + #108, #3875
  static telaVenceu + #109, #3875
  static telaVenceu + #110, #3875
  static telaVenceu + #111, #127
  static telaVenceu + #112, #127
  static telaVenceu + #113, #127
  static telaVenceu + #114, #127
  static telaVenceu + #115, #127
  static telaVenceu + #116, #127
  static telaVenceu + #117, #2862
  static telaVenceu + #118, #127
  static telaVenceu + #119, #127

  ;Linha 3
  static telaVenceu + #120, #127
  static telaVenceu + #121, #127
  static telaVenceu + #122, #127
  static telaVenceu + #123, #127
  static telaVenceu + #124, #127
  static telaVenceu + #125, #123
  static telaVenceu + #126, #123
  static telaVenceu + #127, #123
  static telaVenceu + #128, #127
  static telaVenceu + #129, #127
  static telaVenceu + #130, #127
  static telaVenceu + #131, #3875
  static telaVenceu + #132, #2862
  static telaVenceu + #133, #3875
  static telaVenceu + #134, #2595
  static telaVenceu + #135, #3875
  static telaVenceu + #136, #3875
  static telaVenceu + #137, #2595
  static telaVenceu + #138, #3875
  static telaVenceu + #139, #3875
  static telaVenceu + #140, #2595
  static telaVenceu + #141, #2595
  static telaVenceu + #142, #3875
  static telaVenceu + #143, #3875
  static telaVenceu + #144, #3875
  static telaVenceu + #145, #2595
  static telaVenceu + #146, #2595
  static telaVenceu + #147, #2595
  static telaVenceu + #148, #3875
  static telaVenceu + #149, #2595
  static telaVenceu + #150, #2595
  static telaVenceu + #151, #2595
  static telaVenceu + #152, #127
  static telaVenceu + #153, #558
  static telaVenceu + #154, #127
  static telaVenceu + #155, #127
  static telaVenceu + #156, #127
  static telaVenceu + #157, #127
  static telaVenceu + #158, #127
  static telaVenceu + #159, #127

  ;Linha 4
  static telaVenceu + #160, #127
  static telaVenceu + #161, #127
  static telaVenceu + #162, #127
  static telaVenceu + #163, #127
  static telaVenceu + #164, #127
  static telaVenceu + #165, #123
  static telaVenceu + #166, #123
  static telaVenceu + #167, #123
  static telaVenceu + #168, #127
  static telaVenceu + #169, #127
  static telaVenceu + #170, #127
  static telaVenceu + #171, #3875
  static telaVenceu + #172, #3875
  static telaVenceu + #173, #3875
  static telaVenceu + #174, #2595
  static telaVenceu + #175, #3875
  static telaVenceu + #176, #127
  static telaVenceu + #177, #2595
  static telaVenceu + #178, #3875
  static telaVenceu + #179, #2595
  static telaVenceu + #180, #3875
  static telaVenceu + #181, #3875
  static telaVenceu + #182, #2595
  static telaVenceu + #183, #3875
  static telaVenceu + #184, #2595
  static telaVenceu + #185, #3875
  static telaVenceu + #186, #3875
  static telaVenceu + #187, #3875
  static telaVenceu + #188, #3875
  static telaVenceu + #189, #2595
  static telaVenceu + #190, #3875
  static telaVenceu + #191, #127
  static telaVenceu + #192, #127
  static telaVenceu + #193, #127
  static telaVenceu + #194, #127
  static telaVenceu + #195, #127
  static telaVenceu + #196, #127
  static telaVenceu + #197, #127
  static telaVenceu + #198, #127
  static telaVenceu + #199, #127

  ;Linha 5
  static telaVenceu + #200, #127
  static telaVenceu + #201, #127
  static telaVenceu + #202, #127
  static telaVenceu + #203, #127
  static telaVenceu + #204, #127
  static telaVenceu + #205, #127
  static telaVenceu + #206, #123
  static telaVenceu + #207, #123
  static telaVenceu + #208, #127
  static telaVenceu + #209, #127
  static telaVenceu + #210, #127
  static telaVenceu + #211, #3374
  static telaVenceu + #212, #3875
  static telaVenceu + #213, #3875
  static telaVenceu + #214, #2595
  static telaVenceu + #215, #3875
  static telaVenceu + #216, #3875
  static telaVenceu + #217, #2595
  static telaVenceu + #218, #3875
  static telaVenceu + #219, #2595
  static telaVenceu + #220, #3875
  static telaVenceu + #221, #3875
  static telaVenceu + #222, #2595
  static telaVenceu + #223, #3875
  static telaVenceu + #224, #2595
  static telaVenceu + #225, #3875
  static telaVenceu + #226, #3875
  static telaVenceu + #227, #3875
  static telaVenceu + #228, #3875
  static telaVenceu + #229, #2595
  static telaVenceu + #230, #2595
  static telaVenceu + #231, #2595
  static telaVenceu + #232, #127
  static telaVenceu + #233, #127
  static telaVenceu + #234, #2618
  static telaVenceu + #235, #2601
  static telaVenceu + #236, #127
  static telaVenceu + #237, #127
  static telaVenceu + #238, #127
  static telaVenceu + #239, #127

  ;Linha 6
  static telaVenceu + #240, #127
  static telaVenceu + #241, #127
  static telaVenceu + #242, #127
  static telaVenceu + #243, #127
  static telaVenceu + #244, #127
  static telaVenceu + #245, #127
  static telaVenceu + #246, #2427
  static telaVenceu + #247, #2427
  static telaVenceu + #248, #127
  static telaVenceu + #249, #127
  static telaVenceu + #250, #127
  static telaVenceu + #251, #3875
  static telaVenceu + #252, #3875
  static telaVenceu + #253, #3875
  static telaVenceu + #254, #2595
  static telaVenceu + #255, #3875
  static telaVenceu + #256, #3875
  static telaVenceu + #257, #2595
  static telaVenceu + #258, #3875
  static telaVenceu + #259, #2595
  static telaVenceu + #260, #3875
  static telaVenceu + #261, #3875
  static telaVenceu + #262, #2595
  static telaVenceu + #263, #3875
  static telaVenceu + #264, #2595
  static telaVenceu + #265, #3875
  static telaVenceu + #266, #3875
  static telaVenceu + #267, #3875
  static telaVenceu + #268, #3875
  static telaVenceu + #269, #2595
  static telaVenceu + #270, #3875
  static telaVenceu + #271, #127
  static telaVenceu + #272, #127
  static telaVenceu + #273, #127
  static telaVenceu + #274, #127
  static telaVenceu + #275, #127
  static telaVenceu + #276, #127
  static telaVenceu + #277, #127
  static telaVenceu + #278, #127
  static telaVenceu + #279, #127

  ;Linha 7
  static telaVenceu + #280, #127
  static telaVenceu + #281, #127
  static telaVenceu + #282, #127
  static telaVenceu + #283, #127
  static telaVenceu + #284, #127
  static telaVenceu + #285, #127
  static telaVenceu + #286, #635
  static telaVenceu + #287, #635
  static telaVenceu + #288, #127
  static telaVenceu + #289, #127
  static telaVenceu + #290, #127
  static telaVenceu + #291, #3875
  static telaVenceu + #292, #3875
  static telaVenceu + #293, #3875
  static telaVenceu + #294, #2595
  static telaVenceu + #295, #3875
  static telaVenceu + #296, #3875
  static telaVenceu + #297, #2595
  static telaVenceu + #298, #3875
  static telaVenceu + #299, #2595
  static telaVenceu + #300, #3875
  static telaVenceu + #301, #3875
  static telaVenceu + #302, #2595
  static telaVenceu + #303, #3875
  static telaVenceu + #304, #2595
  static telaVenceu + #305, #3875
  static telaVenceu + #306, #3875
  static telaVenceu + #307, #3875
  static telaVenceu + #308, #3875
  static telaVenceu + #309, #2595
  static telaVenceu + #310, #3875
  static telaVenceu + #311, #127
  static telaVenceu + #312, #127
  static telaVenceu + #313, #127
  static telaVenceu + #314, #127
  static telaVenceu + #315, #3118
  static telaVenceu + #316, #127
  static telaVenceu + #317, #127
  static telaVenceu + #318, #3374
  static telaVenceu + #319, #127

  ;Linha 8
  static telaVenceu + #320, #127
  static telaVenceu + #321, #127
  static telaVenceu + #322, #127
  static telaVenceu + #323, #127
  static telaVenceu + #324, #127
  static telaVenceu + #325, #127
  static telaVenceu + #326, #2939
  static telaVenceu + #327, #2939
  static telaVenceu + #328, #3118
  static telaVenceu + #329, #127
  static telaVenceu + #330, #127
  static telaVenceu + #331, #127
  static telaVenceu + #332, #2862
  static telaVenceu + #333, #3875
  static telaVenceu + #334, #3875
  static telaVenceu + #335, #2595
  static telaVenceu + #336, #2595
  static telaVenceu + #337, #3875
  static telaVenceu + #338, #3875
  static telaVenceu + #339, #3875
  static telaVenceu + #340, #2595
  static telaVenceu + #341, #2595
  static telaVenceu + #342, #3875
  static telaVenceu + #343, #3875
  static telaVenceu + #344, #3875
  static telaVenceu + #345, #2595
  static telaVenceu + #346, #2595
  static telaVenceu + #347, #2595
  static telaVenceu + #348, #3875
  static telaVenceu + #349, #2595
  static telaVenceu + #350, #2595
  static telaVenceu + #351, #2595
  static telaVenceu + #352, #127
  static telaVenceu + #353, #127
  static telaVenceu + #354, #127
  static telaVenceu + #355, #127
  static telaVenceu + #356, #127
  static telaVenceu + #357, #127
  static telaVenceu + #358, #127
  static telaVenceu + #359, #127

  ;Linha 9
  static telaVenceu + #360, #127
  static telaVenceu + #361, #127
  static telaVenceu + #362, #127
  static telaVenceu + #363, #127
  static telaVenceu + #364, #127
  static telaVenceu + #365, #127
  static telaVenceu + #366, #3451
  static telaVenceu + #367, #3451
  static telaVenceu + #368, #127
  static telaVenceu + #369, #127
  static telaVenceu + #370, #127
  static telaVenceu + #371, #3875
  static telaVenceu + #372, #3875
  static telaVenceu + #373, #3875
  static telaVenceu + #374, #3875
  static telaVenceu + #375, #3875
  static telaVenceu + #376, #127
  static telaVenceu + #377, #3875
  static telaVenceu + #378, #2862
  static telaVenceu + #379, #127
  static telaVenceu + #380, #127
  static telaVenceu + #381, #127
  static telaVenceu + #382, #3875
  static telaVenceu + #383, #2350
  static telaVenceu + #384, #127
  static telaVenceu + #385, #127
  static telaVenceu + #386, #127
  static telaVenceu + #387, #127
  static telaVenceu + #388, #127
  static telaVenceu + #389, #127
  static telaVenceu + #390, #3875
  static telaVenceu + #391, #127
  static telaVenceu + #392, #3875
  static telaVenceu + #393, #3875
  static telaVenceu + #394, #127
  static telaVenceu + #395, #127
  static telaVenceu + #396, #127
  static telaVenceu + #397, #127
  static telaVenceu + #398, #127
  static telaVenceu + #399, #3875

  ;Linha 10
  static telaVenceu + #400, #127
  static telaVenceu + #401, #127
  static telaVenceu + #402, #127
  static telaVenceu + #403, #127
  static telaVenceu + #404, #127
  static telaVenceu + #405, #127
  static telaVenceu + #406, #123
  static telaVenceu + #407, #123
  static telaVenceu + #408, #127
  static telaVenceu + #409, #127
  static telaVenceu + #410, #2595
  static telaVenceu + #411, #3875
  static telaVenceu + #412, #3875
  static telaVenceu + #413, #2595
  static telaVenceu + #414, #3875
  static telaVenceu + #415, #2595
  static telaVenceu + #416, #2595
  static telaVenceu + #417, #2595
  static telaVenceu + #418, #3875
  static telaVenceu + #419, #2595
  static telaVenceu + #420, #3875
  static telaVenceu + #421, #3875
  static telaVenceu + #422, #2595
  static telaVenceu + #423, #3875
  static telaVenceu + #424, #3875
  static telaVenceu + #425, #2595
  static telaVenceu + #426, #2595
  static telaVenceu + #427, #2595
  static telaVenceu + #428, #3875
  static telaVenceu + #429, #2595
  static telaVenceu + #430, #2595
  static telaVenceu + #431, #2595
  static telaVenceu + #432, #3875
  static telaVenceu + #433, #2595
  static telaVenceu + #434, #3875
  static telaVenceu + #435, #3875
  static telaVenceu + #436, #2595
  static telaVenceu + #437, #127
  static telaVenceu + #438, #127
  static telaVenceu + #439, #3875

  ;Linha 11
  static telaVenceu + #440, #127
  static telaVenceu + #441, #127
  static telaVenceu + #442, #127
  static telaVenceu + #443, #127
  static telaVenceu + #444, #127
  static telaVenceu + #445, #127
  static telaVenceu + #446, #123
  static telaVenceu + #447, #123
  static telaVenceu + #448, #127
  static telaVenceu + #449, #3875
  static telaVenceu + #450, #2595
  static telaVenceu + #451, #3875
  static telaVenceu + #452, #3875
  static telaVenceu + #453, #2595
  static telaVenceu + #454, #3875
  static telaVenceu + #455, #2595
  static telaVenceu + #456, #3875
  static telaVenceu + #457, #3875
  static telaVenceu + #458, #3875
  static telaVenceu + #459, #2595
  static telaVenceu + #460, #2595
  static telaVenceu + #461, #3875
  static telaVenceu + #462, #2595
  static telaVenceu + #463, #3875
  static telaVenceu + #464, #2595
  static telaVenceu + #465, #127
  static telaVenceu + #466, #3875
  static telaVenceu + #467, #3875
  static telaVenceu + #468, #3875
  static telaVenceu + #469, #2595
  static telaVenceu + #470, #127
  static telaVenceu + #471, #3875
  static telaVenceu + #472, #3875
  static telaVenceu + #473, #2595
  static telaVenceu + #474, #3875
  static telaVenceu + #475, #3875
  static telaVenceu + #476, #2595
  static telaVenceu + #477, #127
  static telaVenceu + #478, #2350
  static telaVenceu + #479, #3875

  ;Linha 12
  static telaVenceu + #480, #127
  static telaVenceu + #481, #127
  static telaVenceu + #482, #127
  static telaVenceu + #483, #127
  static telaVenceu + #484, #127
  static telaVenceu + #485, #127
  static telaVenceu + #486, #123
  static telaVenceu + #487, #123
  static telaVenceu + #488, #127
  static telaVenceu + #489, #3875
  static telaVenceu + #490, #2595
  static telaVenceu + #491, #3875
  static telaVenceu + #492, #3875
  static telaVenceu + #493, #2595
  static telaVenceu + #494, #3875
  static telaVenceu + #495, #2595
  static telaVenceu + #496, #2595
  static telaVenceu + #497, #2595
  static telaVenceu + #498, #3875
  static telaVenceu + #499, #2595
  static telaVenceu + #500, #2595
  static telaVenceu + #501, #2595
  static telaVenceu + #502, #2595
  static telaVenceu + #503, #3875
  static telaVenceu + #504, #2595
  static telaVenceu + #505, #127
  static telaVenceu + #506, #3875
  static telaVenceu + #507, #3875
  static telaVenceu + #508, #127
  static telaVenceu + #509, #2595
  static telaVenceu + #510, #2595
  static telaVenceu + #511, #2595
  static telaVenceu + #512, #3875
  static telaVenceu + #513, #2595
  static telaVenceu + #514, #3875
  static telaVenceu + #515, #127
  static telaVenceu + #516, #2595
  static telaVenceu + #517, #127
  static telaVenceu + #518, #127
  static telaVenceu + #519, #3875

  ;Linha 13
  static telaVenceu + #520, #127
  static telaVenceu + #521, #127
  static telaVenceu + #522, #127
  static telaVenceu + #523, #127
  static telaVenceu + #524, #127
  static telaVenceu + #525, #127
  static telaVenceu + #526, #123
  static telaVenceu + #527, #123
  static telaVenceu + #528, #127
  static telaVenceu + #529, #3875
  static telaVenceu + #530, #2595
  static telaVenceu + #531, #3875
  static telaVenceu + #532, #3875
  static telaVenceu + #533, #2595
  static telaVenceu + #534, #3875
  static telaVenceu + #535, #2595
  static telaVenceu + #536, #3875
  static telaVenceu + #537, #3875
  static telaVenceu + #538, #3875
  static telaVenceu + #539, #2595
  static telaVenceu + #540, #3875
  static telaVenceu + #541, #2595
  static telaVenceu + #542, #2595
  static telaVenceu + #543, #3875
  static telaVenceu + #544, #2595
  static telaVenceu + #545, #127
  static telaVenceu + #546, #3875
  static telaVenceu + #547, #3875
  static telaVenceu + #548, #127
  static telaVenceu + #549, #2595
  static telaVenceu + #550, #127
  static telaVenceu + #551, #3875
  static telaVenceu + #552, #3875
  static telaVenceu + #553, #2595
  static telaVenceu + #554, #127
  static telaVenceu + #555, #127
  static telaVenceu + #556, #2595
  static telaVenceu + #557, #127
  static telaVenceu + #558, #127
  static telaVenceu + #559, #3875

  ;Linha 14
  static telaVenceu + #560, #127
  static telaVenceu + #561, #127
  static telaVenceu + #562, #127
  static telaVenceu + #563, #127
  static telaVenceu + #564, #127
  static telaVenceu + #565, #127
  static telaVenceu + #566, #123
  static telaVenceu + #567, #123
  static telaVenceu + #568, #127
  static telaVenceu + #569, #3875
  static telaVenceu + #570, #2595
  static telaVenceu + #571, #3875
  static telaVenceu + #572, #3875
  static telaVenceu + #573, #2595
  static telaVenceu + #574, #3875
  static telaVenceu + #575, #2595
  static telaVenceu + #576, #3875
  static telaVenceu + #577, #3875
  static telaVenceu + #578, #127
  static telaVenceu + #579, #2595
  static telaVenceu + #580, #127
  static telaVenceu + #581, #2595
  static telaVenceu + #582, #2595
  static telaVenceu + #583, #3875
  static telaVenceu + #584, #2595
  static telaVenceu + #585, #127
  static telaVenceu + #586, #3875
  static telaVenceu + #587, #3875
  static telaVenceu + #588, #3875
  static telaVenceu + #589, #2595
  static telaVenceu + #590, #127
  static telaVenceu + #591, #3875
  static telaVenceu + #592, #3875
  static telaVenceu + #593, #2595
  static telaVenceu + #594, #3875
  static telaVenceu + #595, #3875
  static telaVenceu + #596, #2595
  static telaVenceu + #597, #3875
  static telaVenceu + #598, #3875
  static telaVenceu + #599, #2862

  ;Linha 15
  static telaVenceu + #600, #127
  static telaVenceu + #601, #127
  static telaVenceu + #602, #127
  static telaVenceu + #603, #127
  static telaVenceu + #604, #127
  static telaVenceu + #605, #127
  static telaVenceu + #606, #123
  static telaVenceu + #607, #123
  static telaVenceu + #608, #127
  static telaVenceu + #609, #3875
  static telaVenceu + #610, #3875
  static telaVenceu + #611, #2595
  static telaVenceu + #612, #2595
  static telaVenceu + #613, #3875
  static telaVenceu + #614, #3875
  static telaVenceu + #615, #2595
  static telaVenceu + #616, #2595
  static telaVenceu + #617, #2595
  static telaVenceu + #618, #3875
  static telaVenceu + #619, #2595
  static telaVenceu + #620, #3875
  static telaVenceu + #621, #3875
  static telaVenceu + #622, #2595
  static telaVenceu + #623, #127
  static telaVenceu + #624, #3875
  static telaVenceu + #625, #2595
  static telaVenceu + #626, #2595
  static telaVenceu + #627, #2595
  static telaVenceu + #628, #3875
  static telaVenceu + #629, #2595
  static telaVenceu + #630, #2595
  static telaVenceu + #631, #2595
  static telaVenceu + #632, #3875
  static telaVenceu + #633, #3875
  static telaVenceu + #634, #2595
  static telaVenceu + #635, #2595
  static telaVenceu + #636, #127
  static telaVenceu + #637, #3875
  static telaVenceu + #638, #3875
  static telaVenceu + #639, #127

  ;Linha 16
  static telaVenceu + #640, #127
  static telaVenceu + #641, #127
  static telaVenceu + #642, #127
  static telaVenceu + #643, #127
  static telaVenceu + #644, #127
  static telaVenceu + #645, #127
  static telaVenceu + #646, #123
  static telaVenceu + #647, #123
  static telaVenceu + #648, #127
  static telaVenceu + #649, #3875
  static telaVenceu + #650, #3875
  static telaVenceu + #651, #127
  static telaVenceu + #652, #127
  static telaVenceu + #653, #127
  static telaVenceu + #654, #127
  static telaVenceu + #655, #127
  static telaVenceu + #656, #127
  static telaVenceu + #657, #127
  static telaVenceu + #658, #127
  static telaVenceu + #659, #127
  static telaVenceu + #660, #127
  static telaVenceu + #661, #127
  static telaVenceu + #662, #127
  static telaVenceu + #663, #127
  static telaVenceu + #664, #127
  static telaVenceu + #665, #127
  static telaVenceu + #666, #127
  static telaVenceu + #667, #2862
  static telaVenceu + #668, #127
  static telaVenceu + #669, #127
  static telaVenceu + #670, #127
  static telaVenceu + #671, #127
  static telaVenceu + #672, #127
  static telaVenceu + #673, #127
  static telaVenceu + #674, #127
  static telaVenceu + #675, #127
  static telaVenceu + #676, #127
  static telaVenceu + #677, #3875
  static telaVenceu + #678, #3875
  static telaVenceu + #679, #127

  ;Linha 17
  static telaVenceu + #680, #127
  static telaVenceu + #681, #127
  static telaVenceu + #682, #127
  static telaVenceu + #683, #127
  static telaVenceu + #684, #127
  static telaVenceu + #685, #127
  static telaVenceu + #686, #123
  static telaVenceu + #687, #123
  static telaVenceu + #688, #127
  static telaVenceu + #689, #127
  static telaVenceu + #690, #127
  static telaVenceu + #691, #127
  static telaVenceu + #692, #127
  static telaVenceu + #693, #127
  static telaVenceu + #694, #2862
  static telaVenceu + #695, #127
  static telaVenceu + #696, #127
  static telaVenceu + #697, #127
  static telaVenceu + #698, #2862
  static telaVenceu + #699, #127
  static telaVenceu + #700, #127
  static telaVenceu + #701, #127
  static telaVenceu + #702, #3374
  static telaVenceu + #703, #127
  static telaVenceu + #704, #127
  static telaVenceu + #705, #127
  static telaVenceu + #706, #127
  static telaVenceu + #707, #127
  static telaVenceu + #708, #127
  static telaVenceu + #709, #127
  static telaVenceu + #710, #127
  static telaVenceu + #711, #127
  static telaVenceu + #712, #127
  static telaVenceu + #713, #127
  static telaVenceu + #714, #127
  static telaVenceu + #715, #127
  static telaVenceu + #716, #127
  static telaVenceu + #717, #127
  static telaVenceu + #718, #127
  static telaVenceu + #719, #127

  ;Linha 18
  static telaVenceu + #720, #127
  static telaVenceu + #721, #127
  static telaVenceu + #722, #127
  static telaVenceu + #723, #3195
  static telaVenceu + #724, #127
  static telaVenceu + #725, #127
  static telaVenceu + #726, #123
  static telaVenceu + #727, #123
  static telaVenceu + #728, #127
  static telaVenceu + #729, #127
  static telaVenceu + #730, #3195
  static telaVenceu + #731, #127
  static telaVenceu + #732, #127
  static telaVenceu + #733, #127
  static telaVenceu + #734, #127
  static telaVenceu + #735, #127
  static telaVenceu + #736, #127
  static telaVenceu + #737, #127
  static telaVenceu + #738, #127
  static telaVenceu + #739, #127
  static telaVenceu + #740, #127
  static telaVenceu + #741, #127
  static telaVenceu + #742, #127
  static telaVenceu + #743, #127
  static telaVenceu + #744, #127
  static telaVenceu + #745, #127
  static telaVenceu + #746, #127
  static telaVenceu + #747, #127
  static telaVenceu + #748, #127
  static telaVenceu + #749, #127
  static telaVenceu + #750, #127
  static telaVenceu + #751, #127
  static telaVenceu + #752, #127
  static telaVenceu + #753, #127
  static telaVenceu + #754, #3374
  static telaVenceu + #755, #127
  static telaVenceu + #756, #127
  static telaVenceu + #757, #127
  static telaVenceu + #758, #127
  static telaVenceu + #759, #127

  ;Linha 19
  static telaVenceu + #760, #127
  static telaVenceu + #761, #127
  static telaVenceu + #762, #3195
  static telaVenceu + #763, #3195
  static telaVenceu + #764, #3195
  static telaVenceu + #765, #127
  static telaVenceu + #766, #123
  static telaVenceu + #767, #123
  static telaVenceu + #768, #127
  static telaVenceu + #769, #3195
  static telaVenceu + #770, #3195
  static telaVenceu + #771, #3195
  static telaVenceu + #772, #127
  static telaVenceu + #773, #127
  static telaVenceu + #774, #127
  static telaVenceu + #775, #127
  static telaVenceu + #776, #558
  static telaVenceu + #777, #127
  static telaVenceu + #778, #127
  static telaVenceu + #779, #127
  static telaVenceu + #780, #127
  static telaVenceu + #781, #127
  static telaVenceu + #782, #127
  static telaVenceu + #783, #127
  static telaVenceu + #784, #127
  static telaVenceu + #785, #127
  static telaVenceu + #786, #127
  static telaVenceu + #787, #127
  static telaVenceu + #788, #127
  static telaVenceu + #789, #127
  static telaVenceu + #790, #3118
  static telaVenceu + #791, #127
  static telaVenceu + #792, #127
  static telaVenceu + #793, #127
  static telaVenceu + #794, #127
  static telaVenceu + #795, #127
  static telaVenceu + #796, #127
  static telaVenceu + #797, #127
  static telaVenceu + #798, #127
  static telaVenceu + #799, #127

  ;Linha 20
  static telaVenceu + #800, #127
  static telaVenceu + #801, #127
  static telaVenceu + #802, #3195
  static telaVenceu + #803, #3195
  static telaVenceu + #804, #123
  static telaVenceu + #805, #123
  static telaVenceu + #806, #123
  static telaVenceu + #807, #123
  static telaVenceu + #808, #123
  static telaVenceu + #809, #123
  static telaVenceu + #810, #123
  static telaVenceu + #811, #3195
  static telaVenceu + #812, #127
  static telaVenceu + #813, #127
  static telaVenceu + #814, #127
  static telaVenceu + #815, #127
  static telaVenceu + #816, #127
  static telaVenceu + #817, #127
  static telaVenceu + #818, #127
  static telaVenceu + #819, #127
  static telaVenceu + #820, #3933
  static telaVenceu + #821, #3933
  static telaVenceu + #822, #127
  static telaVenceu + #823, #127
  static telaVenceu + #824, #3933
  static telaVenceu + #825, #3933
  static telaVenceu + #826, #3933
  static telaVenceu + #827, #3933
  static telaVenceu + #828, #3933
  static telaVenceu + #829, #3933
  static telaVenceu + #830, #3933
  static telaVenceu + #831, #3933
  static telaVenceu + #832, #127
  static telaVenceu + #833, #127
  static telaVenceu + #834, #127
  static telaVenceu + #835, #127
  static telaVenceu + #836, #127
  static telaVenceu + #837, #127
  static telaVenceu + #838, #127
  static telaVenceu + #839, #127

  ;Linha 21
  static telaVenceu + #840, #127
  static telaVenceu + #841, #127
  static telaVenceu + #842, #127
  static telaVenceu + #843, #3195
  static telaVenceu + #844, #3195
  static telaVenceu + #845, #123
  static telaVenceu + #846, #123
  static telaVenceu + #847, #127
  static telaVenceu + #848, #123
  static telaVenceu + #849, #123
  static telaVenceu + #850, #3195
  static telaVenceu + #851, #3195
  static telaVenceu + #852, #127
  static telaVenceu + #853, #127
  static telaVenceu + #854, #127
  static telaVenceu + #855, #127
  static telaVenceu + #856, #127
  static telaVenceu + #857, #127
  static telaVenceu + #858, #127
  static telaVenceu + #859, #2896
  static telaVenceu + #860, #2913
  static telaVenceu + #861, #2930
  static telaVenceu + #862, #2913
  static telaVenceu + #863, #3933
  static telaVenceu + #864, #2898
  static telaVenceu + #865, #2917
  static telaVenceu + #866, #2921
  static telaVenceu + #867, #2926
  static telaVenceu + #868, #2921
  static telaVenceu + #869, #2915
  static telaVenceu + #870, #2921
  static telaVenceu + #871, #2913
  static telaVenceu + #872, #2930
  static telaVenceu + #873, #127
  static telaVenceu + #874, #127
  static telaVenceu + #875, #127
  static telaVenceu + #876, #127
  static telaVenceu + #877, #127
  static telaVenceu + #878, #127
  static telaVenceu + #879, #127

  ;Linha 22
  static telaVenceu + #880, #127
  static telaVenceu + #881, #127
  static telaVenceu + #882, #127
  static telaVenceu + #883, #3195
  static telaVenceu + #884, #3195
  static telaVenceu + #885, #123
  static telaVenceu + #886, #123
  static telaVenceu + #887, #127
  static telaVenceu + #888, #123
  static telaVenceu + #889, #123
  static telaVenceu + #890, #3195
  static telaVenceu + #891, #127
  static telaVenceu + #892, #127
  static telaVenceu + #893, #127
  static telaVenceu + #894, #127
  static telaVenceu + #895, #127
  static telaVenceu + #896, #127
  static telaVenceu + #897, #127
  static telaVenceu + #898, #2878
  static telaVenceu + #899, #2878
  static telaVenceu + #900, #127
  static telaVenceu + #901, #3967
  static telaVenceu + #902, #3967
  static telaVenceu + #903, #2885
  static telaVenceu + #904, #2931
  static telaVenceu + #905, #2928
  static telaVenceu + #906, #2913
  static telaVenceu + #907, #2915
  static telaVenceu + #908, #2927
  static telaVenceu + #909, #127
  static telaVenceu + #910, #127
  static telaVenceu + #911, #127
  static telaVenceu + #912, #2876
  static telaVenceu + #913, #2876
  static telaVenceu + #914, #127
  static telaVenceu + #915, #127
  static telaVenceu + #916, #127
  static telaVenceu + #917, #127
  static telaVenceu + #918, #127
  static telaVenceu + #919, #127

  ;Linha 23
  static telaVenceu + #920, #127
  static telaVenceu + #921, #127
  static telaVenceu + #922, #127
  static telaVenceu + #923, #3195
  static telaVenceu + #924, #3195
  static telaVenceu + #925, #123
  static telaVenceu + #926, #123
  static telaVenceu + #927, #127
  static telaVenceu + #928, #123
  static telaVenceu + #929, #123
  static telaVenceu + #930, #3195
  static telaVenceu + #931, #127
  static telaVenceu + #932, #127
  static telaVenceu + #933, #127
  static telaVenceu + #934, #127
  static telaVenceu + #935, #127
  static telaVenceu + #936, #127
  static telaVenceu + #937, #127
  static telaVenceu + #938, #127
  static telaVenceu + #939, #127
  static telaVenceu + #940, #127
  static telaVenceu + #941, #127
  static telaVenceu + #942, #127
  static telaVenceu + #943, #3967
  static telaVenceu + #944, #3967
  static telaVenceu + #945, #3967
  static telaVenceu + #946, #3967
  static telaVenceu + #947, #127
  static telaVenceu + #948, #127
  static telaVenceu + #949, #127
  static telaVenceu + #950, #127
  static telaVenceu + #951, #127
  static telaVenceu + #952, #2431
  static telaVenceu + #953, #127
  static telaVenceu + #954, #127
  static telaVenceu + #955, #127
  static telaVenceu + #956, #127
  static telaVenceu + #957, #127
  static telaVenceu + #958, #127
  static telaVenceu + #959, #127

  ;Linha 24
  static telaVenceu + #960, #127
  static telaVenceu + #961, #127
  static telaVenceu + #962, #3195
  static telaVenceu + #963, #3195
  static telaVenceu + #964, #3195
  static telaVenceu + #965, #123
  static telaVenceu + #966, #123
  static telaVenceu + #967, #123
  static telaVenceu + #968, #123
  static telaVenceu + #969, #123
  static telaVenceu + #970, #3195
  static telaVenceu + #971, #3195
  static telaVenceu + #972, #127
  static telaVenceu + #973, #127
  static telaVenceu + #974, #127
  static telaVenceu + #975, #127
  static telaVenceu + #976, #127
  static telaVenceu + #977, #127
  static telaVenceu + #978, #127
  static telaVenceu + #979, #127
  static telaVenceu + #980, #127
  static telaVenceu + #981, #127
  static telaVenceu + #982, #127
  static telaVenceu + #983, #127
  static telaVenceu + #984, #127
  static telaVenceu + #985, #127
  static telaVenceu + #986, #127
  static telaVenceu + #987, #127
  static telaVenceu + #988, #127
  static telaVenceu + #989, #127
  static telaVenceu + #990, #127
  static telaVenceu + #991, #127
  static telaVenceu + #992, #127
  static telaVenceu + #993, #127
  static telaVenceu + #994, #127
  static telaVenceu + #995, #127
  static telaVenceu + #996, #127
  static telaVenceu + #997, #127
  static telaVenceu + #998, #127
  static telaVenceu + #999, #127

  ;Linha 25
  static telaVenceu + #1000, #127
  static telaVenceu + #1001, #127
  static telaVenceu + #1002, #3195
  static telaVenceu + #1003, #3195
  static telaVenceu + #1004, #123
  static telaVenceu + #1005, #123
  static telaVenceu + #1006, #3195
  static telaVenceu + #1007, #3195
  static telaVenceu + #1008, #3195
  static telaVenceu + #1009, #123
  static telaVenceu + #1010, #123
  static telaVenceu + #1011, #3195
  static telaVenceu + #1012, #127
  static telaVenceu + #1013, #127
  static telaVenceu + #1014, #127
  static telaVenceu + #1015, #127
  static telaVenceu + #1016, #127
  static telaVenceu + #1017, #127
  static telaVenceu + #1018, #127
  static telaVenceu + #1019, #127
  static telaVenceu + #1020, #127
  static telaVenceu + #1021, #127
  static telaVenceu + #1022, #127
  static telaVenceu + #1023, #127
  static telaVenceu + #1024, #127
  static telaVenceu + #1025, #127
  static telaVenceu + #1026, #127
  static telaVenceu + #1027, #127
  static telaVenceu + #1028, #127
  static telaVenceu + #1029, #127
  static telaVenceu + #1030, #127
  static telaVenceu + #1031, #127
  static telaVenceu + #1032, #127
  static telaVenceu + #1033, #127
  static telaVenceu + #1034, #127
  static telaVenceu + #1035, #127
  static telaVenceu + #1036, #127
  static telaVenceu + #1037, #127
  static telaVenceu + #1038, #127
  static telaVenceu + #1039, #127

  ;Linha 26
  static telaVenceu + #1040, #127
  static telaVenceu + #1041, #127
  static telaVenceu + #1042, #3195
  static telaVenceu + #1043, #3195
  static telaVenceu + #1044, #3195
  static telaVenceu + #1045, #3195
  static telaVenceu + #1046, #3195
  static telaVenceu + #1047, #3963
  static telaVenceu + #1048, #3195
  static telaVenceu + #1049, #3195
  static telaVenceu + #1050, #3195
  static telaVenceu + #1051, #3195
  static telaVenceu + #1052, #127
  static telaVenceu + #1053, #127
  static telaVenceu + #1054, #127
  static telaVenceu + #1055, #127
  static telaVenceu + #1056, #127
  static telaVenceu + #1057, #127
  static telaVenceu + #1058, #127
  static telaVenceu + #1059, #127
  static telaVenceu + #1060, #127
  static telaVenceu + #1061, #127
  static telaVenceu + #1062, #127
  static telaVenceu + #1063, #127
  static telaVenceu + #1064, #127
  static telaVenceu + #1065, #127
  static telaVenceu + #1066, #127
  static telaVenceu + #1067, #127
  static telaVenceu + #1068, #127
  static telaVenceu + #1069, #127
  static telaVenceu + #1070, #127
  static telaVenceu + #1071, #127
  static telaVenceu + #1072, #127
  static telaVenceu + #1073, #127
  static telaVenceu + #1074, #127
  static telaVenceu + #1075, #127
  static telaVenceu + #1076, #127
  static telaVenceu + #1077, #127
  static telaVenceu + #1078, #127
  static telaVenceu + #1079, #127

  ;Linha 27
  static telaVenceu + #1080, #127
  static telaVenceu + #1081, #127
  static telaVenceu + #1082, #127
  static telaVenceu + #1083, #3195
  static telaVenceu + #1084, #3195
  static telaVenceu + #1085, #3195
  static telaVenceu + #1086, #3195
  static telaVenceu + #1087, #3195
  static telaVenceu + #1088, #127
  static telaVenceu + #1089, #3195
  static telaVenceu + #1090, #127
  static telaVenceu + #1091, #3195
  static telaVenceu + #1092, #127
  static telaVenceu + #1093, #127
  static telaVenceu + #1094, #127
  static telaVenceu + #1095, #127
  static telaVenceu + #1096, #127
  static telaVenceu + #1097, #127
  static telaVenceu + #1098, #127
  static telaVenceu + #1099, #127
  static telaVenceu + #1100, #127
  static telaVenceu + #1101, #127
  static telaVenceu + #1102, #127
  static telaVenceu + #1103, #127
  static telaVenceu + #1104, #127
  static telaVenceu + #1105, #127
  static telaVenceu + #1106, #127
  static telaVenceu + #1107, #127
  static telaVenceu + #1108, #127
  static telaVenceu + #1109, #127
  static telaVenceu + #1110, #127
  static telaVenceu + #1111, #127
  static telaVenceu + #1112, #127
  static telaVenceu + #1113, #127
  static telaVenceu + #1114, #127
  static telaVenceu + #1115, #127
  static telaVenceu + #1116, #127
  static telaVenceu + #1117, #127
  static telaVenceu + #1118, #127
  static telaVenceu + #1119, #127

  ;Linha 28
  static telaVenceu + #1120, #127
  static telaVenceu + #1121, #127
  static telaVenceu + #1122, #127
  static telaVenceu + #1123, #127
  static telaVenceu + #1124, #3195
  static telaVenceu + #1125, #3195
  static telaVenceu + #1126, #3195
  static telaVenceu + #1127, #3195
  static telaVenceu + #1128, #3195
  static telaVenceu + #1129, #3195
  static telaVenceu + #1130, #3195
  static telaVenceu + #1131, #127
  static telaVenceu + #1132, #127
  static telaVenceu + #1133, #127
  static telaVenceu + #1134, #127
  static telaVenceu + #1135, #127
  static telaVenceu + #1136, #127
  static telaVenceu + #1137, #127
  static telaVenceu + #1138, #127
  static telaVenceu + #1139, #127
  static telaVenceu + #1140, #127
  static telaVenceu + #1141, #127
  static telaVenceu + #1142, #127
  static telaVenceu + #1143, #127
  static telaVenceu + #1144, #127
  static telaVenceu + #1145, #127
  static telaVenceu + #1146, #127
  static telaVenceu + #1147, #127
  static telaVenceu + #1148, #127
  static telaVenceu + #1149, #127
  static telaVenceu + #1150, #127
  static telaVenceu + #1151, #127
  static telaVenceu + #1152, #127
  static telaVenceu + #1153, #127
  static telaVenceu + #1154, #127
  static telaVenceu + #1155, #127
  static telaVenceu + #1156, #127
  static telaVenceu + #1157, #127
  static telaVenceu + #1158, #127
  static telaVenceu + #1159, #127

  ;Linha 29
  static telaVenceu + #1160, #127
  static telaVenceu + #1161, #127
  static telaVenceu + #1162, #127
  static telaVenceu + #1163, #127
  static telaVenceu + #1164, #127
  static telaVenceu + #1165, #127
  static telaVenceu + #1166, #127
  static telaVenceu + #1167, #127
  static telaVenceu + #1168, #127
  static telaVenceu + #1169, #127
  static telaVenceu + #1170, #127
  static telaVenceu + #1171, #127
  static telaVenceu + #1172, #127
  static telaVenceu + #1173, #127
  static telaVenceu + #1174, #127
  static telaVenceu + #1175, #127
  static telaVenceu + #1176, #127
  static telaVenceu + #1177, #127
  static telaVenceu + #1178, #127
  static telaVenceu + #1179, #127
  static telaVenceu + #1180, #127
  static telaVenceu + #1181, #127
  static telaVenceu + #1182, #127
  static telaVenceu + #1183, #127
  static telaVenceu + #1184, #127
  static telaVenceu + #1185, #127
  static telaVenceu + #1186, #127
  static telaVenceu + #1187, #127
  static telaVenceu + #1188, #127
  static telaVenceu + #1189, #127
  static telaVenceu + #1190, #127
  static telaVenceu + #1191, #127
  static telaVenceu + #1192, #127
  static telaVenceu + #1193, #127
  static telaVenceu + #1194, #127
  static telaVenceu + #1195, #127
  static telaVenceu + #1196, #127
  static telaVenceu + #1197, #127
  static telaVenceu + #1198, #127
  static telaVenceu + #1199, #127

printtelaVenceuScreen:
  push R0
  push R1
  push R2
  push R3

  loadn R0, #telaVenceu
  loadn R1, #0
  loadn R2, #1200

  printtelaVenceuScreenLoop:

    add R3,R0,R1
    loadi R3, R3
    outchar R3, R1
    inc R1
    cmp R1, R2

    jne printtelaVenceuScreenLoop

  pop R3
  pop R2
  pop R1
  pop R0
  rts

;------------------------------------------------------------ FIM :) ---------------------------------------------------------

