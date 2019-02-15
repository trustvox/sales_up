module MeetingDataPoints
  def start_meeting(searched_contract)
    @search = searched_contract

    @data = { meeting_sum: 0, partial_sum: 0, sdr_names: '',
              client_names: '', value: 1, wait: false, scheduled_for: '',
              meeting_for: '' }
    @wait = false
    @user_id = 0
  end

  def fetch_meeting_data
    search_meeting_data
  end

  def fetch_meeting_points
    @meeting_points = fetch_meeting_points_list
    @meeting_points.unshift([1, 0]) unless @meeting_points[0][0] == 1
  end

  def fetch_meeting_points_list
    @meeting_data.collect { |meeting| [meeting[0].to_i, meeting[1].to_f] }
  end

  private

  def search_meeting_data
    @search.each_with_index do |info, i|
      @user_id = info.user_id
      
      if proceed_meeting_search?(i)
        partial_meeting_data(info)
      elsif @wait
        add_partial_meeting_data(info)
      else
        add_full_meeting_data(info)
      end
    end
  end

  def proceed_meeting_search?(index)
    !@search[index + 1].nil? && @search[index].day == @search[index + 1].day
  end

  def add_partial_meeting_data(info)
    partial_meeting_data(info)

    list = [info.day, @data[:meeting_sum], @data[:client_names],
            @data[:partial_sum], @data[:scheduled_for], @data[:meeting_for],
            @data[:sdr_names]]
    @meeting_data << list

    @data = { meeting_sum: @data[:meeting_sum], partial_sum: 0,
              sdr_names: '', client_names: '', value: 1, scheduled_for: '',
              meeting_for: '' }
    @wait = false
  end

  def partial_meeting_data(info)
    @data[:meeting_sum] += 1
    @data[:partial_sum] += 1

    add_sdr_scheduled_data(info)

    @data[:value] += 1
    @wait = true
  end

  def add_sdr_scheduled_data(info)
    @data[:sdr_names] +=
      create_string_for_sdr(fetch_username_by_id(@user_id))
    @data[:client_names] += create_string_for_sdr(info.client_name)
    @data[:scheduled_for] +=
      create_string_for_sdr(date_to_string(info.scheduled_for))
    @data[:meeting_for] += create_string_for_sdr(info.meeting_for)
  end

  def add_full_meeting_data(info)
    @data[:meeting_sum] += 1

    @meeting_data << create_meeting_data_list(info)
  end

  def create_meeting_data_list(info)
    [info.day, @data[:meeting_sum], '1-' + info.client_name + '; ', 1,
     '1-' + date_to_string(info.scheduled_for) + '; ',
     '1-' + info.meeting_for + '; ',
     '1-' + fetch_username_by_id(@user_id) + '; ']
  end

  def create_string_for_sdr(text)
    @data[:value].to_s + '-' + text + '; '
  end

  def date_to_string(date)
    date.strftime('%d/%m/%Y') + ' ' + date.strftime('%I:%M%p')
  end
end
