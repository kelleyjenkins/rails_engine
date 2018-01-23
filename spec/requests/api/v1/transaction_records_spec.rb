require 'rails_helper'

describe "Transactions API" do
  it "returns a list of transactions" do
    customer =create (:customer)
    merchant = create(:merchant)
    invoice = create(:invoice, customer_id: customer.id, merchant_id: merchant.id)
    transaction1 = create(:transaction, invoice:invoice)
    transaction2 = create(:transaction, invoice:invoice)
    transaction3 = create(:transaction, invoice:invoice)


    get '/api/v1/transactions'

    expect(response).to be_success

    transactions = JSON.parse(response.body)

    expect(transactions.count).to eq(3)
  end

  it "can return one transaction by it's id" do
    customer =create (:customer)
    merchant = create(:merchant)
    invoice = create(:invoice, customer_id: customer.id, merchant_id: merchant.id)
    id = create(:transaction, invoice: invoice).id

    get "/api/v1/transactions/#{id}"

    transaction = JSON.parse(response.body)

    expect(response).to be_success
    expect(transaction["id"]).to eq(id)
  end

  it "can find one transaction by it's credit_card_number" do
    card = create(:transaction ).credit_card_number

    get "/api/v1/transactions/find?credit_card_number=#{card}"

    transaction = JSON.parse(response.body)

    expect(response).to be_success
    expect(transaction["credit_card_number"]).to eq(card)
  end

  it "can find all transactions by parameters" do
    transaction1 , transaction2, transaction3 = create_list(:transaction, 3)

    get "/api/v1/transactions/find_all?credit_card_number=#{transaction1.credit_card_number}"

    transaction = JSON.parse(response.body)

    expect(response).to be_success
    expect(transaction.first["credit_card_number"]).to eq(transaction1.credit_card_number)
    expect(transaction.count).to eq(3)
  end

  it "can find a random transaction" do
    create_list(:transaction, 3)

    get "/api/v1/transactions/random"

    transaction = JSON.parse(response.body)

    expect(response).to be_success
  end
end
