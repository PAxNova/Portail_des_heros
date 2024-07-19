class PartiesController < ApplicationController
  before_action :set_party, only: [:show, :edit, :update, :destroy]

  def index
    @parties = Party.all
  end

  def show
    # l'action set_party est appelée par le before_action
  end

  def new
    @party = Party.new
  end

  def create
    @party = Party.new(party_params)
    @party.user = current_user

    if @party.save
      redirect_to @party, notice: 'La partie a été créée !'
    else
      render :new
    end
  end

  def edit
    # l'action set_party est appelée par le before_action
  end

  def update
    if @party.update(party_params)
      redirect_to @party, notice: 'La partie a été mise à jour !'
    else
      render :edit
    end
  end

  def destroy
    @party.destroy
    redirect_to parties_url, notice: 'La partie a été supprimée !'
  end

  private

  def set_party
    @party = Party.find(params[:id])
  end

  def party_params
    params.require(:party).permit(:name, :universe_id, :user_id)
  end
end
