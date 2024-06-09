require 'google/apis/gmail_v1'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
APPLICATION_NAME = '作業日報管理システム'.freeze
CREDENTIALS_PATH = Rails.root.join('config/credentials.json').freeze
TOKEN_PATH = Rails.root.join('config/token.yaml').freeze
SCOPE = [
  Google::Apis::GmailV1::AUTH_GMAIL_SEND,
  Google::Apis::GmailV1::AUTH_GMAIL_READONLY
].freeze

class GmailAuthorizer
  def self.authorize
    client_id = Google::Auth::ClientId.from_file(CREDENTIALS_PATH)
    token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)
    authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
    user_id = ENV.fetch('MAIL_ADDRESS')
    credentials = authorizer.get_credentials(user_id)
    if credentials.nil?
      puts "Open the following URL in the browser and enter the resulting code after authorization"
      puts authorizer.get_authorization_url(base_url: OOB_URI)
      code = gets.strip
      credentials = authorizer.get_and_store_credentials_from_code(user_id: user_id, code: code, base_url: OOB_URI)
    end
    if credentials.expired?
      credentials.refresh!
      puts "New Access Token: #{credentials.access_token}"
    end
    credentials
  end
end
