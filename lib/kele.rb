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
    num_of_pages = (self.class.get("/message_threads", headers: { "authorization" => @auth_token})["count"] / 10.to_f).ceil

    response = self.class.get("/message_threads", headers: { "authorization" => @auth_token}, body: { "page": page }).body
    JSON.parse(response)
  end
end
