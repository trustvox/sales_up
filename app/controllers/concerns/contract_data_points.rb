module ContractDataPoints
  def start_contract(searched_contract)
    @search = searched_contract

    @data = { contract_sum: 0, partial_sum: 0, vendor_names: '',
              store_names: '', value: 1, wait: false }
    @wait = false
    @user_id = 0
  end

  def fetch_contract_data
    search_contract_data
  end

  def fetch_contract_points
    @contract_points = fetch_contract_points_list
    @contract_points.unshift([1, 0]) unless @contract_points[0][0] == 1
  end

  def fetch_contract_points_list
    @contract_data.collect { |contract| [contract[0].to_i, contract[1].to_f] }
  end

  private

  def search_contract_data
    @search.each_with_index do |info, i|
      @user_id = info.user_id
      if proceed_contract_search?(i)
        set_partial_contract_data(info.value, info.store_name)
      elsif @wait
        add_partial_contract_data(info.day, info.value, info.store_name)
      else
        add_full_contract_data(info.day, info.store_name, info.value)
      end
    end
  end

  def proceed_contract_search?(index)
    !@search[index + 1].nil? && @search[index].day == @search[index + 1].day
  end

  def add_partial_contract_data(day, value, store_name)
    set_partial_contract_data(value, store_name)

    list = [day, @data[:contract_sum], @data[:store_names],
            @data[:partial_sum], @data[:vendor_names]]
    @contract_data << list

    @data = { contract_sum: @data[:contract_sum], partial_sum: 0,
              vendor_names: '', store_names: '', value: 1 }
    @wait = false
  end

  def set_partial_contract_data(contract_sum, store_name)
    @data[:contract_sum] += contract_sum
    @data[:partial_sum] += contract_sum

    @data[:vendor_names] +=
      create_string_for_AM(fetch_username_by_id(@user_id))
    @data[:store_names] += create_string_for_AM(store_name)

    @data[:value] += 1
    @wait = true
  end

  def add_full_contract_data(day, store_name, value)
    @data[:contract_sum] += value

    list = [day, @data[:contract_sum], '1-' + store_name + '; ',
            value, '1-' + fetch_username_by_id(@user_id) + '; ']
    @contract_data << list
  end

  def create_string_for_AM(text)
    @data[:value].to_s + '-' + text + '; '
  end
end
