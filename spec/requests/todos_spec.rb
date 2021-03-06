require 'rails_helper'

RSpec.describe 'Todos API', type: :request do
	# Initialize test data
	let(:user) { create(:user) }
	let!(:todos) { create_list(:todo, 10, created_by: user.id.to_s) }
  let(:todo_id) { todos.first.id }
  let(:headers) { valid_headers }
	
	describe 'GET /todos' do
		# Make HTTP GET request before each example
    before { get '/todos', params: {}, headers: headers }

		it 'returns todos' do
			# `json` custom helper to parse JSON res
			expect(json_parse).not_to be_empty
			expect(json_parse.size).to eq(10)
		end

		it 'returns status code 200' do
			expect(response).to have_http_status(200)
		end
	end
	
	describe 'GET /todos/:id' do
    before { get "/todos/#{todo_id}", params: {}, headers: headers }

		context 'when the record exists' do
			it 'returns the todo' do
				# `json` custom helper to parse JSON res
				expect(json_parse).not_to be_empty
				expect(json_parse['id']).to eq(todo_id)
			end

			it 'returns status code 200' do
				expect(response).to have_http_status(200)
			end
		end

		context 'when the record does not exist' do
			let(:todo_id) { 100 }

			it 'returns status code 404' do 
				expect(response).to have_http_status(404)
			end	

			it 'returns a not found message' do 
				expect(response.body).to match(/Couldn't find Todo/)
			end
		end
	end
	
	describe 'POST /todos' do
		let(:valid_attributes) { { title: 'Learn Python', created_by: user.id }.to_json }

		context 'when the request is valid' do
			before { post '/todos', params: valid_attributes, headers: headers }

			it 'creates a todo' do
				expect(json_parse['title']).to eq('Learn Python')
			end
			
			it 'returns status code 201' do
				expect(response).to have_http_status(201)
			end
		end

		context 'when the request is invalid' do
			before { post '/todos', params: { created_by: user.id }.to_json, headers: headers }

			it 'returns status code 422' do 
				expect(response).to have_http_status(422)
			end
			
			it 'returns a validation failure message' do
				expect(response.body).to match(/Validation failed: Title can't be blank/)
			end
		end
	end
	
	describe 'PUT /todos/:id' do 
		let(:valid_attributes) { { title: 'Do groceries' }.to_json }

		context 'when the record exists do' do
			before { put "/todos/#{todo_id}", params: valid_attributes, headers: headers }

			it 'updates the record' do
				updated_todo = Todo.find(todo_id)
				expect(updated_todo.title).to match(/Do groceries/)
			end

			it 'returns status code 204' do
				expect(response).to have_http_status(204)
			end
		end
	end
	
	describe 'DELETE /todos/:id' do
		before { delete "/todos/#{todo_id}", params: {}, headers: headers }

		it 'deletes the record' do
			expect(response.body).to match(/Delete Successful/)
		end
		

		it 'returns status code 200' do
			expect(response).to have_http_status(200)
		end
	end
end



