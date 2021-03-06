dados_matricula = [];
dados_ranking = [];
dados_desemp_aluno = [];
dados_periodos_filtrados = [];
dados_departamentos_filtrados = [];
dados_repetencia = [];
dados_agrupamento = [];

show_agrupamento = false;
show_repetencia = false;
show_disciplina = false;
show_distribuicao = false;
rep_filtro = false;

porDisciplina = false;
rep_tipo = "";

id_aluno = "";
id_disciplina = ""; 

box_periodo = [];
box_departamento = [];
box_grupo = [];
/*@

  Carrega todos os dados do sistema


	agrupamento.csv
		------>Todos os dados classificados por grupo (comportamento semelhante entre disciplinas de um aluno específico)  
	
	agrupamento_disciplinas
 		------>Todos os dados classificados por grupo (comportamento semelhante entre disciplinas)

	matriculas.csv
		------>Todas as matriculas dos alunos

	ranking.csv
		------>Dados referente ao ranking de cada a aluno em relação a sua turma 

	repetencia.csv
		------>Todos os dados dos alunos que repetiram alguma disciplina

*/

function loadataDisciplinas(){
        loadata();
	d3.csv("dados/disciplinas.csv",function(data){
		console.log("nao carregado");
		dados_disciplinas = data;
		var materias_disc = data.map(function(d){return d.disciplina;});
		var my_disciplinas = d3.select("#mydisciplinas");
		my_disciplinas.selectAll("option").data(materias_disc).enter().append("option")
		.attr("value",function(d){return d;})
		.attr("label",function(d){return d; })   
		.text(function(d){return d;});
		$('.selectpicker').selectpicker({'selectedText': 'cat'});
	 	console.log("carregado");
	    });

}


function loadata(){
	 d3.csv("dados/ranking.csv",function(data){
		dados_ranking = data;
	    });

	    

	    d3.csv("dados/agrupamento.csv",function(data){
		dados_desemp_aluno = data;
		var materias = data.map(function(d){return d.disciplina;}).unique().sort();
	    });

	    d3.csv("dados/repetencia.csv",function(data){
		dados_repetencia = data;
	    });

	    d3.csv("dados/agrupamento_disciplinas.csv",function(data){
		dados_agrupamento = data;
	    });

    
    
   
}

function loadataAlunos(){
    loadata();
    d3.csv("dados/matriculas.csv" , function (data){    
	
        dados_matricula = data;        
        var mat = data.map(function(d){return d.matricula;});
        var mymatriculas = d3.selectAll("#mymatriculas");
        mymatriculas.selectAll("option").data(mat).enter().append("option")
        .attr("value",function(d){return d;})
        .attr("label",function(d){return d;})
        .text(function(d){return d;}); // texto da matricula 
	$('.selectpicker').selectpicker({'selectedText': 'cat'});
	
       
    });
}

function iniciarAluno(selection){
    show_disciplina = false;
    porDisciplina = false;
    rep_tipo = "disciplina";
    id_aluno = selection.options[selection.selectedIndex].value;
    console.log("BUG - RANKING - TRACK 01 - iniciarAluno[id_aluno = " + id_aluno +"]");
    mostrarBarrasParalelas();
}

function iniciarDisciplina(selection){
    show_disciplina = true;
    porDisciplina = true;
    show_distribuicao = false;
    rep_tipo = "matricula";
    id_disciplina = selection.options[selection.selectedIndex].value;
    mostrarBarrasParalelas();
    // mostrarAgrupamento(false);
}


function mostrarBarrasParalelas(){
    d3.select("#infos2").select("svg").remove();
    d3.select("#infos").select("svg").remove();
    $("#infos").empty();
    $("#infos2").empty();


    if (show_disciplina) {
        porDisciplina = true;
        if (show_repetencia) {
            dados_atuais = dados_repetencia.filter(function(d){return d.disciplina == id_disciplina;});
            
            getRepetencia();  
        } else {
            dados_atuais = dados_desemp_aluno.filter(function(d){return d.disciplina == id_disciplina;});
            if(show_agrupamento){
                getAgrupamento();
            }else{
                getDesempenho();
            }
        } 
    }else{
	console.log("BUG - RANKING - TRACK 02 - mostrarBarrasParalelas[id_aluno = " + id_aluno +"]");
        if (show_repetencia) {
            dados_atuais = dados_repetencia.filter(function(d){return d.matricula == id_aluno;});
            getRepetencia();
		
            getRanking();
        } else { 
            dados_atuais = dados_desemp_aluno.filter(function(d){return d.matricula == id_aluno;});
            getDesempenho();
            getRanking();
        };
    };
    
    atualizarCheckBox();
}

function mostrarBarrasParalelas2(id_aluno){
    id_aluno = id_aluno;
    d3.select("#infos2").select("svg").remove();
    d3.select("#infos").select("svg").remove();
    $("#infos").empty();
    $("#infos2").empty();


    if (show_disciplina) {
        if (show_repetencia) {
            porDisciplina = true;
            dados_atuais = dados_repetencia.filter(function(d){return d.disciplina == id_disciplina;});
            getRepetencia();  
        } else { 
            porDisciplina = true;
            dados_atuais = dados_desemp_aluno.filter(function(d){return d.disciplina == id_disciplina;});
            getDesempenho();
        };
    }else{
        if (show_repetencia) {
            dados_atuais = dados_repetencia.filter(function(d){return d.matricula == id_aluno;});
            getRepetencia();
            getRanking();
        } else { 
            dados_atuais = dados_desemp_aluno.filter(function(d){return d.matricula == id_aluno;});
            getDesempenho();
            getRanking();
        };
    };
    atualizarCheckBox();
}


/*Funcao para mostrar o Desempenho de um aluno/disciplina selecionado*/
function getDesempenho(){
    init(1200, 500,"#infos2");
    executa(dados_atuais, 0,10,4);
    showLegendasRepetencia(false);
    showLegendasDesempenho(true);
    showLegendasAgrupamento(false);
}

function getRepetencia(){
    rep_filtro = true;
    init(1200, 500,"#infos2");
    executa(dados_atuais, 0,10,4);
    showLegendasRepetencia(true);
    showLegendasDesempenho(false);  
    showLegendasAgrupamento(false);
}

function getAgrupamento(){
    init(1200, 500,"#infos2");
    executa(dados_atuais, 0,10,4);
    showLegendasRepetencia(false);
    showLegendasDesempenho(false);
    showLegendasAgrupamento(true);
    show_agrupamento

}


/*Funcao para habilitar/desabilitar as opcoes*/
function atualizarCheckBox(){
    box_periodo = [];
    box_departamento = [];
    box_grupo = [];

    var periodosAluno = getPeriodos();
    var departamentosAluno = getDepartamentos();
    var gruposAluno = getGrupos();

    if (periodosAluno.indexOf("20111") == -1 || show_distribuicao == true) {
        $('#p_20111').prop('disabled', true);
        $('#p_20111').prop('checked', false);
    }else {
        $('#p_20111').prop('disabled', false);
        $('#p_20111').prop('checked', true);
        box_periodo = box_periodo.concat(["20111"]);
    };

    if (periodosAluno.indexOf("20112") == -1 || show_distribuicao == true) {
        $('#p_20112').prop('disabled', true);
        $('#p_20112').prop('checked', false);
    }else {
        $('#p_20112').prop('disabled', false);
        $('#p_20112').prop('checked', true);
        box_periodo = box_periodo.concat(["20112"]);
    };

    if (periodosAluno.indexOf("20121") == -1 || show_distribuicao == true) {
        $('#p_20121').prop('disabled', true);
        $('#p_20121').prop('checked', false);
    }else {
        $('#p_20121').prop('disabled', false);
        $('#p_20121').prop('checked', true);
        box_periodo = box_periodo.concat(["20121"]);
    };

    if (periodosAluno.indexOf("20122") == -1 || show_distribuicao == true) {
        $('#p_20122').prop('disabled', true);
        $('#p_20122').prop('checked', false);
    }else {
        $('#p_20122').prop('disabled', false);
        $('#p_20122').prop('checked', true);
        box_periodo = box_periodo.concat(["20122"]);
    };


    if (!show_disciplina) {
       if (departamentosAluno.indexOf("dsc") == -1) {
            $('#d_dsc').prop('disabled', true);
            $('#d_dsc').prop('checked', false);
        }else {
            $('#d_dsc').prop('disabled', false);
            $('#d_dsc').prop('checked', true);
            box_departamento = box_departamento.concat(["dsc"]);
        };

        if (departamentosAluno.indexOf("dme") == -1) {
            $('#d_dme').prop('disabled', true);
            $('#d_dme').prop('checked', false);
        }else {
            $('#d_dme').prop('disabled', false);
            $('#d_dme').prop('checked', true);
            box_departamento = box_departamento.concat(["dme"]);
        };

        if (departamentosAluno.indexOf("fisica") == -1) {
            $('#d_fisica').prop('disabled', true);
            $('#d_fisica').prop('checked', false);
        }else {
            $('#d_fisica').prop('disabled', false);
            $('#d_fisica').prop('checked', true);
            box_departamento = box_departamento.concat(["fisica"]);
        };

        if (departamentosAluno.indexOf("humanas") == -1) {
            $('#d_humanas').prop('disabled', true);
            $('#d_humanas').prop('checked', false);
        }else {
            $('#d_humanas').prop('disabled', false);
            $('#d_humanas').prop('checked', true);
            box_departamento = box_departamento.concat(["humanas"]);
        };

        if (departamentosAluno.indexOf("esportes") == -1) {
            $('#d_esportes').prop('disabled', true);
            $('#d_esportes').prop('checked', false);
        }else {
            $('#d_esportes').prop('disabled', false);
            $('#d_esportes').prop('checked', true);
            box_departamento = box_departamento.concat(["esportes"]);
        };
        if (!show_repetencia) {
            var teste = dados_repetencia.filter(function(d){return d.matricula == id_aluno;});    
            if((dados_repetencia.filter(function(d){return d.matricula == id_aluno;})).length == 0){
                $('#ckb_reprovacao').prop('disabled', true);
                $('#ckb_reprovacao').prop('checked', false);
             
            }else {
                $('#ckb_reprovacao').prop('disabled', false);
                $('#ckb_reprovacao').prop('checked', false);
            };

            
        };
    
    }else{
        if (!show_repetencia) {
            var teste2 = dados_repetencia.filter(function(d){return d.disciplina == id_disciplina;});

            if((dados_repetencia.filter(function(d){return d.disciplina == id_disciplina;})).length == 0){
                $('#ckb_reprovacao').prop('disabled', true);
                $('#ckb_reprovacao').prop('checked', false);
                $('#ckb_distribuicao').prop('disabled', true);
                $('#ckb_distribuicao').prop('checked', false);
            }else {
                $('#ckb_reprovacao').prop('disabled', false);
                $('#ckb_reprovacao').prop('checked', false);
                $('#ckb_distribuicao').prop('disabled', false);
                $('#ckb_distribuicao').prop('checked', false);
            };
            
            if (gruposAluno.indexOf("1") == -1) {
                $('#grupo1').prop('disabled', true);
                $('#grupo1').prop('checked', false);
            }else {
                $('#grupo1').prop('disabled', false);
                $('#grupo1').prop('checked', true);
                box_grupo = box_grupo.concat(["1"]);
            };

            if (gruposAluno.indexOf("2") == -1) {
                $('#grupo2').prop('disabled', true);
                $('#grupo2').prop('checked', false);
            }else {
                $('#grupo2').prop('disabled', false);
                $('#grupo2').prop('checked', true);
                box_grupo = box_grupo.concat(["2"]);
            };

            if (gruposAluno.indexOf("3") == -1) {
                $('#grupo3').prop('disabled', true);
                $('#grupo3').prop('checked', false);
            }else {
                $('#grupo3').prop('disabled', false);
                $('#grupo3').prop('checked', true);
                box_grupo = box_grupo.concat(["3"]);
            };

            if (gruposAluno.indexOf("4") == -1 || show_distribuicao == true) {
                $('#grupo4').prop('disabled', true);
                $('#grupo4').prop('checked', false);
            }else {
                $('#grupo4').prop('disabled', false);
                $('#grupo4').prop('checked', true);
                box_grupo = box_grupo.concat(["4"]);
            };

            if (gruposAluno.indexOf("5") == -1 || show_distribuicao == true) {
                $('#grupo5').prop('disabled', true);
                $('#grupo5').prop('checked', false);
            }else {
                $('#grupo5').prop('disabled', false);
                $('#grupo5').prop('checked', true);
                box_grupo = box_grupo.concat(["5"]);
            };

            if (gruposAluno.indexOf("6") == -1 || show_distribuicao == true) {
                $('#grupo6').prop('disabled', true);
                $('#grupo6').prop('checked', false);
            }else {
                $('#grupo6').prop('disabled', false);
                $('#grupo6').prop('checked', true);
                box_grupo = box_grupo.concat(["6"]);
            };

            if (gruposAluno.indexOf("7") == -1 || show_distribuicao == true) {
                $('#grupo7').prop('disabled', true);
                $('#grupo7').prop('checked', false);
            }else {
                $('#grupo7').prop('disabled', false);
                $('#grupo7').prop('checked', true);
                box_grupo = box_grupo.concat(["7"]);
            };

            if (gruposAluno.indexOf("8") == -1 || show_distribuicao == true) {
                $('#grupo8').prop('disabled', true);
                $('#grupo8').prop('checked', false);
            }else {
                $('#grupo8').prop('disabled', false);
                $('#grupo8').prop('checked', true);
                box_grupo = box_grupo.concat(["8"]);
            };

            if (gruposAluno.indexOf("0") == -1 || show_distribuicao == true) {
                $('#grupo9').prop('disabled', true);
                $('#grupo9').prop('checked', false);
            }else {
                $('#grupo9').prop('disabled', false);
                $('#grupo9').prop('checked', true);
                box_grupo = box_grupo.concat(["0"]);
            };

        }


    };
    
}


function getPeriodos(){
    var json1 = $.map(dados_atuais, function (r) {return r["periodo"];});
    return json1.unique();
}

function getDepartamentos(){
    var json1 = $.map(dados_atuais, function (r) {return r["departamento"];});
    return json1.unique();
}

function getGrupos(){
    var json1 = $.map(dados_atuais, function (r) {return r["grupo"];});
    return json1.unique();
}


/*Verifica checkbox de periodo*/
function verificaPeriodo(box){
    if(box.checked){
        box_periodo = box_periodo.concat(box.value);
     }else{
        box_periodo.splice(box_periodo.indexOf(box.value), 1);
   }
    filtrar();
}

/*Verifica checkbox de periodo*/
function verificaGrupo(box){
    if(box.checked){
        box_grupo = box_grupo.concat(box.value);
        show_agrupamento = true;
        showLegendasAgrupamento(true);
        showLegendasDesempenho(false);
     }else{
        box_grupo.splice(box_grupo.indexOf(box.value), 1);
        if(box_grupo.length==0){
            show_agrupamento = false;
            showLegendasAgrupamento(false);
            showLegendasDesempenho(true);
        }
   }
   filtrar();
   // atualizarCheckBox();
}

/*Verifica checkbox de departamento*/
function verificaDepartamento(box){
    if(box.checked){
        box_departamento = box_departamento.concat(box.value);
    }else{
        box_departamento.splice(box_departamento.indexOf(box.value), 1);
    }
    filtrar();
}

/*Verifica checkbox de reprovacao*/
function verificaReprovacao(box){
    if(box.checked){
        show_repetencia = true;
        show_distribuicao = false;
        showLegendasRepetencia(true);
        showLegendasDesempenho(false);  
        showLegendasAgrupamento(false);
        mostrarAgrupamento(false);
        $('#ckb_distribuicao').prop('checked', false);
    }else{
        if(show_distribuicao==false){
            showLegendasRepetencia(false);
            if(show_agrupamento==true){
                showLegendasAgrupamento(true);
                showLegendasDesempenho(false); 
                showLegendasRepetencia(false);
            }else{
                showLegendasDesempenho(true); 
                showLegendasRepetencia(false);
                showLegendasAgrupamento(false);
            }
            mostrarAgrupamento(true); 
        }
        show_repetencia = false;
    }
    mostrarBarrasParalelas();
}

/*Verifica checkbox de departamento*/
function verificaReprovacaoDistribuicao(box){
    if(box.checked){
        show_distribuicao = true;
        show_repetencia = false;
        $('#ckb_reprovacao').prop('checked', false);
        $('#ckb_distribuicao').prop('checked', true);
        showDistribuicaoReprovacao();
        showLegendasRepetencia(false);
        showLegendasDesempenho(false);
        mostrarAgrupamento(false);
    }else{
        mostrarAgrupamento(true);
        show_distribuicao = false;
        show_repetencia();

    }
    atualizarCheckBox();   
}


/*Funcao que filtra os periodos selecionados*/
function filtrar(){
    dados_periodos_filtrados = [];
    dados_departamentos_filtrados = [];
    dados_grupos_filtrados = [];

    for (var i = box_periodo.length - 1; i >= 0; i--) {
        dados_periodos_filtrados = dados_periodos_filtrados.concat(dados_atuais.filter(function(d){return d.periodo == box_periodo[i];}));
    }

    if (show_disciplina) {
        dados_processados = dados_periodos_filtrados;
        if (show_agrupamento==true){
            for (var i = box_grupo.length - 1; i >= 0; i--) {
                dados_grupos_filtrados = dados_grupos_filtrados.concat(dados_processados.filter(function(d){return d.grupo == box_grupo[i];}));
            }
            dados_processados = dados_grupos_filtrados;
        }
    } else{
        for (var i = box_departamento.length - 1; i >= 0; i--) {
            dados_departamentos_filtrados = dados_departamentos_filtrados.concat(dados_periodos_filtrados.filter(function(d){return d.departamento == box_departamento[i];}));
        }
        dados_processados = dados_departamentos_filtrados;
    }
    
    init(1200, 500,"#infos2");
    executa(dados_processados, 0,10,4);
}

function showLegendasRepetencia(mostrar){
    if(mostrar == false){
        $("#legendaRep1").hide();
        $("#legendaRep2").hide();
        $("#legendaRep3").hide();
        $("#legendaRep4").hide();
        $("#bolinhaRep1").hide();
        $("#bolinhaRep2").hide();
        $("#bolinhaRep3").hide();
        $("#bolinhaRep4").hide();
    } else{
        $("#legendaRep1").show();
        $("#legendaRep2").show();
        $("#legendaRep3").show();
        $("#legendaRep4").show();
        $("#bolinhaRep1").show();
        $("#bolinhaRep2").show();
        $("#bolinhaRep3").show();
        $("#bolinhaRep4").show();
    }
}


function showLegendasDesempenho(mostrar){
    if(mostrar == false){
        $("#legendaDes1").hide();
        $("#legendaDes2").hide();
        $("#legendaDes3").hide();
        $("#legendaDes4").hide();
        $("#bolinhaDes1").hide();
        $("#bolinhaDes2").hide();
        $("#bolinhaDes3").hide();
        $("#bolinhaDes4").hide();
    } else{
        $("#legendaDes1").show();
        $("#legendaDes2").show();
        $("#legendaDes3").show();
        $("#legendaDes4").show();
        $("#bolinhaDes1").show();
        $("#bolinhaDes2").show();
        $("#bolinhaDes3").show();
        $("#bolinhaDes4").show();
    }
}


function showLegendasAgrupamento(mostrar){
   if(mostrar == false){
        $("#legendaGrupo1").hide();
        $("#legendaGrupo2").hide();
        $("#legendaGrupo3").hide();
        $("#legendaGrupo4").hide();
        $("#legendaGrupo5").hide();
        $("#legendaGrupo6").hide();
        $("#legendaGrupo7").hide();
        $("#legendaGrupo8").hide();
        $("#legendaGrupo9").hide();
        
        $("#bolinhaGrupo1").hide();
        $("#bolinhaGrupo2").hide();
        $("#bolinhaGrupo3").hide();
        $("#bolinhaGrupo4").hide();
        $("#bolinhaGrupo5").hide();
        $("#bolinhaGrupo6").hide();
        $("#bolinhaGrupo7").hide();
        $("#bolinhaGrupo8").hide();
        $("#bolinhaGrupo9").hide();
    } else{
        $("#legendaGrupo1").show();
        $("#legendaGrupo2").show();
        $("#legendaGrupo3").show();
        $("#legendaGrupo4").show();
        $("#legendaGrupo5").show();
        $("#legendaGrupo6").show();
        $("#legendaGrupo7").show();
        $("#legendaGrupo8").show();
        $("#legendaGrupo9").show();

        $("#bolinhaGrupo1").show();
        $("#bolinhaGrupo2").show();
        $("#bolinhaGrupo3").show();
        $("#bolinhaGrupo4").show();
        $("#bolinhaGrupo5").show();
        $("#bolinhaGrupo6").show();
        $("#bolinhaGrupo7").show();
        $("#bolinhaGrupo8").show();
        $("#bolinhaGrupo9").show();
    }
};



function mostrarAgrupamento(mostrar){
    if(mostrar == false){
        $('#grupo1').prop('disabled', true);
        $('#grupo2').prop('disabled', true);
        $('#grupo3').prop('disabled', true);
        $('#grupo4').prop('disabled', true);
        $('#grupo5').prop('disabled', true);
        $('#grupo6').prop('disabled', true);
        $('#grupo7').prop('disabled', true);
        $('#grupo8').prop('disabled', true);
        $('#grupo9').prop('disabled', true);
        

        $('#grupo1').prop('checked', false);
        $('#grupo2').prop('checked', false);
        $('#grupo3').prop('checked', false);
        $('#grupo4').prop('checked', false);
        $('#grupo5').prop('checked', false);
        $('#grupo6').prop('checked', false);
        $('#grupo7').prop('checked', false);
        $('#grupo8').prop('checked', false);
        $('#grupo9').prop('checked', false);
    } else {
        $('#grupo1').prop('disabled', false);
        $('#grupo2').prop('disabled', false);
        $('#grupo3').prop('disabled', false);
        $('#grupo4').prop('disabled', false);
        $('#grupo5').prop('disabled', false);
        $('#grupo6').prop('disabled', false);
        $('#grupo7').prop('disabled', false);
        $('#grupo8').prop('disabled', false);
        $('#grupo9').prop('disabled', false);

        $('#grupo1').prop('checked', false);
        $('#grupo2').prop('checked', false);
        $('#grupo3').prop('checked', false);
        $('#grupo4').prop('checked', false);
        $('#grupo5').prop('checked', false);
        $('#grupo6').prop('checked', false);
        $('#grupo7').prop('checked', false);
        $('#grupo8').prop('checked', false);
        $('#grupo9').prop('checked', false);
    }
}


