# frozen_string_literal: true

class NotesFilter
  def initialize(relation, params)
    @relation = relation
    @params = params
  end

  def call
    filter_by_archived
    filter_by_title
    @relation
  end

  private

  def filter_by_archived
    return unless @params.key?(:archived)

    value = ActiveModel::Type::Boolean.new.cast(@params[:archived])
    @relation = @relation.where(archived: value)
  end

  def filter_by_title
    return if @params[:title].blank?

    @relation = @relation.where('title ILIKE ?', "%#{@params[:title]}%")
  end
end
