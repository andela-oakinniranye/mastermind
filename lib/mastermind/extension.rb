module Mastermind
  class Game
    attr_reader :level, :characters


    def init_level(level=4)
      @level = level
      generate_colors
    end

    def convert_level(level)
      @characters = 4 * ((3/2) ** (level - 1))
      color_count = 4 + 1 * (level - 1)
      additional_color_required =  color_count - @color_array.length
      additional_colors = ['O', 'P', 'C', 'V', 'A', 'I']
      @@color_array += additional_colors.sample(additional_color_required)
    end

    # def quit
    #   alias_method :old_quit, :quit
    #   old_quit
    # end
  end

  class Message

  end
end
