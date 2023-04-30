function calculateSize() {
  const width  = document.getElementById("chart").offsetWidth;
  const height = document.getElementById("chart").offsetHeight;
  return {"id": "populationgrowth", "width": 800, "height": height + 20};
}

function notifyParentOfSize() {
  // If this is included as an iframe, notify the parent of our size so that the iframe can be resized accordingly
  const size = calculateSize();
  window.parent.postMessage(size, "*");
}

window.addEventListener("message", (event) => {
  notifyParentOfSize();
});
