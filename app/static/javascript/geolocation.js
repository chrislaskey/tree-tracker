var geolocation = {};

geolocation.defaults = {};
geolocation.defaults.latitude = 42.357673;
geolocation.defaults.longitude = -71.063356;

geolocation.get_default_options = function() {
	return {
		// Passed to getCurrentPosition() as PositionOptions parameter:
		// https://developer.mozilla.org/en-US/docs/Web/API/PositionOptions
		enableHighAccuracy: true,
		timeout: 120000, // Two minutes
		maximumAge: 5000
	};
}

geolocation.update = function(on_success, on_error, on_not_supported, on_always, options) {

	options = options ? options : geolocation.get_default_options;

	GMaps.geolocate({

		success: function(position) {
			if (_.isFunction(on_success)) {
				on_success(position);
			}
		},

		error: function(error) {
			if (_.isFunction(on_error)) {
				on_error(error);
			}
		},

		not_supported: function() {
			if (_.isFunction(on_not_supported)) {
				on_not_supported();
			}
		},

		always: function() {
			if (_.isFunction(on_always)) {
				on_always();
			}
		},

		options: options

	});

}
