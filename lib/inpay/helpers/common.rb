module Inpay
  module Helpers
    module Common
      
      def inpay_invoice_fields amount, options
        misses = (options.keys - valid_setup_options)
        raise ArgumentError, "Unknown options #{ misses.inspect }" unless misses.empty?
        
        params = {
          :currency     => :EUR,
          :flow_layout  => :multi_page
        }.merge(options)
        
        # fetch currency from amount if a Money object is passed
        params[:currency] = amount.currency if amount.respond_to?(:currency)
        
        # accept both strings and Money objects as amount
        amount = amount.cents.to_f / 100.0 if amount.respond_to?(:cents)
        params[:amount] = sprintf('%.2f', amount)
        
        # build form
        inpay_fields(params)
      end
      
      def inpay_fields fields = {}
        fields.collect do |key, value|
          %Q{<input type="hidden" name="#{ key }" value="#{ value }" />}
        end.join("\n")
      end
      
      private
        
        # all possible invoice options
        def valid_invoice_options
          [
            # required
            :order_id,
            :merchant_id,
            :amount,
            :currency,
            :order_text,
            :flow_layout,
            :buyer_email,
            :checksum,
            
            # nonmandatory
            :return_url,
            :pending_url,
            :cancel_url,
            :country,
            :invoice_comment,
            :buyer_name,
            :buyer_address
          ]
        end
      
    end
  end
end