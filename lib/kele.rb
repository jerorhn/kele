require 'httparty'
require 'json'
require_relative 'roadmap'

class Kele
  include HTTParty
  base_uri 'https://www.bloc.io/api/v1'

  include Roadmap

  def initialize(email, password)
    @auth_token = self.class.post("/sessions", {body: {"email": email,
  "password": password}})["auth_token"]
    if @auth_token.nil?
      p "Invalid Email or Password."
    end
  end

  def get_me
    response = self.class.get("/users/me", headers: { "authorization" => @auth_token }).body
    JSON.parse(response)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get("/mentors/#{mentor_id}/student_availability", headers: { "authorization" => @auth_token }, body: { "id": mentor_id }).body
    JSON.parse(response)
  end

  def get_messages(page = nil)
    if page.nil?
      response = self.class.get("/message_threads", headers: { "authorization" => @auth_token})
    else
      response = self.class.get("/message_threads", headers: { "authorization" => @auth_token}, body: { "page": page })
    end
    JSON.parse(response.body)
  end

  def create_message(sender, recipient_id, token, subject, stripped_text)
    if token == ''
      response = self.class.post("/messages", headers: { "authorization" => @auth_token }, body: { "sender": sender, "recipient_id": recipient_id, "subject": subject, "stripped-text" => stripped_text }).body
    else
      response = self.class.post("/messages", headers: { "authorization" => @auth_token }, body: { "sender": sender, "recipient_id": recipient_id, "token": token, "stripped-text" => stripped_text }).body
    end
  end
end
