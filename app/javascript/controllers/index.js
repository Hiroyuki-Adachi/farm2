// app/javascript/controllers/index.js
import { application } from "controllers/application"
import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"

lazyLoadControllersFrom("controllers", application)
