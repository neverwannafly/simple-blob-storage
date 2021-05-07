module RpcRequestHandlerHelper
  include XmlRequest

  def init_connection(params)
    # Get a server id
    load_balancer_url = Server.balancer.up.active.first&.url
    throw "No Load Balancer Found" if load_balancer_url.nil?

    balancer_response = api_request(
      url: "#{load_balancer_url}/RPC2",
      method_name: 'request_server'
    )
    server_id = Nokogiri::XML(balancer_response).at_xpath('methodResponse').content.strip

    # verify connection with KDC
    kdc_url = Server.kdc.up.active.first&.url
    throw "No KDC Found" if kdc_url.nil?

    kdc_response = api_request(
      url: "#{kdc_url}/RPC2",
      method_name: 'create_session',
      params: [[params[:user_id], "int"], [server_id]]
    )

    session = UserSession.create!(
      user_id: params[:user_id],
      auth_token_id: params[:auth_token_id],
      server_id: server_id,
      state: :ongoing
    )

    return session
  end

  def rpc(url, method, params = [])
    response = api_request(
      url: url,
      method_name: method,
      params: params
    )

    Nokogiri::XML(response).at_xpath('methodResponse').content.strip
  end
end