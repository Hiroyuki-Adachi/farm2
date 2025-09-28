import { Controller } from "@hotwired/stimulus"
import { application } from "controllers/application"
import MarkdownPreviewController from "controllers/markdown_preview_controller"

application.register("markdown-preview", MarkdownPreviewController)

export default class extends Controller {}
