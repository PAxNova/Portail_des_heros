class CharactersController < ApplicationController
  before_action :set_character, only: [:show, :edit, :update]

  def index
    @characters = Character.all
  end

  def create
    @character = Character.new
    @character.user = current_user
    @character.universe_id = params[:universe_id] if params[:universe_id].present?
    @character.completion_rate = 1
    @character.save!

    if @character.save
      redirect_to edit_character_path(@character), notice: 'Le character a été créé !'
    else
      render :new
    end
  end

  def edit
    # l'action set_character est appelée par le before_action
  end

  def show
     # l'action set_character est appelée par le before_action
  end

  def update
    # l'action set_character est appelée par le before_action

    # Compter le nombre de paramètres mis à jour
    updated_fields = character_params.keys.count

    if @character.update(character_params)
      # Incrémenter le taux de complétion
      new_completion_rate = @character.completion_rate + updated_fields
      @character.update(completion_rate: new_completion_rate)

      if @character.completion_rate >= 10
        assign_to_party(@character)
        redirect_to @character, notice: 'Le character est terminé et ajouté à une partie !'
      else
        redirect_to edit_character_path(@character)
      end
    else
      render :edit
    end
  end

  private

  def set_character
    @character = Character.find_by_id(params[:id])
  end

  def character_params
    params.require(:character).permit(:name, :universe_id, :race_id, :univers_class_id, :strength, :dexterity, :intelligence, :constitution, :wisdom, :charisma, :available_status)
  end

  def assign_to_party(character)
    # Attribuer le personnage à la première partie trouvée
    first_party = Party.first
    PartyCharacter.create!(character: character, party: first_party, status: 'accepted') if first_party
  end
end
