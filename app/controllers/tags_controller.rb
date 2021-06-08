class TagsController < ApplicationController
  def index
    tags = ActsAsTaggableOn::Tag.all.order(taggings_count: :desc)
    render_ok(data: tags)
  end
end
