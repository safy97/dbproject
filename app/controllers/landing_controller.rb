class LandingController < ApplicationController
  def show
    redirect_to books_path
  end
end
