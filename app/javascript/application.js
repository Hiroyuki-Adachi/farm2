// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "bootstrap";
import "controllers";

const isPC = document.documentElement.dataset.device === "pc"
           || (matchMedia && matchMedia("(pointer: fine)").matches)
if (isPC) import("pages/pc-common")
