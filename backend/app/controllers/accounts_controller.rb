class AccountsController < ApplicationController
  def login
    user = User.find_by(username: params.require(:username))
    if not user or not user.authenticate(params.require(:password))
      render json: { success: false, error: 'Invalid username or password.' }, status: 400
      return
    end
    session[:user_id] = user.id
    render json: { success: true }
  end

  def logout
    session.delete(:user_id)
    @_current_user = nil
    render json: { success: true }
  end

  def register
    username = params.require(:username)
    password = params.require(:password)
    real_name = params.require(:name)
    user = User.new(username: username, password: password, real_name: real_name)
    if not user.valid?
      render json: { success: false, error: user.errors.full_messages[0] }, status: 400
      return
    end
    user.save
    render json: { success: true }
  end

  def info
    username = params.require(:username)
    user = User.find_by! username: username
    info = user.get_json current_user
    if user
      render json: {
        success: true,
        account: info
      }
    end
  end

  def index
    user = User.find_by username: params.require(:username)
    lastIndex = params.require(:lastIndex)
    user_posts = Post.where(user_id: user.id).offset(lastIndex)
    left = user_posts.length >= 10 ? user_posts.length - 10 : user_posts.length
    render json: {
      success: true,
      left: left,
      posts: user_posts.map { | p | p.get_basic_json }
    }
  end
end
