require 'httparty'
require 'json'

class Kele
  include HTTParty
  base_uri 'https://www.bloc.io/api/v1'

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
    response = self.class.get("/mentors/#{mentor_id}/student_availability", body: { "id": mentor_id }).body
    JSON.parse(response)
  end
end
