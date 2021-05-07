module XmlRequest
  def api_request(url:, method_name:, params: [])
    uri = URI.parse(url)
    post = Net::HTTP::Post.new(uri, 'content-type' => 'text/xml; charset=UTF-8')
    request_body = construct_body(method_name, params)

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
      if type == 'struct'
        inner_string = ""
        value.each do |member|
          mem_key = member[0]
          mem_value = member[1]
          mem_type = member[2] || "string"
          inner_string += "
            <member>
              <name>#{mem_key}</name>
              <value><#{mem_type}>#{mem_value}</#{mem_type}></value>
            </member>
          "
        end
        param_string += "<param>
          <value><#{type}>#{inner_string}</#{type}></value>
        </param>
        "
      else
        param_string += "<param>
          <value><#{type}>#{value}</#{type}></value>
        </param>"
      end
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