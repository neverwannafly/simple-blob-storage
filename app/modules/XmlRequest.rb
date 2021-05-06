module XmlRequest
  def api_request(url:, method_name:, params: [])
    uri = URI.parse(url)
    post = Net::HTTP::Post.new(uri, 'content-type' => 'text/xml; charset=UTF-8')
    request_body = construct_body(method_name, params)

    puts request_body
    Net::HTTP.new(uri.host, uri.port).start do |http|
      http.request(post, request_body) do |response|
        return response.body
      end
    end
  end

  private

  def construct_body(method_name, params)
    param_string = ""
    params.each do |param|
      value = param[0]
      type = param[1] || "string"
      param_string += "<param>
        <value><#{type}>#{value}</#{type}></value>
      </param>"
    end
    "<?xml version='1.0'?>
      <methodCall>
        <methodName>#{method_name}</methodName>
          <params>
            #{param_string}
          </params>
      </methodCall>"
  end
end