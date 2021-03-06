library(ggplot2)
library(gridExtra)
dados = read.csv("../../data/notas_alunos.csv",sep = "|", encoding = "UTF-8")

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


# Separando os dados do DSC e de outros departamentos 
dados_dsc = subset(dados, dados$disciplina %in% dsc)
dados_outros = subset(dados, dados$disciplina %in% outros)


# Boxplot por periodo
plot1 <- ggplot(dados_dsc, aes(factor(periodo), R_F)) + geom_boxplot(fill = "light blue", colour = "dark blue") +  ylim(0, 100) + coord_flip() + labs(list(title = "Dados - DSC\n", x = "Per�odo", y = "Taxa de reprova��o")) +  theme(panel.grid.major = element_line(size = 1), panel.grid.minor = element_line(colour = "white"))
plot2 <- ggplot(dados_outros, aes(factor(periodo), R_F)) + geom_boxplot(fill = "light blue", colour = "dark blue") +  ylim(0, 100) + coord_flip() + labs(list(title = "Dados - Outros departamentos\n", x = "Per�odo", y = "Taxa de reprova��o")) +  theme(panel.grid.major = element_line(size = 1), panel.grid.minor = element_line(colour = "white"))
grid.arrange(plot1, plot2, ncol=2)

# Boxplot geral
plot5 <- ggplot(dados_dsc, aes(factor(""), R_F)) + geom_boxplot(fill = "light blue", colour = "dark blue") +  ylim(0, 100) + coord_flip() + labs(list(title = "Dados - DSC\n", x = "DSC", y = "Taxa de reprova��o")) +  theme(panel.grid.major = element_line(size = 1), panel.grid.minor = element_line(colour = "white"))
plot6 <- ggplot(dados_outros, aes(factor(""), R_F)) + geom_boxplot(fill = "light blue", colour = "dark blue") +  ylim(0, 100) + coord_flip() + labs(list(title = "Dados - Outros departamentos\n", x = "Outros departamentos", y = "Taxa de reprova��o")) +  theme(panel.grid.major = element_line(size = 1), panel.grid.minor = element_line(colour = "white"))
grid.arrange(plot5, plot6, ncol=2)


# Densidade por periodo
plot3 <- ggplot(dados_dsc, aes(x = R_F)) +stat_density() + facet_grid( .~periodo) +xlim(0, 100)+ylim(0, 0.05)+ labs(list(title = "Dados - DSC\n", y = "Desidade", x = "Taxa de reprova��o")) +  theme(panel.grid.major = element_line(size = 1), panel.grid.minor = element_line(colour = "white"))
plot4 <- ggplot(dados_outros, aes(x = R_F)) +stat_density() + facet_grid( .~periodo) +xlim(0, 100)+ylim(0, 0.05)+ labs(list(title = "Dados - Outros departamentos\n", y = "Densidade", x = "Taxa de reprova��o")) +  theme(panel.grid.major = element_line(size = 1), panel.grid.minor = element_line(colour = "white"))
grid.arrange(plot3, plot4, ncol=2)

# Densidade geral
plot7 <- ggplot(dados_dsc, aes(x = R_F)) +stat_density() + xlim(0, 100)+ylim(0, 0.05)+ labs(list(title = "Dados - DSC\n", y = "Desidade", x = "Taxa de reprova��o")) +  theme(panel.grid.major = element_line(size = 1), panel.grid.minor = element_line(colour = "white"))
plot8 <- ggplot(dados_outros, aes(x = R_F)) +stat_density() + xlim(0, 100)+ylim(0, 0.05)+ labs(list(title = "Dados - Outros departamentos\n", y = "Densidade", x = "Taxa de reprova��o")) +  theme(panel.grid.major = element_line(size = 1), panel.grid.minor = element_line(colour = "white"))
grid.arrange(plot7, plot8, ncol=2)

# Histograma sem legenda 
plot9 <- ggplot(dados_dsc, aes(x=R_F)) + geom_histogram(aes(y = ..density..))+ geom_vline(xintercept = mean(dados_dsc$R_F),colour="green", size =1) + geom_vline(xintercept = median(dados_dsc$R_F),colour="blue", size =1)+ scale_y_continuous(limits=c(0, 0.20))+ scale_x_continuous(limits=c(0, 100))+ labs(list(title = "Reprova��o - DSC", x = "Taxa de reprova��o", y = "Frequ�ncia"))
plot10 <- ggplot(dados_outros, aes(x=R_F)) + geom_histogram(aes(y = ..density..))+ geom_vline(xintercept = mean(na.omit(dados_outros$R_F)),colour="green", size =1) + geom_vline(xintercept = median(na.omit(dados_outros$R_F)),colour="blue", size =1)+ scale_y_continuous(limits=c(0, 0.20))+ scale_x_continuous(limits=c(0, 100))+ labs(list(title = "Reprova��o - Outros departamentos", x = "Taxa de reprova��o", y = "Frequ�ncia"))
grid.arrange(plot9, plot10, ncol=2)

# Histograma com legenda
par(mfrow=c(1, 2))
hist(dados_dsc$R_F,  main = "Reprova��o - DSC", xlab ="Taxa de reprova��o", ylab = "Densidade", col='light blue',probability=TRUE, xlim=c(0,100),  ylim=c(0, 0.10)) 
abline(v = mean(dados_dsc$R_F), col=2, lty=1, lwd=2) 
abline(v = median(dados_dsc$R_F), col=3, lty=1, lwd=2) 
abline(v = which.max(table(dados_dsc$R_F)), col=4, lty=1, lwd=2) 
ex12 = expression(media, mediana, moda) 
utils::str(legend("topright", ex12, col = 2:4, lty=1, lwd=2)) 
hist(dados_outros$R_F, main = "Reprova��o - Outros departamentos", xlab ="Taxa de reprova��o", ylab = "Densidade" ,col='light blue',probability=TRUE, xlim=c(0,100),  ylim=c(0, 0.10)) 
abline(v = mean(na.omit(dados_outros$R_F)), col=2, lty=1, lwd=2) 
abline(v = median(na.omit(dados_outros$R_F)), col=3, lty=1, lwd=2) 
abline(v = which.max(table(na.omit(dados_outros$R_F))), col=4, lty=1, lwd=2) 
ex12 = expression(media, mediana, moda) 
utils::str(legend("topright", ex12, col = 2:4, lty=1, lwd=2)) 
par(mfrow=c(1, 1))
