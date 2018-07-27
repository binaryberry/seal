class Message
  def initialize(text, mood: nil)
    @text = text
    @mood = mood
  end

  attr_reader :text, :mood
end
