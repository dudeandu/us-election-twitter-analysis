

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
				+ '</br><span class="moreLess">Show more <i class="fas fa-caret-down"></i></span> </p><div class="contentLarge"><p>'
				+ policyFull
				+'</p>'
				+'<p class="moreLess">Show Less <span><i class="fas fa-caret-up"></i></span></p></div>')

		// console.log(policyTitle, partyTitle, policyShort, policyFull)

	});
	sendHeight()

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

	// console.log("id is: " + theId + " | the class is: " + theClass)

	d3.selectAll( '.filterButton').classed("selected", false)
	d3.select( '#' + theId ).classed("selected", true)


	theId = theId.toUpperCase();
	d3.selectAll( '.policy').classed("hidden", true)
	d3.selectAll( '.policy.' + theId).classed("hidden", false)


	// Close the menu after clicking
	$('#burgerMenu').prop('checked',false);

	// 	$( ".policy").hide(500);
	sendHeight()

});

$('.filterPolicies .filterButton').on('click', function(){
	var theClass = $(this).attr("class");
	var theId = $(this).attr("id");
	var testChecker = $(this).hasClass( theClass );

	// console.log(".policy ." + theId)

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
	sendHeight()

});

$('.policyBox').on('click', '.policy', function(data){

	var contentsHtml = this.children[0].children;

	// console.log(contentsHtml);

	// console.log(this.children[0]);

	// console.log(d3.select(this.children[0].children[3]).classed("showText"));
	// d3.selectAll('.policy .policySub').classed("hidden",false);
	if (d3.select(this.children[0].children[3]).classed("showText")) {
		
		d3.selectAll('.contentLarge').classed('showText', false);
		d3.selectAll('.policySub').classed('hidden', false);

	} else {
	
		d3.selectAll('.contentLarge').classed('showText', false);
		d3.selectAll('.policySub').classed('hidden', false);

		$(this).find('.policySub').addClass( "hidden" );
		$(this).find('.contentLarge').addClass( "showText" );

	}

	// resize();
	sendHeight()

});

$('#burgerMenu').on('click', function(){
	console.log(this);
});

		// function resize(){

		// 	var theHeight = $('.graphic-wrapper')[0].offsetHeight + 30;

		//        var message = {'resize':
		//                  {
		//                    'iframe':'myIframePolicyTracker',
		//                    'height': theHeight
		//                  }
		//                };
		//        // console.log(document.getElementsByClassName('graphic-wrapper')[0].offsetHeight + 30);
		//        console.log(message);
		//        parent.postMessage(message, "*");
		//    };

		//    $(window).on('load',function(){
		//        resize();
		//    });

		//    $(window).on('resize',function(){
		//        resize();
		//    });


// sendHeight = function(){
//   height = $('div').height()
//   window.parent.postMessage({"height": height}, "*")
// }

sendHeight = function(){
  height = $('.graphic-wrapper').height()
  parent.postMessage({"height": height}, "*")
}









