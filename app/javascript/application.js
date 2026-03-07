import "@hotwired/turbo-rails";
import "./textarea-form-submission";

if ("serviceWorker" in navigator) {
  navigator.serviceWorker.register("/service-worker.js");
}
