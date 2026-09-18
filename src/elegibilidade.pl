% =========================================================
% CAMADA 2: REGRAS DE ELEGIBILIDADE
% =========================================================

:- ensure_loaded('curriculum.pl').

% Identifica os alunos presentes no histórico.
% setof evita repetir o aluno para cada disciplina cursada.
aluno(Aluno) :-
    setof(A, D^cursou(A, D), Alunos),
    member(Aluno, Alunos).

% Verifica se TODOS os pré-requisitos diretos foram cursados.
% Uma disciplina sem pré-requisitos também satisfaz a regra.
prerequisitos_ok(Aluno, Disciplina) :-
    aluno(Aluno),
    disciplina(Disciplina, _, _, _),
    forall(
        prerequisito(Disciplina, Pre),
        cursou(Aluno, Pre)
    ).

% Pode cursar se a disciplina existe, ainda não foi concluída
% e todos os seus pré-requisitos diretos foram cumpridos.
pode_cursar(Aluno, Disciplina) :-
    aluno(Aluno),
    disciplina(Disciplina, _, _, _),
    \+ cursou(Aluno, Disciplina),
    prerequisitos_ok(Aluno, Disciplina).

% Lista as disciplinas liberadas, incluindo eletivas.
disciplinas_liberadas(Aluno, Lista) :-
    aluno(Aluno),
    findall(
        D,
        pode_cursar(Aluno, D),
        Disciplinas
    ),
    sort(Disciplinas, Lista).

% Lista todas as obrigatórias ainda não concluídas,
% mesmo que estejam bloqueadas por pré-requisitos.
disciplinas_pendentes(Aluno, Lista) :-
    aluno(Aluno),
    findall(
        D,
        (
            disciplina(D, obrigatoria, _, _),
            \+ cursou(Aluno, D)
        ),
        Disciplinas
    ),
    sort(Disciplinas, Lista).

% Soma os créditos das disciplinas concluídas.
% sort evita contar uma disciplina duas vezes caso
% o mesmo fato cursou/2 seja repetido por engano.
creditos_cursados(Aluno, Total) :-
    aluno(Aluno),
    findall(D, cursou(Aluno, D), Historico),
    sort(Historico, Disciplinas),
    findall(
        C,
        (
            member(D, Disciplinas),
            disciplina(D, _, C, _)
        ),
        Creditos
    ),
    sum_list(Creditos, Total).
