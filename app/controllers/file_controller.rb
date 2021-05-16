class FileController < ApplicationController
  include MessageEncryptor

  before_action :set_data

  def index
    send_file @fs.get_disk_address, file_name: @fs.node_name, disposition: 'inline'
  end

  private

  def set_data
    @fs = FileSystem.where(id: params[:id]).first
    head :not_found and return if @fs.nil?
    head :forbidden and return unless is_sharable
  end

  def is_sharable
    signed_cerificate = params[:certificate]&.gsub(" ", "+") || ''
    is_valid_certifcate = false
    begin
      data = YAML.load(decrypt(signed_cerificate))
      is_valid_certifcate ||= data[:valid_upto] >= DateTime.now
    rescue Exception => e
      puts e
    end

    @fs.permissions == :visible || is_valid_certifcate
  end
end
