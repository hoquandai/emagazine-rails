class CategoriesController < ApplicationController
  def index
    render_ok(data: Category.all)
  end

  def groups
    render_ok(data: Category.all.each_slice(4))
  end
end
