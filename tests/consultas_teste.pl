% =========================================================
% CONSULTAS DE TESTE - CURRICULUM ADVISOR
% =========================================================
%
% As consultas foram organizadas por camada e devem ser
% executadas individualmente.
%
% Para carregar:
%   swipl -s tests/consultas_teste.pl
%
% Para visualizar as consultas:
%   ?- consultas_disponiveis.
%
% Exemplo:
%   ?- consulta_01_disciplinas_periodo.
%
% =========================================================

:- ensure_loaded('../src/main.pl').

% Biblioteca padrao do SWI-Prolog utilizada para limitar a quantidade de respostas.
:- use_module(
    library(solution_sequences),
    [
        limit/2,
        findnsols/4
    ]
).


% =========================================================
% MENU DAS CONSULTAS
% =========================================================

consultas_disponiveis :-
    writeln('================================================='),
    writeln('              CONSULTAS DISPONIVEIS              '),
    writeln('================================================='),
    nl,

    writeln('CAMADA 1 - BASE DE FATOS'),
    writeln('  consulta_01_disciplinas_periodo.'),
    writeln('  consulta_02_quantidade_disciplinas.'),
    writeln('  consulta_03_periodos_cadastrados.'),
    writeln('  consulta_04_alunos_cadastrados.'),
    nl,

    writeln('CAMADA 2 - ELEGIBILIDADE'),
    writeln('  consulta_05_liberadas_ana.'),
    writeln('  consulta_06_liberadas_bruno.'),
    writeln('  consulta_07_liberadas_carla.'),
    writeln('  consulta_08_pendentes_ana.'),
    writeln('  consulta_09_pendentes_bruno.'),
    writeln('  consulta_10_pendentes_carla.'),
    writeln('  consulta_11_negacao_por_falha.'),
    writeln('  consulta_12_creditos_alunos.'),
    nl,

    writeln('CAMADA 3 - RECURSAO E TRILHAS'),
    writeln('  consulta_13_fecho_transitivo.'),
    writeln('  consulta_14_verificar_ciclos.'),
    writeln('  consulta_15_trilha_ana.'),
    writeln('  consulta_16_trilha_bruno.'),
    writeln('  consulta_17_trilha_carla.'),
    writeln('  consulta_18_multiplas_trilhas.'),
    writeln('  consulta_19_multiplas_trilhas_findall.'),
    nl,

    writeln('TRATAMENTO DE ERROS'),
    writeln('  consulta_20_limite_invalido.'),
    writeln('  consulta_21_aluno_inexistente.'),
    writeln('  consulta_22_disciplina_inexistente.'),
    nl,

    writeln('DEMONSTRACAO GERAL'),
    writeln('  demo.'),
    nl,

    writeln('=================================================').


% =========================================================
% CAMADA 1: BASE DE FATOS
% =========================================================

% ---------------------------------------------------------
% CONSULTA 01
%
% Lista as disciplinas do 5o periodo.
%
% Resultado esperado:
% 5 disciplinas.
% ---------------------------------------------------------

consulta_01_disciplinas_periodo :-
    findall(
        Disciplina,
        disciplina(
            Disciplina,
            _,
            _,
            5
        ),
        Lista
    ),

    length(
        Lista,
        Quantidade
    ),

    writeln('Disciplinas do 5o periodo:'),

    imprimir_lista_teste(Lista),

    format(
        'Quantidade encontrada: ~w~n',
        [Quantidade]
    ),

    writeln('Resultado esperado: 5 disciplinas.').


% ---------------------------------------------------------
% CONSULTA 02
%
% Conta todas as disciplinas cadastradas.
%
% Resultado esperado:
% 35 disciplinas.
% ---------------------------------------------------------

consulta_02_quantidade_disciplinas :-
    findall(
        Disciplina,
        disciplina(
            Disciplina,
            _,
            _,
            _
        ),
        Lista
    ),

    length(
        Lista,
        Quantidade
    ),

    format(
        'Quantidade de disciplinas: ~w~n',
        [Quantidade]
    ),

    writeln('Resultado esperado: 35 disciplinas.').


% ---------------------------------------------------------
% CONSULTA 03
%
% Lista todos os periodos cadastrados.
%
% Resultado esperado:
% [1,2,3,4,5,6]
% ---------------------------------------------------------

consulta_03_periodos_cadastrados :-
    setof(
        Semestre,
        Disciplina^Tipo^Creditos^
        disciplina(
            Disciplina,
            Tipo,
            Creditos,
            Semestre
        ),
        Semestres
    ),

    format(
        'Periodos cadastrados: ~w~n',
        [Semestres]
    ),

    writeln('Resultado esperado: [1,2,3,4,5,6].').


% ---------------------------------------------------------
% CONSULTA 04
%
% Lista os alunos ficticios cadastrados.
%
% Resultado esperado:
% [ana,bruno,carla]
% ---------------------------------------------------------

consulta_04_alunos_cadastrados :-
    setof(
        Aluno,
        Disciplina^cursou(
            Aluno,
            Disciplina
        ),
        Alunos
    ),

    format(
        'Alunos cadastrados: ~w~n',
        [Alunos]
    ),

    writeln('Resultado esperado: [ana,bruno,carla].').


% =========================================================
% CAMADA 2: DISCIPLINAS LIBERADAS
% =========================================================

% ---------------------------------------------------------
% CONSULTA 05
%
% Lista as disciplinas liberadas para Ana.
% ---------------------------------------------------------

consulta_05_liberadas_ana :-
    once(
        disciplinas_liberadas(
            ana,
            Lista
        )
    ),

    writeln('Disciplinas liberadas para Ana:'),

    imprimir_lista_teste(Lista).


% ---------------------------------------------------------
% CONSULTA 06
%
% Lista as disciplinas liberadas para Bruno.
% ---------------------------------------------------------

consulta_06_liberadas_bruno :-
    once(
        disciplinas_liberadas(
            bruno,
            Lista
        )
    ),

    writeln('Disciplinas liberadas para Bruno:'),

    imprimir_lista_teste(Lista).


% ---------------------------------------------------------
% CONSULTA 07
%
% Lista as disciplinas liberadas para Carla.
% ---------------------------------------------------------

consulta_07_liberadas_carla :-
    once(
        disciplinas_liberadas(
            carla,
            Lista
        )
    ),

    writeln('Disciplinas liberadas para Carla:'),

    imprimir_lista_teste(Lista).


% =========================================================
% CAMADA 2: DISCIPLINAS PENDENTES
% =========================================================

% ---------------------------------------------------------
% CONSULTA 08
%
% Resultado esperado:
% Ana possui 14 obrigatorias pendentes.
% ---------------------------------------------------------

consulta_08_pendentes_ana :-
    once(
        disciplinas_pendentes(
            ana,
            Lista
        )
    ),

    length(
        Lista,
        Quantidade
    ),

    writeln('Disciplinas pendentes de Ana:'),

    imprimir_lista_teste(Lista),

    format(
        'Quantidade: ~w~n',
        [Quantidade]
    ),

    writeln('Resultado esperado: 14.').


% ---------------------------------------------------------
% CONSULTA 09
%
% Resultado esperado:
% Bruno possui 23 obrigatorias pendentes.
% ---------------------------------------------------------

consulta_09_pendentes_bruno :-
    once(
        disciplinas_pendentes(
            bruno,
            Lista
        )
    ),

    length(
        Lista,
        Quantidade
    ),

    writeln('Disciplinas pendentes de Bruno:'),

    imprimir_lista_teste(Lista),

    format(
        'Quantidade: ~w~n',
        [Quantidade]
    ),

    writeln('Resultado esperado: 23.').


% ---------------------------------------------------------
% CONSULTA 10
%
% Resultado esperado:
% Carla possui 30 obrigatorias pendentes.
% ---------------------------------------------------------

consulta_10_pendentes_carla :-
    once(
        disciplinas_pendentes(
            carla,
            Lista
        )
    ),

    length(
        Lista,
        Quantidade
    ),

    writeln('Disciplinas pendentes de Carla:'),

    imprimir_lista_teste(Lista),

    format(
        'Quantidade: ~w~n',
        [Quantidade]
    ),

    writeln('Resultado esperado: 30.').


% =========================================================
% CAMADA 2: NEGACAO POR FALHA
% =========================================================

% ---------------------------------------------------------
% CONSULTA 11
%
% Demonstra que \+ cursou/2 e decisivo.
%
% Bruno:
% - possui o pre-requisito de POO;
% - ainda nao cursou POO;
% - resultado esperado: true.
%
% Ana:
% - possui o pre-requisito de POO;
% - ja cursou POO;
% - resultado esperado: false.
% ---------------------------------------------------------

consulta_11_negacao_por_falha :-
    (
        once(
            pode_cursar(
                bruno,
                poo
            )
        )
    ->
        ResultadoBruno = true
    ;
        ResultadoBruno = false
    ),

    (
        once(
            pode_cursar(
                ana,
                poo
            )
        )
    ->
        ResultadoAna = true
    ;
        ResultadoAna = false
    ),

    format(
        'Bruno pode cursar POO: ~w~n',
        [ResultadoBruno]
    ),

    format(
        'Ana pode cursar POO novamente: ~w~n',
        [ResultadoAna]
    ),

    writeln('Resultado esperado para Bruno: true.'),
    writeln('Resultado esperado para Ana: false.').


% =========================================================
% CAMADA 2: CREDITOS CURSADOS
% =========================================================

% ---------------------------------------------------------
% CONSULTA 12
%
% Resultados esperados:
% Ana:   88 creditos
% Bruno: 48 creditos
% Carla: 14 creditos
% ---------------------------------------------------------

consulta_12_creditos_alunos :-
    once(
        creditos_cursados(
            ana,
            CreditosAna
        )
    ),

    once(
        creditos_cursados(
            bruno,
            CreditosBruno
        )
    ),

    once(
        creditos_cursados(
            carla,
            CreditosCarla
        )
    ),

    format(
        'Creditos de Ana: ~w (esperado: 88)~n',
        [CreditosAna]
    ),

    format(
        'Creditos de Bruno: ~w (esperado: 48)~n',
        [CreditosBruno]
    ),

    format(
        'Creditos de Carla: ~w (esperado: 14)~n',
        [CreditosCarla]
    ).


% =========================================================
% CAMADA 3: FECHO TRANSITIVO
% =========================================================

% ---------------------------------------------------------
% CONSULTA 13
%
% Verifica a cadeia:
%
% programacao_logica_funcional
% -> poo
% -> programacao_imperativa
% -> raciocinio_algoritmico
% ---------------------------------------------------------

consulta_13_fecho_transitivo :-
    setof(
        Ancestral,
        prerequisito_transitivo(
            programacao_logica_funcional,
            Ancestral
        ),
        Ancestrais
    ),

    writeln(
        'Pre-requisitos de programacao_logica_funcional:'
    ),

    imprimir_lista_teste(Ancestrais),

    writeln('Resultados esperados:'),

    writeln(' - poo'),
    writeln(' - programacao_imperativa'),
    writeln(' - raciocinio_algoritmico').


% =========================================================
% CAMADA 3: DETECCAO DE CICLOS
% =========================================================

% ---------------------------------------------------------
% CONSULTA 14
%
% Verifica se a base principal possui ciclos.
%
% Resultado esperado:
% nenhum ciclo.
%
% O teste com um ciclo proposital deve ficar no arquivo
% separado tests/teste_ciclo.pl.
% ---------------------------------------------------------

consulta_14_verificar_ciclos :-
    (
        base_sem_ciclos
    ->
        writeln(
            'Resultado: nenhum ciclo encontrado.'
        )
    ;
        writeln(
            'Resultado: existe um ciclo na base.'
        )
    ),

    writeln(
        'Resultado esperado: nenhum ciclo encontrado.'
    ).


% =========================================================
% CAMADA 3: GERACAO DE UMA TRILHA
% =========================================================

% ---------------------------------------------------------
% CONSULTA 15
%
% Gera uma trilha para Ana.
% Ana possui menos disciplinas pendentes.
% ---------------------------------------------------------

consulta_15_trilha_ana :-
    writeln(
        'Buscando uma trilha para Ana...'
    ),

    (
        once(
            trilha_valida(
                ana,
                24,
                Trilha
            )
        )
    ->
        length(
            Trilha,
            QuantidadeSemestres
        ),

        format(
            'Quantidade de semestres: ~w~n',
            [QuantidadeSemestres]
        ),

        imprimir_trilha(
            Trilha,
            1
        )
    ;
        writeln(
            'Nenhuma trilha valida encontrada para Ana.'
        )
    ).


% ---------------------------------------------------------
% CONSULTA 16
%
% Gera uma trilha para Bruno.
% ---------------------------------------------------------

consulta_16_trilha_bruno :-
    writeln(
        'Buscando uma trilha para Bruno...'
    ),

    (
        once(
            trilha_valida(
                bruno,
                24,
                Trilha
            )
        )
    ->
        length(
            Trilha,
            QuantidadeSemestres
        ),

        format(
            'Quantidade de semestres: ~w~n',
            [QuantidadeSemestres]
        ),

        imprimir_trilha(
            Trilha,
            1
        )
    ;
        writeln(
            'Nenhuma trilha valida encontrada para Bruno.'
        )
    ).


% ---------------------------------------------------------
% CONSULTA 17
%
% Gera uma trilha para Carla.
% A busca pode ser mais demorada porque Carla possui
% mais disciplinas pendentes.
% ---------------------------------------------------------

consulta_17_trilha_carla :-
    writeln(
        'Buscando uma trilha para Carla...'
    ),

    (
        once(
            trilha_valida(
                carla,
                24,
                Trilha
            )
        )
    ->
        length(
            Trilha,
            QuantidadeSemestres
        ),

        format(
            'Quantidade de semestres: ~w~n',
            [QuantidadeSemestres]
        ),

        imprimir_trilha(
            Trilha,
            1
        )
    ;
        writeln(
            'Nenhuma trilha valida encontrada para Carla.'
        )
    ).


% =========================================================
% CAMADA 3: MULTIPLAS TRILHAS
% =========================================================

% ---------------------------------------------------------
% CONSULTA 18
%
% Forma segura para revisao.
% Busca somente as tres primeiras trilhas utilizando
% findnsols/4.
% ---------------------------------------------------------

consulta_18_multiplas_trilhas :-
    writeln(
        'Buscando as 3 primeiras trilhas para Ana...'
    ),

    findnsols(
        3,
        Trilha,
        trilha_valida(
            ana,
            24,
            Trilha
        ),
        Trilhas
    ),

    length(
        Trilhas,
        Quantidade
    ),

    format(
        'Quantidade encontrada: ~w~n',
        [Quantidade]
    ),

    imprimir_varias_trilhas(
        Trilhas,
        1
    ).


% ---------------------------------------------------------
% CONSULTA 19
%
% Utiliza findall/3, conforme solicitado no trabalho.
%
% limit/2 impede que findall tente guardar todas as
% combinacoes possiveis e estoure a pilha do Prolog.
% ---------------------------------------------------------

consulta_19_multiplas_trilhas_findall :-
    writeln(
        'Buscando as 3 primeiras trilhas com findall...'
    ),

    findall(
        Trilha,
        limit(
            3,
            trilha_valida(
                ana,
                24,
                Trilha
            )
        ),
        Trilhas
    ),

    length(
        Trilhas,
        Quantidade
    ),

    format(
        'Quantidade encontrada: ~w~n',
        [Quantidade]
    ),

    imprimir_varias_trilhas(
        Trilhas,
        1
    ).


% =========================================================
% TRATAMENTO DE ERROS E CASOS DE BORDA
% =========================================================

% ---------------------------------------------------------
% CONSULTA 20
%
% Testa limites invalidos.
%
% Resultados esperados:
% limite zero:  false
% limite texto: false
% ---------------------------------------------------------

consulta_20_limite_invalido :-
    (
        trilha_valida(
            ana,
            0,
            _
        )
    ->
        ResultadoZero = true
    ;
        ResultadoZero = false
    ),

    (
        trilha_valida(
            ana,
            texto,
            _
        )
    ->
        ResultadoTexto = true
    ;
        ResultadoTexto = false
    ),

    format(
        'Limite zero: ~w~n',
        [ResultadoZero]
    ),

    format(
        'Limite texto: ~w~n',
        [ResultadoTexto]
    ),

    writeln(
        'Resultado esperado para os dois casos: false.'
    ).


% ---------------------------------------------------------
% CONSULTA 21
%
% Testa um aluno inexistente.
%
% Resultado esperado:
% false.
% ---------------------------------------------------------

consulta_21_aluno_inexistente :-
    (
        trilha_valida(
            aluno_inexistente,
            24,
            _
        )
    ->
        Resultado = true
    ;
        Resultado = false
    ),

    format(
        'Resultado para aluno inexistente: ~w~n',
        [Resultado]
    ),

    writeln('Resultado esperado: false.').


% ---------------------------------------------------------
% CONSULTA 22
%
% Testa uma disciplina inexistente.
%
% Resultado esperado:
% false.
% ---------------------------------------------------------

consulta_22_disciplina_inexistente :-
    (
        pode_cursar(
            ana,
            disciplina_inexistente
        )
    ->
        Resultado = true
    ;
        Resultado = false
    ),

    format(
        'Resultado para disciplina inexistente: ~w~n',
        [Resultado]
    ),

    writeln('Resultado esperado: false.').


% =========================================================
% PREDICADOS AUXILIARES DE IMPRESSAO
% =========================================================

% Imprime os elementos de uma lista.

imprimir_lista_teste([]).

imprimir_lista_teste(
    [Elemento | Resto]
) :-
    format(
        ' - ~w~n',
        [Elemento]
    ),

    imprimir_lista_teste(Resto).


% Imprime varias trilhas separadamente.

imprimir_varias_trilhas([], _).

imprimir_varias_trilhas(
    [Trilha | Resto],
    Numero
) :-
    format(
        '~n========== TRILHA ~w ==========~n',
        [Numero]
    ),

    imprimir_trilha(
        Trilha,
        1
    ),

    Proximo is Numero + 1,

    imprimir_varias_trilhas(
        Resto,
        Proximo
    ).