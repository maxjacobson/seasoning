// Handle Cmd+Enter / Ctrl+Enter form submission in textareas
document.addEventListener("keydown", function (event) {
  if ((event.metaKey || event.ctrlKey) && event.key === "Enter") {
    const textarea = event.target;
    if (textarea.tagName === "TEXTAREA") {
      const form = textarea.closest("form");
      if (form) {
        event.preventDefault();
        form.requestSubmit(); // Uses native form validation and works with Turbo
      }
    }
  }
});
