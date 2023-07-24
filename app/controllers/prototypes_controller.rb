class PrototypesController < ApplicationController
  before_action :authenticate_user!,only:[:edit]
  before_action :move_to_index, except: [:index, :show, :new, :create]
  

  def index
    @prototypes= Prototype.all 

  end

  def new
    @prototype= Prototype.new
   
  end

  def create
    @prototype=  Prototype.create (prototype_params)
    if @prototype.save
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    @prototype= Prototype.find(params[:id])
    @prototype.comments.destroy_all
    @prototype.destroy
    redirect_to prototypes_path

  end

  def show
    @prototype= Prototype.find(params[:id])
    @comment= Comment.new
    @comments= @prototype.comments.includes(:user)
  end

  def edit
    @prototype= Prototype.find(params[:id])
    unless current_user == @prototype.user
    redirect_to action: :index
    end
  end

  def update
    @prototype = Prototype.find(params[:id])
    original_attributes = @prototype.attributes.dup

    if @prototype.update(prototype_params) && attributes_changed?(original_attributes) 
      redirect_to prototype_path(@prototype)
    elsif !attributes_changed?(original_attributes)
      redirect_to edit_prototype_path(@prototype)
    else
     render :edit
    end
  end


  private
  def prototype_params
    params.require(:prototype).permit(:image, :title, :catch_copy, :concept ).merge(user_id: current_user.id)
  end

  def attributes_changed?(original_attributes)
    prototype_params.to_h.any?{ |key, value| original_attributes[key.to_s] != value}
  end
  
  def comment_params
    params.require(:comment).permit(:content, :prototype_id).merge(user_id: current_user.id, prototype_id: params[:prototype_id])
  end

  def move_to_index
    unless user_signed_in?
      redirect_to action: :index 
    end
  end
end
