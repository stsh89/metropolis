import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input", "value" ]

  find() {
    const searchInput = this.inputTarget
    const searchValue = searchInput.value.toLowerCase()
    const values = this.valueTargets

    for (let i = 0; i < values.length; i++) {
      if (values[i].dataset.value.toLowerCase().search(searchValue) < 0) {
        values[i].classList.add("is-hidden")
      } else {
        values[i].classList.remove("is-hidden")
      }
    }
  }
}
