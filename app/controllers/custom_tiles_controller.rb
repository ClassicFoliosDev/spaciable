# frozen_string_literal: true

class CustomTilesController < ApplicationController
  load_and_authorize_resource :development
  load_and_authorize_resource :custom_tile, through: [:development]

  before_action :set_parent

  def index; end

  def new; end

  def edit; end

  def show; end

  private

  def set_parent
    @parent = @development
  end
end