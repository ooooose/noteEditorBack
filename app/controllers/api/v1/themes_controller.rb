class Api::V1::ThemesController < ApplicationController
  before_action :authenticate_request
  before_action :set_theme, only: %i[destroy]

  # GET /api/v1/themes
  def index
    themes = Theme.all
    render json: ThemeSerializer.new(themes).serializable_hash, status: :ok
  end

  # POST /api/v1/themes
  def create
    theme = Theme.new(theme_params)
    authorize theme

    if theme.save
      render json: theme, status: :created
    else
      render json: { error: theme.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/themes/:id
  def destroy
    authorize @theme
    @theme.soft_destroy
    render json: { message: "Theme was successfully deleted" }, status: :ok
  end

  private

    def set_theme
      @theme = Theme.find(params[:id])
    end

    def theme_params
      params.require(:theme).permit(:title)
    end
end
