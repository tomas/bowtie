var Bowtie = {

///////////////////////////////////////////////////
// custom stuff for in-place editing
///////////////////////////////////////////////////

	toggleEditableMode: function(a){

		if ($(a).hasClass('active')){

			$('table td.editable').data('disabled.editable', true);
			html = 'Edit Mode OFF';

		} else {

			if ($('table td.editable').data('disabled.editable'))
				$('table td.editable').data('disabled.editable', false);
			else
				this.activateEditables();

			html = 'Edit Mode ON';
		}

		$(a).toggleClass('active').html(html);

	},

	activateEditables: function(){

		var current_path = location.pathname;

		$('table td.editable').editable(function(value, settings){

			var self = this;
			var original = $(this).html();
			var id =  $(this).siblings('.id-col').children('a').html();
			var field = "resource[" + $(this).attr('class').split('-')[0] + "]";
			var submitdata = { '_method' : 'put' };
			submitdata[field] = value;

			$.post(current_path + '/' + id, submitdata, function(response){

				if(response)
					$(self).removeClass('error').html(value);
				else
					$(self).addClass('error').html(self.revert)

				// callback.apply(self, [self.innerHTML, settings]);
				self.editing = false;
			});

			return false;

		}, {
			event     : "dblclick",
			indicator : 'Saving...',
			placeholder   : "<em>(edit)</em>",
		});

	}

}

$(document).ready(function() {

	$("table.sortable").tablesorter({
		headers: { 0: { sorter: false } }
	});

});
