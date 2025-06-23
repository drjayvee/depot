# frozen_string_literal: true

module Payment
  TYPES = {
    check: 0,
    credit_card: 1,
    purchase_order: 2
  }

  TYPE_NAMES = {
    TYPES[:check] => "Check",
    TYPES[:credit_card] => "Credit card",
    TYPES[:purchase_order] => "Purchase order"
  }
end
