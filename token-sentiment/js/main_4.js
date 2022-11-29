
// var middleClass = [52200,53100,53100,52500,53800,52400,50800,48900,49400,49600,49300,49100,50400,51100,49000,46400,46900,45700,46000,45900,45200,45100,46300,48300,48600,50600,50500,50500,50800,52000,53100,54600,55300,55200,54700,54500,56000,56400,57900,57700,57900,59800]
// var upperClass =  [104600,105000,105900,104800,105500,104700,103200,101200,100600,102400,102200,103200,105600,106600,103600,100600,100800,98900,99700,98900,99700,101300,106000,108900,111200,115500,116200,115900,118100,120200,124300,128000,129500,131200,131600,132500,133100,138500,136900,138700,138300,142100]

// var height = 4000,
// 	width = 592,
// 	barOffset = 5,
// 	barwidth = (width/middleClass.length) - (barOffset);

d3.csv("assets/sheet-test.csv", function(data){
	
	// console.log(data)
	data.forEach(function(d,i){
		
		var party = d.partyShort.toUpperCase();
		var policyTitle = d.policy;
		var partyTitle = d.party;
		var policyShort = d.contentShort;
		var policyClass = d.policyClass;
		var policyFull = d.content;

		d3.select('.policyBox')
			.append('div')
			.classed("policy " + policyClass + ' ' + party, true)
			// .classed(policyClass,true)
			.append('div')
			.classed("party", true)
			.classed(party, true)
			.html('<h4 class="policyTitle">' 
				+ policyTitle 
				+ '</h4><div class="partyTitle">' 
				+ partyTitle 
				+ '</div><p class="policySub">'
				+ policyShort
				+ '</p><p class="contentLarge">'
				+ policyFull
				+'</p>')

		// console.log(policyTitle, partyTitle, policyShort, policyFull)

	});

});

// $('.policyBox').on('click', function(){
// 	var theClass = $(this).attr("class");
// 	var theId = $(this).attr("id");
// 	console.log(theId,theClass)
// });

$('.filterParties .filterButton').on('click', function(){
	var theClass = $(this).attr("class");
	var theId = $(this).attr("id");
	var testChecker = $(this).hasClass( theClass );

	console.log("id is: " + theId + " | the class is: " + theClass)

	d3.selectAll( '.filterButton').classed("selected", false)
	d3.select( '#' + theId ).classed("selected", true)


	theId = theId.toUpperCase();
	d3.selectAll( '.policy').classed("hidden", true)
	d3.selectAll( '.policy.' + theId).classed("hidden", false)


	// Close the menu after clicking
	$('#burgerMenu').prop('checked',false);

	// 	$( ".policy").hide(500);

});

$('.filterPolicies .filterButton').on('click', function(){
	var theClass = $(this).attr("class");
	var theId = $(this).attr("id");
	var testChecker = $(this).hasClass( theClass );

	console.log(".policy ." + theId)

	d3.selectAll( '.filterButton').classed("selected", false)
	d3.select( '#' + theId ).classed("selected", true)


	d3.selectAll( '.policy').classed("hidden", true)
	d3.selectAll( '.policy.' + theId).classed("hidden", false)


	// Close the menu after clicking
	$('#burgerMenu').prop('checked',false);

	// $( ".policy." + theId ).show(500);

	// $( '".policy .' + theId + '"').show(500);

	// d3.selectAll( ".policy" )
	// // .hasClass( theClass )

	//   .classed( "hidden", true )

});

$('.policyBox').on('click', '.policy', function(data){

	var contentsHtml = this.children[0].children;


	console.log(contentsHtml[0].innerHTML);
	console.log(contentsHtml[1].innerHTML);
	console.log(contentsHtml[2].innerHTML);
	console.log(contentsHtml[3].innerHTML);

	// var test = $(this).children( 'contentLarge' );
	// console.log('<div class="contentLarge">' + contentsHtml + '</div>');

	// $(this).find('.contentLarge').css('display', 'inline');

	d3.selectAll('.policy .contentLarge').classed("showText",false);
	d3.selectAll('.policy .policySub').classed("hidden",false);

	$(this).find('.policySub').toggleClass( "hidden" );
	$(this).find('.contentLarge').toggleClass( "showText" );


    modal.style.display = "block";

});

$('#burgerMenu').on('click', function(){
	console.log(this);
});

