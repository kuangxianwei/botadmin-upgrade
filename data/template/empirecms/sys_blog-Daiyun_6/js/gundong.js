$(document).ready(function () {

	
	
	//aside
    var Sticky = new hcSticky('aside', {
      stickTo: 'article',
      innerTop: 100,
      followScroll: false,
      queries: {
        480: {
          disable: true,
          stickTo: 'body'
        }
      }
    });


		
	});