# script/test_image_generator_job.rb
if Rails.env.development? || Rails.env.test?
  # Load the Rails environment
  # require_relative '../config/environment'

  # Find or create the necessary objects
  user = User.first
  universe = Universe.first
  race = Race.first
  univers_class = UniversClass.first

  # Create a character
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

  # Check if the character was created and is valid
  if character.persisted? && character.completion_rate == 10
    # Launch the image generation job
    ImageGeneratorJob.perform_now(character.id)

    # Reload the character to get the updated data
    character.reload

    # Check and display the URL of the attached image
    if character.photo.attached?
      url = Rails.application.routes.url_helpers.url_for(character.photo)
      puts "Image generated and attached successfully: #{url}"
    else
      puts "Failed to generate or attach the image."
    end
  else
    puts "Failed to create the character or validation problem."
  end
end
