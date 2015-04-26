class StaticpagesController < ApplicationController
  def index
  	@detail = Detail.new
  end
end
