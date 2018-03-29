module ContractData
  def start_contract(data, points, searched_contract)
    @contract_data = data
    @contract_points = points
    @search = searched_contract

    @data = { contract_sum: 0, partial_sum: 0, vendor_names: '',
              store_names: '', value: 1, wait: false }
    @wait = false
    @user_id = 0
  end

  def fetch_contract_data
    search_data
    @contract_data
  end

  def fetch_contract_points
    @contract_points = '[ [1,0]'

    @contract_data.each do |contract|
      @contract_points += ', [' + contract[0].to_s +
                          ',' + contract[1].to_s + ']'
    end

    @contract_points += ']'
  end

  private

  def search_data
    @search.each_with_index do |info, i|
      @user_id = info.user_id
      if proceed?(i)
        set_partial_data(info.value, info.store_name)
      elsif @wait
        add_partial_data(info.day, info.value, info.store_name)
      else
        add_full_data(info.day, info.store_name, info.value)
      end
    end
  end

  def proceed?(index)
    !@search[index + 1].nil? && @search[index].day == @search[index + 1].day
  end

  def add_partial_data(day, value, store_name)
    set_partial_data(value, store_name)

    list = [day, @data[:contract_sum], @data[:store_names],
            @data[:partial_sum], @data[:vendor_names]]
    @contract_data << list

    @data = { contract_sum: @data[:contract_sum], partial_sum: 0,
              vendor_names: '', store_names: '', value: 1 }
    @wait = false
  end

  def set_partial_data(contract_sum, store_name)
    @data[:contract_sum] += contract_sum
    @data[:partial_sum] += contract_sum

    @data[:vendor_names] += create_string(fetch_username_by_id(@user_id))
    @data[:store_names] += create_string(store_name)

    @data[:value] += 1
    @wait = true
  end

  def add_full_data(day, store_name, value)
    @data[:contract_sum] += value

    list = [day, @data[:contract_sum], store_name,
            value, fetch_username_by_id(@user_id)]
    @contract_data << list
  end

  def create_string(text)
    @data[:value].to_s + '-' + text + '; '
  end
end
