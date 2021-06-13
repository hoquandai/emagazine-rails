class CategoriesController < ApplicationController
  before_action :authenticate_user, only: [:create, :update, :destroy]
  before_action :admin?, only: [:create, :update, :destroy]

  def index
    render_ok(data: Category.all)
  end

  def groups
    render_ok(data: Category.all.each_slice(4))
  end

  def show
    category = Category.find_by(id: params[:id])
    if category
      render_ok(data: category)
    else
      render_error(message: 'Category not found!')
    end
  end

  def create
    category = Category.new(category_params)
    if category.save
      render_ok(data: category)
    else
      render_error(message: category.errors.messages)
    end
  end

  def update
    category = Category.find_by(id: params[:id])
    if category.update(category_params)
      render_ok(data: category)
    else
      render_error(message: category.errors.messages)
    end
  end

  def destroy
    category = Category.find_by(id: params[:id])
    if category.destroy
      render_ok(data: category)
    else
      render_error(message: category.errors.messages)
    end
  end

  protected

  def category_params
    params.require(:category).permit(:name, :description)
  end
end
