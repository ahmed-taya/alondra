require 'test_helper'
module PushyResources
  class ChatPushingTest < ActiveSupport::IntegrationCase

    self.use_transactional_fixtures = false

    Capybara.register_driver :selenium_chrome do |app|
      Capybara::Selenium::Driver.new(app, :browser => :chrome)
    end

    setup do
      clean_db
      Capybara.default_driver = :selenium
    end

    teardown do
      clean_db
    end

    test "push chat changes to client" do
      user = Factory.create :user
      chat = Factory.create :chat, :name => 'A chat about nothing'

      login_as user

      chat_path = chat_path(chat)

      visit chat_path

      wait_until(10) do
        Channel[chat_path].users.include?(user)
      end

      assert page.has_content? 'A chat about nothing'

      chat.update_attributes! :name => 'A chat about everything'

      wait_until(10) do
        page.has_content? 'A chat about everything'
      end
    end
  end
end