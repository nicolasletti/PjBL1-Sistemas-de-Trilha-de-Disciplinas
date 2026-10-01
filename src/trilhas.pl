% =========================================================
% CAMADA 3: FECHO TRANSITIVO E GERACAO DE TRILHAS
% =========================================================

:- ensure_loaded('elegibilidade.pl').


% =========================================================
% 1. FECHO TRANSITIVO DE PRE-REQUISITOS
% =========================================================

% prerequisito_transitivo(+Disciplina, -Ancestral)
%
% Verdadeiro quando Ancestral e um pre-requisito direto
% ou indireto de Disciplina.
%
% A lista de visitados impede recursao infinita caso
% exista um ciclo na base de pre-requisitos.

prerequisito_transitivo(Disciplina, Ancestral) :-
    caminho_prerequisito(
        Disciplina,
        Ancestral,
        [Disciplina]
    ).


% caminho_prerequisito(
%     +Disciplina,
%     -Ancestral,
%     +Visitados
% )
%
% Primeiro encontra um pre-requisito direto.
% Depois pode continuar procurando pre-requisitos indiretos.

caminho_prerequisito(Disciplina, Ancestral, Visitados) :-
    prerequisito(Disciplina, Proximo),
    (
        % Caso base: encontrou um pre-requisito direto.
        Ancestral = Proximo
    ;
        % Caso recursivo: continua procurando na cadeia.
        % O proximo no nao pode ter sido visitado.
        \+ member(Proximo, Visitados),

        caminho_prerequisito(
            Proximo,
            Ancestral,
            [Proximo | Visitados]
        )
    ).


% =========================================================
% 2. DETECCAO DE CICLOS
% =========================================================

% existe_ciclo(+Disciplina)
%
% Existe ciclo quando, seguindo os pre-requisitos,
% uma disciplina volta a depender dela mesma.

existe_ciclo(Disciplina) :-
    caminho_prerequisito(
        Disciplina,
        Disciplina,
        [Disciplina]
    ).


% base_sem_ciclos/0
%
% Verifica todas as disciplinas cadastradas.
% A regra e verdadeira somente quando nenhuma disciplina
% participa de um ciclo.

base_sem_ciclos :-
    \+ (
        disciplina(Disciplina, _, _, _),
        existe_ciclo(Disciplina)
    ).


% =========================================================
% 3. GERACAO DE TRILHAS
% =========================================================

% trilha_valida(
%     +Aluno,
%     +MaxCreditosPorSemestre,
%     -Trilha
% )
%
% A Trilha e uma lista de semestres.
% Cada semestre tambem e uma lista de disciplinas.
%
% Exemplo:
%
% [
%     [poo, seguranca_informacao],
%     [programacao_logica_funcional],
%     [inteligencia_artificial]
% ]

trilha_valida(Aluno, MaxCreditos, Trilha) :-
    % O aluno precisa estar cadastrado.
    aluno(Aluno),

    % Evita erro caso o limite seja uma variavel,
    % texto ou outro valor invalido.
    number(MaxCreditos),
    MaxCreditos > 0,

    % Uma base com ciclos nao pode gerar uma trilha segura.
    base_sem_ciclos,

    % Coleta as obrigatorias ainda nao concluidas.
    disciplinas_pendentes(
        Aluno,
        PendentesIniciais
    ),

    % Coleta o historico inicial do aluno.
    findall(
        Disciplina,
        cursou(Aluno, Disciplina),
        Historico
    ),

    % Remove possiveis repeticoes no historico.
    sort(Historico, CursadasIniciais),

    % Limite de seguranca: no maximo 12 semestres.
    simular_semestres(
        PendentesIniciais,
        CursadasIniciais,
        MaxCreditos,
        12,
        Trilha
    ).


% =========================================================
% 4. SIMULACAO DOS SEMESTRES
% =========================================================

% Caso base:
% quando nao existem disciplinas pendentes, a trilha terminou.

simular_semestres([], _, _, _, []).


% Caso recursivo:
% ainda existem disciplinas pendentes e semestres disponiveis.

simular_semestres(
    Pendentes,
    Cursadas,
    MaxCreditos,
    SemestresRestantes,
    [SemestreAtual | RestoTrilha]
) :-
    Pendentes \= [],
    SemestresRestantes > 0,

    % Escolhe um conjunto valido de disciplinas
    % para o semestre atual.
    selecionar_disciplinas_semestre(
        Pendentes,
        Cursadas,
        MaxCreditos,
        SemestreAtual
    ),

    % Impede a criacao de semestres vazios.
    SemestreAtual \= [],

    % Remove do conjunto de pendentes as disciplinas
    % escolhidas para o semestre atual.
    subtract(
        Pendentes,
        SemestreAtual,
        NovasPendentes
    ),

    % Adiciona as novas disciplinas ao historico simulado.
    append(
        SemestreAtual,
        Cursadas,
        NovoHistorico
    ),

    % Diminui o limite de semestres.
    NovoLimite is SemestresRestantes - 1,

    % Continua a simulacao.
    simular_semestres(
        NovasPendentes,
        NovoHistorico,
        MaxCreditos,
        NovoLimite,
        RestoTrilha
    ).


% =========================================================
% 5. SELECAO DAS DISCIPLINAS DO SEMESTRE
% =========================================================

% selecionar_disciplinas_semestre(
%     +Pendentes,
%     +Cursadas,
%     +MaxCreditos,
%     -Selecionadas
% )
%
% Primeiro encontra todas as disciplinas elegiveis.
% Depois gera subconjuntos que respeitam o limite de creditos.

selecionar_disciplinas_semestre(
    Pendentes,
    Cursadas,
    MaxCreditos,
    Selecionadas
) :-
    findall(
        Disciplina,
        (
            member(Disciplina, Pendentes),
            requisitos_cumpridos(
                Disciplina,
                Cursadas
            )
        ),
        ElegiveisBrutas
    ),

    % Evita disciplinas duplicadas.
    sort(ElegiveisBrutas, Elegiveis),

    subconjunto_com_limite(
        Elegiveis,
        MaxCreditos,
        Selecionadas
    ).


% requisitos_cumpridos(+Disciplina, +Cursadas)
%
% Todos os pre-requisitos diretos precisam fazer parte
% do historico acumulado.
%
% Como cada nivel da cadeia e verificado semestre a
% semestre, os pre-requisitos indiretos tambem acabam
% sendo respeitados.

requisitos_cumpridos(Disciplina, Cursadas) :-
    forall(
        prerequisito(Disciplina, PreRequisito),
        member(PreRequisito, Cursadas)
    ).


% =========================================================
% 6. SUBCONJUNTOS COM LIMITE DE CREDITOS
% =========================================================

% Caso base:
% nao existem mais disciplinas para analisar.

subconjunto_com_limite([], _, []).


% Opcao 1:
% inclui a disciplina atual quando ela cabe no limite.

subconjunto_com_limite(
    [Disciplina | Resto],
    MaxCreditos,
    [Disciplina | Selecionadas]
) :-
    disciplina(
        Disciplina,
        _,
        Creditos,
        _
    ),

    Creditos =< MaxCreditos,

    CreditosRestantes is MaxCreditos - Creditos,

    subconjunto_com_limite(
        Resto,
        CreditosRestantes,
        Selecionadas
    ).


% Opcao 2:
% nao inclui a disciplina atual.
%
% O backtracking permite retornar a este ponto e testar
% outras combinacoes de disciplinas.

subconjunto_com_limite(
    [_ | Resto],
    MaxCreditos,
    Selecionadas
) :-
    subconjunto_com_limite(
        Resto,
        MaxCreditos,
        Selecionadas
    ).
