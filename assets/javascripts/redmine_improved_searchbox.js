$(function(){
	var str = $('#project_quick_jump_box option:first').text();
	$('#project_quick_jump_box option:first').text("").val("");
	$('#project_quick_jump_box').attr("data-placeholder", str).chosen();
});