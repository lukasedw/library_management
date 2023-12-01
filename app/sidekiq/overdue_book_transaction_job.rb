class OverdueBookTransactionJob
  include Sidekiq::Job

  sidekiq_options queue: "default", retry: 3

  BATCH_SIZE = 1000

  def perform
    BookTransaction.where("return_at < ?", Date.current).borrowed.find_in_batches(batch_size: BATCH_SIZE) do |group|
      BookTransaction.transaction do
        group.each { |transaction| transaction.update!(state: "overdue") }
      rescue => e
        Rails.logger.error "Failed to update batch: #{e.message}"
        raise ActiveRecord::Rollback
      end
    end
  end
end
