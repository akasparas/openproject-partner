class PartnersController < ApplicationController
  before_action :require_admin, except: [:index, :show]
  before_action :get_partner_by_identifier, except: [:index, :new, :create, :set_partner]
  before_action :get_contacts, only: [:edit, :update, :show]
  respond_to :html, :json

  helper :projects #, :custom_fields

  def index
    @partners = Partner.all.order(name: :asc)
    recode = {'partner_id'=>'id', 'name'=>'name'}
    if (request.params[:q] && request.params[:q].length > 0)
      q = request.params[:q].downcase()
      @partners = @partners.select {|e| e[:name].downcase().include?(q) || e[:partner_id].downcase().include?(q)}
    end
    respond_to do |format|
      format.html 
      format.any(:xml, :json, :js) { render request.format.to_sym => { results: { items: @partners.map {|v| {'id'=> v['partner_id'], 'name'=> v['name']} } } } }
    end

     # @custom_fields = CompanyCustomField.all.order(position: :asc)
  end

  def show
    # @projects = @company.all_projects
  end

  def new
    @partner = Partner.new
  end

  def create
    @partner = Partner.new partner_attributes

    if @partner.save
      flash[:notice] = t(:notice_successful_create)

      redirect_to @partner
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @partner.update partner_attributes
      flash[:notice] = t(:notice_successful_update)

      redirect_to @partner
    else
      render action: 'edit'
    end
  end

  def destroy
    @partner.destroy
    flash[:notice] = t(:notice_partner_deleted)

    redirect_to partners_url
  end

  def set_partner
    @project= Project.find(request.params[:id])
    if (@project)
      @project.partner_id = request.params[:project][:partner_id] == '-1' ? nil : request.params[:project][:partner_id]
      @project.save
      flash[:notice] = t(:notice_partner_set_success)
    else 
      flash[:notice] = t(:notice_partner_not_set)
    end
    redirect_back(fallback_location: '/')
  end 

  # def delete_member
  #   member = User.find(params[:member_id])
  #   @company.members.delete(member)

  #   flash[:notice] = t(:notice_company_member_deleted)

  #   redirect_to edit_company_path(id: @company.identifier)
  # end

  # def add_members
  #   member_ids = params[:member_ids]
  #   @company.member_ids += member_ids

  #   flash[:notice] = t(:notice_company_member_added)

  #   redirect_to edit_company_path(id: @company.identifier)
  # end

  # def filter_available_members
  #   @members = @company.members.sorted_alphabetically
  #   found = params[:q].blank? ? User.active : User.active.like(params[:q])
  #   @available_members = found.sorted_alphabetically.limit(100) - @members

  #   render partial: 'available_members'
  # end

  # def delete_project
  #   project = Project.find(params[:project_id])
  #   @company.projects.delete(project)

  #   flash[:notice] = t(:notice_company_project_deleted)

  #   redirect_to edit_company_path(id: @company.identifier)
  # end

  # def add_projects
  #   project_ids = params[:project_ids]
  #   @company.project_ids += project_ids

  #   flash[:notice] = t(:notice_company_project_added)

  #   redirect_to edit_company_path(id: @company.identifier)
  # end

  # def filter_available_projects
  #   @projects = @company.projects.sorted_alphabetically
  #   found = params[:q].blank? ? Project.active : Project.active.like(params[:q])
  #   @available_projects = found.sorted_alphabetically.limit(100) - @projects

  #   render partial: 'available_projects'
  # end

  # private

  # def get_settings
  #   @settings = Setting.plugin_openproject_companies
  # end

  # def get_members
  #   @members = @company.members.sorted_alphabetically
  #   @available_members = User.active.sorted_alphabetically.limit(100) - @members
  # end

  # def get_projects
  #   @projects = @company.projects.sorted_alphabetically

  #   all_projects = Project.active.sorted_alphabetically.order(name: :asc).limit(100)
  #   @available_projects = all_projects - @projects
  # end

  def get_partner_by_identifier
    @partner = Partner.find_by!(partner_id: params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def partner_attributes
    params
      .require(:partner)
      .permit(:partner_id, :name)
  end

  def default_breadcrumb
    if action_name == 'index' || action_name == 'new'
      t('label_partner_plural')
    else
      # ActionController::Base.helpers.link_to(t('label_partner_plural'), partner_path)
    end
  end

  def show_local_breadcrumb
    true
  end

  def partners_path
  end

  def add_contact
    contact  = Contact.find(request.params[:partner][:new_contact])
    partner = Partner.find(request.params[:id])
    if (contact && partner)
      contact.partners << partner
      flash[:notice] = t(:notice_association_added)
      redirect_back(fallback_location: partners_url)
    end
  rescue => error
    puts error.inspect
    render_404
  end

  def available_contacts
    id = request.params[:id].gsub(/[^0-9a-zA-Z .,@ąčęėįšųūžAČĘĖĮŠŲŽ]/, "")
    # no SQL injection here because 
    # 1) get_partner_by_identifier is called and project by :id is found
    # 2) project_id length is very limited
    # 3) supplied parameter is sanitized
    @contacts = Contact.joins("LEFT JOIN contacts_partners ON contacts_partners.contact_id = contacts.id and contacts_partners.partner_id = '#{id}'").
      where('contacts_partners.partner_id is null and (lower(contacts.name) like :q or contacts.phone like :q or lower(contacts.email) like :q)', 
        q: "%#{request.params[:q].downcase}%").
      order(name: :asc)
    respond_to do |format|
      format.any(:json) { render request.format.to_sym => { results: { items: @contacts } } }
    end

  end

  def get_contacts
    @contacts = @partner.contacts.sorted_alphabetically
    @available_contacts = Contact.sorted_alphabetically.limit(100) - @contacts
  end
end
