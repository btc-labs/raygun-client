module RaygunClient
  class Log < ::Log
    def tag!(tags)
      tags << :raygun_client
      tags << :verbose
    end
  end
end
