require "rails_helper"

RSpec.describe OverdueBookTransactionJob, type: :job do
  describe "#perform" do
    let(:overdue_transactions) { create_list(:book_transaction, 5, return_at: 1.day.ago, state: :borrowed) }
    let(:on_time_transactions) { create_list(:book_transaction, 5, return_at: 1.day.from_now, state: :borrowed) }

    before do
      overdue_transactions
      on_time_transactions
    end

    it "marks only overdue transactions as overdue" do
      described_class.new.perform

      overdue_transactions.each do |transaction|
        expect(transaction.reload.state).to eq("overdue")
      end

      on_time_transactions.each do |transaction|
        expect(transaction.reload.state).not_to eq("overdue")
      end
    end

    context "when an error occurs during batch update" do
      before do
        allow_any_instance_of(BookTransaction).to receive(:update!).and_raise(StandardError, "Update failed")
      end

      it "logs the error and does not mark transactions as overdue" do
        expect(Rails.logger).to receive(:error).with(/Failed to update batch: Update failed/)
        expect { described_class.new.perform }.not_to change { BookTransaction.where(state: "overdue").count }

        overdue_transactions.each do |transaction|
          expect(transaction.reload.state).not_to eq("overdue")
        end
      end
    end
  end

  xdescribe 'OverdueBookTransactionJob schedule' do
    it 'is scheduled to run every day at 1:00 AM' do
      schedule = Sidekiq::Cron::Job.find('overdue_book_transaction_job')

      expect(schedule).not_to be_nil
      expect(schedule.cron).to eq('0 1 * * *') # "0 1 * * *" means every day at 1:00 AM
      expect(schedule.klass).to eq('OverdueBookTransactionJob')
    end
  end
end
