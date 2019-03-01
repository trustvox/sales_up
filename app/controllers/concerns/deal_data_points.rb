module DealDataPoints
  def start_deal
    @data = { deal_sum: 0, partial_sum: 0, vendor_names: '',
              client_name: '', value: 1, wait: false }
  end

  def fetch_deal_data(searched_deal)
    search_deal_data(searched_deal)
  end

  def fetch_deal_points
    @deal_data.collect { |deal| [deal[0].to_i, deal[1].to_f] }
  end

  private

  def search_deal_data(searchs, wait = false)
    searchs.each_with_index do |info, i|
      if proceed_deal_search?(i, searchs)
        wait = change_partial_deal_data(info)
      elsif wait
        wait = add_partial_deal_data(info)
      else
        add_full_deal_data(info)
      end
    end
  end

  def proceed_deal_search?(index, searchs)
    !searchs[index + 1].nil? && searchs[index].day == searchs[index + 1].day
  end

  def add_partial_deal_data(info)
    change_partial_deal_data(info)

    list = [info.day, @data[:deal_sum], @data[:client_name],
            @data[:partial_sum], @data[:vendor_names]]
    @deal_data << list

    @data = { deal_sum: @data[:deal_sum], partial_sum: 0,
              vendor_names: '', client_name: '', value: 1 }
    false
  end

  def change_partial_deal_data(info)
    @data[:deal_sum] += info.value
    @data[:partial_sum] += info.value

    @data[:vendor_names] +=
      create_string_for_am(fetch_username_by_id(info.user_id))
    @data[:client_name] += create_string_for_am(info.client_name)

    @data[:value] += 1

    true
  end

  def add_full_deal_data(info)
    @data[:deal_sum] += info.value

    list = [info.day, @data[:deal_sum], '1-' + info.client_name + '; ',
            info.value, '1-' + fetch_username_by_id(info.user_id) + '; ']

    @deal_data << list
  end

  def create_string_for_am(text)
    @data[:value].to_s + '-' + text + '; '
  end
end
