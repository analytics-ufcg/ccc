library(ggplot2)
dados = read.csv("../../data/notas.txt", sep = "\t",dec=",",encoding = "UTF-8")

# Transformando a apresentaco do periodo
for(i in 1:(length(dados$periodo))){
  dados[i,2] <- paste(dados$ano[i],dados$periodo[i], sep = ".")
}

outros <- c("Administra��o", "�lgebra Linear", "�lgebra Vetorial e Geometria Anal�tica", 
            "BASQUETE   MASC/FEM",  "BASQUETEBOL - FEM", "BASQUETEBOL - MASC", 
            "C�lculo Diferencial e Integral I", "C�lculo Diferencial e Integral II", 
            "C�lculo Diferencial e Integral III", "Direito e Cidadania", "Economia", 
            "EQUACOES DIFERENCIAIS", "EXPRESSAO GRAFICA", "Fundamentos de F�sica Cl�ssica", 
            "Fundamentos de F�sica Moderna", "Futsal", "Inform�tica e Sociedade", "Ingl�s", 
            "Introdu��o � Arquitetura", "Leitura e Produ��o de Textos", "M�todos Estat�sticos", 
            "Probabilidade e Estat�stica", "Qu�mica Geral", "Rela��es Humanas", "Sociologia Industrial I" )

dsc <- c("An�lise e T�cnicas de Algoritmos", "Avalia��o de Desempenho de Sistemas Discretos", 
         "Banco de Dados I", "Banco de Dados II", 
         "Compiladores", "Empreendedorismo", 
         "Engenharia de Software I", "Est�gio Integrado", 
         "Estruturas de Dados e Algoritmos", "Ger�ncia da Informa��o", 
         "GERENCIA DE Redes de Computadores", "Intelig�ncia Artificial I", "Interconex�o de Redes de Computadores", 
         "Introdu��o � Computa��o", "Lab. de Engenharia de Software", 
         "Lab. de Estruturas de Dados e Algoritmos", "Lab. de Interconex�o de Redes de Computadores", 
         "Lab. de Organiza��o e Arquitetura de Computadores", "Lab. de Programa��o I", 
         "Lab. de Programa��o II", "L�gica Matem�tica", 
         "Matem�tica Discreta", "Metodologia Cient�fica", "M�todos e Software Num�ricos", 
         "Organiza��o e Arquitetura de Computadores", 
         "Paradigmas de Linguagem de Programa��o", 
         "Programa��o I", "Programa��o II", "Projeto de Redes de Computadores", 
         "Projeto em Computa��o I", "Projeto em Computa��o II", 
         "Redes de Computadores", "Redes Neurais", 
         "Semin�rios (Educa��o Ambiental)", "Sistemas de Informa��o I", 
         "Sistemas de Informa��o II", "Sistemas de Informa��es Geogr�ficas", 
         "Sistemas Operacionais", "TEC (Princ�pios de Administra��o Financeira)", 
         "TECC (Administra��o de Sistemas)", "TECC (Algoritmos Avan�ados I)", 
         "TECC (Algoritmos Avan�ados II)", "TECC (Algoritmos Avan�ados III)", 
         "TECC (Economia de Tecnologia da Informa��o)", "TECC (Est�gio Integrado II)", 
         "TECC (Fundamentos e Aplica��es de Realidade Virtual)", "TECC (M�todos Formais)", 
         "TECC (Modelagem de Ambientes Virtuais)", "TECC (Redes Ad Hoc Sem Fio)", 
         "TECC (Seguran�a em Redes de Computadores)", "TECC (Sistemas de Recupera��o da Informa��o)", 
         "TECC (Vis�o Computacional)", "TECC(DIDATICA EM CIENCIA DA COMPUTACAO II)", 
         "TECC(DIDATICA EM CIENCIA DA COMPUTACAO)", "TECC(Empreendedorismo em Software)   ", 
         "TECC(Fundamentos de Prog. Concorrente)", "TECC(METODOS E P T G M DADOS HISTORICOS)", 
         "Teoria da Computa��o", "Teoria dos Grafos")

# Retirando os dados dos alunos reprovados por falta ou trancamento
dados_validos = subset(dados, dados$situacao %in% c("A","R"))

# Separando os dados do DSC e de outros departamentos 
dados_dsc = subset(dados_validos, dados_validos$disciplina %in% dsc)
dados_outros = subset(dados_validos, dados_validos$disciplina %in% outros)


# Retirando as m�ltiplas entradas por aluno
dados_validos <- dados_validos[!duplicated(dados_validos[,c("matricula","disciplina")]),]

# Adicionando colunas
dados_validos[10] <- NA
dados_validos[11] <- NA
names(dados_validos) <- c("ano","periodo","codigo","disciplina","matricula","num_Nota","nota","media","situacao","final","aprovado_final")

# Preenchendo as colunas "final" e "aprovado_final"
for(i in 1:(nrow(dados_validos))){
  if (dados_validos$num_Nota[i] == "F"){
      if (dados_validos$media[i] < 5) {
        dados_validos$aprovado_final[i] = "2. Reprova��o na final"
      }else{
        dados_validos$aprovado_final[i] = "3. Aprova��o na final"
      }
  }else{
    if (dados_validos$media[i] < 4) {
      dados_validos$aprovado_final[i] = "1. Reprova��o por m�dia"
    }else {
      dados_validos$aprovado_final[i] = "4. Aprova��o por m�dia"
    }
  }
}



# Calcula o numero de ocorrencias de cada situacao 
dados_validos$contador = 1 
disc_taxa = aggregate(dados_validos$contador,list(dados_validos$disciplina, dados_validos$situacao, dados_validos$aprovado_final, dados_validos$periodo),FUN=sum)
names(disc_taxa) <- c("disciplina","situacao","aprovado_final","periodo","ocorrencia")

# Calculando o total de matri?culas por peri?odo/disciplina 
matriculados = aggregate(disc_taxa$ocorrencia, list(disc_taxa$disciplina, disc_taxa$periodo),FUN=sum)
names(matriculados) <- c("disciplina","periodo","matriculados")


# Adicionando a coluna do total de matriculados
disc_taxa$matriculados = NA
for(i in 1:(nrow(disc_taxa))){
  for(j in 1:(nrow(matriculados))){
    if(disc_taxa$disciplina[i] ==  matriculados$disciplina[j] && disc_taxa$periodo[i] ==  matriculados$periodo[j] )
      disc_taxa$matriculados[i] <- matriculados$matriculados[j]
  }
}


# Adicionando a taxa de final
d_dsc <- subset(disc_taxa, disc_taxa$disciplina %in% dsc)
d_dsc[7] <- NA
names(d_dsc) <- c("disciplina", "situacao", "aprovado_final", "periodo", "ocorrencia","matriculados", "taxa_final")
for(i in 1:nrow(d_dsc)){
  d_dsc$taxa_final[i] <- (d_dsc$ocorrencia[i]*100)/d_dsc$matriculados[i]
}
d_outros <- subset(disc_taxa, disc_taxa$disciplina %in% outros)
d_outros[7] <- NA
names(d_outros) <- c("disciplina", "situacao", "aprovado_final", "periodo", "ocorrencia","matriculados", "taxa_final")
for(i in 1:nrow(d_outros)){
  d_outros$taxa_final[i] <- (d_outros$ocorrencia[i]*100)/d_outros$matriculados[i]
}


# Plotando os gr�ficos de Distribui��o de alunos na final por disciplina, 
names(d_outros) <- c("disciplina", "situacao", "Aprovados", "periodo", "ocorrencia", "matriculados", "Taxa")
names(d_dsc) <- c("disciplina", "situacao", "Aprovados", "periodo", "ocorrencia", "matriculados", "Taxa")
ggplot(d_outros, aes(x=disciplina, y=Taxa, fill = factor(Aprovados))) + labs(title="Distribui��o de alunos na final - Outros departamentos", y="Taxa", x="Disciplina") + geom_bar(stat = "identity")+ coord_flip()+ facet_grid(. ~ periodo) + scale_fill_manual(values = c("#B80000","#FF6600","#FFCC00","#339900"))
ggplot(d_dsc, aes(x=disciplina, y=Taxa, fill = Aprovados)) + labs(title="Distribui��o de alunos na final - DSC", y="Taxa", x="Disciplina") + geom_bar(stat = "identity")+ coord_flip()+ facet_grid(. ~ periodo)  + scale_fill_manual(values = c("#B80000","#FF6600","#FFCC00","#339900"))


# Plotando os gr�ficos de alunos reprovados sem final
l <- subset(d_outros, Aprovados %in% c("1. Reprova��o por m�dia"))
#l <- subset(l, situacao %in% c("R"))
m <- subset(d_dsc, Aprovados %in% c("1. Reprova��o por m�dia"))
#m <- subset(m, situacao %in% c("R"))
qplot(disciplina, data=l, geom="bar", weight=Taxa, ylim=c(0,100), main = "Distribui��o de alunos reprovados sem final - Outros departamentos", xlab= "Disciplinas", ylab="Taxa de reprova��o", fill = Taxa) + facet_grid(. ~ periodo) +coord_flip() + scale_fill_gradientn(limits=c(0, 100),colours = c("dark green", "orange", "red")) + theme(panel.grid.major = element_line(size = 0.8), panel.grid.minor = element_line(colour = "white"))
qplot(disciplina, data=m, geom="bar", weight=Taxa, ylim=c(0,100), main = "Distribui��o de alunos reprovados sem final - DSC", xlab= "Disciplinas", ylab="Taxa de reprova��o", fill = Taxa) + facet_grid(. ~ periodo) +coord_flip() + scale_fill_gradientn(limits=c(0, 100),colours = c("dark green", "orange", "red")) + theme(panel.grid.major = element_line(size = 0.8), panel.grid.minor = element_line(colour = "white"))
