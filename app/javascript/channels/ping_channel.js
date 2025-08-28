import consumer from "channels/consumer"

consumer.subscriptions.create("PingChannel", {
  connected(){ console.log("ping connected") },
  received(d){ console.log("ping:", d) }
});
