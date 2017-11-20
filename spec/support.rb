def response_body
  JSON(response.body, symbolize_names: true)
end
