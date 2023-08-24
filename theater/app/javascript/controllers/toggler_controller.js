import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  async toggle() {
    this.inputTarget.classList.toggle("is-hidden")
  }
}
