require 'rails_helper'

RSpec.describe AuthorizeApiRequest do
	# Create test user
	let(:user) { create(:user) }
	# Mock 'Auth' header
	let(:header) { { 'Authorization' => token_generator(user.id) } }
	# Invalid request subject
	subject(:invalid_request_obj) { described_class.new({}) }
	# Valid request subject
	subject(:request_obj) { described_class.new(header) }

	describe '#call' do

		context 'when valid request' do
			it 'returns user object' do
				result = request_obj.call
				expect(result[:user]).to eq(user)
			end
		end
		
		context 'when request is invalid' do 
			context 'when missing token' do
				it 'raises a MissingToken error' do
					expect { invalid_request_obj.call }.to raise_error(ExceptionHandler::MissingToken, /Missing token/)
				end
			end
			
			context 'when token is invalid' do
				subject(:invalid_request_obj) do 
					described_class.new('Authorization' => token_generator(5))
				end

				it 'raises an InvalidToken error' do
					expect { invalid_request_obj.call }.to raise_error(ExceptionHandler::InvalidToken, /Invalid token/)
				end
			end
			
			context 'when token is expired' do
				let(:header) { { 'Authorization' => expired_token_generator(user.id) } }
				subject(:request_obj) { described_class.new(header) }

				it 'raises ExceptionHandler::ExpiredSignature error' do
					expect { request_obj.call }.to raise_error(ExceptionHandler::ExpiredSignature, /Signature has expired/)
				end
			end
		end
	end
end
