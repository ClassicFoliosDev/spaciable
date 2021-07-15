# frozen_string_literal: true

class ContentManagementsController < ApplicationController

  load_and_authorize_resource :developer
  load_and_authorize_resource :division

  before_action :set_parent

  def show; end

  def set_parent
    @parent = @development || @division
  end
end
