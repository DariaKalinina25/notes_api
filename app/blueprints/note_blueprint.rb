# frozen_string_literal: true

class NoteBlueprint < Blueprinter::Base
  identifier :id

  fields :title, :body, :archived, :created_at, :updated_at
end
