class Config
  class StructureHelper
    class << self
      def structure_to_hash(structure_instance)
        structure_instance.each_pair.reduce({}) do |acc, (name, value)|
          case
          when value.is_a?(Struct)
            acc.merge(name => structure_to_hash(value))
          else
            acc.merge(name => value)
          end
        end
      end
    end
  end
end
