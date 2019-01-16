module Avrodrome
  class Schema
    attr_reader :body, :id, :version, :name
    
    def initialize(body:, id:, version:, name:)
      @body = body
      @id = id
      @version = version
      @name = name
    end

    def to_hash
      {
        subject: name,
        version: version,
        id: id,
        schema: body.to_s
      }
    end

    def to_json
      to_hash.to_json
    end

  end
end