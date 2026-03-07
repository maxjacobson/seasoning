let installPrompt = null;

window.addEventListener("beforeinstallprompt", (event) => {
  event.preventDefault();
  installPrompt = event;
  document.getElementById("install-app-button")?.removeAttribute("hidden");
});

window.addEventListener("appinstalled", () => {
  installPrompt = null;
  document.getElementById("install-app-button")?.setAttribute("hidden", "");
});

document.addEventListener("click", async (event) => {
  if (event.target.id !== "install-app-button") return;
  if (!installPrompt) return;
  const result = await installPrompt.prompt();
  if (result.outcome === "accepted") {
    installPrompt = null;
    document.getElementById("install-app-button")?.setAttribute("hidden", "");
  }
});
