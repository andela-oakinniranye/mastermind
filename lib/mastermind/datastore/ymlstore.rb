module Mastermind
  module Datastore
    class YmlStore
      include Singleton

      attr_accessor :filename
      def create_file_if_not_exist file_name, file_type= 'yml', mode = 'w'
        file_name = add_file_extension_if_not_present(file_name, file_type)
        ::File.open(file_name, mode) unless File.exists? file_name
      end

      def save file_name, data, mode = 'w', file_type='yml'
        create_file_if_not_exist file_name
        ::File.open(file_name, mode) do |yml_data|
          ::YAML.dump data, yml_data
        end
      end

      def save_top_ten file_name='topten.yaml', data
        save(file_name, data, 'w')
      end

      def fetch file_name
        create_file_if_not_exist unless File.exists? file_name
        data = ::File.read(file_name)
        data
      end

      def fetch_yml file_name
        create_file_if_not_exist file_name
        ::YAML::load_file(file_name)
      end

      def fetch_multiple_records file_name
        list = []
        ::YAML.load_stream(File.read(file_name)){ |record|
          list << record
        }
        list
      end

      def filename=(file_name, mode='w')
        create_file_if_not_exist file_name
      end

      def method_missing(method, *args)
        missing_method = method.to_s
        if missing_method.match(/save_([a-z]+)/)
          self.save(*args, 'w+', $1)
        elsif missing_method.match(/fetch_([a-z]+)/)
          self.fetch(*args, $1)
        else
          raise NoMethodError
        end
      end

      def add_file_extension_if_not_present(file_name, file_type = 'yml')
        file_name += '.' + file_type unless file_name.match(/\w+\.[a-z]+/)
        file_name
      end
    end
  end
end
