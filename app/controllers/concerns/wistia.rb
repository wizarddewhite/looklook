require 'net/http'
require 'net/https'
require 'net/http/post/multipart'

module Wistia

  def self.post_video(name, path_to_video)

    uri = URI('https://upload.wistia.com/')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    # Construct the request.
    request = Net::HTTP::Post::Multipart.new uri.request_uri, {
      'api_password' => ENV["WISTIA_APP_PASSWORD"],
      #'contact_id'   => '<CONTACT_ID>', # Optional.
      #'project_id'   => '<PROJECT_ID>', # Optional.
      'name'         => name, # Optional.

      'file' => UploadIO.new(
                  File.open(path_to_video),
                  'application/octet-stream',
                  File.basename(path_to_video)
                )
    }

    # Make it so!
    response = http.request(request)

    return response
  end

  def self.remove_video(hashed_id)
    wistia_delete_string = "https://api.wistia.com/v1/medias/"
    uri = URI(wistia_delete_string + hashed_id + ".json?api_password=#{ENV["WISTIA_APP_PASSWORD"]}")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    # Construct the request.
    request = Net::HTTP::Delete.new uri.request_uri
    # Make it so!
    response = http.request(request)

    return response
  end

  def self.create_project(project_name)
    uri = URI("https://api.wistia.com/v1/projects.json")

    puts "uri #{uri.request_uri}"
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    # Construct the request.
    request = Net::HTTP::Post::Multipart.new uri.request_uri, {
      'api_password' => ENV["WISTIA_APP_PASSWORD"],
      'name' => project_name
    }
    # Make it so!
    response = http.request(request)

    return response
  end

  def self.update_project(hashid, project_name)
    uri = URI("https://api.wistia.com/v1/projects/#{hashid}.json")

    puts "uri #{uri.request_uri}"
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    # Construct the request.
    request = Net::HTTP::Put::Multipart.new uri.request_uri, {
      'api_password' => ENV["WISTIA_APP_PASSWORD"],
      'name' => project_name
    }
    # Make it so!
    response = http.request(request)

    return response
  end

  def self.delete_project(hashid)
    uri = URI("https://api.wistia.com/v1/projects/#{hashid}.json?api_password=#{ENV["WISTIA_APP_PASSWORD"]}")

    puts "Try to delete project #{hashid}"
    puts "uri #{uri.request_uri}"
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    # Construct the request.
    request = Net::HTTP::Delete.new uri.request_uri
    # Make it so!
    response = http.request(request)

    return response
  end

end
