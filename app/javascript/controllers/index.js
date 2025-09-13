// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { lazyLoadControllersFrom  } from "@hotwired/stimulus-loading"
lazyLoadControllersFrom ("controllers", application)
