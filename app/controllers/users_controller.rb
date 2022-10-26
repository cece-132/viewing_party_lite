# frozen_string_literal: true

class UsersController < ApplicationController
  # def show
  #   @user = User.find(params[:id])
  # end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.password = params[:user][:password]
    if @user.save && user.authenticate(params[:user][:password])
      redirect_to user_path
      session[:user_id] = @user.id
      flash[:success] = "Welcome, #{@user.user_name}!"
    else
      redirect_to register_path(@user)
      flash[:alert] = @user.errors.full_messages.to_sentence # [ @user.errors.full_messages_for(:user_name), 
      #                   @user.errors.full_messages_for(:email),
      #                   @user.errors.full_messages_for(:password),
      #                   @user.errors.full_messages_for(:password_confirmation) ].join(", ").tr(",", "")
    end
  end

  def login_form
  end

  def login_user
    user = User.find_by(email: params[:email])
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome Back #{user.user_name}! Couldn't stay away for long we see"
      redirect_to user_path
    else
      flash[:error] = "Uhmm...this is awkward...but you're wrong"
      render :login_form
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :email, :password, :password_confirmation)
  end
end

