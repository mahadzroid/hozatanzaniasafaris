function stickFooter() {
  const footer = document.querySelector(".site-footer");
  const bodyHeight = document.body.offsetHeight;
  const windowHeight = window.innerHeight;

  if (bodyHeight < windowHeight) {
    footer.style.position = "absolute";
    footer.style.bottom = "0";
    footer.style.width = "100%";
  } else {
    footer.style.position = "static";
  }
}

// Run on load and resize
window.addEventListener("load", stickFooter);
window.addEventListener("resize", stickFooter);
