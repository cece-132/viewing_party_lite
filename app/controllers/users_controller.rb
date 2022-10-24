# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.valid?
      @user.save
      redirect_to user_path(@user)
    else
      #Make sure to run all flash messages for email, password, and password confirmation.
      redirect_to register_path(@user)
      flash[:alert] = @user.errors.full_messages.to_sentence
    end
  end

  def login_form

  end

  def login
    user = User.find_by(user_name: params[:user_name]) 
    #Find user email due to uniquness of email----(.downcase)username.
    flash[:success] = "Welcome, #{user.user_name}!"
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :email, :password, :password_confirmation) 
    #The parameters to create a user need to know exactly what to pass in for the decrypt.
    #Password and password confirmation gets matched by our gem. Decrpyt will be looking for 
    #a password field in order to know what to compare.
  end
end

