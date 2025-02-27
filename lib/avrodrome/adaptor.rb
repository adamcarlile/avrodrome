module Avrodrome
  class Adaptor
    attr_reader :registry, :logger

    def initialize(logger: Avrodrome.logger, registry: Avrodrome::Registry.new)
      @logger   = logger
      @registry = registry
    end

    def fetch(id)
      logger.info "Fetching schema with id #{id}"
      registry.find(id)&.body&.to_s || errors[:not_found]
    end

    def register(subject, schema)
      id = registry.subject(subject)&.check(schema)&.id
      return id if id

      registered_schema = registry.register!(subject, schema)
      logger.info "Registered schema for subject `#{subject}`; id = #{registered_schema.id}"
      registered_schema.id
    end

    # List all subjects
    def subjects
      registry.subjects.map(&:name)
    end

    # List all versions for a subject
    def subject_versions(subject_name)
      subject = registry.subject(subject_name)
      return errors[:subject_not_found] unless subject
      subject.schemas.map(&:version)
    end

    # Get a specific version for a subject
    def subject_version(subject_name, version = 'latest')
      subject = registry.subject(subject_name)
      return errors[:subject_not_found] unless subject
      version = nil if version == 'latest'
      subject.version(version) || errors[:version_not_found]
    end

    # Check if a schema exists. Returns nil if not found.
    def check(subject_name, schema)
      subject = registry.subject(subject_name)
      return errors[:subject_not_found] unless subject
      subject.check(schema)&.to_hash
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
      subject = registry.subject(subject)
      return errors[:subject_not_found] unless subject
      subject.config
    end

    # Update config for subject
    def update_subject_config(subject, config)
      subject = registry.subject(subject)
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
