var messages = {};

messages._types = [ 'info', 'warning', 'success', 'error' ];

messages._get_type = function (type) {
	return _.contains(messages._types, type) ? type : 'regular';
}

messages._get_header = function (header) {
	return header ? '<div class="header">' + header + '</div>' : '';
}

messages._get_content = function (content) {
	if ( content.indexOf('<') === -1 ) {
		content = '<p>' + content + '</p>';
	}
	return '<div class="message-content">' + content + '</div>';
}

messages._get_icon = function (options) {
	var icon_object = {},
		icon = _.has(options, 'icon') ? options.icon : '';
	icon_object.class = icon ? 'icon' : '';
	icon_object.html = icon ? '<i class="' + icon + ' icon"></i>' : '';
	return icon_object;
}

messages._get_close_icon = function (options) {
	var close = _.has(options, 'close') ? options.close : '';
	return close ? '<i class="close icon"></i>' : '';
}

messages._get_container = function (options) {
	return _.has(options, 'container') ? options.container : $('.messages');
}

messages._get_fadeOut = function (options) {
	return _.has(options, 'fadeOut') ? parseInt(options.fadeOut) : false;
}

messages._get_clear = function (options) {
	return _.has(options, 'clear') ? options.clear : false;
}

messages._clear_messages = function () {
	return $('.js-message').remove();
}

messages._add_close_event_listener = function () {
	$('.js-message .close').on('click', function() {
		$(this).closest('.js-message').fadeOut();
	});
}

messages._add_fadeOut = function (fadeOut) {
	$('.js-message:last-child').fadeOut(fadeOut);
}

messages.create = function (type, header, content, options){
	var options = options ? options : {},
		type = messages._get_type(type),
		header = messages._get_header(header),
		content = messages._get_content(content),
		icon = messages._get_icon(options),
		close = messages._get_close_icon(options),
		container = messages._get_container(options),
		fadeOut = messages._get_fadeOut(options),
		clear = messages._get_clear(options),
		message;

	message =  '<div class="ui ' + type + ' ' + icon.class + ' message js-message">\
			' + icon.html + '\
			' + close + '\
			<div class="content">\
				' + header + '\
				' + content + '\
			</div>\
		</div>';
	
	if ( clear ) { messages._clear_messages(); }

	$('.messages').append(message);

	messages._add_close_event_listener();

	if ( fadeOut ) { messages._add_fadeOut(fadeOut); }

}
