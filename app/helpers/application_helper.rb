module ApplicationHelper

  def profit_color_class(profit)
    if profit > 0
      'table-primary'
    elsif profit < 0
      'table-danger'
    else
      ''
    end

  end

end
