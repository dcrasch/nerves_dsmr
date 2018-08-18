// for phoenix_html support, including form and button helpers
// copy the following scripts into your javascript bundle:
// * https://raw.githubusercontent.com/phoenixframework/phoenix_html/v2.10.0/priv/static/phoenix_html.js
let socket = new Phoenix.Socket("/socket");
socket.connect();
let channel = socket.channel("telegram:electricity", {});

channel
  .join()
  .receive("ok", resp => {
    console.log("Joined successfully", resp);
  })
  .receive("error", resp => {
    console.log("Unable to join", resp);
  });

channel.on("update", message => {
  document.querySelector("#electricity_delivered_1").innerHTML =
    message.electricity_delivered_1;
  document.querySelector("#electricity_delivered_2").innerHTML =
    message.electricity_delivered_2;
  document.querySelector("#electricity_returned_1").innerHTML =
    message.electricity_returned_1;
  document.querySelector("#electricity_returned_2").innerHTML =
    message.electricity_returned_2;
  document.querySelector("#power_delivered").innerHTML =
    message.power_delivered;
  document.querySelector("#power_returned").innerHTML = message.power_returned;
});
