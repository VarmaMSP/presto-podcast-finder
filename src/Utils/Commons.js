//presto uses this function to set the screen
exports["showUI'"] = function(sc, screen) {
	return function() {
		var screenJSON = JSON.parse(screen);
		var screenName = screenJSON.tag;
		console.log(screenJSON);
		screenJSON.screen = screenName;
		window.__duiShowScreen(sc, screenJSON);
	};
};

//presto uses this function to make a API call
exports["callAPI'"] = function(error) {
	return function(success) {
		return function(request) {
			return function() {
				var url     = request.url;
				var method  = request.method;
				var payload = request.payload;

				var headers_ = {};
		    for(var i = 0; i < request.headers.length; i++){
		      headers_[request.headers[i].field] = request.headers[i].value;
				}

				// using browsers fetch api for api calls
				fetch(url, {
					method: method,
					headers: headers_,
					body: payload
				})
				.then(function(response) {
					return response.json();
				})
				.then(function(data) {
					var successResponse = {
						status: 'OK',
						response: data,
						code: 200
					}
					console.log("success", successResponse);
					success(JSON.stringify(successResponse))();
				})
				.catch(function(err) {
					var errorResponse = {
						status: "failed",
						response: "{}",
						code: 50
					};
					console.log("error", errorResponse);
					error(JSON.stringify(errorResponse))();
				});
			}
		}
	}
}

//a utility function to log to console (for debugging purposes)
exports["logAny"] = function(x) {
  console.log(x);
}
