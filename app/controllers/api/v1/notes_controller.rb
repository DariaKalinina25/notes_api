# frozen_string_literal: true

module Api
  module V1
    class NotesController < ApplicationController
      before_action :set_note, only: %i[show update destroy]

      def index
        notes = NotesFilter.new(Note.all, params).call
        render json: NoteBlueprint.render(notes), status: :ok
      end

      def show
        render json: NoteBlueprint.render(@note), status: :ok
      end

      def create
        note = Note.new(note_params)
        if note.save
          render json: NoteBlueprint.render(note), status: :created
        else
          render json: { errors: note.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @note.update(note_params)
          render json: NoteBlueprint.render(@note), status: :ok
        else
          render json: { errors: @note.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @note.destroy
        head :no_content
      end

      private

      def set_note
        @note = Note.find_by(id: params[:id])
        render json: { error: 'Note not found' }, status: :not_found unless @note
      end

      def note_params
        params.expect(note: %i[title body archived])
      end
    end
  end
end
