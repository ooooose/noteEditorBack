class Api::V1::PicturesController < ApplicationController
  # GET /api/v1/pictures
  def index
    current_user.pictures
  end
end
