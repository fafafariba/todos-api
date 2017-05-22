module RequestSpecHelper

	def json_parse
		JSON.parse(response.body)
	end
end
