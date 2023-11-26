module Helpers::ResponseHelpers
  def success_render!(data, status = 200)
    status(status)
    {
      message: data,
      status: status
    }
  end

  def error_render!(data, status = 422)
    status(status)
    {
      message: data,
      status: status
    }
  end
end
