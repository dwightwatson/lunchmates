import {Socket, Presence} from "phoenix";

let socket = new Socket("/socket", {params: {token: window.userToken}});

socket.connect();

let presences = {};

let channel = socket.channel("lunch:lobby", {});

channel.on("presence_state", state => {
  presences = Presence.syncState(presences, state);
  render(presences);
});

channel.on("presence_diff", diff => {
  presences = Presence.syncDiff(presences, diff);
  render(presences);
});

channel.join();

let userList = document.getElementById("user-list");

let listBy = (id, {metas: [first, ...rest]}) => {
  first.id = id;
  first.count = rest.length + 1;
  return first;
}

let render = (presences) => {
  if (userList) {
    userList.innerHTML = Presence.list(presences, listBy)
      .map(user => `<li>${user.name} (${user.count})</li>`)
      .join('');
  }
}

export default socket
