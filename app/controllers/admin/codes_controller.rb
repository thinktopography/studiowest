class Admin::CodesController < ApplicationController
  
  def index
    @users=User.joins('INNER JOIN codes ON (codes.id = users.code_id)')
  end
  
end