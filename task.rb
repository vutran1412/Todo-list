class Task
    attr_reader :description
    attr_accessor :status

    def initialize(description, status = false)
        @description = description
        @status = status
    end

    def to_s
        description
    end

    def completed?
        status
    end

    def toggle_status
        @status = !completed?
    end

    def to_machine
        "#{represent_status}: #{description}"
    end

    private
    def represent_status
        "#{completed? ? "[X]" : "[ ]"}"
    end

end