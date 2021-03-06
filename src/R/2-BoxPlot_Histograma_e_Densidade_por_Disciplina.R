library(ggplot2)
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


# BoxPlot - DSC
for(i in 1:length(dsc)){
  nome =  gsub(" ","_",dsc[i],fixed=TRUE) 
  nome =  gsub("/","_",nome,fixed=TRUE) 
  nome =  gsub("-","_",nome,fixed=TRUE) 
  nome =  gsub("(","_",nome,fixed=TRUE) 
  nome =  gsub(")","_",nome,fixed=TRUE)   
  mypath <- file.path(paste("../../plots/2-BoxPlot/DSC/", nome, ".png", sep = ""))
  png(file=mypath, width = 900)
  p <- qplot(num_Nota, nota, data = subset(dados_validos, dados_validos$disciplina %in% dsc[i]), fill=num_Nota, geom="boxplot", main=dsc[i],xlab="Prova", ylab="Nota")+  ylim(0, 10) +  facet_grid(.~periodo)
  plot(p, main = mytitle)
  dev.off()
}


# BoxPlot - Outros
for(i in 1:length(outros)){
  nome =  gsub(" ","_",outros[i],fixed=TRUE) 
  nome =  gsub("/","_",nome,fixed=TRUE) 
  nome =  gsub("-","_",nome,fixed=TRUE) 
  nome =  gsub("(","_",nome,fixed=TRUE) 
  nome =  gsub(")","_",nome,fixed=TRUE) 
  mypath <- file.path(paste("../../plots/2-BoxPlot/Outros/", nome, ".png", sep = ""))
  png(file=mypath, width = 900)
  p <- qplot(num_Nota, nota, data = subset(d, d$disciplina %in% outros[i]), fill=num_Nota, geom="boxplot", main=outros[i],xlab="Prova", ylab="Nota")+  ylim(0, 10) +  facet_grid(.~periodo)
  plot(p, main = mytitle)
  dev.off()
}


# Histograma - DSC
for(i in 1:length(dsc)){
  nome =  gsub(" ","_",dsc[i],fixed=TRUE) 
  nome =  gsub("/","_",nome,fixed=TRUE) 
  nome =  gsub("-","_",nome,fixed=TRUE) 
  nome =  gsub("(","_",nome,fixed=TRUE) 
  nome =  gsub(")","_",nome,fixed=TRUE)   
  mypath <- file.path(paste("../../plots/2-Histograma/DSC/", nome, ".png", sep = ""))
  png(file=mypath, width = 900)
  p <- ggplot(subset(d, d$disciplina %in% dsc[i]), aes(x=nota, fill=num_Nota))+ labs(title=dsc[i], y="Ocorr�ncia", x="Nota")  + geom_histogram(binwidth = 1)+  facet_grid(num_Nota~periodo) #+ scale_y_continuous(limits=c(0, 5000))
  plot(p, main = mytitle)
  dev.off()
}


# Histograma - Outros
for(i in 1:length(outros)){
  nome =  gsub(" ","_",outros[i],fixed=TRUE) 
  nome =  gsub("/","_",nome,fixed=TRUE) 
  nome =  gsub("-","_",nome,fixed=TRUE) 
  nome =  gsub("(","_",nome,fixed=TRUE) 
  nome =  gsub(")","_",nome,fixed=TRUE)   
  mypath <- file.path(paste("../../plots/2-Histograma/Outros/", nome, ".png", sep = ""))
  png(file=mypath, width = 900)
  p<-ggplot(subset(d, d$disciplina %in% outros[i]), aes(x=nota, fill=num_Nota)) + labs(title=outros[i], y="Ocorr�ncia", x="Nota") + geom_histogram(binwidth = 1)+  facet_grid(num_Nota~periodo)
  plot(p, main = mytitle)
  dev.off()
}


# Densidade - DSC
for(i in 1:length(dsc)){
  nome =  gsub(" ","_",dsc[i],fixed=TRUE) 
  nome =  gsub("/","_",nome,fixed=TRUE) 
  nome =  gsub("-","_",nome,fixed=TRUE) 
  nome =  gsub("(","_",nome,fixed=TRUE) 
  nome =  gsub(")","_",nome,fixed=TRUE)   
  mypath <- file.path(paste("../../plots/2-Densidade/DSC/", nome, ".png", sep = ""))
  png(file=mypath, width = 900)
  p <- ggplot(subset(d, d$disciplina %in% dsc[i]), aes(x=nota, fill=num_Nota))+ labs(title=dsc[i], y="Densidade", x="Nota")  + geom_density(binwidth = 1)+  facet_grid(num_Nota~periodo) #+ scale_y_continuous(limits=c(0, 5000))
  plot(p, main = mytitle)
  dev.off()
}


# Densidade - Outros
for(i in 24:length(outros)){
  nome =  gsub(" ","_",outros[i],fixed=TRUE) 
  nome =  gsub("/","_",nome,fixed=TRUE) 
  nome =  gsub("-","_",nome,fixed=TRUE) 
  nome =  gsub("(","_",nome,fixed=TRUE) 
  nome =  gsub(")","_",nome,fixed=TRUE)   
  mypath <- file.path(paste("../../plots/2-Densidade/Outros/", nome, ".png", sep = ""))
  png(file=mypath, width = 900)
  p <- ggplot(subset(d, d$disciplina %in% outros[i]), aes(x=nota, fill=num_Nota))+ labs(title=outros[i], y="Densidade", x="Nota")  + geom_density(binwidth = 1)+  facet_grid(num_Nota~periodo) #+ scale_y_continuous(limits=c(0, 5000))
  plot(p, main = mytitle)
  dev.off()
}
