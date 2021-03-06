library(ggplot2)
library(gridExtra)

d = read.csv("../../data/notas.txt",sep = "\t", encoding = "UTF-8")

for(i in 1:nrow(d)){
  d$periodo[i] <- paste(d$ano[i],d$periodo[i],sep = ".")
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
dados_validos = subset(d, d$situacao %in% c("A","R"))

# Separando os dados do DSC e de outros departamentos 
dados_dsc = subset(dados_validos, dados_validos$disciplina %in% dsc)
dados_outros = subset(dados_validos, dados_validos$disciplina %in% outros)


############ vers�o 5 - media
# BoxPlot por entrada simples - Outros
z <- subset(dados_validos, dados_validos$disciplina %in% outros)
primeiro <- subset(z,substr(z$matricula, 4, 4) %in% c("1"))
segundo <- subset(z,substr(z$matricula, 4, 4) %in% c("2"))
p <- qplot("-", media, data = primeiro, geom="boxplot", main = "Alunos da pimeira entrada - Outros departamentos",xlab="", ylab="Nota")+  ylim(0, 10)
s <- qplot("-", media, data = segundo, geom="boxplot", main = "Alunos da segunda entrada - Outros departamentos",xlab="", ylab="Nota")+  ylim(0, 10)
grid.arrange(p, s, ncol=2)

# BoxPlot por entrada simples - DSC
z <- subset(dados_validos, dados_validos$disciplina %in% dsc)
primeiro <- subset(z,substr(z$matricula, 4, 4) %in% c("1"))
segundo <- subset(z,substr(z$matricula, 4, 4) %in% c("2"))
p <- qplot("-", media, data = primeiro, geom="boxplot", main = "Alunos da pimeira entrada - DSC",xlab="", ylab="Nota")+  ylim(0, 10)
s <- qplot("-", media, data = segundo, geom="boxplot", main = "Alunos da segunda entrada - DSC",xlab="", ylab="Nota")+  ylim(0, 10)
grid.arrange(p, s, ncol=2)


############ vers�o 6 - media
# BoxPlot por entrada / periodo - Outros
z <- subset(dados_validos, dados_validos$disciplina %in% outros)
primeiro <- subset(z,substr(z$matricula, 4, 4) %in% c("1"))
segundo <- subset(z,substr(z$matricula, 4, 4) %in% c("2"))
p <- qplot("-", media, data = primeiro, geom="boxplot", main = "Alunos da pimeira entrada - Outros departamentos",xlab="", ylab="Nota")+  ylim(0, 10)+  facet_grid(.~periodo)
s <- qplot("-", media, data = segundo, geom="boxplot", main = "Alunos da segunda entrada - Outros departamentos",xlab="", ylab="Nota")+  ylim(0, 10)+  facet_grid(.~periodo)
grid.arrange(p, s, ncol=2)

# BoxPlot por entrada / periodo - DSC
z <- subset(dados_validos, dados_validos$disciplina %in% dsc)
primeiro <- subset(z,substr(z$matricula, 4, 4) %in% c("1"))
segundo <- subset(z,substr(z$matricula, 4, 4) %in% c("2"))
p <- qplot("-", media, data = primeiro, geom="boxplot", main = "Alunos da pimeira entrada - DSC",xlab="", ylab="Nota")+  ylim(0, 10)+  facet_grid(.~periodo)
s <- qplot("-", media, data = segundo, geom="boxplot", main = "Alunos da segunda entrada - DSC",xlab="", ylab="Nota")+  ylim(0, 10)+  facet_grid(.~periodo)
grid.arrange(p, s, ncol=2)




############ Teste de hipotese
z <- subset(dados_validos, dados_validos$disciplina %in% outros)
primeiro <- subset(z,substr(z$matricula, 4, 4) %in% c("1"))
segundo <- subset(z,substr(z$matricula, 4, 4) %in% c("2"))
t.test(primeiro$media,segundo$media, alternative="greater",conf.level=1) #primeiro > segundo com 95% de conf

#Welch Two Sample t-test

#data:  primeiro$media and segundo$media
#t = 9.4957, df = 9715.232, p-value < 2.2e-16
#alternative hypothesis: true difference in means is greater than 0
#100 percent confidence interval:
#  -Inf  Inf
#sample estimates:
#  mean of x mean of y 
#6.046157  5.523940 