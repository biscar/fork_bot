class ApiBase
  def self.post(uri, params = {})
    response = Net::HTTP.post_form(uri, params)

    JSON.parse(response.body)
  end

end