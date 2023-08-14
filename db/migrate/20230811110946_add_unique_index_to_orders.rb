class AddUniqueIndexToOrders < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          CREATE UNIQUE INDEX index_unique_cart_order_for_user
          ON orders (user_id)
          WHERE "isCart" = TRUE;
        SQL
      end

      dir.down do
        execute <<-SQL
          DROP INDEX index_unique_cart_order_for_user;
        SQL
      end
    end
  end
end
