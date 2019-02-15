module ContractDataPoints
  def start_contract
    @data = { contract_sum: 0, partial_sum: 0, vendor_names: '',
              store_names: '', value: 1, wait: false }
  end

  def fetch_contract_data(searched_contract)
    search_contract_data(searched_contract)
  end

  def fetch_contract_points
    list = fetch_contract_points_list
  end

  def fetch_contract_points_list
    @contract_data.collect { |cont| [cont[0].to_i, cont[1].to_f] }
  end

  private

  def search_contract_data(searchs, wait = false)
    searchs.each_with_index do |info, i|
      if proceed_contract_search?(i, searchs)
        wait = set_partial_contract_data(info)
      elsif wait
        wait = add_partial_contract_data(info)
      else
        add_full_contract_data(info)
      end
    end
  end

  def proceed_contract_search?(index, searchs)
    !searchs[index + 1].nil? && searchs[index].day == searchs[index + 1].day
  end

  def add_partial_contract_data(info)
    set_partial_contract_data(info)

    list = [info.day, @data[:contract_sum], @data[:store_names],
            @data[:partial_sum], @data[:vendor_names]]
    @contract_data << list

    @data = { contract_sum: @data[:contract_sum], partial_sum: 0,
              vendor_names: '', store_names: '', value: 1 }
    false
  end

  def set_partial_contract_data(info)
    @data[:contract_sum] += info.value
    @data[:partial_sum] += info.value

    @data[:vendor_names] +=
      create_string_for_am(fetch_username_by_id(info.user_id))
    @data[:store_names] += create_string_for_am(info.store_name)

    @data[:value] += 1

    true
  end

  def add_full_contract_data(info)
    @data[:contract_sum] += info.value

    list = [info.day, @data[:contract_sum], '1-' + info.store_name + '; ',
            info.value, '1-' + fetch_username_by_id(info.user_id) + '; ']

    @contract_data << list
  end

  def create_string_for_am(text)
    @data[:value].to_s + '-' + text + '; '
  end
end
