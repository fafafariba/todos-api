# Singleton

class JsonWebToken
	# Secret to encode and decode token
	HMAC_SECRET = Rails.application.secrets.secret_key_base

	def self.encode(payload, exp = 24.hours.from_now)
		# Set expiry to 24 hours from creation
		payload[:exp] = exp.to_i
		# Sign token with application secret
		JWT.encode(payload, HMAC_SECRET)
	end

	def self.decode(token)
		# Get payload; first index in decoded array
		body = JWT.decode(token, HMAC_SECRET)[0]

		# ActiveRecord, Implements hash where keys :foo and "foo" are considered the same
		HashWithIndifferentAccess.new(body)
		# Rescue
	rescue JWT::ExpiredSignature, JWT::VerificationError => e 
		# Raise custom error to be handled by custom handler
		raise ExceptionHandler::ExpiredSignature, e.message 
	end
end
