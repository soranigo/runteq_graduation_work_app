// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

import "@hotwired/turbo-rails"
import "trix"
import "@rails/actiontext"
import "channels/consumer"
import "channels/notifications_channel"
import "modals/plans_registration_form"

document.addEventListener("turbo:load", () => {
  console.log("Turbo loaded");
});
