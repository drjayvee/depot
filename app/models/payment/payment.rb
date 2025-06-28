# frozen_string_literal: true

module Payment
  class Payment
    include ActiveModel::API
    include ActiveModel::Attributes
    include ActiveModel::Serializers::JSON

    def self.new(*)
      raise NotImplementedError if self == Payment

      super
    end

    # Create a Payment from a JSON +string+ sets attributes.
    #
    #   pm = SomePayment.new(attr: "value")
    #   Payment.from_json(pm.to_json) # => <SomePayment:0x1337, @attr="value">
    #
    # Uses the +"type"+ key to determine the subclass and calls its +from_json+.
    def self.from_json(json)
      hash = ActiveSupport::JSON.decode(json)
      klass = TYPE_CLASSES[hash["type"]]

      klass.new.tap do
        it.from_json(json)
      end
    end

    def as_json
      super.merge(type: TYPE_CLASSES.key(self.class))
    end

    def attributes=(hash) # overriding from_json be nicer but would require more code
      super(hash.without("type"))
    end
  end
end
