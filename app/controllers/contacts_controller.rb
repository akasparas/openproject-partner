class ContactsController < ApplicationController
  before_action :require_admin, except: [:index, :show]
  before_action :get_contact_by_identifier, except: [:index, :new, :create]
  before_action :get_partners, only: [:edit, :update, :show]

  helper :projects #, :custom_fields

  def index
    @contacts = Contact.includes(:partners).all.order(name: :asc)
    if (request.params[:q] && request.params[:q].length > 0)
      q = request.params[:q].downcase()
      @contacts = @contacts.select {|e| e[:name].downcase().include?(q) || e[:email].downcase().include?(q) || e[:phone].downcase().include?(q)}
    end
    respond_to do |format|
      format.html 
      format.any(:xml, :json, :js) { render request.format.to_sym => { results: { items: @contacts } } }
    end
  end

  def new
    @contact = Contact.new
  end

  def show
  end

  def create
    @contact = Contact.new contact_attributes

    if @contact.save
      flash[:notice] = t(:notice_successful_create)

      redirect_to @contact
    else
      render action: 'new'
    end
  end


  def update
    if @contact.update contact_attributes
      flash[:notice] = t(:notice_successful_update)

      redirect_to @contact
    else
      render action: 'edit'
    end
  end


  def edit
  end

  def destroy
    @contact.destroy
    flash[:notice] = t(:notice_contact_deleted)

    redirect_to contacts_url
  end

  def contact_attributes
    params
      .require(:contact)
      .permit(:name, :phone, :email)
  end  

  def add_partner
    contact  = Contact.find(request.params[:id])
    partner = Partner.find(request.params[:contact][:new_partner])
    if (contact && partner)
      contact.partners << partner
      flash[:notice] = t(:notice_association_added)
      redirect_back(fallback_location: contacts_url)
    end
  rescue => error
    puts error.inspect
    render_404
  end

  def delete_partner
    contact  = Contact.find(request.params[:id])
    partner = contact.partners.find(request.params[:partner_id])

    if (contact && partner)
      contact.partners.delete(partner)
      flash[:notice] = t(:notice_association_removed)
      redirect_back(fallback_location: contacts_url)
    end 
  rescue => error
    puts error.inspect
    render_404
  end 

  def available_partners
    @partners = Partner.joins("LEFT JOIN contacts_partners ON contacts_partners.partner_id = partners.partner_id and contacts_partners.contact_id = #{Integer(request.params[:id])}").
      where('contacts_partners.contact_id is null and (lower(partners.partner_id) like :q or lower(partners.name) like :q)', 
        q: "%#{request.params[:q].downcase}%").
      order(name: :asc)
    respond_to do |format|
      format.any(:json) { render request.format.to_sym => { results: { items: @partners.map {|v| {'id'=> v['partner_id'], 'name'=> v['name']} } } } }
    end

  end

  private

  def get_contact_by_identifier
    @contact = Contact.find_by!(id: params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def get_partners
    @partners = @contact.partners.sorted_alphabetically
    @available_partners = Partner.sorted_alphabetically.limit(100) - @partners
  end

end
