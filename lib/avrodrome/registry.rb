module Avrodrome
  class Registry
    
    def subjects
      @subjects ||= []
    end
    
    def schemas
      subjects.map(&:schemas).flatten
    end
    
    def register!(subject_name, schema)
      subject = subjects.detect {|x| x.name == subject_name } || (Avrodrome::Subject.new(name: subject_name).tap { |x| subjects << x } )
      subject.register!(schema: schema, id: next_id)
    end
    
    def find(id)
      schemas.detect {|x| x.id == id }
    end
    
    def subject(name)
      subjects.detect {|x| x.name == name }
    end
    
    def next_id
      (subjects.sum(&:total_schemas) || 0) + 1 
    end

  end
end
