# app/jobs/generate_backstory_job.rb
class GenerateBackstoryJob < ApplicationJob
  queue_as :default

  def perform(character_id)
    character = Character.find(character_id)
    prompt = generate_prompt(character)
    client = OpenAI::Client.new

    begin
      response = client.chat(
        parameters: {
          model: "gpt-4o-mini",
          messages: [{ role: "user", content: prompt }],
          temperature: 0.7,
          max_tokens: 4096
        }
      )
    rescue Faraday::TooManyRequestsError
      puts "Rate limit exceeded. Retrying after delay..."
      sleep(10)
      retry
    rescue => e
      puts "An error occurred: #{e.message}"
      return
    end

    backstory_content = response.dig("choices", 0, "message", "content")

    if backstory_content.present?
      character.update(backstory: backstory_content)
      puts "Backstory updated for character #{character.name}"

      ActionCable.server.broadcast(
        "character_channel_#{character.user.id}",
        character_id: character.id,
        backstory: character.backstory,
        message: "Your character's backstory has been updated!"
      )
    else
      puts "No backstory was generated for character #{character.name}"
    end
  end

  private

  def generate_prompt(character)
    YAML.load_file(Rails.root.join('config/prompts.yml'))['generate_backstory']['template'] % {
      name: character.name,
      race: character.race.name,
      univers_class: character.univers_class.name,
      universe: character.universe.name,
      strength: character.strength,
      dexterity: character.dexterity,
      intelligence: character.intelligence,
      constitution: character.constitution,
      wisdom: character.wisdom,
      charisma: character.charisma
    }
  end
end
