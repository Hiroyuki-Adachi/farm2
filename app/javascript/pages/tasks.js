import { Application } from "@hotwired/stimulus"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
const application = Application.start()

import MarkdownPreviewController from "./markdown_preview_controller"
application.register("markdown-preview", MarkdownPreviewController)
