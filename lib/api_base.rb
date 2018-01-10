class ApiBase
  def self.post(uri, params = {})
    response = Net::HTTP.post_form(uri, params)

    response.body
  end

end