import { Application } from "@hotwired/stimulus"

const application = Application.start();

// Configure Stimulus development experience
application.debug = false;
window.Stimulus   = application;

export { application }

import BsModalController from "controllers/bs_modal_controller"
application.register("bs-modal", BsModalController)
