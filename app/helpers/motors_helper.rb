module MotorsHelper

  def row_span_helper(policy)
    count = policy.item_perils.count
    if count > 1
      count + 1
    else
      count + 1
    end
  end
end
