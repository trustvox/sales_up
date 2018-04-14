class HomeController < DashboardController
  def graphic
    @current_report = session[:current_report]
    @report_data = session[:report_data]
    @report_points = session[:report_points]
    @contract_points = session[:contract_points]
    @month_year_list = session[:month_year_list]

    render_menu
  end

  def spreadsheet
    begin
      authorize! :spreadsheet, HomeController
    rescue CanCan::AccessDenied
      redirect_to graphic_path
    end

    @month_year_list = session[:month_year_list]
    @current_report = session[:current_report]
    @report_data = session[:report_data]
    @users = session[:all_users]

    render_menu
  end

  def logout
    sign_out_and_redirect(current_user)
  end

  def add_contract_data
    add_contract
    refresh_spreadsheet
  end

  def alter_contract_data
    alter_contract
    refresh_spreadsheet
  end

  def delete_contract_data
    destroy_contract_by_id(params[:delete])
    refresh_spreadsheet
  end

  def refresh_spreadsheet
    fetch_data_and_points
    redirect_to spreadsheet_path
  end
end
