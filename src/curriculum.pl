trabalho de redes: % =========================================================
% CAMADA 1: BASE DE FATOS (curriculum.pl)% =========================================================

% disciplina(Nome, Tipo, Creditos, SemestreSugerido).
% Tipo: {obrigatoria, eletiva}

% --- 1º Período ---
disciplina(fundamentos_sistemas_ciberfisicos, obrigatoria, 4, 1).
disciplina(logica_matematica, obrigatoria, 4, 1).
disciplina(filosofia, eletiva, 4, 1).
disciplina(ec_navegando_computacao, obrigatoria, 6, 1).
disciplina(raciocinio_algoritmico, obrigatoria, 6, 1).

% --- 2º Período ---
disciplina(natureza_discreta, obrigatoria, 4, 2).
disciplina(arquitetura_banco_dados, obrigatoria, 6, 2).
disciplina(programacao_imperativa, obrigatoria, 4, 2).
disciplina(programacao_web, obrigatoria, 4, 2).
disciplina(conectividade_sistemas, obrigatoria, 4, 2).
disciplina(etica, eletiva, 2, 2).

% --- 3º Período ---
disciplina(modelagem_fenomenos_fisicos, obrigatoria, 4, 3).
disciplina(ec_criando_solucoes, obrigatoria, 6, 3).
disciplina(poo, obrigatoria, 6, 3).
disciplina(seguranca_informacao, obrigatoria, 4, 3).
disciplina(performance_sistemas, obrigatoria, 4, 3).
disciplina(clinica_tic, obrigatoria, 2, 3).

% --- 4º Período ---
disciplina(teologia_sociedade, eletiva, 2, 4).
disciplina(resolucao_problemas_estruturados, obrigatoria, 4, 4).
disciplina(programacao_logica_funcional, obrigatoria, 4, 4).
disciplina(big_data, obrigatoria, 4, 4).
disciplina(sistemas_operacionais, obrigatoria, 4, 4).
disciplina(redes_convergentes, obrigatoria, 4, 4).
disciplina(modelagem_sistemas_computacionais, obrigatoria, 4, 4).

% --- 5º Período ---
disciplina(complexidade_algoritmos, obrigatoria, 4, 5).
disciplina(metodos_quantitativos_computacao, obrigatoria, 4, 5).
disciplina(resolucao_problemas_grafos, obrigatoria, 6, 5).
disciplina(metodos_pesquisa_cientifica, obrigatoria, 4, 5).
disciplina(ec_inovando_colaborativamente, obrigatoria, 6, 5).

% --- 6º Período ---
disciplina(aprendizagem_maquina, obrigatoria, 4, 6).
disciplina(inteligencia_artificial, obrigatoria, 4, 6).
disciplina(programacao_distribuida, obrigatoria, 4, 6).
disciplina(gestao_projetos_metodos_ageis, obrigatoria, 6, 6).
disciplina(pesquisa_aplicada, obrigatoria, 4, 6).
disciplina(engenharia_software, obrigatoria, 4, 6).

% prerequisito(Disciplina, Prerequisito).
% Cadeia com profundidade >= 3 para testar a recursão na Camada 3:
% raciocinio_algoritmico -> programacao_imperativa -> poo -> programacao_logica_funcional
prerequisito(programacao_imperativa, raciocinio_algoritmico).
prerequisito(poo, programacao_imperativa).
prerequisito(programacao_logica_funcional, poo).

% Outras dependências lógicas sugeridas
prerequisito(conectividade_sistemas, fundamentos_sistemas_ciberfisicos).
prerequisito(redes_convergentes, conectividade_sistemas).
prerequisito(natureza_discreta, logica_matematica).
prerequisito(arquitetura_banco_dados, raciocinio_algoritmico).
prerequisito(big_data, arquitetura_banco_dados).
prerequisito(programacao_web, programacao_imperativa).


% cursou(Aluno, Disciplina).
% Incluindo apenas as disciplinas concluídas com sucesso (Aprovado).
% O que não está aqui, a regra "pode_cursar/2" da Camada 2 considerará como pendente.

% =========================================================
% HISTÓRICOS DOS ALUNOS FICTÍCIOS
% =========================================================

% ---------------------------------------------------------
% ANA: ALUNA ADIANTADA
% Concluiu todas as disciplinas do 1º ao 3º período
% e algumas disciplinas do 4º período.
% ---------------------------------------------------------

% 1º período
cursou(ana, fundamentos_sistemas_ciberfisicos).
cursou(ana, logica_matematica).
cursou(ana, filosofia).
cursou(ana, ec_navegando_computacao).
cursou(ana, raciocinio_algoritmico).

% 2º período
cursou(ana, natureza_discreta).
cursou(ana, arquitetura_banco_dados).
cursou(ana, programacao_imperativa).
cursou(ana, programacao_web).
cursou(ana, conectividade_sistemas).
cursou(ana, etica).

% 3º período
cursou(ana, modelagem_fenomenos_fisicos).
cursou(ana, ec_criando_solucoes).
cursou(ana, poo).
cursou(ana, seguranca_informacao).
cursou(ana, performance_sistemas).
cursou(ana, clinica_tic).

% Parte do 4º período
cursou(ana, teologia_sociedade).
cursou(ana, resolucao_problemas_estruturados).
cursou(ana, programacao_logica_funcional).
cursou(ana, sistemas_operacionais).


% ---------------------------------------------------------
% BRUNO: ALUNO NO RITMO NORMAL
% Concluiu integralmente o 1º e o 2º períodos.
% Está pronto para avançar para o 3º período.
% ---------------------------------------------------------

% 1º período
cursou(bruno, fundamentos_sistemas_ciberfisicos).
cursou(bruno, logica_matematica).
cursou(bruno, filosofia).
cursou(bruno, ec_navegando_computacao).
cursou(bruno, raciocinio_algoritmico).

% 2º período
cursou(bruno, natureza_discreta).
cursou(bruno, arquitetura_banco_dados).
cursou(bruno, programacao_imperativa).
cursou(bruno, programacao_web).
cursou(bruno, conectividade_sistemas).
cursou(bruno, etica).

% ---------------------------------------------------------
% CARLA: ALUNA ATRASADA
% Concluiu somente parte do 1º período.
% Ainda possui disciplinas básicas pendentes.
% ---------------------------------------------------------

cursou(carla, fundamentos_sistemas_ciberfisicos).
cursou(carla, filosofia).
cursou(carla, ec_navegando_computacao).
