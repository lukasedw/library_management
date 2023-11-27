class V1::BookTransactionResource < BaseAPI
  namespace :book_transactions do
    desc "List transactions", security: [{Bearer: []}]
    get do
      authenticate!
      authorize BookTransaction, :index?
      book_transactions = policy_scope(BookTransaction).all
      present book_transactions, with: V1::Entities::BookTransactionEntity
    end
    route_param :id do
      before do
        authenticate!
        @book_transaction = policy_scope(BookTransaction).find(params[:id])
      end
      desc "Get Transactions", security: [{Bearer: []}]
      get do
        authorize @book_transaction, :show?
        present @book_transaction, with: V1::Entities::BookTransactionEntity
      end

      desc "Return a Book", security: [{Bearer: []}]
      post :return do
        authorize @book_transaction, :return?
        checkout_result = BookReturnService.call(@book_transaction.id)
        if checkout_result[:success]
          success!(checkout_result[:message], 200)
        else
          error!(checkout_result[:message], 422)
        end
      end
    end
  end
end
