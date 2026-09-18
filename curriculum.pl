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

cursou(aluno_real, fundamentos_sistemas_ciberfisicos).
cursou(aluno_real, logica_matematica).
cursou(aluno_real, filosofia).
cursou(aluno_real, ec_navegando_computacao).

cursou(aluno_real, arquitetura_banco_dados).
cursou(aluno_real, programacao_imperativa).
cursou(aluno_real, conectividade_sistemas).
cursou(aluno_real, etica).

cursou(aluno_real, ec_criando_solucoes).
cursou(aluno_real, poo).
cursou(aluno_real, seguranca_informacao).
cursou(aluno_real, clinica_tic).
