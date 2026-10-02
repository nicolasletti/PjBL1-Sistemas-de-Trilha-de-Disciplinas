# Decisões de modelagem e implementação

Este documento registra as escolhas técnicas do **Sistema de Trilhas de Disciplinas em Prolog**, seus motivos, consequências e limitações. Ele complementa o `README.md` e ajuda a justificar o projeto durante a avaliação.

## 1. Objetivo e escopo

O sistema foi criado para representar uma grade curricular e calcular caminhos válidos para estudantes com históricos diferentes. O foco não é reproduzir todo o sistema acadêmico de uma universidade, mas demonstrar conceitos de programação lógica:

- fatos e regras;
- unificação;
- negação por falha;
- quantificação com `forall/2`;
- coleta de soluções;
- recursão;
- detecção de ciclos;
- busca com *backtracking*.

## 2. Organização em camadas

| Arquivo | Responsabilidade | Motivo da separação |
|---|---|---|
| `src/curriculum.pl` | Base de fatos | Mantém os dados independentes das regras |
| `src/elegibilidade.pl` | Regras individuais | Centraliza o que um estudante cursou, pode cursar e ainda deve cursar |
| `src/trilhas.pl` | Recursão e planejamento | Isola a parte de busca, que tem maior complexidade |
| `src/main.pl` | Demonstração | Oferece um ponto de entrada simples |
| `tests/consultas_teste.pl` | Consultas numeradas | Permite revisar cada comportamento separadamente |

Cada camada carrega apenas sua dependência imediata. Assim, `main.pl` não precisa carregar manualmente todos os arquivos.

## 3. Representação do currículo

### 3.1 Disciplinas

Uma disciplina é representada por:

```prolog
disciplina(Nome, Tipo, Creditos, SemestreSugerido).
```

Exemplo:

```prolog
disciplina(poo, obrigatoria, 6, 3).
```

Foram usados átomos em `snake_case` para evitar aspas e facilitar as consultas. O período é apenas uma recomendação curricular; a trilha é determinada principalmente pelos pré-requisitos e pelo limite de créditos.

### 3.2 Pré-requisitos

A relação:

```prolog
prerequisito(Disciplina, Prerequisito).
```

é orientada. O primeiro argumento depende do segundo. Essa ordem torna natural a pergunta “quais requisitos esta disciplina exige?”.

A base inclui a cadeia:

```text
raciocinio_algoritmico
    → programacao_imperativa
        → poo
            → programacao_logica_funcional
```

Ela garante profundidade suficiente para demonstrar recursão transitiva.

### 3.3 Histórico

```prolog
cursou(Aluno, Disciplina).
```

O fato significa que a disciplina foi concluída com aprovação. Notas, reprovações, equivalências e matrículas em andamento ficam fora do escopo.

## 4. Perfis de estudantes

Três históricos diferentes evitam que as regras sejam validadas com um único cenário.

| Perfil | Característica | Comportamento esperado |
|---|---|---|
| `ana` | avançado | Poucas pendências e trilha mais curta |
| `bruno` | regular | Disciplinas intermediárias liberadas |
| `carla` | atrasado | Mais bloqueios e trilha mais longa |

A existência de um estudante é inferida a partir de pelo menos um fato `cursou/2`. Como consequência, um estudante sem nenhuma aprovação ainda não pode ser representado somente por essa relação. Uma evolução possível seria adicionar `estudante/1`.

## 5. Hipótese de mundo fechado

O projeto adota a hipótese de mundo fechado comum em Prolog: se `cursou(Aluno, Disciplina)` não pode ser provado, a disciplina é considerada não concluída.

Isso permite escrever:

```prolog
\+ cursou(Aluno, Disciplina)
```

para impedir repetição. Essa negação não significa “provar que é falso”; significa “não foi possível provar que é verdadeiro”. Por isso, as variáveis relevantes devem estar instanciadas antes do uso de `\+/1`.

## 6. Elegibilidade

### 6.1 Todos os pré-requisitos devem ser atendidos

`prerequisitos_ok/2` usa `forall/2` para expressar diretamente a regra universal:

> Para todo pré-requisito da disciplina, o estudante deve tê-lo cursado.

Disciplinas sem pré-requisitos satisfazem a regra naturalmente, pois não existe contraexemplo.

### 6.2 Uma disciplina pode ser cursada quando

1. existe na base;
2. ainda não foi concluída pelo estudante;
3. todos os seus pré-requisitos foram concluídos.

O predicado `pode_cursar/2` combina exatamente essas condições.

### 6.3 Listas e créditos

As consultas agregadas usam `findall/3` ou `setof/3`, conforme a necessidade, e `sort/2` para:

- eliminar duplicatas acidentais;
- apresentar resultados determinísticos;
- facilitar a comparação nos testes.

O total de créditos é calculado a partir das disciplinas únicas do histórico.

## 7. Fecho transitivo protegido contra ciclos

Uma implementação recursiva ingênua de `prerequisito_transitivo/2` pode entrar em recursão infinita quando há um ciclo. Por isso, a busca interna mantém uma lista de disciplinas visitadas.

Antes de avançar para um novo nó, a regra verifica que ele ainda não aparece nessa lista. A mesma busca permite:

- encontrar ancestrais diretos e indiretos;
- detectar se uma disciplina alcança novamente a si própria.

Essa proteção torna a consulta robusta mesmo quando a base contém um erro de modelagem.

## 8. Geração das trilhas

### 8.1 Histórico simulado

A geração não modifica a base de fatos. A cada semestre, o algoritmo:

1. calcula as disciplinas elegíveis considerando o histórico atual;
2. escolhe um subconjunto cujo total não exceda o limite de créditos;
3. adiciona as disciplinas escolhidas a uma nova lista de histórico;
4. remove essas disciplinas da lista de pendências;
5. continua recursivamente.

Essa abordagem é funcional e reversível. Não são usados `assert/1` nem `retract/1`.

### 8.2 Restrições adotadas

| Restrição | Justificativa |
|---|---|
| máximo de créditos por semestre | Representa a carga acadêmica escolhida |
| semestre não vazio | Evita soluções artificiais sem progresso |
| máximo de 12 semestres | Impede buscas sem limite e atende ao escopo acadêmico |
| somente pendências obrigatórias | Mantém um objetivo claro de conclusão |
| pré-requisitos no histórico anterior | Evita cursar requisito e dependente simultaneamente |

### 8.3 Múltiplas soluções

O Prolog explora diferentes subconjuntos e devolve trilhas alternativas por *backtracking*. A primeira resposta não é necessariamente a única nem representa uma otimização global.

Esse espaço de busca é combinatório. Pedir todas as respostas com um `findall/3` irrestrito pode consumir muita memória. Para demonstração e testes, são preferíveis:

```prolog
once(trilha_valida(ana, 24, Trilha)).
```

ou:

```prolog
findnsols(3, T, trilha_valida(ana, 24, T), Trilhas).
```

## 9. Detecção e teste de ciclos

A base oficial deve permanecer acíclica. Para provar que `existe_ciclo/1` funciona, o ciclo deve ser criado apenas em um arquivo de teste separado:

```prolog
prerequisito(teste_a, teste_b).
prerequisito(teste_b, teste_a).
```

Resultado esperado:

```prolog
?- existe_ciclo(teste_a).
true.
```

Misturar esse caso artificial ao currículo impediria a geração normal de trilhas e enfraqueceria a qualidade da base principal.

## 10. Tratamento de entradas inválidas

O comportamento preferido é falhar de forma limpa:

```prolog
?- trilha_valida(aluno_inexistente, 24, _).
false.

?- trilha_valida(ana, 0, _).
false.

?- pode_cursar(ana, disciplina_inexistente).
false.
```

Essa escolha mantém os predicados relacionais. Mensagens detalhadas poderiam ser adicionadas em uma camada de interface, sem misturá-las às regras lógicas.

## 11. Estratégia de validação

As consultas são organizadas na mesma ordem da arquitetura:

| Grupo | O que comprova |
|---|---|
| Camada 1 | quantidade, períodos, disciplinas e estudantes |
| Camada 2 | liberação, pendências, créditos e negação por falha |
| Camada 3 | transitividade, ausência/presença de ciclos e trilhas |
| Robustez | limites inválidos, aluno desconhecido e disciplina inexistente |

As consultas separadas foram escolhidas porque facilitam a demonstração ao professor e a inspeção das respostas. Como melhoria futura, os mesmos casos podem ser convertidos para `plunit`, oferecendo execução automatizada e relatório de aprovação.

## 12. Limitações conhecidas

- O período sugerido não restringe a trilha; ele funciona como dado curricular.
- A trilha não considera choque de horários ou oferta semestral real.
- Não há notas, reprovações, equivalências ou disciplinas em andamento.
- As eletivas não entram no objetivo de conclusão da trilha.
- Um aluno sem aprovações precisa de um futuro fato `estudante/1` para existir na base.
- A geração encontra soluções válidas, mas não garante a melhor trilha segundo um critério de otimização.
- Uma consulta por todas as trilhas pode causar explosão combinatória.
- As relações de pré-requisito são decisões de modelagem acadêmica do projeto e devem ser conferidas caso sejam comparadas com uma matriz oficial.

## 13. Evoluções sugeridas

1. Criar testes automatizados com `plunit`.
2. Adicionar `estudante/1` e dados separados de matrícula.
3. Incluir uma carga mínima de eletivas.
4. Restringir disciplinas aos períodos em que são ofertadas.
5. Ordenar a busca para priorizar o semestre sugerido.
6. Definir critérios de otimização, como menor número de semestres.
7. Exportar a trilha em JSON, CSV ou relatório visual.
8. Criar uma interface web simples para consultas.

## 14. Resumo das escolhas

| Decisão | Benefício | Custo ou ressalva |
|---|---|---|
| fatos em arquivo separado | manutenção simples | exige carregamento correto dos arquivos |
| mundo fechado | regras concisas | ausência é interpretada como falso |
| listas como histórico simulado | execução pura e reversível | cópia de listas durante a busca |
| lista de visitados | proteção contra ciclos | estado adicional na recursão |
| `sort/2` nos resultados | saída estável e sem duplicatas | perde a ordem original de geração |
| *backtracking* para trilhas | múltiplas soluções naturalmente | espaço de busca combinatório |
| falha limpa em erros | predicados continuam declarativos | não explica o erro ao usuário final |

---

Essas decisões mantêm o projeto fiel ao paradigma lógico e, ao mesmo tempo, demonstram de forma clara os conceitos centrais exigidos no trabalho.
