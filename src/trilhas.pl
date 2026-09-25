% =========================================================
% CAMADA 3: FECHO TRANSITIVO E GERAÇÃO DE TRILHAS
% =========================================================

:- ensure_loaded('curriculum.pl').
:- ensure_loaded('elegibilidade.pl').

% ---------------------------------------------------------
% 1. FECHO TRANSITIVO E CICLOS
% ---------------------------------------------------------

% Caso base: Pré-requisito direto
prerequisito_transitivo(Disciplina, Ancestral) :-
    prerequisito(Disciplina, Ancestral).

% Caso recursivo: Pré-requisito indireto (Fecho Transitivo)
prerequisito_transitivo(Disciplina, Ancestral) :-
    prerequisito(Disciplina, Intermediario),
    prerequisito_transitivo(Intermediario, Ancestral).

% Detecção de ciclos na base de fatos (ex.: A -> B -> A)
existe_ciclo(Disciplina) :-
    prerequisito_transitivo(Disciplina, Disciplina).


% ---------------------------------------------------------
% 2. GERAÇÃO DE TRILHAS VÁLIDAS (PURE BACKTRACKING)
% ---------------------------------------------------------

% trilha_valida(+Aluno, +MaxCreditosPorSemestre, -Trilha)
% Gera uma sequência de semestres (listas de disciplinas) até a formatura.
trilha_valida(Aluno, MaxCreditos, Trilha) :-
    aluno(Aluno),
    disciplinas_pendentes(Aluno, PendentesIniciais),
    findall(D, cursou(Aluno, D), CursadasIniciais),
    % Limite máximo de segurança: 12 semestres simulados
    simular_semestres(PendentesIniciais, CursadasIniciais, MaxCreditos, 12, Trilha).

% Caso base: Todas as disciplinas obrigatórias foram alocadas
simular_semestres([], _, _, _, []) :- !.

% Trava de segurança: atinge o limite de semestres sem concluir
simular_semestres(_, _, _, 0, _) :- !, fail.

% Passo recursivo de simulação por semestre
simular_semestres(Pendentes, Cursadas, MaxCreditos, SemestresRestantes, [SemestreAtual | RestoTrilha]) :-
    SemestresRestantes > 0,
    selecionar_disciplinas_semestre(Pendentes, Cursadas, MaxCreditos, SemestreAtual),
    SemestreAtual \= [], % Exige progresso (semestre não pode ser vazio)
    
    % Atualiza disciplinas pendentes e cursadas para o próximo semestre simulado
    subtract(Pendentes, SemestreAtual, NovasPendentes),
    append(SemestreAtual, Cursadas, NovasCursadas),
    
    ProximoLimite is SemestresRestantes - 1,
    simular_semestres(NovasPendentes, NovasCursadas, MaxCreditos, ProximoLimite, RestoTrilha).

% Seleciona um subconjunto de disciplinas cujos pré-requisitos foram satisfeitos
selecionar_disciplinas_semestre(Pendentes, Cursadas, MaxCreditos, Selecionadas) :-
    findall(D, (member(D, Pendentes), requisitos_cumpridos(D, Cursadas)), Elegiveis),
    subconjunto_com_limite(Elegiveis, MaxCreditos, Selecionadas).

requisitos_cumpridos(Disciplina, Cursadas) :-
    forall(prerequisito(Disciplina, Pre), member(Pre, Cursadas)).

% Gera combinações de disciplinas respeitando o limite máximo de créditos
subconjunto_com_limite([], _, []).
subconjunto_com_limite([D | Resto], MaxCreditos, [D | Selecionados]) :-
    disciplina(D, _, Creditos, _),
    Creditos =< MaxCreditos,
    NovoMax is MaxCreditos - Creditos,
    subconjunto_com_limite(Resto, NovoMax, Selecionados).
subconjunto_com_limite([_ | Resto], MaxCreditos, Selecionados) :-
    subconjunto_com_limite(Resto, MaxCreditos, Selecionados).
