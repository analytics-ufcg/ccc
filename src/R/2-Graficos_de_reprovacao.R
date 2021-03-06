library(ggplot2)
library(gridExtra)

dados = read.csv("../../data/notas_alunos.csv",sep = "|", encoding = "UTF-8")
names(dados)[8] <- "Taxa"

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

dados_dsc <- subset(dados, dados$disciplinas %in% dsc)
dados_outros <- subset(dados, dados$disciplinas %in% outros)

top8_piores_dsc <- subset(dados, dados$disciplinas %in% c("Teoria da Computa��o", "Lab. de Programa��o I", "Lab. de Programa��o II", "Matem�tica Discreta", "Programa��o I", "Programa��o II", "Ger�ncia da Informa��o","Compiladores"))
top8_piores_outros <- subset(dados, dados$disciplinas %in% c("M�todos Estat�sticos","�lgebra Linear", "�lgebra Vetorial e Geometria Anal�tica", "C�lculo Diferencial e Integral I", "C�lculo Diferencial e Integral II", "Fundamentos de F�sica Cl�ssica", "Probabilidade e Estat�stica","Economia"))

# Gr�fico de barras - Taxa de reprovacao por per�odo
qplot(disciplinas, data=dados_dsc, geom="bar", weight=Taxa, ylim=c(0,100), main = "Dados - DSC\n", xlab= "Disciplinas", ylab="Taxa de reprova��o", fill = Taxa) + facet_grid(. ~ periodo) +coord_flip() + scale_fill_gradientn(limits=c(0, 100),colours = c("dark green", "orange", "red")) + theme(panel.grid.major = element_line(size = 0.8), panel.grid.minor = element_line(colour = "white"))
qplot(disciplinas, data=dados_outros, geom="bar", weight=Taxa, ylim=c(0,100), main = "Dados - Outros departamentos\n", xlab= "Disciplinas", ylab="Taxa de reprova��o", fill = Taxa) + facet_grid(. ~ periodo) +coord_flip() + scale_fill_gradientn(limits=c(0, 100),colours = c("dark green", "orange", "red"))+ theme(panel.grid.major = element_line(size = 0.8), panel.grid.minor = element_line(colour = "white"))

# Box Plot da taxa de reprovacao 
ggplot(dados_dsc, aes(factor(disciplinas), Taxa)) + geom_boxplot(fill = "light blue", colour = "dark blue") +  ylim(0, 100) + coord_flip() + labs(list(title = "Dados - DSC\n", x = "Disciplinas", y = "Taxa de reprova��o")) +  theme(panel.grid.major = element_line(size = 1), panel.grid.minor = element_line(colour = "white"))
ggplot(dados_outros, aes(factor(disciplinas), Taxa)) + geom_boxplot(fill = "light blue", colour = "dark blue") +  ylim(0, 100) + coord_flip() + labs(list(title = "Dados - Outros departamentos\n", x = "Disciplinas", y = "Taxa de reprova��o")) +  theme(panel.grid.major = element_line(size = 1), panel.grid.minor = element_line(colour = "white"))

# Gr�fico de barras - Taxa de reprovacao TOP 8
plot1 <- qplot(disciplinas, data=top8_piores_dsc, geom="bar", weight=Taxa, ylim=c(0,100), main = "Dados - DSC\n", xlab= "Disciplinas", ylab="Taxa de reprova��o", fill = Taxa) + facet_grid(. ~ periodo) +coord_flip() + scale_fill_gradientn(limits=c(0, 100),colours = c("dark green", "orange", "red")) + theme(panel.grid.major = element_line(size = 0.8), panel.grid.minor = element_line(colour = "white"))
plot2 <- qplot(disciplinas, data=top8_piores_outros, geom="bar", weight=Taxa, ylim=c(0,100), main = "Dados - Outros departamentos\n", xlab= "Disciplinas", ylab="Taxa de reprova��o", fill = Taxa) + facet_grid(. ~ periodo) +coord_flip() + scale_fill_gradientn(limits=c(0, 100),colours = c("dark green", "orange", "red"))+ theme(panel.grid.major = element_line(size = 0.8), panel.grid.minor = element_line(colour = "white"))
grid.arrange(plot1, plot2, ncol=2)

# Box Plot da taxa de reprovacao TOP 8
plot3 <- ggplot(top8_piores_dsc, aes(factor(disciplinas), Taxa)) + geom_boxplot(fill = "light blue", colour = "dark blue") +  ylim(0, 100) + coord_flip() + labs(list(title = "Dados - DSC\n", x = "Disciplinas", y = "Taxa de reprova��o")) +  theme(panel.grid.major = element_line(size = 1), panel.grid.minor = element_line(colour = "white"))
plot4 <- ggplot(top8_piores_outros, aes(factor(disciplinas), Taxa)) + geom_boxplot(fill = "light blue", colour = "dark blue") +  ylim(0, 100) + coord_flip() + labs(list(title = "Dados - Outros departamentos\n", x = "Disciplinas", y = "Taxa de reprova��o")) +  theme(panel.grid.major = element_line(size = 1), panel.grid.minor = element_line(colour = "white"))
grid.arrange(plot3, plot4, ncol=2)


# Gr�fico de barras ordenado - DSC
mm <- ddply(dados_dsc, "disciplinas", summarise, taxa_de_reprovacao = mean(Taxa))
mm = mm[order(mm$taxa_de_reprovacao,mm$disciplinas) , ]
qplot(reorder(disciplinas, -taxa_de_reprovacao), data=mm, geom="bar", weight=taxa_de_reprovacao, ylim=c(0,100), main = "Dados - Outros departamentos\n", xlab= "Disciplinas", ylab="Taxa de reprova��o", fill = taxa_de_reprovacao) + coord_flip() + scale_fill_gradientn(limits=c(0, 100),colours = c("dark green", "orange", "red"))+ theme(panel.grid.major = element_line(size = 0.8), panel.grid.minor = element_line(colour = "white"))

# Gr�fico de barras ordenado - Outros
mm <- ddply(dados_outros, "disciplinas", summarise, taxa_de_reprovacao = mean(Taxa))
mm = mm[order(mm$taxa_de_reprovacao,mm$disciplinas) , ]
qplot(reorder(disciplinas, -taxa_de_reprovacao), data=mm, geom="bar", weight=taxa_de_reprovacao, ylim=c(0,100), main = "Dados - Outros departamentos\n", xlab= "Disciplinas", ylab="Taxa de reprova��o", fill = taxa_de_reprovacao) + coord_flip() + scale_fill_gradientn(limits=c(0, 100),colours = c("dark green", "orange", "red"))+ theme(panel.grid.major = element_line(size = 0.8), panel.grid.minor = element_line(colour = "white"))
