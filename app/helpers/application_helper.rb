module ApplicationHelper

  def profit_color_class(profit)
    return '' unless profit

    if profit > 0
      'table-primary'
    elsif profit < 0
      'table-danger'
    else
      ''
    end

  end

  def profit_to_percent(profit)
    ((profit - 1) * 100).round(10)
  end

end
