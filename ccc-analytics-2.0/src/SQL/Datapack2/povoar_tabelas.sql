--rodar isql -v [DSN] desde ccc-analytics-2.0
--caso nao funcione usar o caminho global (completo) para o CSV

COPY Disciplina (CodigoDisciplina, NomeDisciplina, CodigoDepto, Obrigatoria) FROM LOCAL '/home/tales/R Dev/Scripts/Dados v2/data/TabelaDisciplina.csv' WITH DELIMITER ',';

COPY Aluno (MatriculaAluno) FROM LOCAL '/home/tales/R Dev/Scripts/Dados v2/data/TabelaAlunos.csv' WITH DELIMITER ',';

COPY DisciplinaAluno (CodigoDisciplina, MatriculaAluno, Periodo, Media, PeriodoRelativo, CodigoSituacao) FROM LOCAL '/home/tales/development/ccc/ccc-analytics-2.0/data/CSVtoDatabase/Datapack2/TabelaDisciplinaAluno.csv' WITH DELIMITER ',';

COPY Departamento (CodigoDepto, NomeDepto, CentroUA, Area) FROM LOCAL '/home/tales/R Dev/Scripts/Dados v2/data/TabelaDepartamento.csv' WITH DELIMITER ',';

COPY Situacao (CodigoSituacao, NomeSituacao) FROM LOCAL '/home/tales/R Dev/Scripts/Dados v2/data/TabelaSituacao.csv' WITH DELIMITER ',';

--Este CSV foi criado por Célio a partir de um outro CSV
COPY PreRequisitosDisciplina (CodigoDisciplina, CodigoPreRequisito) FROM LOCAL '/home/tales/R Dev/Scripts/Dados v2/data/TabelaPrerrequisitosDisciplina.csv' WITH DELIMITER ',';

COPY GradeDisciplinasPorPeriodo (Periodo, CodigoDisciplina) FROM LOCAL '/home/tales/R Dev/Scripts/Dados v2/gradeObr.csv' WITH DELIMITER ',';

--Deve-se deletar a coluna TipoDisciplina antes de copiar, esta informação é redundante e pode ser encontrada na tabela Disciplina
COPY MaioresFrequenciasPorDisciplina (CodigoDisciplina, PeriodoMaisFreq1st, FreqRelativa1st, PeriodoMaisFreq2nd, FreqRelativa2nd, PeriodoMaisFreq3rd, FreqRelativa3rd, TotalDeAlunosPorDisciplina) FROM LOCAL '/home/tales/R Dev/Scripts/Dados v2/data/TabelaMaioresFrequenciasPorDisciplina.csv'  WITH DELIMITER ',';

COPY Reprovacoes (CodigoDisciplina, ReprovacaoAbsoluta, ReprovacaoRelativa) FROM LOCAL '/home/tales/R Dev/Scripts/Dados v2/data/TabelaReprovacoesPorDisciplina.csv' WITH DELIMITER ',';

--Para povoar tabela Clusters é necessário modificar o CSV X_cluster.csv. Para esta copia uso um csv modificado meu
COPY PerfisFluxograma (CodigoDisciplina, Periodo, Cluster) FROM LOCAL 'ccc-analytics-2.0/ccc2/data/SwapNomePorCodigo/all_clusters.csv' WITH DELIMITER ',';

COPY CorrelacaoDisciplinasPorNotas (CodDisciplina1, CodDisciplina2, Correlacao) FROM LOCAL '/home/tales/development/ccc/ccc-analytics-2.0/data/US06_matrizCorrelacaoFiltrada_spearmaan.csv' WITH DELIMITER ',';
