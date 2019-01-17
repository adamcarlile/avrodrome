module Avrodrome
  class Subject
    attr_reader :name

    def initialize(name:)
      @name = name
    end

    def config
      @config ||= {}
    end

    def find(id)
      schemas.detect {|x| x.id == id}
    end

    def version(version=nil)
      if version
        schemas.detect {|x| x.version == version }
      else
        schemas.last
      end
    end

    def check(schema)
      schemas.detect {|x| x.body == schema }
    end

    def schemas
      @schemas ||= []
    end

    def register!(schema:, id:, version: next_version)
      Avrodrome::Schema.new(body: schema, id: id, version: version, name: name).tap { |x| schemas << x }
    end

    def total_schemas
      schemas.count
    end

    private

    def next_version
      schemas.count + 1
    end

  end
end
