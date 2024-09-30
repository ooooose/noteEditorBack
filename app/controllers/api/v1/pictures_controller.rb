class Api::V1::PicturesController < ApplicationController
  # GET /api/v1/pictures
  def index
    pictures = current_user.pictures
    
  end
end
