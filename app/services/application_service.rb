class ApplicationService
  def self.call(*, &block)
    new(*, &block).call
  end
end
