
class ProducerMailer < Spree::BaseMailer

  def order_cycle_report(producer, order_cycle)
    @producer = producer
    @coordinator = order_cycle.coordinator
    @order_cycle = order_cycle

    subject = "[#{Spree::Config.site_name}] Order cycle report"

    @line_items = Spree::LineItem.
      joins(:order => :order_cycle, :variant => :product).
      where('order_cycles.id = ?', order_cycle).
      where('spree_products.supplier_id = ?', producer).
      merge(Spree::Order.complete)

    # Arrange the items in a hash to group quantities
    @line_items = @line_items.inject({}) do |lis, li|
      lis[li.variant] ||= {line_item: li, quantity: 0}
      lis[li.variant][:quantity] += li.quantity
      lis
    end

    mail(to: @producer.email,
         from: from_address,
         subject: subject,
         reply_to: @coordinator.email,
         cc: @coordinator.email)
  end

end