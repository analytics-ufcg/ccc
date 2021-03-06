var margin = {top: 0, right: 40, bottom: 20, left: 200},
    w, //calcula a largura das colunas
    h; //calcula a altura das colunas
    colunas = 3; //numero de colunas a serem plotados
    campos = 0; // para contar o numero de campos, isso evita de ficar declarando a variavel em toda funcao

var x,t
    y = {},
    dragging = {};

var line = d3.svg.line().defined(function(d) { return !isNaN(d[1]); }),
    axis = d3.svg.axis().orient("left"),
    background,
    foreground;

var svg;

var tooltip;
var matricula_selecionada;
var dados_competencia;
var projection, projectionR;
var data;


//@width  largura do svg
//@height altura do svg
function buildSvg(width, height,body){	
	

	d3.select(body).selectAll("svg").remove();

	//d3.select(body).select("#infos").remove();
	

	svg = d3.select(body);
	
	var svg2 = d3.select(body).append("svg")
		.attr("width", width)
		.attr("height", 15);

	svg = d3.select(body).append("svg")
		.attr("width", width)
		.attr("height", height);
	
	svg2.append("text")
            .attr("y", 10)
            .attr("x", 95)
            .attr("text-anchor", "center")
            .attr("font-size", "12px")
            .attr("font-weight", "bold")
            .text("Nota 1");

    svg2.append("text")
            .attr("y", 10)
            .attr("x", 322)
            .attr("text-anchor", "center")
            .attr("font-size", "12px")
            .attr("font-weight", "bold")
            .text("Nota 2");

	svg2.append("text")
            .attr("y", 10)
            .attr("x", 551)
            .attr("text-anchor", "center")
            .attr("font-size", "12px")
            .attr("font-weight", "bold")
            .text("Nota 3");

    svg2.append("text")
            .attr("y", 10)
            .attr("x", 778)
            .attr("text-anchor", "center")
            .attr("font-size", "12px")
            .attr("font-weight", "bold")
            .text("Final");

	tooltip = d3.select(body)
		.append("div")	//TODO ver isso depois
		.style("position", "absolute","red")
		.style("z-index", "10")
		.style("visibility", "hidden")
		.style("stroke","red");	

}

//@inicia as variaveis iniciais das cordenadas paralelas e instancia o svg
//@width  largura do svg
//@height altura do svg
function init(width, height,body){
	w = width - margin.right -250;
    h = height - margin.top - margin.bottom;
    x = d3.scale.ordinal().rangePoints([0, w], 1);	
	buildSvg(width, height,body);
}


//@ smin = valor minimo da escala da coluna
//@ smax = valor maximo da escala da coluna
//@ col = numero de colunas a ser plotado
//OBS. para nao processar a coluna especificada colocar o caractere '#' no inicio do nome do campo
function executa(data_file, smin,smax,col){
	console.log("arquivo = "+data_file.length);
	if (data_file.length == 0){
             data_file = [[[-1],[-1],[-1],[-1],[-1]] ,  [[-1],[-1],[-1],[-1],[-1]] ,	 [[-1],[-1],[-1],[-1],[-1]], 			  [[-1],[-1],[-1],[-1],[-1]]];
	     colunas = 4;
        }
	colunas = col;
	campos = 0;
	data = data_file;
        
	x.domain(dimensions = d3.keys(data_file[0]).filter(function(d){
		campos += 1;
		if(campos <= colunas){
			return d[0] != "1" && (y[d]= d3.scale.linear().domain([smin,smax]).range([h,0]));
		}
	}));

	  // pinta as linhas estrangeiras de cinza
	  background = svg.append("svg:g")
	      .attr("class", "background")
	    .selectAll("path")
	      .data(data_file)
	    .enter().append("svg:path")
	      .attr("d", path);
	     


	  // pinta as linhas que estao focadas de azul
	  foreground = svg.append("svg:g")
	      .attr("class", "foreground")
	    .selectAll("path")
	      .data(data_file)
	    .enter().append("svg:path")
	      .attr("d", path);
	      
	      

	  // Add a group element for each dimension.
	  campos = 0;
	  var g = svg.selectAll(".dimension")
	      .data(dimensions)
	    .enter().append("svg:g")
	      .attr("class", "dimension")
	      .attr("transform", function(d) { return "translate(" + x(d) + ")"; })
	      .call(d3.behavior.drag())
	      .on("dragstart", dragstart)
	      .on("drag", drag)
	      .on("dragend", dragend);
	      
       showAxis(g);
	 
	 	if (!show_repetencia) {
      		if (show_agrupamento) {
				projection = svg.selectAll(".background path,.foreground path")
					.classed("grupo1", function(p) { return p.grupo == "1"; })
					.classed("grupo2", function(p) { return p.grupo == "2"; })
					.classed("grupo3", function(p) { return p.grupo == "3"; })
					.classed("grupo4", function(p) { return p.grupo == "4"; })
					.classed("grupo5", function(p) { return p.grupo == "5"; })
					.classed("grupo6", function(p) { return p.grupo == "6"; })
					.classed("grupo7", function(p) { return p.grupo == "7"; })
					.classed("grupo8", function(p) { return p.grupo == "8"; })
					.classed("grupo9", function(p) { return p.grupo == "0"; })
					.classed("perdeu", function(p) { return p.media < 5; })
					.on("mouseover", mouseover)
	        		.on("mouseout", mouseout)
		    		.on("mousemove",mousemove);
      		}else{
	      		projection = svg.selectAll(".background path,.foreground path")
					.classed("dsc", function(p) { return p.departamento == "dsc"; })
					.classed("dme", function(p) { return p.departamento == "dme"; })
					.classed("fisica", function(p) { return p.departamento == "fisica"; })
					.classed("humanas", function(p) { return p.departamento == "humanas"; })
					.classed("esportes", function(p) { return p.departamento == "esportes"; })
					.classed("perdeu", function(p) { return p.media < 5; })
					.on("mouseover", mouseover)
	        		.on("mouseout", mouseout)
		    		.on("mousemove",mousemove);
	  		}
	  	}else {
       		projection = svg.selectAll(".background path,.foreground path")
				.classed("primeira", function(p) { return p.vez == "1"; })
				.classed("segunda", function(p) { return p.vez == "2"; })
				.classed("terceira", function(p) { return p.vez == "3"; })
				.classed("quarta", function(p) { return p.vez == "4"; })
				.classed("perdeu", function(p) { return p.media < 5; })
				.on("mouseover", mouseover)
        		.on("mouseout", mouseout)
	    		.on("mousemove",mousemove);
	  	}
}
			


function position(d) {
  var v = dragging[d];
  return v == null ? x(d) : v;
}

function transition(g) {
  return g.transition().duration(500);
}

// retorna um caminho com todos os pontos referente a um objeto.
function path(d) {
  campos = 0;


  	   return line(dimensions.map(function(p) { 
	       campos += 1;
	     
	       //se a nota for == -1.0 nao mostre a linha (consequentemente o caminho sera quebrado)
	       if (d[p] == -1.0) return [,]; //TODO encontrar uma forma de retirar as notas inexistentes

	       //console.info([position(p), y[p](d[p])])
	      		 //(x,y)
	       return [position(p), y[p](d[p])]; 
	     

             }));
}

// Handles a brush event, toggling the display of foreground lines.
//esta linha e utilizada para selecionar um intervalo em uma determinada coluna
function brush() {
  var actives = dimensions.filter(function(p) { return !y[p].brush.empty(); }),
      extents = actives.map(function(p) { return y[p].brush.extent(); });
  foreground.style("display", function(d) {
		
	return actives.every(function(p, i) {
	return extents[i][0] <= d[p] && d[p] <= extents[i][1];}) ? null : "none";
		

  });
}

function showAxis(g){
 // Add an axis and title.
  campos = 0; //para contar o numero de colunas	
  g.append("svg:g")
      .attr("class", "axis")
      .each(function(d) { 
		campos += 1;
		//console.info(campos);			
		
		//limita o numero de colunas a ser plotado
		if (campos <= colunas)
		   d3.select(this).call(axis.scale(y[d])); 

	})
    .append("svg:text")
      .attr("class", "title")
      .attr("text-anchor", "middle")
      .attr("y", -12)
      .text(function(d) { return d.name; });

  // Add and store a brush for each axis.
  //executa a quantidade de campos a serem plotados

 
  g.append("svg:g")
      .attr("class", "brush")
      .each(function(d) { 
	     d3.select(this).call(
             y[d].brush = d3.svg.brush().y(y[d]).on("brush", brush)); 
			
       })
    .selectAll("rect")
      .attr("x", -8)
      .attr("width", 16);
}

//------------------------------Funcoes utilitarias-----------------------

 function dragstart(d) {}
 function drag(d) {}
 function dragend(d) {}

 function moveToFront() {
     this.parentNode.appendChild(this);
 }

 //esta funcao e responsavel por descobrir qual variavel foi filtrada
 function variableFixed(d){

        //console.info(d);
	//var teste = d3.keys(data[0]);
	//var teste2 = d3.items(data[0]);
	
	//console.info(d3.keys(data[0]));
        //teste.map(function(p){ console.info("p ="+p+"valor = "+d[p]);});
 }

 
 


//----------------------------  Eventos -------------------------

  function mouseover(d) {
	  
    svg.classed("active", true);
    console.log(rep_tipo);
   	if(show_repetencia){
   		console.log(rep_tipo);
   		projection.classed("inactive", function(p) { return p[rep_tipo] !== d[rep_tipo]; });
    	projection.filter(function(p) { return p[rep_tipo] === d[rep_tipo]; }).each(moveToFront);
   	}else{
    	projection.classed("inactive", function(p) { return p !== d; });
    	projection.filter(function(p) { return p === d; }).each(moveToFront);
   	}
  }

  function mouseout(d) {
    
    tooltip.style("visibility", "hidden");
    svg.classed("active", false);
    projection.classed("inactive", false);
   
    
   
  }

  function mousemove(d){
        tooltip.style("top", (event.pageY-10)+"px").style("left",(event.pageX+17)+"px").style({color: 'black'});
		//var ano = d.periodo.substring(0,4);
		//var parte = d.periodo.substring(4,);
		//console.log(ano+parte)
	if (porDisciplina == true){
		tooltip.text(d.matricula+ " - "+ d.periodo);
	}else{
	    tooltip.text(d.disciplina+ " - "+ d.periodo);
    }    
    tooltip.style("visibility", "visible");
  }












