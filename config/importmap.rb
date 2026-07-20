# Pin npm packages by running ./bin/importmap

pin "application"
pin "trix"
pin "@rails/actiontext", to: "actiontext.js"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/turbo", to: "@hotwired--turbo.js" # @8.0.23

pin "@rails/actioncable", to: "actioncable.esm.js"
pin "notifications", to: "notifications.js"
pin "channels/consumer", to: "channels/consumer.js"
pin "channels/notifications_channel", to: "channels/notifications_channel.js"
