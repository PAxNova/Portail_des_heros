// app/javascript/controllers/backstory_controller.js
import { Controller } from "@hotwired/stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  static targets = ["backstory", "photo"]

  connect() {
    console.log("Backstory controller connected");

    // Abonnement au canal ActionCable
    console.log("Connecting to ActionCable channel: CharacterChannel");
    this.channel = consumer.subscriptions.create("CharacterChannel", {
      received: (data) => {
        console.log("Received data from ActionCable:", data);
        if (data.character_id === parseInt(this.data.get("characterId"))) {
          this.updateCharacter(data)
        }
      },
      connected: () => {
        console.log("Successfully connected to CharacterChannel");
      },
      disconnected: () => {
        console.log("Disconnected from CharacterChannel");
      }
    });

    console.log("Backstory controller fully set up.");
  }

  async updateCharacter(data) {
    console.log("Updating character with data:", data);
    alert(data.message);

    // Met à jour la photo
    this.photoTarget.src = data.photo_url;

    // Récupère le contenu HTML de la partial backstory et remplace le contenu actuel
    const response = await fetch(`/characters/${data.character_id}/backstory_partial`);
    const html = await response.text();
    this.backstoryTarget.innerHTML = html;
  }
}
