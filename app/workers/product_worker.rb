class ProductWorker
  include Sidekiq::Worker
  require 'csv'
  sidekiq_options retry: false
 
  def perform(csv_path)
    CSV.foreach((csv_path), headers: true) do |product|
      Product.create(
        name: product[0],
        description: product[1],
        price: product[2],
        user_id: product[3]
      )
    end
  end

end