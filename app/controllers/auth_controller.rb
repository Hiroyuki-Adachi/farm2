require 'fileutils'

class AuthController < ApplicationController
  REFRESH_TOKEN_PATH = Rails.root.join('config/google_refresh_token.txt')

  def create
    auth = request.env['omniauth.auth']
    refresh_token = auth.credentials.refresh_token

    File.write(REFRESH_TOKEN_PATH, refresh_token)

    redirect_to root_path, notice: "認証に成功し、Refresh Token を保存しました。"
  end

  def failure
    redirect_to root_path, alert: "認証に失敗しました。"
  end

  def self.read_refresh_token
    File.exist?(REFRESH_TOKEN_PATH) ? File.read(REFRESH_TOKEN_PATH).strip : nil
  end
end
