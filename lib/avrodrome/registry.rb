module Avrodrome
  class Registry
    class << self
      def subjects
        @subjects ||= []
      end

      def schemas
        subjects.map(&:schemas).flatten
      end

      def register!(subject_name, schema)
        subject = subjects.detect {|x| x.name == subject_name } || (Avrodrome::Subject.new(name: subject_name).tap { |x| subjects << x } )
        subject.register!(schema: schema)
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

    def initialize(logger: Avrodrome.logger)
      @logger = logger
    end

    def fetch(id)
      @logger.info "Fetching schema with id #{id}"
      self.class.find(id)&.body.to_s || errors[:not_found]
    end

    def register(subject, schema)
      registered_schema = self.class.register!(subject, schema)
      @logger.info "Registered schema for subject `#{subject}`; id = #{registered_schema.id}"
      registered_schema.id
    end

    # List all subjects
    def subjects
      self.class.subjects.map(&:name)
    end

    # List all versions for a subject
    def subject_versions(subject_name)
      subject = self.class.subject(subject_name)
      return errors[:subject_not_found] unless subject
      subject.schemas.map(:version)
    end

    # Get a specific version for a subject
    def subject_version(subject_name, version = 'latest')
      subject = self.class.subject[subject_name]
      return errors[:subject_not_found] unless subject
      subject.version(version) || errors[:version_not_found]
    end

    # Check if a schema exists. Returns nil if not found.
    def check(subject, schema)
      subject = self.class.subject(subject_name)
      return nil unless subject
      subject
    end

    # AC: Assume short lived in memory store, no historic schemas for now 
    #
    # Check if a schema is compatible with the stored version.
    # Returns:
    # - true if compatible
    # - nil if the subject or version does not exist
    # - false if incompatible
    # http://docs.confluent.io/3.1.2/schema-registry/docs/api.html#compatibility
    def compatible?(subject, schema, version = 'latest')
      true
      # data = post("/compatibility/subjects/#{subject}/versions/#{version}",
      #             expects: [200, 404],
      #             body: { schema: schema.to_s }.to_json)
      # data.fetch('is_compatible', false) unless data.has_key?('error_code')
    end

    # Get global config
    def global_config
      @gloabl_config ||= { "compatibilityLevel" => "BACKWARD" }
    end

    # Update global config
    def update_global_config(config)
      global_config.merge!(config)
    end

    # Get config for subject
    def subject_config(subject)
      subject = self.class.subject(subject)
      return errors[:subject_not_found] unless subject
      subject.config
    end

    # Update config for subject
    def update_subject_config(subject, config)
      subject = self.class.subject(subject)
      return errors[:subject_not_found] unless subject
      subject.config.merge!(config)
    end

    private
    
    def errors
      @errors ||= {
        not_found: { error_code: 404, message: "HTTP 404 Not Found" },
        version_not_found: { error_code: 40402, message: "Version not found." },
        subject_not_found: { error_code: 40401, message: "Subject not found." }
      }
    end
  end
end
