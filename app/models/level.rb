class Level
  
  attr_accessor :level_number, :root_object, :parent_object, :ancestor_object
  
  def initialize(level, root)
    @level_number= level
    @level_object = root
    @ancestor_object = root
  end
  
  def update(actual)
    @ancestor_object = @level_object
    @level_object = actual
    @level_number -= 1 if @level_number > 0
  end
  
end