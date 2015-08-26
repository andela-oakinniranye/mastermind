module Mastermind
  class Datastore
    include Singleton

    def create_file_if_not_exist file_name
      ::File.open(file_name, 'w') unless File.exists? file_name
    end

    def save_yml data, file_name, write_mode = 'w'
      File.open(file_name, write_mode) do |yml_data|
        ::YAML.dump data, yml_data
      end
    end

    def fetch_yml file_name
      ::YAML::load_file(file_name)
    end
  end
end
