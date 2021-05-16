class CategoriesController < ApplicationController
  def index
    render_ok(data: Category.all)
  end
end
