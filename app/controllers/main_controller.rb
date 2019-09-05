class MainController < ApplicationController
  def index
    @tests = Test.all;
  end
end
