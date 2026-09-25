% =========================================================
% SCRIPT PRINCIPAL E DEMONSTRAÇÃO
% =========================================================

:- ensure_loaded('curriculum.pl').
:- ensure_loaded('elegibilidade.pl').
:- ensure_loaded('trilhas.pl').

demo :-
    writeln('================================================='),
    writeln('          SISTEMA CURRICULUM ADVISOR             '),
    writeln('================================================='),
    nl,
    
    % 1. CAMADA 1: Consulta simples
    writeln('--> CAMADA 1: Disciplinas do 1º Período'),
    forall(disciplina(D, Tipo, C, 1), format(' - ~w (~w, ~w cr)~n', [D, Tipo, C])),
    nl,

    % 2. CAMADA 2: Elegibilidade dos alunos
    writeln('--> CAMADA 2: Diagnóstico dos Alunos'),
    forall(aluno(A), (
        creditos_cursados(A, Creds),
        disciplinas_liberadas(A, Lib),
        format('Aluno: ~w | Créditos Cursados: ~w~n', [A, Creds]),
        format('  Disciplinas Liberadas: ~w~n~n', [Lib])
    )),

    % 3. CAMADA 3: Fecho Transitivo
    writeln('--> CAMADA 3: Teste de Cadeia Transitiva (profundidade >= 3)'),
    format('Pré-requisitos transitivos de programacao_logica_funcional:~n'),
    forall(prerequisito_transitivo(programacao_logica_funcional, Ancestral),
        format(' - Depende de: ~w~n', [Ancestral])),
    nl,

    % 4. CAMADA 3: Geração de Trilha
    writeln('--> CAMADA 3: Trilha de Formatura Simulada (Bruno - Máx 24 créditos/sem)'),
    (   trilha_valida(bruno, 24, Trilha)
    ->  imprimir_trilha(Trilha, 1)
    ;   writeln('Nenhuma trilha válida foi encontrada.')
    ),
    writeln('=================================================').

imprimir_trilha([], _).
imprimir_trilha([Semestre|Resto], N) :-
    format('Semestre ~w: ~w~n', [N, Semestre]),
    Proximo is N + 1,
    imprimir_trilha(Resto, Proximo). **
