# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Notes' do
  shared_examples 'returns status 200' do
    it 'returns status 200' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /api/v1/notes' do
    before { create_list(:note, 3) }

    context 'when fetching all notes without filters' do
      before { get '/api/v1/notes' }

      it_behaves_like 'returns status 200'

      it 'returns all notes' do
        expect(response.parsed_body.size).to eq(3)
      end
    end

    context 'when filtering notes with archived: true' do
      before do
        create(:note, :archived)

        get '/api/v1/notes', params: { archived: true }
      end

      it_behaves_like 'returns status 200'

      it 'returns one note' do
        expect(response.parsed_body.size).to eq(1)
      end

      it 'returns only archived notes' do
        expect(response.parsed_body).to all(include('archived' => true))
      end
    end

    context 'when filtering notes with archived: false' do
      before do
        create(:note, :archived)

        get '/api/v1/notes', params: { archived: false }
      end

      it_behaves_like 'returns status 200'

      it 'returns three notes' do
        expect(response.parsed_body.size).to eq(3)
      end

      it 'returns only unarchived notes' do
        expect(response.parsed_body).to all(include('archived' => false))
      end
    end

    context 'when filtering notes by title' do
      before do
        create(:note, title: 'Meeting Notes')
        create(:note, title: 'Daily meeting summary')

        get '/api/v1/notes', params: { title: 'meeting' }
      end

      it_behaves_like 'returns status 200'

      it 'returns two notes' do
        expect(response.parsed_body.size).to eq(2)
      end

      it 'returns only notes with matching title' do
        titles = response.parsed_body.map { |n| n['title'] }
        expect(titles).to all(match(/meeting/i))
      end
    end

    context 'when filtering notes with no matching title' do
      before { get '/api/v1/notes', params: { title: 'meeting' } }

      it_behaves_like 'returns status 200'

      it 'returns no notes' do
        expect(response.parsed_body).to be_empty
      end
    end

    context 'when filtering by title and archived' do
      before do
        create(:note, :archived, title: 'Meeting Memo')
        create(:note, :archived, title: 'Shopping list')

        get '/api/v1/notes', params: { title: 'meeting', archived: true }
      end

      it_behaves_like 'returns status 200'

      it 'returns one note' do
        expect(response.parsed_body.size).to eq(1)
      end

      it 'returns only archived notes matching the title' do
        titles = response.parsed_body.map { |n| n['title'] }
        expect(titles).to contain_exactly('Meeting Memo')
      end
    end
  end

  describe 'GET /api/v1/notes/:id' do
    let(:note) { create(:note) }

    context 'when note exists' do
      before { get "/api/v1/notes/#{note.id}" }

      it_behaves_like 'returns status 200'

      it 'returns the note' do
        expect(response.parsed_body['id']).to eq(note.id)
      end
    end

    context 'when note does not exist' do
      before { get '/api/v1/notes/999999' }

      it 'returns 404 not found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns error message' do
        expect(response.parsed_body['error']).to eq('Note not found')
      end
    end
  end

  describe 'POST /api/v1/notes' do
    context 'with valid params' do
      let(:valid_params) { { note: { title: 'Test', body: 'Content' } } }

      before { post '/api/v1/notes', params: valid_params, as: :json }

      it 'returns created status' do
        expect(response).to have_http_status(:created)
      end

      it 'returns created note data' do
        expect(response.parsed_body).to include('title' => 'Test',
                                                'body' => 'Content',
                                                'archived' => false)
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { { note: { title: '', body: '' } } }

      before { post '/api/v1/notes', params: invalid_params, as: :json }

      it 'returns unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error message' do
        expect(response.parsed_body['errors']).to include("Title can't be blank")
      end
    end
  end

  describe 'PATCH /api/v1/notes/:id' do
    let(:note) { create(:note) }

    context 'with valid params' do
      let(:valid_params) { { note: { title: 'Updated' } } }

      before { patch "/api/v1/notes/#{note.id}", params: valid_params, as: :json }

      it_behaves_like 'returns status 200'

      it 'updates the note title' do
        expect(note.reload.title).to eq('Updated')
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { { note: { title: '' } } }

      before { patch "/api/v1/notes/#{note.id}", params: invalid_params, as: :json }

      it 'returns unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error message' do
        expect(response.parsed_body['errors']).to include("Title can't be blank")
      end
    end

    context 'when note does not exist' do
      let(:valid_params) { { note: { title: 'Updated' } } }

      before { patch '/api/v1/notes/999999', params: valid_params, as: :json }

      it 'returns 404 not found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns error message' do
        expect(response.parsed_body['error']).to eq('Note not found')
      end
    end
  end
end
