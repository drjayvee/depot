# frozen_string_literal: true

module Payment
  class Payment
    include ActiveModel::API
    include ActiveModel::Attributes
    include ActiveModel::Serializers::JSON

    class << self
      def new(*)
        raise NotImplementedError if self == Payment

        super
      end

      # Needed to use this class as a serializer for Order.payment
      def dump(payment)
        payment.to_json
      end

      # Create a Payment from a JSON +string+ or +hash+ and sets attributes.
      #
      #   pm = SomePayment.new(attr: "value")
      #   Payment.load(pm.dump) # => <SomePayment:0x1337, @attr="value">
      #
      # Uses the +"type"+ key to determine the subclass and calls +attributes=n+.
      #
      # Also needed for Order.payment
      def load(json)
        return nil if json.nil?

        hash = if json.kind_of? String
                 ActiveSupport::JSON.decode(json)
               else
                 json.stringify_keys
               end
        klass = TYPE_CLASSES[hash["type"].to_i]

        klass.new.tap do |payment|
          payment.attributes = hash.filter { payment.attributes.include?(it) }
        end
      end
    end

    def as_json
      super.merge("type" => TYPE_CLASSES.key(self.class))
    end

    def attributes=(hash)
      # overriding from_json be nicer but would require more code
      super(hash.without("type"))
    end

    def type_name
      TYPE_NAMES[TYPE_CLASSES.key(self.class)]
    end
  end
end
