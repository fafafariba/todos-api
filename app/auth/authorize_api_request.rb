class AuthorizeApiRequest
	def initialize(headers = {})
		@headers = headers
	end
	
	def call
		{
			user: user
		}
	end
	
	private

	attr_reader :headers 

	def user
		# Check to see if user in dB, memoize
		@user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
	rescue ActiveRecord::RecordNotFound => e 
		# Raise custom error
		raise(
			ExceptionHandler::InvalidToken,
			("#{Message.invalid_token} #{e.message}")
		)
	end

	# Decode authentication token
	def decoded_auth_token
		@decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
	end

	# Check for token in 'Authorization' header
	def http_auth_header
		if headers['Authorization'].present?
			return headers['Authorization'].split(' ').last
		else
			raise(ExceptionHandler::MissingToken, Message.missing_token)
		end
	end
end
