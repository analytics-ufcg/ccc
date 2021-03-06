import csv
import json
import pyodbc

def create_connection():
    return pyodbc.connect("DSN=VerticaDSN")

def disciplinas_por_periodo():
    cnxn = create_connection()
    cursor = cnxn.cursor()
    cursor.execute("select * from GradeDisciplinasPorPeriodo")
    rows = cursor.fetchall()
    cnxn.close()
    lista_tuplas = []
    for tupla in rows:
       lista_tuplas.append(tupla)
    col = ["codigo", "periodo", "disciplina"]
    response = montaJson(lista_tuplas, col)
    return json.dumps(response)


def pre_requisitos():
    cnxn = create_connection()
    cursor = cnxn.cursor()
    cursor.execute("select * from PreRequisitosDisciplina")
    rows = cursor.fetchall()
    cnxn.close()
    lista_tuplas = []
    for tupla in rows:
       lista_tuplas.append(tupla)
    col = ["codigo", "codigoPreRequisito"]
    response = montaJson(lista_tuplas, col)
    return json.dumps(response)


def maiores_frequencias():
    cnxn = create_connection()
    cursor = cnxn.cursor()
    cursor.execute("select * from MaioresFrequenciasPorDisciplinaOrdenadoObrigatorias")
    rows = cursor.fetchall()
    cnxn.close()
    lista_tuplas = []
    for tupla in rows:
       lista_tuplas.append(tupla)
    col = ["codigo", "disciplina", "periodoMaisFreq1st", "freqRelativa1st", "periodoMaisFreq2nd", "freqRelativa2nd", "periodoMaisFreq3rd", "freqRelativa3rd", "totalDeAlunos"]
    response = montaJson(lista_tuplas, col)
    return json.dumps(response)

def montaJson(spamreader, col):
	response = []
	colunas = col
	i = 0
	for row in spamreader:
		celulas = {}
		for indexColumns in range(0,len(colunas)):
			celulas[colunas[indexColumns]] = row[indexColumns]
		response.append(celulas)
		i = i + 1;
	return response
