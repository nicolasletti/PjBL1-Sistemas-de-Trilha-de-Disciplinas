% =========================================================
% ARQUIVO PRINCIPAL E DEMONSTRACAO
% =========================================================

% trilhas.pl carrega elegibilidade.pl,
% que por sua vez carrega curriculum.pl.
:- ensure_loaded('trilhas.pl').


% =========================================================
% DEMONSTRACAO COMPLETA
% =========================================================

demo :-
    writeln('================================================='),
    writeln('          SISTEMA CURRICULUM ADVISOR             '),
    writeln('================================================='),
    nl,

    demonstrar_camada_1,
    demonstrar_camada_2,
    demonstrar_fecho_transitivo,
    demonstrar_ciclos,
    demonstrar_trilha,

    writeln('================================================='),
    writeln('              FIM DA DEMONSTRACAO                '),
    writeln('=================================================').


% =========================================================
% CAMADA 1: BASE DE FATOS
% =========================================================

demonstrar_camada_1 :-
    writeln('--> CAMADA 1: Disciplinas do 1o periodo'),

    forall(
        disciplina(
            Disciplina,
            Tipo,
            Creditos,
            1
        ),
        format(
            ' - ~w (~w, ~w creditos)~n',
            [Disciplina, Tipo, Creditos]
        )
    ),

    nl.


% =========================================================
% CAMADA 2: ELEGIBILIDADE
% =========================================================

demonstrar_camada_2 :-
    writeln('--> CAMADA 2: Diagnostico dos alunos'),

    forall(
        aluno(Aluno),
        demonstrar_aluno(Aluno)
    ),

    nl.


demonstrar_aluno(Aluno) :-
    creditos_cursados(
        Aluno,
        TotalCreditos
    ),

    disciplinas_liberadas(
        Aluno,
        Liberadas
    ),

    disciplinas_pendentes(
        Aluno,
        Pendentes
    ),

    format(
        'Aluno: ~w~n',
        [Aluno]
    ),

    format(
        '  Creditos cursados: ~w~n',
        [TotalCreditos]
    ),

    format(
        '  Disciplinas liberadas: ~w~n',
        [Liberadas]
    ),

    format(
        '  Disciplinas obrigatorias pendentes: ~w~n~n',
        [Pendentes]
    ).


% =========================================================
% CAMADA 3: FECHO TRANSITIVO
% =========================================================

demonstrar_fecho_transitivo :-
    writeln('--> CAMADA 3: Fecho transitivo'),

    writeln(
        'Pre-requisitos diretos e indiretos de programacao_logica_funcional:'
    ),

    setof(
        Ancestral,
        prerequisito_transitivo(
            programacao_logica_funcional,
            Ancestral
        ),
        Ancestrais
    ),

    imprimir_lista(Ancestrais),

    nl.


% =========================================================
% CAMADA 3: DETECCAO DE CICLOS
% =========================================================

demonstrar_ciclos :-
    writeln('--> CAMADA 3: Deteccao de ciclos'),

    (
        base_sem_ciclos
    ->
        writeln('Nenhum ciclo foi encontrado na base principal.')
    ;
        writeln('ATENCAO: foi encontrado um ciclo na base.')
    ),

    nl.


% =========================================================
% CAMADA 3: GERACAO DE TRILHA
% =========================================================

demonstrar_trilha :-
    writeln(
        '--> CAMADA 3: Trilha simulada para Ana'
    ),

    writeln(
        'Limite: 24 creditos por semestre'
    ),

    % once/1 solicita somente a primeira trilha encontrada.
    % Isso reduz o risco de explosao combinatoria no demo.
    (
        once(trilha_valida(ana, 24, Trilha))
    ->
        imprimir_trilha(Trilha, 1)
    ;
        writeln(
            'Nenhuma trilha valida foi encontrada.'
        )
    ),

    nl.


% =========================================================
% IMPRESSAO DAS LISTAS
% =========================================================

imprimir_lista([]).

imprimir_lista([Elemento | Resto]) :-
    format(
        ' - ~w~n',
        [Elemento]
    ),

    imprimir_lista(Resto).


% =========================================================
% IMPRESSAO DA TRILHA
% =========================================================

imprimir_trilha([], _).

imprimir_trilha(
    [Semestre | Resto],
    NumeroSemestre
) :-
    creditos_do_semestre(
        Semestre,
        TotalCreditos
    ),

    format(
        'Semestre ~w (~w creditos): ~w~n',
        [
            NumeroSemestre,
            TotalCreditos,
            Semestre
        ]
    ),

    ProximoSemestre is NumeroSemestre + 1,

    imprimir_trilha(
        Resto,
        ProximoSemestre
    ).


% =========================================================
% SOMA DOS CREDITOS DE UM SEMESTRE
% =========================================================

creditos_do_semestre([], 0).

creditos_do_semestre(
    [Disciplina | Resto],
    Total
) :-
    disciplina(
        Disciplina,
        _,
        Creditos,
        _
    ),

    creditos_do_semestre(
        Resto,
        Parcial
    ),

    Total is Creditos + Parcial.
