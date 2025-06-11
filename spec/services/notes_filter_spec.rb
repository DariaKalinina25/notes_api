# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotesFilter do
  let(:meeting_note) { create(:note, title: 'Meeting Notes') }
  let(:archived_meeting_note) { create(:note, :archived, title: 'Daily meeting summary') }
  let(:shopping_note) { create(:note, title: 'Shopping list') }

  def filtered(params = {})
    described_class.new(Note.all, params).call
  end

  describe '#call' do
    context 'without any filters' do
      it 'returns all notes' do
        expect(filtered).to contain_exactly(meeting_note, archived_meeting_note, shopping_note)
      end
    end

    context 'with archived: true' do
      it 'returns only archived notes' do
        expect(filtered(archived: true)).to contain_exactly(archived_meeting_note)
      end
    end

    context 'with archived: false' do
      it 'returns only unarchived notes' do
        expect(filtered(archived: false)).to contain_exactly(meeting_note, shopping_note)
      end
    end

    context 'with title filter' do
      it 'returns notes matching title' do
        expect(filtered(title: 'meeting')).to contain_exactly(meeting_note, archived_meeting_note)
      end
    end

    context 'with title and archived filter' do
      it 'returns notes matching both filters' do
        expect(filtered(title: 'meeting', archived: true)).to contain_exactly(archived_meeting_note)
      end
    end

    context 'with no matches' do
      it 'returns empty result' do
        expect(filtered(title: 'foobar')).to be_empty
      end
    end
  end
end
