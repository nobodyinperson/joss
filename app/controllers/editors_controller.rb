class EditorsController < ApplicationController
  before_action :require_admin_user, except: [:lookup]
  before_action :set_editor, only: [:show, :edit, :update, :destroy]

  def index
    @editors = Editor.all
    @assignment_by_editor = Paper.unscoped.in_progress.group(:editor_id).count
    @paused_by_editor = Paper.unscoped.in_progress.where("labels->>'paused' ILIKE '%'").group(:editor_id).count
  end

  def show
  end

  def new
    @editor = Editor.new
  end

  def lookup
    editor = Editor.find_by_login(params[:login])
    if editor.url
      url = editor.url
    else
      url = "https://github.com/#{params[:login]}"
    end

    response = {  name: "#{editor.first_name} #{editor.last_name}",
                  url: url }

    render json: response.to_json
  end

  def edit
  end

  def create
    @editor = Editor.new(editor_params)

    if @editor.save
      redirect_to @editor, notice: 'Editor was successfully created.'
    else
      render :new
    end
  end

  def update
    if @editor.update(editor_params)
      redirect_to @editor, notice: 'Editor was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @editor.destroy
    redirect_to editors_url, notice: 'Editor was successfully destroyed.'
  end

  private
    def set_editor
      @editor = Editor.find(params[:id])
    end

    def editor_params
      params.require(:editor).permit(:availability, :availability_comment, :kind, :title, :first_name, :last_name, :login, :email, :avatar_url, :category_list, :url, :description)
    end
end
