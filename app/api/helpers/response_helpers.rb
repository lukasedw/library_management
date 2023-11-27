module Helpers::ResponseHelpers
  def success!(data, status = 200)
    status(status)
    {
      success: data
    }
  end
end
