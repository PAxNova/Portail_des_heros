# app/jobs/generate_backstory_job.rb
class GenerateBackstoryJob < ApplicationJob
  queue_as :default

  def perform(character_id)
    character = Character.find(character_id)
    prompt_template = YAML.load_file(Rails.root.join('config/prompts.yml'))['generate_backstory']['template']
    prompt = prompt_template % { name: character.name, race: character.race.name, univers_class: character.univers_class.name, universe: character.universe.name }
  
    client = OpenAI::Client.new
    response = nil

    begin
      response = client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: [{ role: "user", content: prompt }],
          temperature: 0.7
        }
      )
    rescue Faraday::TooManyRequestsError => e
      puts "Rate limit exceeded. Retrying after delay..."
      sleep(10) # Attendez 10 secondes avant de réessayer
      retry
    end

    character.update(backstory: response.dig("choices", 0, "message", "content"))
  end
end
