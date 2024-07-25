import { Application } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"


const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }

// Configure Action Cable
createConsumer()
