import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    navigator.geolocation.getCurrentPosition(this.success.bind(this), this.error);
  }

  async success(location) {
    const coords = location.coords;
    const response = await fetch(`/weather?latitude=${coords.latitude}&longitude=${coords.longitude}`);

    if (response.ok) {
      const html = await response.text();
      Turbo.renderStreamMessage(html);
    }
  }

  error(error) {
    console.error(error);
  }
}
