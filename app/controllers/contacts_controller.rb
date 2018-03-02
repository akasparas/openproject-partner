class ContactsController < ApplicationController
  before_action :require_admin, except: [:index, :show]
  before_action :get_contact_by_identifier, except: [:index, :new, :create]

  helper :projects #, :custom_fields

  def index
    @contacts = Contact.all.order(name: :asc)
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

  private

  def get_contact_by_identifier
    @contact = Contact.find_by!(id: params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end


end
