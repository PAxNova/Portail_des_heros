# script/test_full_character_creation.rb

# Charger l'environnement Rails
# require_relative '../config/environment'

# Trouver ou créer les objets nécessaires
user = User.first
universe = Universe.first
race = Race.first
univers_class = UniversClass.first

# Créer un personnage
character = Character.create(
  name: "TestHero",
  user: user,
  universe: universe,
  race: race,
  univers_class: univers_class,
  strength: "10",
  dexterity: "10",
  intelligence: "10",
  constitution: "10",
  wisdom: "10",
  charisma: "10",
  completion_rate: 10
)

# Vérifier si le personnage a été créé et est valide
if character.persisted? && character.completion_rate == 10
  # Lancer le job de génération d'image
  ImageGeneratorJob.perform_now(character.id)

  # Recharger le personnage pour obtenir les données mises à jour
  character.reload

  # Vérifier et afficher l'URL de l'image attachée
  if character.photo.attached?
    url = Rails.application.routes.url_helpers.url_for(character.photo)
    puts "Image générée et attachée avec succès : #{url}"
  else
    puts "Échec de la génération ou de l'attachement de l'image."
  end
else
  puts "Échec de la création du personnage ou problème de validation."
end
