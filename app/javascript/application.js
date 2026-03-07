import "@hotwired/turbo-rails";
import "./textarea-form-submission";
import "./install-prompt";

if ("serviceWorker" in navigator) {
  navigator.serviceWorker.register("/service-worker.js");
}
