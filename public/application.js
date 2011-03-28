$(document).ready(function () {
	$('.switch').click(function() {
    mpmetrics.track('Switch callee');
		if ($('.switch')[0].innerHTML == "Switch to Contacting Your Representative") {
			$('.rep').show();
      $('.sen').hide();
      $('.switch').text("Switch to Contacting Your Senator");
		}
		else {
			$('.rep').hide();
      $('.sen').show();
      $('.switch').text("Switch to Contacting Your Representative");
		}
  })
})
