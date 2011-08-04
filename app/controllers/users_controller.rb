class UsersController < ApplicationController
  before_filter :authenticate_user!
  layout 'user'

  def index

  end

  def new

  end

  def edit
    @user = User.find current_user.id
  end

  def create

  end

  def update
    @user = User.find current_user.id
    if params[:user][:password].empty?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @user = User.find current_user.id
  end

  def edit_data
    user = User.find current_user.id

    render :partial => params[:data], :object => user.send(params[:data]), :locals => {:user => user}
  end

  def update_data
    user = User.find current_user.id
    data = user.send(params[:data])
    if data.update_attributes(params[params[:data]])
      render(:update){ |p| p.call 'app.reload_section', params[:data]}
    else
      message = '<p>' + data.errors.full_messages.join('</p><p>') + '</p>'
      render(:update) do |page|
        page['#'+params[:data]+'_flash'].parents(0).show
        page['#'+params[:data]+'_flash'].html message
      end
    end
  end

  def display_addresses
    @user = User.find current_user.id
    render '_show_addresses.html', :layout => false
  end

  def display_section
    @user = User.find current_user.id
    render '_show_'+params[:section]+'.html', :layout => false
  end

end
